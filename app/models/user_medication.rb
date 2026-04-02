class UserMedication < ApplicationRecord
  belongs_to :user
  belongs_to :drug

  validates :drug_id, uniqueness: { scope: :user_id }
end
