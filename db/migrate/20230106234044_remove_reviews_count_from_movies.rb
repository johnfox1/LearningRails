class RemoveReviewsCountFromMovies < ActiveRecord::Migration[7.0]
  def change
    remove_column :movies, :review_count, :integer
  end
end
