class LikesController < ApplicationController
  before_action :require_login
  before_action :set_likeable

  def create
    existing_like = @likeable.likes.find_by(user_id: current_user.id)

    if existing_like
      if existing_like.user_id == current_user.id
        existing_like.destroy
        redirect_back fallback_location: root_path, notice: "Like removed."
      else
        render "errors/forbidden", status: :forbidden
      end
    else
      like = @likeable.likes.build(user: current_user)
      if like.save
        redirect_back fallback_location: root_path, notice: "Liked successfully."
      else
        redirect_back fallback_location: root_path, alert: "Unable to like."
      end
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
