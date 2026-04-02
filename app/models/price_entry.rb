class PriceEntry < ApplicationRecord
  belongs_to :drug
  belongs_to :pharmacy

  validates :price_per_box, presence: true, numericality: { greater_than: 0 }
  validates :units_per_box, presence: true, numericality: { only_integer: true, greater_than: 0 }

  before_save :calculate_price_per_unit

  private

  # price_per_unit se calcula automáticamente para evitar inconsistencias
  def calculate_price_per_unit
    return unless price_per_box.present? && units_per_box.present? && units_per_box > 0

    self.price_per_unit = (price_per_box / units_per_box).round(2)
  end
end
