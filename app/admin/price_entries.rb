ActiveAdmin.register PriceEntry do
  menu label: "Precios", priority: 4

  permit_params :drug_id, :pharmacy_id, :price_per_box, :units_per_box,
                :promotion, :promotion_expiry, :in_stock, :home_delivery

  filter :drug,     as: :select, collection: -> { Drug.order(:name).pluck(:name, :id) }
  filter :pharmacy, as: :select, collection: -> { Pharmacy.order(:name).pluck(:name, :id) }
  filter :in_stock
  filter :home_delivery
  filter :updated_at

  index do
    selectable_column
    id_column
    column("Medicamento") { |e| link_to e.drug.name, admin_drug_path(e.drug) }
    column("Farmacia")    { |e| link_to e.pharmacy.name, admin_pharmacy_path(e.pharmacy) }
    column("$/pieza")     { |e| number_with_precision(e.price_per_unit, precision: 2) }
    column("$/caja")      { |e| number_with_precision(e.price_per_box, precision: 2) }
    column("Piezas")      { |e| e.units_per_box }
    column("En stock")    { |e| e.in_stock? ? "✓" : "—" }
    column("Domicilio")   { |e| e.home_delivery? ? "✓" : "—" }
    column("Promoción")   { |e| e.promotion.present? ? "✓" : "—" }
    column :updated_at
    actions
  end

  controller do
    def new
      super
      resource.drug_id = params[:drug_id] if params[:drug_id]
    end
  end

  form do |f|
    f.inputs "Precio por farmacia" do
      f.input :drug,     label: "Medicamento", as: :select,
                         collection: Drug.order(:name).map { |d| ["#{d.name} #{d.dosage}", d.id] },
                         selected: f.object.drug_id
      f.input :pharmacy, label: "Farmacia", as: :select,
                         collection: Pharmacy.order(:name).pluck(:name, :id)
      f.input :price_per_box,  label: "Precio por caja ($)", min: 0.01
      f.input :units_per_box,  label: "Piezas por caja",    min: 1
      f.input :in_stock,       label: "En stock"
      f.input :home_delivery,  label: "Envío a domicilio"
      f.input :promotion,      label: "Descripción de promoción"
      f.input :promotion_expiry, label: "Vigencia de promoción", as: :date_picker
    end
    f.actions
  end
end
