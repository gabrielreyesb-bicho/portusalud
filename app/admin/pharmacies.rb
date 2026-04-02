ActiveAdmin.register Pharmacy do
  menu label: "Farmacias", priority: 3

  permit_params :name, :kind, :logo

  filter :name
  filter :kind, as: :select, collection: Pharmacy::KINDS

  index do
    selectable_column
    id_column
    column :name
    column :kind
    column("Precios registrados") { |p| p.price_entries.count }
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :kind
      row("Logo") { |p| p.logo.attached? ? image_tag(p.logo, height: 48) : "Sin logo" }
      row :created_at
      row :updated_at
    end

    panel "Precios registrados (#{resource.price_entries.count})" do
      table_for resource.price_entries.includes(:drug).order(updated_at: :desc).limit(20) do
        column("Medicamento") { |e| e.drug.name }
        column("$/pieza")     { |e| number_with_precision(e.price_per_unit, precision: 2) }
        column("$/caja")      { |e| number_with_precision(e.price_per_box, precision: 2) }
        column("Actualizado") { |e| l(e.updated_at, format: :short) }
      end
    end
  end

  form do |f|
    f.inputs "Datos de la farmacia" do
      f.input :name, label: "Nombre"
      f.input :kind, label: "Tipo", as: :select, collection: Pharmacy::KINDS
      f.input :logo, label: "Logo", as: :file,
                     hint: "Formatos recomendados: PNG o SVG. Se almacena localmente."
    end
    f.actions
  end
end
