class Booking < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validate :time_slot
  validate :check_holiday

  private

  def time_slot
    end_time = self.booked_date + self.duration.minutes
    prev_bookings = Booking.where('room_id = ? and booked_date BETWEEN ? AND ?',self.room_id,self.booked_date,end_time)
    if prev_bookings.present?
        errors.add(:booked_date, "can't be booked as this slot is already booked.")
    end
  end

  def check_holiday
    holiday_check = Holiday.where("DATE(holiday_date) = ?", self.booked_date.to_date) 
    if holiday_check.present?
        errors.add(:booked_date, "can't be booked as this date is a holiday declared.")
    end
  end

end
