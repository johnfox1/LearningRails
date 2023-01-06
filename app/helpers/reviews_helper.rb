module ReviewsHelper

    def average_stars(movie)
        if movie.average_stars == 0.0
            "No reviews yet"  
       else
            pluralize(
                number_with_precision(movie.average_stars, precision: 1), 
                "star")
       end
    end    


    def number_of_reviews_zero_blank(movie)
        link_to "(#{movie.reviews.size})", movie_reviews_path(movie) if movie.reviews.any?
    end


    def number_of_reviews_zero_message(movie)
        if movie.reviews.size.zero?
            "No reviews yet"
        else
            link_to pluralize(
                movie.reviews.size, "Review"), 
                movie_reviews_path(movie)
        end
    end

end
