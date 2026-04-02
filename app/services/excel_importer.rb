# Importa datos desde un archivo .xlsx con hasta 4 sheets opcionales:
#
#   Medicamentos  → crea / actualiza registros Drug
#   Farmacias     → crea / actualiza registros Pharmacy
#   Precios       → crea / actualiza PriceEntry (requiere drug y pharmacy ya existentes)
#   Equivalencias → crea / actualiza GenericEquivalent
#
# Uso:
#   result = ExcelImporter.call(file: path_or_file)
#   result.success?      # → true / false
#   result.imported      # → { drugs: 3, pharmacies: 2, prices: 10, equivalents: 1 }
#   result.errors        # → [{ sheet: "Precios", row: 4, field: "drug_slug", message: "no encontrado" }]
#
class ExcelImporter
  Result = Struct.new(:success?, :imported, :errors, :found_sheets, keyword_init: true)

  SHEET_NAMES = {
    drugs:        "Medicamentos",
    pharmacies:   "Farmacias",
    prices:       "Precios",
    equivalents:  "Equivalencias"
  }.freeze

  DRUG_COLUMNS = %w[name active_ingredient form dosage requires_prescription
                    therapeutic_group via drug_type slug].freeze
  PHARMACY_COLUMNS = %w[name kind].freeze
  PRICE_COLUMNS    = %w[drug_slug pharmacy_name price_per_box units_per_box
                        promotion promotion_expiry in_stock home_delivery].freeze
  EQUIVALENT_COLUMNS = %w[drug_slug reference_drug_slug cofepris_registration].freeze

  def self.call(file:)
    new(file: file).call
  end

  def initialize(file:)
    @file   = file
    @errors = []
    @counts = { drugs: 0, pharmacies: 0, prices: 0, equivalents: 0 }
  end

  def call
    book = Roo::Spreadsheet.open(path_from(@file))

    import_drugs(book)       if sheet_present?(book, SHEET_NAMES[:drugs])
    import_pharmacies(book)  if sheet_present?(book, SHEET_NAMES[:pharmacies])
    import_prices(book)      if sheet_present?(book, SHEET_NAMES[:prices])
    import_equivalents(book) if sheet_present?(book, SHEET_NAMES[:equivalents])

    Result.new(
      success?:     @errors.empty?,
      imported:     @counts,
      errors:       @errors,
      found_sheets: book.sheets
    )
  rescue => e
    Result.new(
      success?:     false,
      imported:     @counts,
      errors:       [{ sheet: "Archivo", row: nil, field: nil, message: e.message }],
      found_sheets: []
    )
  end

  private

  # ── Importadores por sheet ──────────────────────────────────────────────

  def import_drugs(book)
    each_row(book, SHEET_NAMES[:drugs], DRUG_COLUMNS) do |row, idx|
      slug = (row["slug"].presence || Drug.generate_slug(row["name"].to_s)).strip

      drug = Drug.find_or_initialize_by(slug: slug)
      drug.assign_attributes(
        name:                  row["name"].to_s.strip,
        active_ingredient:     row["active_ingredient"].to_s.strip,
        form:                  row["form"].to_s.presence,
        dosage:                row["dosage"].to_s.presence,
        requires_prescription: truthy?(row["requires_prescription"]),
        therapeutic_group:     row["therapeutic_group"].to_s.presence,
        via:                   row["via"].to_s.presence,
        drug_type:             row["drug_type"].to_s.presence || "generico_intercambiable"
      )

      if drug.valid?
        drug.save!
        @counts[:drugs] += 1
      else
        drug.errors.full_messages.each do |msg|
          add_error(SHEET_NAMES[:drugs], idx, nil, msg)
        end
      end
    end
  end

  def import_pharmacies(book)
    each_row(book, SHEET_NAMES[:pharmacies], PHARMACY_COLUMNS) do |row, idx|
      name = row["name"].to_s.strip
      next add_error(SHEET_NAMES[:pharmacies], idx, "name", "requerido") if name.blank?

      pharmacy = Pharmacy.find_or_initialize_by(name: name)
      pharmacy.kind = row["kind"].to_s.strip.presence || pharmacy.kind

      if pharmacy.valid?
        pharmacy.save!
        @counts[:pharmacies] += 1
      else
        pharmacy.errors.full_messages.each do |msg|
          add_error(SHEET_NAMES[:pharmacies], idx, nil, msg)
        end
      end
    end
  end

  def import_prices(book)
    each_row(book, SHEET_NAMES[:prices], PRICE_COLUMNS) do |row, idx|
      drug     = Drug.find_by(slug: row["drug_slug"].to_s.strip)
      pharmacy = Pharmacy.find_by(name: row["pharmacy_name"].to_s.strip)

      if drug.nil?
        add_error(SHEET_NAMES[:prices], idx, "drug_slug", "medicamento '#{row["drug_slug"]}' no encontrado")
        next
      end
      if pharmacy.nil?
        add_error(SHEET_NAMES[:prices], idx, "pharmacy_name", "farmacia '#{row["pharmacy_name"]}' no encontrada")
        next
      end

      entry = PriceEntry.find_or_initialize_by(drug: drug, pharmacy: pharmacy)
      entry.assign_attributes(
        price_per_box:    parse_decimal(row["price_per_box"]),
        units_per_box:    row["units_per_box"].to_i,
        promotion:        row["promotion"].to_s.presence,
        promotion_expiry: parse_date(row["promotion_expiry"]),
        in_stock:         row["in_stock"].nil? ? true : truthy?(row["in_stock"]),
        home_delivery:    truthy?(row["home_delivery"])
      )

      if entry.valid?
        entry.save!
        @counts[:prices] += 1
      else
        entry.errors.full_messages.each do |msg|
          add_error(SHEET_NAMES[:prices], idx, nil, msg)
        end
      end
    end
  end

  def import_equivalents(book)
    each_row(book, SHEET_NAMES[:equivalents], EQUIVALENT_COLUMNS) do |row, idx|
      drug     = Drug.find_by(slug: row["drug_slug"].to_s.strip)
      ref_drug = Drug.find_by(slug: row["reference_drug_slug"].to_s.strip)

      if drug.nil?
        add_error(SHEET_NAMES[:equivalents], idx, "drug_slug",
                  "genérico '#{row["drug_slug"]}' no encontrado")
        next
      end
      if ref_drug.nil?
        add_error(SHEET_NAMES[:equivalents], idx, "reference_drug_slug",
                  "referencia '#{row["reference_drug_slug"]}' no encontrada")
        next
      end

      ge = GenericEquivalent.find_or_initialize_by(drug: drug, reference_drug: ref_drug)
      ge.cofepris_registration = row["cofepris_registration"].to_s.presence

      if ge.valid?
        ge.save!
        @counts[:equivalents] += 1
      else
        ge.errors.full_messages.each do |msg|
          add_error(SHEET_NAMES[:equivalents], idx, nil, msg)
        end
      end
    end
  end

  # ── Helpers ────────────────────────────────────────────────────────────

  # Busca el nombre real de la sheet de forma case-insensitive
  def find_sheet(book, name)
    book.sheets.find { |s| s.strip.downcase == name.strip.downcase }
  end

  def sheet_present?(book, name)
    find_sheet(book, name).present?
  end

  # Itera filas de una sheet después de la cabecera (fila 1).
  # Convierte cada fila a Hash usando los encabezados de la primera fila.
  def each_row(book, sheet_name, _expected_columns, &block)
    real_name = find_sheet(book, sheet_name)
    sheet = book.sheet(real_name)
    headers = sheet.row(1).map { |h| h.to_s.strip.downcase.tr(" ", "_") }

    (2..sheet.last_row).each do |i|
      values = sheet.row(i)
      next if values.all?(&:blank?)

      row = headers.zip(values).to_h
      block.call(row, i)
    end
  end

  def add_error(sheet, row, field, message)
    @errors << { sheet: sheet, row: row, field: field, message: message }
  end

  def truthy?(val)
    return false if val.nil?
    return val   if val == true || val == false

    %w[1 si sí yes true].include?(val.to_s.strip.downcase)
  end

  def parse_decimal(val)
    return nil if val.nil? || val.to_s.strip.blank?

    val.to_s.gsub(/[^\d.]/, "").to_d
  end

  def parse_date(val)
    return nil if val.nil? || val.to_s.strip.blank?
    return val if val.is_a?(Date) || val.is_a?(DateTime) || val.is_a?(Time)

    Date.parse(val.to_s)
  rescue Date::Error
    nil
  end

  def path_from(file)
    file.respond_to?(:path) ? file.path : file.to_s
  end
end
