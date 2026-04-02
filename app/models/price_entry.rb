class PriceEntry < ApplicationRecord
  belongs_to :drug
  belongs_to :pharmacy

  validates :price_per_box, presence: true, numericality: { greater_than: 0 }
  validates :units_per_box, presence: true, numericality: { only_integer: true, greater_than: 0 }

  before_save :calculate_price_per_unit

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at drug_id home_delivery id in_stock pharmacy_id
       price_per_box price_per_unit promotion promotion_expiry
       units_per_box updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[drug pharmacy]
  end

  private

  # price_per_unit se calcula automáticamente para evitar inconsistencias
  def calculate_price_per_unit
    return unless price_per_box.present? && units_per_box.present? && units_per_box > 0

    self.price_per_unit = (price_per_box / units_per_box).round(2)
  end
end
