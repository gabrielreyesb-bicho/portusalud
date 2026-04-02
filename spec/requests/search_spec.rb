require "rails_helper"

RSpec.describe "Search", type: :request do
  before do
    Drug.create!(name: "Metformina", active_ingredient: "metformina",
                 dosage: "850mg", requires_prescription: true,
                 slug: "metformina-850mg")
  end

  describe "GET /buscar" do
    it "devuelve 200 con una búsqueda válida" do
      get buscar_path, params: { q: "metformina" }
      expect(response).to have_http_status(:ok)
    end

    it "muestra el medicamento encontrado" do
      get buscar_path, params: { q: "metformina" }
      expect(response.body).to include("Metformina")
    end

    it "maneja búsquedas sin resultados sin error" do
      get buscar_path, params: { q: "xyzabc123" }
      expect(response).to have_http_status(:ok)
    end

    it "maneja query vacía sin error" do
      get buscar_path, params: { q: "" }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /buscar/autocomplete" do
    it "devuelve turbo_stream con resultados" do
      get autocomplete_buscar_path,
          params: { q: "metformina" },
          headers: { "Accept" => "text/vnd.turbo-stream.html" }
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("turbo-stream")
    end

    it "devuelve turbo_stream vacío para query corto" do
      get autocomplete_buscar_path,
          params: { q: "a" },
          headers: { "Accept" => "text/vnd.turbo-stream.html" }
      expect(response).to have_http_status(:ok)
    end
  end
end
