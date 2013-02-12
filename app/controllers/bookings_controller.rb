class BookingsController < InheritedResources::Base
  before_filter :check_auth, :except => [:index, :for]

  def create
    puts "I'm here Nigga"
    @booking = Booking.new(params[:booking])
    @booking.approved = 'PENDING'
    @booking.projector_approved = 'PENDING'
    @booking.user_id = current_user.id
    if @booking.save
      room = Room.find(@booking.room_id)
      wing = Wing.find(room.wing_id)
      flash[:success] = "Room Successfully Booked"
      redirect_to '/bookings/for/' + wing.name + '/' + room.name + '/begin/' + Date.current.to_s
    else
      render 'new'
    end
  end

  def for
    begin
      Date.parse(params[:time])
      @wing = Wing.where(:name => params[:wing]).first
      @room = Room.where(:name => params[:room], :wing_id => @wing.id).first
      @t_begin = Time.parse(params[:time]).beginning_of_day
      t_end = @t_begin + 7.days
      @bookings = Booking.find :all, :conditions => ["begin >= ? AND end < ? AND room_id = ? AND approved = 'YES'", @t_begin, t_end, @room.id]
    rescue
      redirect_to '/bookings/for/' + params[:wing] + '/' + params[:room] + '/begin/' + Date.current.to_s
    end
  end

  def list
    @bookings = Booking.where(:user_id => current_user.id).paginate(:page => params[:page], :per_page => 30).order('updated_at DESC')
  end
end
