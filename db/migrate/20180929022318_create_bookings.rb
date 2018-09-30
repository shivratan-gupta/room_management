class CreateBookings < ActiveRecord::Migration[5.2]
  def change
    create_table :bookings do |t|
      t.integer :duration
      t.datetime :booked_date
      t.integer :user_id
      t.integer :room_id

      t.timestamps
    end
  end
end
