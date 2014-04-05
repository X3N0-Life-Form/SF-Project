# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Users" do
  describe "GET /users" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get users_index_path
      response.status.should be(200)
    end
  end

  describe "sign up" do

    describe "failed" do

      it "ne devrait pas créer un nouvel utilisateur" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => ""
          fill_in "eMail",        :with => ""
          fill_in "Password",     :with => ""
          fill_in "Confirm password", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end

    describe "success" do

      it "devrait créer un nouvel utilisateur" do
        lambda do
          visit signup_path
          fill_in "Name", :with => "Example User"
          fill_in "eMail", :with => "user@example.com"
          fill_in "Password", :with => "foobar"
          fill_in "Confirm password", :with => "foobar"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end

  end

  describe "identification/déconnexion" do

    describe "l'échec" do
      it "ne devrait pas identifier l'utilisateur" do
        visit signin_path
        fill_in "eMail",    :with => ""
        fill_in "Password", :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end

    describe "le succès" do
      it "devrait identifier un utilisateur puis le déconnecter" do
        user = Factory(:user)
        visit signin_path
        fill_in "eMail",    :with => user.email
        fill_in "Password", :with => user.password
        click_button
        controller.should be_signed_in
        click_link "Disconnect"
        controller.should_not be_signed_in
      end
    end
  end

end
