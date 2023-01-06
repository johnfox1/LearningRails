class Movie < ApplicationRecord

    before_save :set_slug

    has_many :reviews, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :fans, through: :favorites, source: :user
    has_many :critics, through: :reviews, source: :user
    has_many :categorizations, dependent: :destroy
    has_many :genres, through: :categorizations

    validates :title, presence: true, uniqueness: true
    validates :title, :released_on, :duration, presence: true
    validates :description, length: { minimum: 25 }
    validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
    validates :image_file_name, format: { with: /\w+\.(jpg|png)\z/i, message: "must be a JPG or PNG image" }
    RATINGS = %w(G PG PG-13 PG-15 MA15+ R NC-17)
    validates :rating, inclusion: { in: RATINGS }


    # Scopes for custom queries on the home page
    scope :released, -> { where("released_on < ?", Time.now).order(released_on: :desc) }
    scope :highest_gross, -> { order(total_gross: :desc) }
    scope :upcoming, -> { where("released_on > ?", Time.now).order(released_on: :asc) }
    scope :recent, ->(max=5) { where("released_on < ?", Time.now).order(released_on: :desc).limit(max) }
    scope :hits, -> { where("released_on < ?", Time.now).where("total_gross > 1000000000").order(total_gross: :desc) }
    scope :grossed_less_than, ->(amount) { where("total_gross < ?", amount).order(total_gross: :desc) }
    scope :grossed_more_than, ->(amount) { where("total_gross > ?", amount).order(total_gross: :desc) }


    def flop?
        if reviews.size > 50 && reviews.averages(:stars) > 4
            false
        elsif total_gross.zero?
            false
        elsif total_gross < 100000000
            true
        else
            false
        end
    end

    def average_stars
        reviews.average(:stars) || 0.0
    end


    def to_param
        slug
    end

    def review_count
        reviews.size
    end


    private

    def set_slug
        self.slug = title.parameterize
    end


end
