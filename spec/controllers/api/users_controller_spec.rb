require 'spec_helper'

describe Api::UsersController, type: :controller do

  before do
    User.destroy_all
  end

  describe "create" do
    it "creates and returns a new user from username and password params" do
      params = { 'new_user' => { 'username' => 'testuser', 'password' => 'testpass' } }

      expect{ post :create, params }
        .to change{ User.where(params['new_user']).count }
        .by 1

      expect(JSON.parse(response.body)).to eq(params['new_user'])
    end

    it "returns an error when not given a password" do
      post :create, { 'new_user' => { username: 'testuser' } }
      expect(response.code).to eq("422")
    end

    it "returns an error when not given a username" do
      post :create, { 'new_user' => { password: 'testpass' } }
      expect(response.code).to eq("422")
      
    end
  end

  describe "index" do

    before do 
      (1..3).each{ |n| User.create( id: n, username: "name#{n}", password: "pass#{n}" ) }
    end

    it "lists all usernames and ids" do
      get :index

      expect(JSON.parse(response.body)).to eq( 
        { 'users' => 
          [
            { 'id' => 1, 'username' => 'name1' },
            { 'id' => 2, 'username' => 'name2' },
            { 'id' => 3, 'username' => 'name3' }
          ]
        }
      )
    end
  end
end
