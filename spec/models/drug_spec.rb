require "rails_helper"

RSpec.describe Drug, type: :model do
  describe "validaciones" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:active_ingredient) }
    it { should validate_presence_of(:slug) }

    it "valida unicidad del slug" do
      # shoulda-matchers necesita un subject con campos requeridos para crear el registro de referencia
      subject = Drug.new(name: "Test", active_ingredient: "test", slug: "test-100mg",
                         requires_prescription: false)
      expect(subject).to validate_uniqueness_of(:slug)
    end
  end

  describe "asociaciones" do
    it { should have_many(:price_entries).dependent(:destroy) }
    it { should have_many(:generic_equivalents).dependent(:destroy) }
    it { should have_one(:drug_page).dependent(:destroy) }
    it { should have_many(:user_medications).dependent(:destroy) }
  end

  describe ".search_by_name_and_ingredient" do
    before do
      Drug.create!(name: "Metformina", active_ingredient: "metformina",
                   dosage: "850mg", requires_prescription: true,
                   slug: "metformina-850mg")
      Drug.create!(name: "Glucophage", active_ingredient: "metformina",
                   dosage: "850mg", requires_prescription: true,
                   slug: "glucophage-850mg")
      Drug.create!(name: "Atorvastatina", active_ingredient: "atorvastatina",
                   dosage: "20mg", requires_prescription: true,
                   slug: "atorvastatina-20mg")
    end

    it "encuentra por nombre comercial exacto" do
      results = Drug.search_by_name_and_ingredient("Metformina")
      expect(results.map(&:name)).to include("Metformina")
    end

    it "encuentra por principio activo" do
      results = Drug.search_by_name_and_ingredient("metformina")
      names = results.map(&:name)
      expect(names).to include("Metformina")
      expect(names).to include("Glucophage")
    end

    it "encuentra con error tipográfico (búsqueda fuzzy)" do
      results = Drug.search_by_name_and_ingredient("metfomina")
      expect(results.map(&:name)).to include("Metformina")
    end

    it "encuentra con nombre parcial" do
      results = Drug.search_by_name_and_ingredient("atorva")
      expect(results.map(&:name)).to include("Atorvastatina")
    end

    it "no devuelve resultados para búsquedas sin relación" do
      results = Drug.search_by_name_and_ingredient("xyzabc123")
      expect(results).to be_empty
    end
  end

  describe "generación automática de slug" do
    it "genera el slug al validar si está vacío" do
      drug = Drug.new(name: "Ibuprofeno", active_ingredient: "ibuprofeno",
                      dosage: "400mg", requires_prescription: false)
      drug.valid?
      expect(drug.slug).to eq("ibuprofeno-400mg")
    end

    it "normaliza caracteres especiales en el slug" do
      drug = Drug.new(name: "Amoxicilina", active_ingredient: "amoxicilina",
                      dosage: "500mg", requires_prescription: false)
      drug.valid?
      expect(drug.slug).to match(/\A[a-z0-9-]+\z/)
    end
  end
end
