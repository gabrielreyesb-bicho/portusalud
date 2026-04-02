ActiveAdmin.register Drug do
  menu label: "Medicamentos", priority: 2

  permit_params :name, :active_ingredient, :form, :dosage,
                :requires_prescription, :therapeutic_group, :via,
                :drug_type, :slug

  filter :name
  filter :active_ingredient
  filter :drug_type, as: :select, collection: Drug::DRUG_TYPES
  filter :requires_prescription
  filter :therapeutic_group

  index do
    selectable_column
    id_column
    column :name
    column :active_ingredient
    column("Dosis") { |d| d.dosage }
    column("Tipo")  { |d| d.drug_type }
    column("Receta") { |d| d.requires_prescription? ? "Sí" : "No" }
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :active_ingredient
      row :form
      row :dosage
      row :drug_type
      row :requires_prescription
      row :therapeutic_group
      row :via
      row :slug
      row :created_at
      row :updated_at
    end

    panel "Entradas de precio (#{resource.price_entries.count})" do
      table_for resource.price_entries.includes(:pharmacy).order(:price_per_unit) do
        column("Farmacia")    { |e| e.pharmacy.name }
        column("$/pieza")     { |e| number_with_precision(e.price_per_unit, precision: 2) }
        column("$/caja")      { |e| number_with_precision(e.price_per_box, precision: 2) }
        column("Piezas")      { |e| e.units_per_box }
        column("Stock")       { |e| e.in_stock? ? "✓" : "—" }
        column("Actualizado") { |e| l(e.updated_at, format: :short) }
        column("") do |e|
          span { link_to "Editar",   edit_admin_price_entry_path(e) }
          span { " | " }
          span { link_to "Eliminar", admin_price_entry_path(e), method: :delete,
                          data: { confirm: "¿Eliminar este precio?" } }
        end
      end
    end

    div style: "margin-top: 0.5rem" do
      link_to "＋ Agregar precio", new_admin_price_entry_path(drug_id: resource.id),
              class: "button"
    end
  end

  form do |f|
    f.inputs "Datos del medicamento" do
      f.input :name,                  label: "Nombre comercial"
      f.input :active_ingredient,     label: "Principio activo"
      f.input :form,                  label: "Forma farmacéutica"
      f.input :dosage,                label: "Dosis"
      f.input :drug_type,             label: "Tipo", as: :select,
                                      collection: Drug::DRUG_TYPES
      f.input :requires_prescription, label: "Requiere receta"
      f.input :therapeutic_group,     label: "Grupo terapéutico"
      f.input :via,                   label: "Vía de administración"
      f.input :slug,                  label: "Slug (URL)",
                                      hint: "Se genera automáticamente si se deja en blanco"
    end
    f.actions
  end
end
