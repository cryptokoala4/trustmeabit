class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable
  include DeviseTokenAuth::Concerns::User

  has_one :wallet

  before_save :update_identification

  def update_identification
    if self.identification.nil?
      self.identification = self.nickname
    end
  end
end
