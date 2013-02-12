class UsersController < InheritedResources::Base

  skip_before_filter :check_auth

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to ARC Room Booking Portal."
      redirect_to :controller => 'bookings'
    else
      render 'new'
    end
  end

end
