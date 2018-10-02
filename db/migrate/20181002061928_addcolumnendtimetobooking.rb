class Addcolumnendtimetobooking < ActiveRecord::Migration[5.2]
  def change
  	add_column :bookings, :end_date, :datetime
  end
end
