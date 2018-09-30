class PagesController < ApplicationController
	def index
	  condition = []
    condition << "fascilities.name ILIKE '%#{params[:query]}%'" if params[:query].present?

    condition = condition.join(' and ')

		@bookings = Booking.joins(:room, :user).where(condition).order('booked_date desc').page params[:page]
	end
end
