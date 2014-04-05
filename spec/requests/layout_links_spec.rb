# -*- coding: utf-8 -*-
require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end

  it "should have a Contact page at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => "Contact")
  end

  it "should have an About page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => "About")
  end

  it "should have a Help page at '/help'" do
    get '/help'
    response.should have_selector('title', :content => "Help")
  end

  it "should have a Sign Up page at '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => "Sign Up")
  end

  describe "quand pas identifié" do
    it "doit avoir un lien de connexion" do
      visit root_path
      response.should have_selector("a", :href => signin_path,
                                         :content => "Login")
    end
  end

  describe "quand identifié" do

    before(:each) do
      @user = Factory(:user)
      visit signin_path
      fill_in :email,    :with => @user.email
      fill_in "Password", :with => @user.password
      click_button
    end

    it "devrait avoir un lien de déconnexion" do
      visit root_path
      response.should have_selector("a", :href => signout_path,
                                         :content => "Logout")
    end

    it "devrait avoir un lien vers le profil" do
      visit root_path
      response.should have_selector("a", :href => user_path(@user),
                                         :content => "Profil")
    end
  end
end
