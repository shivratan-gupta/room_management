class Room < ApplicationRecord
  has_many :fascilities
  has_many :bookings
end
