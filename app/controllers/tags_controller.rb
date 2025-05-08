class TagsController < ApplicationController
  def show
    @tag = Tag.find_by!(slug: params[:id])
    @posts = @tag.posts.includes(:user)
  end
end
