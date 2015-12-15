require 'spec_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id:@user.id
    end

    it "returns the information about a reporter on a hash" do
      user_response = json_response
      expect(user_response[:email]).to eql @user.email
    end

    it { should respond_with 200 }
  end


  describe "POST #create" do
    context "when successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, { user: @user_attributes }
      end

      it "renders the json representation for the user record created" do
        user_response = json_response
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context "when not created" do
      before(:each) do
        @invalid_user_attributes = { password: "12345678", password_confirmation: "12345678" }
        post :create, { user: @invalid_user_attributes }
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "gives an explanation" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    context "when successfully updated" do
      before(:each) do
        @user = FactoryGirl.create :user
        put :update, { id: @user.id, user: { email: "newemail@abc.com" } }
      end

      it "renders the json representation for the updated user" do
        user_response = json_response
        expect(user_response[:email]).to eql "newemail@abc.com"
      end

      it { should respond_with 200 }
    end

    context "when unsuccessfuly updated" do
      before(:each) do
        @user = FactoryGirl.create :user
        put :update, { id: @user.id, user: { email: "newemail.com" } }
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "includes details on error" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      delete :destroy, { id: @user.id }
    end

    it { should respond_with 204 }
  end
end
