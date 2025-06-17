require 'rails_helper'

RSpec.describe TagsController, type: :request do
  let(:routes) { Rails.application.routes.url_helpers }

  describe "GET /tags/:id" do
    let(:user) { User.create!(email: "test@example.com", username: "tester", password: "password") }
    let(:tag) { Tag.create!(name: "ruby", slug: "ruby") }

    before do
      7.times do |i|
        post = Post.create!(title: "Post #{i}", created_at: i.minutes.ago, content: "Content #{i}", user: user)
        PostTag.create!(post: post, tag: tag)
      end
    end

    context "as a guest" do
      it "shows a tage page with 5 recent posts" do
        get routes.tag_path(tag.slug)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Post 0")
        expect(response.body).to include("Post 1")
      end
    end

    context "as a registered user" do
      before do
        post routes.login_path, params: { email: user.email, password: "password" }
      end

      it "shows an Unfollow button if the user follows this tag " do
        user.tags << tag

        get routes.tag_path(tag.slug)

        expect(response.body).to include("Unfollow")
        expect(response.body).not_to include("ПFollow")
      end

      it "shows a Follow button if the user doesn't follow this tag" do
        get routes.tag_path(tag.slug)

        expect(response.body).to include("Follow")
        expect(response.body).not_to include("Unfollow")
      end

      it "shows the page 2 with other posts" do
        get routes.tag_path(tag.slug), params: { page: 2 }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Post 5")
        expect(response.body).to include("Post 6")
      end
    end

    context "if the tag doesn't exist" do
      it "returns 404" do
        get routes.tag_path("non-existent-tag")
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
