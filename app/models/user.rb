class User < ApplicationRecord
  has_secure_password
  has_many :posts
  has_many :comments
  has_many :bookmarks
  has_many :bookmarked_posts, through: :bookmarks, source: :post
end
