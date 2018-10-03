class RoomsController < ApplicationController
	before_action :authenticate_user!


	def index

		condition = []
    condition << "fascilities.name LIKE '%#{params[:query]}%'" if params[:query].present?

    condition = condition.join(' and ')

		@rooms = Room.includes(:fascilities).where(condition).references(:fascilities).order('rooms.created_at desc').page params[:page]
		#@rooms = Room.where("").order(:created_at).page params[:page]
	end

	def show
		@room = Room.find(params[:id])
	end

	def new
		@room = Room.new
	end

	def create
		@room = Room.new(room_params)
		respond_to do |format|
      if @room.save
        format.html { redirect_to rooms_path, :flash=> {notice: 'Room has been created.' }}
        format.json { render :index, status: :created, location: rooms_path }
      else
        format.html { render :index }
        format.json { render json: @room, status: :unprocessable_entity }
      end
    end
  end

	def edit
		@room = Room.find(params[:id])
	end

	def update
		@room = Room.find(params[:id])
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
	end

	def destroy
		@room = Room.find(params[:id])
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_path, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
	end

  def new_booking
  	@booking = Booking.new
  	@room_id = params["id"]
  end

  def create_booking
		@user = current_user
		@rooms = Room.where("")
		@booking = Booking.new(booking_params)
		@bookings = Booking.where(:room_id => booking_params[:room_id],:booked_date => booking_params[:booked_date])
		respond_to do |format|
      if @booking.save
      	if @booking[:status].to_i != 0
      		RoomManagementMailer.booking_confirmation_for_waiting(@user,@booking).deliver
      		format.html { redirect_to rooms_path, :flash=> {notice: "Room can't be booked, As this time slot is already booked. You are in Queue, If earlier record get cancelled then you will get the room booking confirmation" }}
      		format.json { render :index, status: :created, location: rooms_path }
      	else
      		RoomManagementMailer.booking_confirmation(@user).deliver
        	format.html { redirect_to rooms_path, :flash=> {notice: 'Room has been booked.' }}
        	format.json { render :index, status: :created, location: rooms_path }
      	end
      else
        format.html { render :new_booking }
        format.json { render json: @booking, status: :unprocessable_entity }
      end
    end
  end

  def edit_booking
  	@booking = Booking.find(params[:id])
  end

  def update_booking
		@booking = Booking.find(params[:id])
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to root_path, notice: 'Booking was successfully updated.' }
        format.json { render :index, status: :ok, location: root_path }
      else
        format.html { render :edit_booking }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy_booking
  	@user = current_user
		@booking = Booking.find(params[:id])
    @booking.destroy
    SendMailWorker.perform_async(@booking.booked_date,@booking.end_date,@booking.room_id,@booking.status,@user.id)
    RoomManagementMailer.booking_cancelation(@user).deliver
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Booking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

private
  def room_params
    params.require(:room).permit(:room_no)
  end

  def booking_params
  	params[:booking][:booked_date] = Time.parse(params[:booking][:booked_date]).strftime '%d/%m/%Y %I:%M %p'
  	date = Time.parse(params[:booking][:booked_date]) + (params[:booking][:duration].to_i * 60)
  	params[:booking][:end_date] = date.strftime '%d/%m/%Y %I:%M %p'

  	st_time_for_query = Time.parse(params[:booking][:booked_date]).strftime '%Y-%m-%d %H:%M:%S'
  	ed_time_for_query = Time.parse(params[:booking][:end_date]).strftime '%Y-%m-%d %H:%M:%S'
  	start_bookings = Booking.where('room_id = ? and booked_date <= ? and end_date >= ?',params[:booking][:room_id],st_time_for_query,st_time_for_query)
    end_bookings = Booking.where('room_id = ? and booked_date <= ? and end_date >= ?',params[:booking][:room_id],ed_time_for_query,ed_time_for_query)
    if start_bookings.present? || end_bookings.present?
    	params[:booking][:status] = 	start_bookings.last.status.to_i + 1
    else
    	params[:booking][:status] = 0
    end
    params.require(:booking).permit(:room_id, :user_id, :booked_date, :duration,:end_date,:status)
  end
end
