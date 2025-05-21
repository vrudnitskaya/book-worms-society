require 'rails_helper'

RSpec.describe "Bookmarks", type: :request do
  let!(:post_owner) do
    User.create!(
      username: "post_owner",
      email: "owner@example.com",
      password: "password"
    )
  end

  let!(:other_user) do
    User.create!(
      username: "other_user",
      email: "other@example.com",
      password: "password"
    )
  end

  let!(:post_record) do
    Post.create!(
      title: "Sample Post",
      content: "Some content",
      user: post_owner
    )
  end

  after do
    Bookmark.destroy_all
    Post.destroy_all
    User.destroy_all
  end

  describe "POST /bookmarks" do
    it "creates a bookmark for a user" do
      post "/bookmarks", params: { post_id: post_record.id }

      expect(response).to redirect_to(post_path(post_record))
      follow_redirect!
      expect(response.body).to include("Bookmark created for user #{other_user.username}")
    end

    it "does not create a bookmark if it already exists" do
      Bookmark.create!(user: other_user, post: post_record)

      post "/bookmarks", params: { post_id: post_record.id }

      expect(response).to redirect_to(post_path(post_record))
      follow_redirect!
      expect(response.body).to include("Bookmark already exists for user #{other_user.username}")
    end

    it "shows an error if bookmark cannot be saved" do
      allow_any_instance_of(Bookmark).to receive(:save).and_return(false)

      post "/bookmarks", params: { post_id: post_record.id }

      expect(response).to redirect_to(post_path(post_record))
      follow_redirect!
      expect(response.body).to include("Failed to create bookmark")
    end
  end
end
