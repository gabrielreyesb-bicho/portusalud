class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :user_medications, dependent: :destroy
  has_many :drugs, through: :user_medications

  # Encuentra o crea un usuario a partir de la respuesta de Google.
  # Si ya existe una cuenta con ese email, la vincula automáticamente.
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid      = auth.uid
      user.email    = auth.info.email

      if user.new_record?
        existing = find_by(email: auth.info.email)
        if existing
          existing.update!(provider: auth.provider, uid: auth.uid)
          return existing
        end
        user.password = Devise.friendly_token[0, 20]
      end

      user.save!
    end
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[admin created_at email id updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user_medications drugs]
  end
end
