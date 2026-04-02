ActiveAdmin.register User do
  menu label: "Usuarios", priority: 7

  permit_params :email, :admin

  actions :index, :show, :edit, :update

  filter :email
  filter :admin
  filter :created_at

  index do
    selectable_column
    id_column
    column :email
    column("Admin") { |u| u.admin? ? "✓ Admin" : "Usuario" }
    column("Medicinas guardadas") { |u| u.user_medications.count }
    column :created_at
    actions defaults: false do |u|
      item "Ver",   admin_user_path(u)
      item "Editar", edit_admin_user_path(u)
    end
  end

  show do
    attributes_table do
      row :email
      row("Rol") { |u| u.admin? ? "Administrador" : "Usuario" }
      row :created_at
      row :updated_at
    end
    panel "Medicamentos guardados (#{resource.user_medications.count})" do
      table_for resource.user_medications.includes(:drug) do
        column("Medicamento") { |um| um.drug.name }
        column("Guardado en") { |um| l(um.created_at, format: :short) }
      end
    end
  end

  form do |f|
    f.inputs "Usuario" do
      f.input :email, label: "Correo electrónico"
      f.input :admin, label: "¿Administrador?"
    end
    f.actions
  end
end
