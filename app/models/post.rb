class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :post_tags
  has_many :tags, through: :post_tags
  has_many :bookmarks
  has_many :users, through: :bookmarks

  validates :title, presence: true
  validates :content, presence: true
end
