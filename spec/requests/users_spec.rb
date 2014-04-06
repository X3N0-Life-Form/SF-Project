# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Users" do

  describe "sign up" do

    describe "failed" do

      it "ne devrait pas créer un nouvel utilisateur" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => ""
          fill_in "eMail",        :with => ""
          fill_in "Date of Birth (dd/mm/yyyy)", :with => ""
          fill_in "Weight (in kg)", :with => ""
          fill_in "Ideal Weight (in kg)", :with => ""
          fill_in "Height (in m)", :with => ""
          # "Do you do sports?"
          # "Would you like to do sports?"
          fill_in "Password",     :with => ""
          fill_in "Confirm Password", :with => ""
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
          fill_in "Date of Birth (dd/mm/yyyy)", :with => "01/01/1990"
          fill_in "Weight (in kg)", :with => "65"
          fill_in "Ideal Weight (in kg)", :with => "60"
          fill_in "Height (in m)", :with => "1.80"
          # "Do you do sports?"
          # "Would you like to do sports?"
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
        response.should have_selector("div.flash.error", :content => "Email/Password combination ")
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
        click_link "Logout"
        controller.should_not be_signed_in
      end
    end
  end

end
