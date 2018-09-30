class RoomManagementMailer < ApplicationMailer

	default from: 'notifications@example.com'
 
	  def booking_confirmation(user)
	    @user = user
	    @url  = 'http://example.com/login'
	    mail(to: @user.email, subject: 'Confirmation mail for Room Booking')
	  end

	   def booking_cancelation(user)
	    @user = user
	    @url  = 'http://example.com/login'
	    mail(to: @user.email, subject: 'Room booking cancelation mail')
	  end

end
