class RoomManagementMailer < ApplicationMailer

	default from: 'shiv58ratan@gmail.com'
 
	  def booking_confirmation(user)
	    @user = user
	    @url  = 'https://meeting-room-management.herokuapp.com/users/sign_in'
	    @app_name  = 'https://meeting-room-management.herokuapp.com'
	    mail(to: @user.email, subject: 'Confirmation mail for Room Booking')
	  end

	   def booking_cancelation(user)
	    @user = user
	    @url  = 'https://meeting-room-management.herokuapp.com/users/sign_in'
	    @app_name  = 'https://meeting-room-management.herokuapp.com'
	    mail(to: @user.email, subject: 'Room booking cancelation mail')
	  end

	 def booking_confirmation_for_waiting(user,booking)
	    @user = user
	    @booking = booking
	    @url  = 'https://meeting-room-management.herokuapp.com/users/sign_in'
	    @app_name  = 'https://meeting-room-management.herokuapp.com'
	    mail(to: @user.email, subject: 'Confirmation mail for Room Booking')
	  end

end
