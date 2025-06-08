require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let!(:user) do
    User.create!(username: "comment_user", email: "comment@test.com", password: "password")
  end

  let!(:other_user) do
    User.create!(username: "other_user", email: "other@test.com", password: "password")
  end

  let!(:post_record) do
    Post.create!(title: "Test Post", content: "Test Post Content", user: user)
  end

  def login_as(user)
    post login_path, params: { email: user.email, password: "password" }
  end

  describe "POST /comments" do
    it "requires login" do
      post comments_path, params: {
        comment: { content: "Unauthorized", post_id: post_record.id }
      }
      expect(response).to redirect_to(login_path)
    end

    it "creates a comment on a post" do
      login_as(user)

      post comments_path, params: {
        comment: {
          content: "This is a comment to the post",
          post_id: post_record.id
        }
      }

      expect(response).to redirect_to(post_path(post_record))
      follow_redirect!
      expect(response.body).to include("Comment added.")
      expect(Comment.last.content).to eq("This is a comment to the post")
    end

    it "creates a reply to another comment" do
      parent = Comment.create!(content: "This is a parent comment", user: user, post: post_record)
      login_as(other_user)

      post comments_path, params: {
        comment: {
          content: "Reply here",
          post_id: post_record.id,
          parent_comment_id: parent.id
        }
      }

      expect(response).to redirect_to(post_path(post_record))
      expect(Comment.last.parent_comment_id).to eq(parent.id)
    end

    it "renders new if validation fails" do
      login_as(user)

      post comments_path, params: {
        comment: {
          content: "",
          post_id: post_record.id
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Add Comment")
    end
  end

  describe "GET /comments/:id/edit" do
    it "renders the edit form for the author" do
      comment = Comment.create!(content: "My comment", user: user, post: post_record)
      login_as(user)

      get edit_comment_path(comment)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Edit Comment")
    end

    it "forbids editing by another user" do
      comment = Comment.create!(content: "You can not edit this comment", user: user, post: post_record)
      login_as(other_user)

      get edit_comment_path(comment)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "PATCH /comments/:id" do
    it "updates the comment if the user is an author" do
      comment = Comment.create!(content: "Old content", user: user, post: post_record)
      login_as(user)

      patch comment_path(comment), params: {
        comment: {
          content: "Updated content"
        }
      }

      expect(response).to redirect_to(post_path(post_record))
      follow_redirect!
      expect(response.body).to include("Comment updated.")
      expect(comment.reload.content).to eq("Updated content")
    end

    it "forbids update by another user" do
      comment = Comment.create!(content: "You can not update this.", user: user, post: post_record)
      login_as(other_user)

      patch comment_path(comment), params: {
        comment: {
          content: "Updated content"
        }
      }

      expect(response).to have_http_status(:forbidden)
      expect(comment.reload.content).to eq("You can not update this.")
    end

    it "renders edit if update fails" do
      comment = Comment.create!(content: "Good", user: user, post: post_record)
      login_as(user)

      patch comment_path(comment), params: {
        comment: {
          content: ""
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Edit Comment")
    end
  end

  describe "DELETE /comments/:id" do
    it "deletes the comment if author" do
      comment = Comment.create!(content: "To delete", user: user, post: post_record)
      login_as(user)

      delete comment_path(comment)

      expect(response).to redirect_to(post_path(post_record))
      follow_redirect!
      expect(response.body).to include("Comment deleted.")
      expect(Comment.exists?(comment.id)).to be_falsey
    end

    it "forbids deletion by another user" do
      comment = Comment.create!(content: "You can not delete this.", user: user, post: post_record)
      login_as(other_user)

      delete comment_path(comment)
      expect(response).to have_http_status(:forbidden)
      expect(Comment.exists?(comment.id)).to be_truthy
    end
  end
end
