class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :check_auth

  protected
  def check_auth
    if !signed_in?
      redirect_to '/signin', :flash => { :error => 'You need to be logged in to access that location.' }
    end
  end
end
