class FascilitiesController < ApplicationController

  before_action :authenticate_user!

	def index
		@room = Room.find(params[:room_id])
		@fascilities = @room.fascilities.where("").order(:created_at).page params[:page]
	end

	def show
		@fascility = Fascility.find(params[:id])
		@room = @fascility.room
	end

	def new
		@room = Room.find(params[:room_id])
		@fascility = @room.fascilities.build
	end

	def create
		@room = Room.find(params[:room_id])
		@fascility = @room.fascilities.new(fascility_params)
		respond_to do |format|
      if @fascility.save
        format.html { redirect_to room_fascilities_path, :flash=> {notice: 'fascility has been created.' }}
        format.json { render :index, status: :created, location: fascilitys_path }
      else
        format.html { render :index }
        format.json { render json: @fascility, status: :unprocessable_entity }
      end
    end
  end

	def edit
		@room = Room.find(params[:room_id])
		@fascility = Fascility.find(params[:id])
	end

	def update
		@fascility = Fascility.find(params[:id])
		@room = @fascility.room
    respond_to do |format|
      if @fascility.update(fascility_params)
        format.html { redirect_to room_fascility_path(@room, @fascility), notice: 'fascility was successfully updated.' }
        format.json { render :show, status: :ok, location: @fascility }
      else
        format.html { render :edit }
        format.json { render json: @fascility.errors, status: :unprocessable_entity }
      end
    end
	end

	def destroy
		@fascility = Fascility.find(params[:id])
    @fascility.destroy
    respond_to do |format|
      format.html { redirect_to room_fascilities_path, notice: 'fascility was successfully destroyed.' }
      format.json { head :no_content }
    end
	end

private
  def fascility_params
    params.require(:fascility).permit(:name, :description)
  end
end
