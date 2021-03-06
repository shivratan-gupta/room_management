class ApplicationController < ActionController::Base
 	before_action :configure_permitted_parameters, if: :devise_controller?

	def current_ability
	  @current_ability ||= Ability.new(current_user)
	end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username,:full_name,:role])
  end
end
