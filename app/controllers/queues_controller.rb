class QueuesController < ApplicationController

  before_action :confirm_logged_in

  def index
    @user = User.find session[:user_id]
    @cues = Cue.all

    render :new
  end

  def new
    @cue = Cue.new
    # @rest = Restaurant.new
    @restaurant = Restaurant.all
    @dropdown_arr = []
    @restaurant.each do |f|
      @dropdown_arr.push(f.name)
    end

  end

  def create
    user = User.find session[:user_id]
    @cue = Cue.create cue_params
    user.cues << @cue
    # user = User.find session[:user_id]
    # rest_params = {}
    # rest_params["restaurant_id"] = Restaurant.find_by(name: cue_params["rests"]).id
    # rest_params["user_id"] = session[:user_id]
    # rest_params["cue_id"] = User.find(session[:user_id]).cues[0].id
    # rest_params["start_date"] = cue_params["start_date(1i)"] + "-" + cue_params["start_date(2i)"] + "-" + cue_params["start_date(3i)"]
    # rest_params["end_date"] = cue_params["end_date(1i)"] + "-" + cue_params["end_date(2i)"] + "-" + cue_params["end_date(3i)"]
    # rest_params["start_time"] = cue_params["start_time(4i)"] + ":" + cue_params["start_time(5i)"] + ":00"
    # rest_params["end_time"] = cue_params["end_time(4i)"] + ":" + cue_params["end_time(5i)"] + ":00"
    # rest_params["covers"] = cue_params["covers"]

    # @cue_res = CueRestaurant.new rest_params
    # if @cue_res.save
    #   puts "Saved successfully"
    #   Crawler.first_crawl @cue_res
    #   redirect_to home_path
    # else
    #   puts "not saved"
    #   render :new
    # end
  redirect_to cues_path
  end

  def update

    @cue = Cue.find(params[:id])
    user = User.find session[:user_id]
    rest_params = {}
    rest_params["restaurant_id"] = Restaurant.find_by(name: cue_params["rests"]).id
    rest_params["user_id"] = session[:user_id]
    rest_params["cue_id"] = @cue.id
    rest_params["start_date"] = @cue.start_date
    rest_params["end_date"] = @cue.end_date
    rest_params["start_time"] = @cue.start_time
    rest_params["end_time"] = @cue.end_time
    rest_params["covers"] = @cue.covers
    rest_params["rank"] = params["cue"]["covers"]
    @cue_res = CueRestaurant.new rest_params
    if @cue_res.save
      puts "Saved successfully"
      redirect_to cue_path @cue
    else
      puts "not saved"
      render :new
    end

  end

  def check_availability
    @cue = Cue.find(params[:cue_id])
    rest_list = CueRestaurant.where(cue_id:params[:cue_id])
    Crawler.cue_reservation_check rest_list
    redirect_to cue_path @cue
  end

  def remove_reservation
    user = User.find(session[:user_id])
    cue_id = params[:cue_id]
    @cue = Cue.find(cue_id)
    reservation = user.reservations.where(cue_id: cue_id)
    unless reservation[0].nil?
      Bot.cancel_reservation reservation[0].reservation_url, cue_id, user.id
      reservation[0].destroy
    end
    redirect_to cue_path @cue
  end

  def destroy
    @user = User.find session[:user_id]
    @cue = Cue.find(params[:id])
    @cue.destroy
    CueRestaurant.where(:cue_id => params[:id]).destroy_all
    @user.reservations.where(:cue_id => params[:id]).destroy_all
    # @findrow = CueRestaurant.find_by(restaurant_id: @findrest, start_date: @cue.start_date, end_date: @cue.end_date, start_time: @cue.start_time, end_time: @cue.end_time).destroy

    # @cue.destroy
    # if @user.cues.empty?
    #   redirect_to new_queue_path
    # else
    #   redirect_to cues_path
    # end
  redirect_to cues_path
  end

  def destroy_cue_restaurant
    @user = User.find session[:user_id]
    @cue = Cue.find(params[:cue_id])
    CueRestaurant.where(:restaurant_id => params[:restaurant_id], :cue_id => params[:cue_id]).destroy_all
    @user.reservations.where(:restaurant_id => params[:restaurant_id], :cue_id => params[:cue_id]).destroy_all
    redirect_to cue_path @cue
  end

private
  def cue_params

    params.require(:cue).permit(:user_id, :rests, :start_date, :end_date, :start_time, :end_time, :covers, :name)
  end

  def restaurant_params
    params.require(:restaurant).permit(:id)
  end

end
