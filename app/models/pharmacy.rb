class Pharmacy < ApplicationRecord
  has_one_attached :logo
  has_many :price_entries, dependent: :destroy

  KINDS = %w[cadena autoservicio].freeze

  validates :name, presence: true
  validates :kind, presence: true, inclusion: { in: KINDS }

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id kind name updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[price_entries]
  end
end
