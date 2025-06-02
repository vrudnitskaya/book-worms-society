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

  def login_as(user)
    post login_path, params: { email: user.email, password: "password" }
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

  describe "GET /posts/:id for non-existent post" do
    it "renders the 404 error page" do
      get post_path(id: "999999")
      expect(response).to have_http_status(:not_found)
      expect(response.body).to include("404")
    end
  end

  describe "GET /posts/new" do
    it "renders the new post form" do
      login_as(user)
      get new_post_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("New Post")
    end
  end

  describe "POST /posts" do
    it "creates a new post" do
      login_as(user)
      post_params = {
        post: {
          title: "New Test Post",
          content: "New Test Content",
          image_url: "https://test.com/image.png"
        }
      }

      post posts_path, params: post_params

      new_post = Post.last
      expect(response).to redirect_to(post_path(new_post))
      follow_redirect!

      expect(response.body).to include("Post was successfully created.")
      expect(response.body).to include("New Test Post")
    end
  end

  describe "GET /posts/:id/edit" do
    it "renders the edit form" do
      login_as(user)
      get edit_post_path(post_record)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Edit Post")
    end
  end

  describe "GET /posts/:id/edit for another user" do
    let!(:other_user) do
      User.create!(
        username: "another_user",
        email: "another@example.com",
        password: "password"
      )
    end

    before do
      post login_path, params: { email: other_user.email, password: "password" }
    end

    it "renders the 403 error page" do
      get edit_post_path(post_record)
      expect(response).to have_http_status(:forbidden)
      expect(response.body).to include("403")
    end
  end

  describe "PATCH /posts/:id" do
    it "updates the post successfully" do
      login_as(user)
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
      login_as(user)
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
