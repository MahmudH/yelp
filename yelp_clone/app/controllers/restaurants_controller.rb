class RestaurantsController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end

  def restaurant_params
    params.require(:restaurant).permit(:name)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.user != current_user
      flash[:notice] = 'You cannot edit this restaurant'
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    @restaurant.update(restaurant_params)
    redirect_to '/restaurants'
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.user != current_user
      flash[:notice] = 'You cannot delete this restaurant'
      redirect_to root_path
    else
      @restaurant.destroy
      flash[:notice] = 'Restaurant deleted successfully'
      redirect_to root_path
    end
  end
end
