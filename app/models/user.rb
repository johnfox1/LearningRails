class User < ApplicationRecord
  
  has_secure_password

  before_save :set_username

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie

  validates :name, presence: true
  validates :email, presence: true, format: { with: /\S+@\S+/ }, uniqueness: { case_sensitive: false }
  validates :username, presence: true, format: { with: /\A[A-Z0-9]+\z/i }, uniqueness: { case_sensitive: false }
  
  scope :by_name, -> { order(name: :asc)}
  scope :not_admins, -> { by_name.where(admin: :false) }


  # Sort by most recently sign up
  def self.most_recent_signup 
    order(created_at: :desc) 
  end
   
  def to_param
    username
  end
  
  private

  def set_username
    self.username = username.downcase
  end


end
