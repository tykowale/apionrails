require 'spec_helper'

class Authentication < ApplicationController
  include Authenticable
end

RSpec.describe Authenticable, type: :controller do
  let(:authentication) { Authentication.new }
  subject { authentication }

  describe "#current_user" do
    before(:each) do
      @user = FactoryGirl.create :user
      request.headers['Authorization'] = @user.auth_token
      allow(authentication).to receive(:request).and_return(request)
    end

    it "returns the user from the authorization header" do
      expect(authentication.current_user.auth_token).to eql  @user.auth_token
    end
  end
end
