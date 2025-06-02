class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :bookmarks, dependent: :destroy
  has_many :users, through: :bookmarks
  has_many :likes, as: :likeable, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true
end
