class ReviewsController < ApplicationController

    before_action :require_signin
    before_action :set_movie

    def index
        @reviews = @movie.reviews.most_recent_review
    end
    

    def new
        @review = @movie.reviews.new
    end
    

    def create
        @review = @movie.reviews.new(review_params)
        @review.user = current_user
        if @review.save
            redirect_to movie_reviews_path(@movie), notice: "Review received!"
        else
            render :new, status: :unprocessable_entity
        end        
    end 


    private
    def review_params
        params.require(:review).permit(:stars, :comment)
    end
    
    def set_movie
        @movie = Movie.find_by!(slug: params[:movie_id])
    end    

end
