# -*- coding: utf-8 -*-
require 'spec_helper'

describe UsersController do
  render_views
  
  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
    end

    it "devrait réussir" do
      get :show, :id => @user
      response.should be_success
    end

    it "devrait trouver le bon utilisateur" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

    it "devrait avoir le bon titre" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "devrait inclure le nom de l'utilisateur" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    #it "devrait avoir une image de profil" do
    #  get :show, :id => @user
    #  response.should have_selector("h1>img", :class => "gravatar")
    #end

  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
    
    it "should have an adequate title" do
      get 'new'
      response.should have_selector("title", :content => "Sign Up")
    end
  end

  ###############
  ### Sign Up ###
  ###############

  describe "POST 'create'" do

    describe "échec" do

      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => "" }
      end

      it "ne devrait pas créer d'utilisateur" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "devrait avoir le bon titre" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign Up")
      end

      it "devrait rendre la page 'new'" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end
  end

  describe "success" do
    
    before(:each) do
      @attr = { :name => "New User", :email => "user@example.com",
        :date_of_birth => "06/01/1990",
        :weight => "65", :ideal_weight => "60", :height => "1.80",
        :do_sport => false, :would_do_sport => true,
        :password => "foobar", :password_confirmation => "foobar" }
    end
    
    it "devrait créer un utilisateur" do
      lambda do
        post :create, :user => @attr
      end.should change(User, :count).by(1)
    end
    
    it "devrait rediriger vers la page d'affichage de l'utilisateur" do
        post :create, :user => @attr
      response.should redirect_to(user_path(assigns(:user)))
    end
    
    it "devrait avoir un message de bienvenue" do
      post :create, :user => @attr
      flash[:success].should =~ /Welcome to the Sample App/i
    end
    
    it "devrait identifier l'utilisateur" do
      post :create, :user => @attr
      controller.should be_signed_in
    end
    
  end


end
