class HolidaysController < ApplicationController
	before_action :authenticate_user!

	
	def index
		@holidays = Holiday.where("").order(:created_at).page params[:page]
	end

	def show
		@holiday = Holiday.find(params[:id])
	end

	def new
		@holiday = Holiday.new
	end

	def create
		@holiday = Holiday.new(holiday_params)
		respond_to do |format|
      if @holiday.save
        format.html { redirect_to holidays_path, :flash=> {notice: 'holiday has been created.' }}
        format.json { render :index, status: :created, location: holidays_path }
      else
        format.html { render :index }
        format.json { render json: @holiday, status: :unprocessable_entity }
      end
    end
  end

	def edit
		@holiday = Holiday.find(params[:id])
	end

	def update
		@holiday = Holiday.find(params[:id])
    respond_to do |format|
      if @holiday.update(holiday_params)
        format.html { redirect_to holidays_path, :flash=> {notice: 'holiday was successfully updated.' }}
        format.json { render :index, status: :created, location: holidays_path }
      else
        format.html { render :edit }
        format.json { render json: @holiday.errors, status: :unprocessable_entity }
      end
    end
	end

	def destroy
		@holiday = Holiday.find(params[:id])
    @holiday.destroy
    respond_to do |format|
      format.html { redirect_to holidays_path, notice: 'holiday was successfully destroyed.' }
      format.json { head :no_content }
    end
	end

private
  def holiday_params
    params.require(:holiday).permit(:title, :holiday_date)
  end

end
