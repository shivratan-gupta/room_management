class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :validatable,
  :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :bookings


  ROLES = {0 => "guest", 1 => "user", 2 => "admin"}

  attr_reader :role

  # def initialize(role_id = 0)
  #   @role = ROLES.has_key?(role_id.to_i) ? ROLES[role_id.to_i] : ROLES[0]
  # end

  def role_declare
    @role = ROLES.has_key?(self["role"].to_i) ? ROLES[self["role"].to_i] : ROLES[0]
  end
  
end
