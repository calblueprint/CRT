class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :toast

  before_action :authenticate_user!

  def toast
    toast = {}
    flash.each do |type, message|
      toast[:success] = message
    end
    toast
  end
end
