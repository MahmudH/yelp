class ReviewsController < ApplicationController
  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    #if current_user.has_reviewed? @restaurant
      @review = Review.new
    #else
      #flash[:notice] = 'You have already given a review for this restaurant'
    #end
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @restaurant.reviews.create(review_params)

    redirect_to restaurants_path
  end

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end
end
