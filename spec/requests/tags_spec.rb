require 'rails_helper'

RSpec.describe "Tags", type: :request do
  describe "GET /tags/:slug" do
    it "displays the tag name and associated posts" do
      tag = Tag.create!(name: "fiction", slug: "fiction")
      user = User.create!(username: "testuser", email: "test@example.com", password: "password")
      post = Post.create!(title: "Interesting Post", content: "Some content", user: user)
      post.tags << tag

      get tag_path(tag.slug)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("fiction")
      expect(response.body).to include("Interesting Post")
    end
  end
end
