class UsersController < InheritedResources::Base

  skip_before_filter :check_auth
  before_filter :forbid_signup_in_session, :only => [:create, :new]
  before_filter :check_superadmin, :except => [:create, :new]

  def create
    @user = User.new(params[:user])
    if !(signed_in? && current_user.superadmin)
      @user.superadmin = false
      @user.projector_admin = false
    end
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to ARC Room Booking Portal."
      redirect_to :controller => 'bookings'
    else
      render 'new'
    end
  end

end
