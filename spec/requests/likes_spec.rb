require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let!(:post_owner) do
    User.create!(
      username: "owner",
      email: "owner@example.com",
      password: "password"
    )
  end

  let!(:other_user) do
    User.create!(
      username: "other",
      email: "other@example.com",
      password: "password"
    )
  end

  let!(:post_record) do
    Post.create!(
      title: "Post to Like",
      content: "Content",
      user: post_owner
    )
  end

  after do
    Like.destroy_all
    Post.destroy_all
    User.destroy_all
  end

  describe "POST /likes" do
    it "creates a like for another user" do
      post "/likes", params: {
        likeable_type: "Post",
        likeable_id: post_record.id
      }

      expect(response).to redirect_to(root_path)
      follow_redirect!

      expect(response.body).to include("Liked successfully")
      expect(Like.last.user.username).to eq("other")
    end

    it "shows error if like fails to save" do
      allow_any_instance_of(Like).to receive(:save).and_return(false)

      post "/likes", params: {
        likeable_type: "Post",
        likeable_id: post_record.id
      }

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Unable to like")
    end
  end
end
