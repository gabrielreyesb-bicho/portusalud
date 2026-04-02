ActiveAdmin.register GenericEquivalent do
  menu label: "Equivalencias", priority: 5

  permit_params :drug_id, :reference_drug_id, :cofepris_registration

  filter :cofepris_registration

  index do
    selectable_column
    id_column
    column("Genérico")    { |ge| link_to ge.drug.name, admin_drug_path(ge.drug) }
    column("Referencia")  { |ge| link_to ge.reference_drug.name, admin_drug_path(ge.reference_drug) }
    column :cofepris_registration
    column :updated_at
    actions
  end

  form do |f|
    f.inputs "Equivalencia genérica" do
      f.input :drug,             label: "Medicamento genérico", as: :select,
                                 collection: Drug.where(drug_type: %w[generico_intercambiable branded_generic])
                                                 .order(:name).map { |d| ["#{d.name} #{d.dosage}", d.id] }
      f.input :reference_drug_id, label: "Medicamento de referencia", as: :select,
                                  collection: Drug.where(drug_type: "referencia")
                                                  .order(:name).map { |d| ["#{d.name} #{d.dosage}", d.id] }
      f.input :cofepris_registration, label: "Registro COFEPRIS"
    end
    f.actions
  end
end
