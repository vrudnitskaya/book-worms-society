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
    klass = params[:likeable_type].classify.constantize
    @likeable = klass.find(params[:likeable_id])
  end
end
