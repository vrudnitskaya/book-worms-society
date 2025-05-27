class LikesController < ApplicationController
  before_action :set_likeable

  def create
    #  temporary
    user = User.where.not(id: @likeable.user_id).order("RANDOM()").first
    like = @likeable.likes.build(user: user)

    if like.save
      redirect_back fallback_location: root_path, notice: "Liked successfully"
    else
      redirect_back fallback_location: root_path, alert: "Unable to like"
    end
  end

  private

  def set_likeable
    likeable_type = params[:likeable_type]

    case likeable_type
    when "Post"
      @likeable = Post.find(params[:likeable_id])
    when "Comment"
      @likeable = Comment.find(params[:likeable_id])
    else
      redirect_back fallback_location: root_path, alert: "Invalid likeable type"
      nil
    end
  end
end
