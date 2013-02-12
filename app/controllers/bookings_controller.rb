class BookingsController < InheritedResources::Base
  require 'will_paginate/array'
  before_filter :check_auth, :except => [:index, :for]
  before_filter :set_user_for_model

  def create
    @booking = Booking.new(params[:booking])
    if !current_user.superadmin
      @booking.approved = 'PENDING'
      if !current_user.projector_admin
        @booking.projector_approved = 'PENDING'
      else
        @booking.projector_approved = 'YES'
      end
    else
      @booking.projector_approved = 'YES'
      @booking.approved = 'YES'
    end
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

  def pending
    if current_user.superadmin
      @bookings = Booking.find(:all, :conditions => ["begin >= ? AND approved='PENDING' AND (projector_approved='YES' OR (projector_approved='PENDING' AND projector=0))", Time.current.to_s]).paginate(:page => params[:page], :per_page => 50)
    else
      @bookings = Booking.find(:all, :conditions => ["begin >= ? AND projector_approved='PENDING'", Time.current.to_s]).paginate(:page => params[:page], :per_page => 50)
    end
  end

  def approve
    booking = Booking.find(params[:id])
    if current_user.superadmin
      booking.approved = 'YES'
    else
      booking.projector_approved = 'YES'
    end
    if booking.save
      room = Room.find(booking.room_id)
      flash[:notice] = (current_user.projector_admin ? 'Projector ' : '') + 'Booking for Room ' + Wing.find(room.wing_id).name + '-' + room.name + ' Begining on ' + booking.begin.strftime("%H:%M, %B %d, %Y") + ' and Ending on ' + booking.end.strftime("%H:%M, %B %d, %Y") + ' approved.'
    else
      flash[:error] = booking.errors.full_messages.map! { |k| "#{k}" }.join("\n")
    end
    redirect_to '/admin'
  end

  def deny
    booking = Booking.find(params[:id])
    if current_user.superadmin
      booking.approved = 'NO'
    else
      booking.projector_approved = 'NO'
    end
    if booking.save
      room = Room.find(booking.room_id)
      flash[:notice] = (current_user.projector_admin ? 'Projector ' : '') + 'Booking for Room ' + Wing.find(room.wing_id).name + '-' + room.name + ' Begining on ' + booking.begin.strftime("%H:%M, %B %d, %Y") + ' and Ending on ' + booking.end.strftime("%H:%M, %B %d, %Y") + ' denied.'
    else
      flash[:error] = booking.errors.full_messages.map! { |k| "#{k}" }.join("\n")
    end
    redirect_to '/admin'
  end

  private
  def set_user_for_model
    if signed_in?
      Booking.current_user = current_user
    end
  end
end
