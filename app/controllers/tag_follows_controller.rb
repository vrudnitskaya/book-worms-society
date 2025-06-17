class TagFollowsController < ApplicationController
  before_action :require_login

  def index
    @followed_tags = current_user.tags
  end

  def create
    tag = Tag.find(params[:tag_id])
    current_user.tag_follows.create!(tag: tag)
    redirect_to tag_path(tag), notice: "You have subscribed to the tag ##{tag.name}"
  end

  def destroy
    tag = Tag.find(params[:tag_id])
    tag_follow = current_user.tag_follows.find_by(tag_id: tag.id)
    tag_follow&.destroy
    redirect_to tag_path(tag), notice: "You have unsubscribed from the tag"
  end
end
