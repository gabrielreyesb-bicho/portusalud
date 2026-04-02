Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  # Rutas de Devise con paths en español (§3.3)
  devise_for :users, path: "cuenta", path_names: {
    sign_in:  "sesion",
    sign_out: "salir",
    sign_up:  "registro"
  }

  # Buscador — núcleo del sistema
  get "/buscar",              to: "search#index",        as: :buscar
  get "/buscar/autocomplete", to: "search#autocomplete", as: :autocomplete_buscar

  # Comparativo de precios por medicamento (Etapa 3)
  get "/comparar/:slug", to: "comparisons#show", as: :comparar

  # Ficha educativa por medicamento (Etapa 6)
  get "/medicamento/:slug", to: "drug_pages#show", as: :medicamento

  # Mis medicinas — requiere sesión (Etapa 5)
  get  "/mis-medicinas",                     to: "user_medications#index",   as: :mis_medicinas
  post "/mis-medicinas/guardar/:drug_id",    to: "user_medications#create",  as: :guardar_medicamento
  delete "/mis-medicinas/quitar/:drug_id",   to: "user_medications#destroy", as: :quitar_medicamento

  # Importador de Excel (acceso solo admin, bajo /admin/importar)
  namespace :admin do
    get  "importar",          to: "imports#new",      as: :import
    post "importar",          to: "imports#create",   as: :run_import
    get  "importar/plantilla", to: "imports#template", as: :import_template
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
