class Pharmacy < ApplicationRecord
  has_one_attached :logo
  has_many :price_entries, dependent: :destroy

  KINDS = %w[cadena autoservicio].freeze

  validates :name, presence: true
  validates :kind, presence: true, inclusion: { in: KINDS }
end
