ActiveAdmin.register DrugPage do
  menu label: "Fichas educativas", priority: 6

  permit_params :drug_id, :slug, :educational_content

  filter :drug, as: :select, collection: -> { Drug.order(:name).pluck(:name, :id) }
  filter :slug

  index do
    selectable_column
    id_column
    column("Medicamento")  { |dp| link_to dp.drug.name, admin_drug_path(dp.drug) }
    column :slug
    column("Contenido")    { |dp| truncate(dp.educational_content, length: 80) }
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row("Medicamento")  { |dp| link_to dp.drug.name, admin_drug_path(dp.drug) }
      row :slug
      row("Ver ficha pública") { |dp| link_to "/medicamento/#{dp.slug}", "/medicamento/#{dp.slug}", target: "_blank" }
      row :created_at
      row :updated_at
    end
    panel "Contenido educativo" do
      pre resource.educational_content
    end
  end

  form do |f|
    f.inputs "Ficha educativa" do
      f.input :drug, label: "Medicamento", as: :select,
                     collection: Drug.order(:name).pluck(:name, :id)
      f.input :slug, label: "Slug (URL /medicamento/:slug)",
                     hint: "Debe coincidir con el slug del medicamento"
      f.input :educational_content, label: "Contenido educativo",
                                    as: :text,
                                    input_html: { rows: 20, style: "font-family: monospace" },
                                    hint: "Separa secciones con === Título de sección ==="
    end
    f.actions
  end
end
