require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) do
    User.create!(
      username: "test_user",
      email: "test@example.com",
      password: "password"
    )
  end

  let(:post) do
    Post.create!(
      title: "Test Post",
      content: "This is a test post content.",
      user_id: user.id
    )
  end

  after do
    post.destroy
    user.destroy
  end

  describe "GET /posts/:id" do
    it "renders the show page" do
      get post_path(post)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(post.title)
      expect(response.body).to include(post.content)
    end
  end
end
