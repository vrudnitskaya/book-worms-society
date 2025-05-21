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

  describe "POST /comments" do
    it "creates a comment on a post" do
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

      get edit_comment_path(comment)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Edit Comment")
    end
  end

  describe "PATCH /comments/:id" do
    it "updates the comment if the user is an author" do
      comment = Comment.create!(content: "Old content", user: user, post: post_record)

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

    it "renders edit if update fails" do
      comment = Comment.create!(content: "Good", user: user, post: post_record)

      patch comment_path(comment), params: {
        comment: {
          content: ""
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Edit Comment")
    end
  end
end
