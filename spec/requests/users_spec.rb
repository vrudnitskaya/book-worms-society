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
      expect(response.body).to include("Followers: 1")
    end

    it "displays the number of following users" do
      get user_path(user.id)
      expect(response.body).to include("Following: 0")
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
end
