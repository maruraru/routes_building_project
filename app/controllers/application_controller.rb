# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def authenticate_admin_user
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV.fetch('ADMIN_NAME') && password == ENV.fetch('ADMIN_PASSWORD')
    end
  end

  def main_page
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[organisation_name email password password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password remember_me])
  end

end
