require "spec_helper"

describe FollowingsController do
  describe "routing" do

    it "routes to #index" do
      get("/followings").should route_to("followings#index")
    end

    it "routes to #new" do
      get("/followings/new").should route_to("followings#new")
    end

    it "routes to #show" do
      get("/followings/1").should route_to("followings#show", :id => "1")
    end

    it "routes to #edit" do
      get("/followings/1/edit").should route_to("followings#edit", :id => "1")
    end

    it "routes to #create" do
      post("/followings").should route_to("followings#create")
    end

    it "routes to #update" do
      put("/followings/1").should route_to("followings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/followings/1").should route_to("followings#destroy", :id => "1")
    end

  end
end
