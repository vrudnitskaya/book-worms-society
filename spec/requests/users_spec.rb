require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { User.create(username: "testuser", email: "testuser@example.com", password: "password", bio: "Hello, I am testuser and I love reading", avatar_url: "https://example.com/avatar.png") }
  let(:follower) { User.create(username: "follower", email: "follower@example.com", password: "password") }

  before do
    Follow.create(following_user: follower, followed_user: user)
  end

  describe "GET /users/:id" do
    it "displays the number of followers" do
      get user_path(user.id)
      expect(response.body).to include("Followers (1)")
    end

    it "displays the number of following users" do
      get user_path(user.id)
      expect(response.body).to include("Following (0)")
    end

    it "displays the user's name" do
      get user_path(user.id)
      expect(response.body).to include(user.username)
    end

    it "displays the user's avatar" do
      get user_path(user.id)
      expect(response.body).to include(user.avatar_url)
    end

    it "displays the user's bio" do
      get user_path(user.id)
      expect(response.body).to include(user.bio)
    end
  end

  describe "GET /users/:id/edit" do
    context "when logged in as the user" do
      before do
        post login_path, params: { email: user.email, password: "password" }
      end

      it "renders the edit profile page" do
        get edit_user_path(user)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Update Profile")
      end
    end

    context "when not logged in" do
      it "redirects to login page" do
        get edit_user_path(user)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "PATCH /users/:id" do
    before do
      post login_path, params: { email: user.email, password: "password" }
    end

    it "updates the user's username successfully" do
      patch user_path(user), params: { user: { username: "newusername" } }
      expect(response).to redirect_to(user_path(user))
      follow_redirect!
      expect(response.body).to include("newusername")
    end

    it "does not update with invalid email" do
      patch user_path(user), params: { user: { email: "" } }
      expect(response.body).to include("Email can&#39;t be blank")
    end
  end
end
