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

  def login_as(user)
    post login_path, params: { email: user.email, password: "password" }
  end

  after do
    Bookmark.destroy_all
    Post.destroy_all
    User.destroy_all
  end

  describe "POST /bookmarks" do
    context "when the user is not logged in" do
      it "redirects to login" do
        post "/bookmarks", params: { post_id: post_record.id }

        expect(response).to redirect_to(login_path)
      end
    end

    context "when the user is logged in" do
      before do
        login_as(other_user)
      end

      it "creates a new bookmark" do
        post "/bookmarks", params: { post_id: post_record.id }

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Added to bookmarks.")
        expect(Bookmark.last.user).to eq(other_user)
      end

      it "removes existing bookmark" do
        Bookmark.create!(user: other_user, post: post_record)

        expect { post "/bookmarks", params: { post_id: post_record.id } }.to change { Bookmark.count }.by(-1)

        follow_redirect!
        expect(response.body).to include("Bookmark removed.")
      end

      it "fails to save bookmark" do
        allow_any_instance_of(Bookmark).to receive(:save).and_return(false)

        post "/bookmarks", params: { post_id: post_record.id }

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Failed to bookmark post.")
      end
    end
  end
end
