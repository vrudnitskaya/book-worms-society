require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let!(:user) do
    User.create!(
      username: "test_user",
      email: "test@example.com",
      password: "password"
    )
  end

  let!(:post_record) do
    Post.create!(
      title: "Test Post",
      content: "This is a test post content.",
      user_id: user.id
    )
  end

  after do
    Post.destroy_all
    User.destroy_all
  end

  describe "GET /posts/:id" do
    it "renders the show page" do
      get post_path(post_record)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(post_record.title)
      expect(response.body).to include(post_record.content)
    end
  end

  describe "GET /posts/new" do
    it "renders the new post form" do
      get new_post_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("New Post")
    end
  end

  describe "POST /posts" do
    it "creates a new post with a random user" do
      post_params = {
        post: {
          title: "New Test Post",
          content: "New Test Content",
          image_url: "https://test.com/image.png"
        }
      }

      expect(User.count).to be >= 1

      post posts_path, params: post_params

      new_post = Post.last
      expect(response).to redirect_to(post_path(new_post))
      follow_redirect!

      expect(response.body).to include("Post was successfully created.")
      expect(response.body).to include("New Test Post")
    end

    it "redirects to root if no users exist" do
      Post.destroy_all
      User.destroy_all

      post posts_path, params: {
        post: {
          title: "This Test",
          content: "Should fail"
        }
      }

      expect(response).to redirect_to(root_path)
      follow_redirect!

      expect(response.body).to include("No users found to assign this post.")
    end
  end

  describe "GET /posts/:id/edit" do
    it "renders the edit form" do
      get edit_post_path(post_record)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Edit Post")
    end
  end

  describe "PATCH /posts/:id" do
    it "updates the post successfully" do
      patch post_path(post_record), params: {
        post: {
          title: "Updated Title",
          content: "Updated content"
        }
      }

      expect(response).to redirect_to(post_path(post_record))
      follow_redirect!

      expect(response.body).to include("Post was successfully updated.")
      expect(response.body).to include("Updated Title")
    end

    it "renders edit if update fails" do
      patch post_path(post_record), params: {
        post: {
          title: "",
          content: "Still valid"
        }
      }

      expect(response.body).to include("Edit Post")
      expect(response.body).to include("error")
    end
  end
end
