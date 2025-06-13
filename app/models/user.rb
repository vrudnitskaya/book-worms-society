class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true, length: { minimum: 3 }
  validates :password, length: { minimum: 5 }, allow_nil: true, if: :password_required?
  has_many :posts
  has_many :comments
  has_many :bookmarks
  has_many :bookmarked_posts, through: :bookmarks, source: :post
  has_many :following_relationships, class_name: "Follow", foreign_key: "following_user_id"
  has_many :followed_users, through: :following_relationships, source: :followed_user
  has_many :followed_relationships, class_name: "Follow", foreign_key: "followed_user_id"
  has_many :followers, through: :followed_relationships, source: :following_user
  has_many :tag_follows
  has_many :tags, through: :tag_follows
  has_many :likes, dependent: :destroy

  def password_required?
    new_record? || password.present?
  end
end
