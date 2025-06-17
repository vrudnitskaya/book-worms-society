class Post < ApplicationRecord
  before_save :sanitize_content
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :bookmarks, dependent: :destroy
  has_many :users, through: :bookmarks
  has_many :likes, as: :likeable, dependent: :destroy

  validates :content, presence: true, length: { minimum: 5 }
  validates :title, presence: true, length: { minimum: 3 }

  private

  def sanitize_content
    self.content = ActionController::Base.helpers.strip_tags(content)
    self.title = ActionController::Base.helpers.strip_tags(title)
  end
end
