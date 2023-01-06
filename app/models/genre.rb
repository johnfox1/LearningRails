class Genre < ApplicationRecord

    validates :name, presence: true, uniqueness: true

    has_many :categorizations, dependent: :destroy
    has_many :movies, through: :categorizations

    
end
