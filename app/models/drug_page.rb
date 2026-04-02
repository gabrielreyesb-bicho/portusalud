class DrugPage < ApplicationRecord
  belongs_to :drug

  validates :slug, presence: true, uniqueness: true
  validates :drug_id, uniqueness: true
end
