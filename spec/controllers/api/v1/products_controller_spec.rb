require 'spec_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  describe "GET #index" do
    before(:each) do
      4.times { FactoryGirl.create :product }
      get :index
    end

    it "returns 4 records from the database" do
      expect(json_response[:products].length).to eql 4
    end

  end

  describe "GET #show" do
    before(:each) do
      @product = FactoryGirl.create :product
      get :show, id: @product.id
    end

    it "returns the information about a reporter on a hash" do
      product_response = json_response
      expect(product_response[:title]).to eql @product.title
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do
    context "when successfully created" do
      before(:each) do
        user = FactoryGirl.create :user
        @product_attributes = FactoryGirl.attributes_for :product
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, product: @product_attributes }
      end

      it "renders the json for the product record" do
        expect(json_response[:title]).to eql @product_attributes[:title]
      end

      it { should respond_with 201 }
    end

    context "when not created" do
      before(:each) do
        user = FactoryGirl.create :user
        @invalid_product_attributes = { title: 'Smart TV', price: 'twelve' }
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, product: @invalid_product_attributes }
      end

      it "renders an errors json" do
        expect(json_response).to have_key(:errors)
      end

      it "renders details of error" do
        expect(json_response[:errors][:price]).to include "is not a number"
      end

      it { should respond_with 422 }
    end
  end
end
