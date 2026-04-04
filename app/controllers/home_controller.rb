class HomeController < ApplicationController
  def index
    load_metformina_savings_example
  end

  private

  # Misma lógica que ComparisonsController: mejor precio referencia vs genérico (metformina 850mg).
  def load_metformina_savings_example
    related_ids = Drug.where(active_ingredient: "metformina", dosage: "850mg").pluck(:id)
    return if related_ids.empty?

    entries = PriceEntry.where(drug_id: related_ids).includes(:drug)
    ref_entries = entries.select { |e| e.drug.referencia? }
    gen_entries = entries.select { |e| e.drug.generico? || e.drug.branded? }
    return if ref_entries.empty? || gen_entries.empty?

    @demo_ref_entry = ref_entries.min_by(&:price_per_unit)
    @demo_gen_entry = gen_entries.min_by(&:price_per_unit)
    savings_per_unit = @demo_ref_entry.price_per_unit - @demo_gen_entry.price_per_unit
    return if savings_per_unit <= 0

    @demo_savings_annual = (savings_per_unit * 30 * 12).round(2)
    @demo_comparison_drug = Drug.find_by(
      active_ingredient: "metformina",
      dosage: "850mg",
      drug_type: "generico_intercambiable"
    ) || @demo_gen_entry.drug
  end
end
