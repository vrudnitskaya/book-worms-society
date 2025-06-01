class CommentsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def new
    @comment = Comment.new(
      parent_comment_id: params[:parent_comment_id],
      post_id: params[:post_id]
    )
  end

  def create
    @comment = current_user.comments.new(comment_params)

    if @comment.save
      redirect_to post_path(@comment.post_id), notice: "Comment added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to post_path(@comment.post_id), notice: "Comment updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    post_id = @comment.post_id
    @comment.destroy
    redirect_to post_path(post_id), notice: "Comment deleted."
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def authorize_user!
    unless @comment.user == current_user
      render "errors/forbidden", status: :forbidden
    end
  end

  def comment_params
    params.require(:comment).permit(:content, :post_id, :parent_comment_id)
  end
end
