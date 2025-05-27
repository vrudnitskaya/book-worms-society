class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :post_tags
  has_many :tags, through: :post_tags
  has_many :bookmarks
  has_many :users, through: :bookmarks
  has_many :likes, as: :likeable, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true
end
