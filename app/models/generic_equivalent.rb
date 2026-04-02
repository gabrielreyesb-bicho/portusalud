class GenericEquivalent < ApplicationRecord
  # drug = el genérico intercambiable
  belongs_to :drug
  # reference_drug = el innovador
  belongs_to :reference_drug, class_name: "Drug", foreign_key: :reference_drug_id

  validates :drug_id, uniqueness: { scope: :reference_drug_id }
  validates :reference_drug_id, presence: true
end
