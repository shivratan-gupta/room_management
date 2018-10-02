class SendMailWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  def perform(st_date,ed_date,room_id,status,user_id)
  	max_count = status.to_i
  	@user = User.find(user_id)
  	start_bookings = Booking.where('room_id = ? and booked_date <= ? and end_date >= ?',room_id,st_date,st_date)
    end_bookings = Booking.where('room_id = ? and booked_date <= ? and end_date >= ?',room_id,ed_date,ed_date)

    if start_bookings.present?
	    start_bookings.each do |x|
	    	if x.status != 0 and x.status.to_i > max_count
	    		x.status = x.status.to_i - 1
	    		x.save
	    		RoomManagementMailer.booking_confirmation_for_waiting(@user,x).deliver
	    	end
	    end
	end
    if end_bookings.present?
	    end_bookings.each do |x|
	    	if x.status != 0 and x.status.to_i > max_count
	    		x.status = x.status.to_i - 1
	    		x.save
	    		RoomManagementMailer.booking_confirmation_for_waiting(@user,x).deliver
	    	end
	    end
	end
    # Do something
  end
end
