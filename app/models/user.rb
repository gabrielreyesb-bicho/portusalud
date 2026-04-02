class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_medications, dependent: :destroy
  has_many :drugs, through: :user_medications

  def self.ransackable_attributes(_auth_object = nil)
    %w[admin created_at email id updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user_medications drugs]
  end
end
