require 'rails_helper'

RSpec.describe "Home Page", type: :request do
  describe "GET /" do
    it "returns the home page" do
      get root_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Book Worms Society")
      expect(response.body).to include("Recent Posts")
      expect(response.body).to include("Top Tags")
    end
  end
end
