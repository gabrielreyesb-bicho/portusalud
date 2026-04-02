class Drug < ApplicationRecord
  include PgSearch::Model

  # Búsqueda fuzzy en nombre comercial y principio activo simultáneamente.
  # Peso A para nombre (más relevante en resultados) y B para principio activo.
  # Umbral 0.1 permite tolerancia a errores tipográficos ('metfomina' → 'metformina').
  pg_search_scope :search_by_name_and_ingredient,
    against: { name: "A", active_ingredient: "B" },
    using: {
      trigram: { threshold: 0.1 }
    }

  has_many :price_entries, dependent: :destroy
  # Equivalencias donde este medicamento es el genérico
  has_many :generic_equivalents, dependent: :destroy
  # Equivalencias donde este medicamento es el innovador (reference_drug)
  has_many :generic_equivalent_references,
           class_name: "GenericEquivalent",
           foreign_key: :reference_drug_id,
           dependent: :destroy
  has_one :drug_page, dependent: :destroy
  has_many :user_medications, dependent: :destroy

  DRUG_TYPES = %w[generico_intercambiable branded_generic referencia].freeze

  validates :name, presence: true
  validates :active_ingredient, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :requires_prescription, inclusion: { in: [ true, false ] }
  validates :drug_type, inclusion: { in: DRUG_TYPES }

  def referencia?   = drug_type == "referencia"
  def innovador?    = referencia?   # alias para compatibilidad interna
  def generico?     = drug_type == "generico_intercambiable"
  def branded?      = drug_type == "branded_generic"

  before_validation :generate_slug, if: -> { slug.blank? && name.present? && dosage.present? }

  def self.ransackable_attributes(_auth_object = nil)
    %w[active_ingredient created_at dosage drug_type form id name
       requires_prescription slug therapeutic_group updated_at via]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[drug_page generic_equivalents generic_equivalent_references
       price_entries user_medications]
  end

  def self.generate_slug(name, dosage = nil)
    base = dosage.present? ? "#{name}-#{dosage}" : name
    base.downcase.strip
        .gsub(/[áàä]/, "a").gsub(/[éèë]/, "e")
        .gsub(/[íìï]/, "i").gsub(/[óòö]/, "o")
        .gsub(/[úùü]/, "u").gsub("ñ", "n")
        .gsub(/[^a-z0-9\s-]/, "")
        .gsub(/\s+/, "-")
        .gsub(/-+/, "-")
  end

  private

  def generate_slug
    self.slug = self.class.generate_slug(name, dosage)
  end
end
