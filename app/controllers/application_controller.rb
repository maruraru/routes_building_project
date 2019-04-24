# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def authenticate_admin_user
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV.fetch('ADMIN_NAME') && password == ENV.fetch('ADMIN_PASSWORD')
    end
  end

  def main_page
  end
end
