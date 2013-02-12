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

  def forbid_signup_in_session
    if signed_in? && !current_user.superadmin
      flash[:error] = 'You need to be logged out to access that location.'
      redirect_to :controller => 'bookings'
    end
  end

  def forbid_login_in_session
    if signed_in?
      flash[:error] = 'You need to be logged out to access that location.'
      redirect_to :controller => 'bookings'
    end
  end

  def check_superadmin
    if !(signed_in? && current_user.superadmin)
      flash[:error] = 'You do not have the previlleges to access that location.'
      redirect_to :controller => 'bookings'
    end
  end

  def check_projector_admin
    if !(signed_in? && current_user.projector_admin)
      flash[:error] = 'You do not have the previlleges to access that location.'
      redirect_to :controller => 'bookings'
    end
  end

end
