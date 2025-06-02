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

  def login_as(user)
    post login_path, params: { email: user.email, password: "password" }
  end

  after do
    Like.destroy_all
    Post.destroy_all
    User.destroy_all
  end

  describe "POST /likes" do
    context "when the user is not logged in" do
      it "redirects to login" do
        post "/likes", params: {
          likeable_type: "Post",
          likeable_id: post_record.id
        }

        expect(response).to redirect_to(login_path)
      end
    end

    context "when the user is logged in" do
      before do
        login_as(other_user)
      end

      it "likes a post successfully" do
        post "/likes", params: {
          likeable_type: "Post",
          likeable_id: post_record.id
        }

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Liked successfully")
        expect(Like.last.user).to eq(other_user)
        expect(Like.last.likeable).to eq(post_record)
      end

      it "removes an existing like" do
        post_record.likes.create!(user: other_user)

        expect {
          post "/likes", params: {
            likeable_type: "Post",
            likeable_id: post_record.id
          }
        }.to change { Like.count }.by(-1)

        follow_redirect!
        expect(response.body).to include("Like removed.")
      end

      it "fails to save like" do
        allow_any_instance_of(Like).to receive(:save).and_return(false)

        post "/likes", params: {
          likeable_type: "Post",
          likeable_id: post_record.id
        }

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Unable to like")
      end

      it "returns 404 for invalid likeable type" do
        post "/likes", params: {
          likeable_type: "InvalidType",
          likeable_id: 123
        }

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Invalid likeable type")
      end
    end
  end
end
