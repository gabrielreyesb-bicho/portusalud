class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_medications, dependent: :destroy
  has_many :drugs, through: :user_medications
end
