class Tag < ApplicationRecord
  has_many :post_tags
  has_many :posts, through: :post_tags
  has_many :tag_follows
  has_many :users, through: :tag_follows
  
  validates :name, presence: true, uniqueness: true
end
