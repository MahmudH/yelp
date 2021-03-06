class ReviewsController < ApplicationController
  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new(review_params)
    @review.restaurant_id = @restaurant.id
    @review.user = current_user
    @review.save

    redirect_to restaurants_path
  end
  
  def destroy

  end

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end
end
