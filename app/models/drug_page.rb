class DrugPage < ApplicationRecord
  belongs_to :drug

  validates :slug, presence: true, uniqueness: true
  validates :drug_id, uniqueness: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at drug_id educational_content id slug updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[drug]
  end
end
