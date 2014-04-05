# -*- coding: utf-8 -*-
require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar",
      :date_of_birth => "06/01/1990",
      :weight => "65",
      :ideal_weight => "60",
      :do_sport => false,
      :would_do_sport => true
    }
  end

  it "should create a new instance with valid attributes" do
    User.create!(@attr)
  end

  ############
  ### name ###
  ############

  it "require a name" do
    bad_guy = User.new(@attr.merge(:name => ""))
    bad_guy.should_not be_valid
  end

  it "require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should reject overly long names" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  #############
  ### email ###
  #############

  it "should accept a valid email address" do
    adresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    adresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject an invalid email address" do
    adresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    adresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "devrait rejeter un email double" do
    # Place un utilisateur avec un email donné dans la BD.
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "devrait rejeter une adresse email invalide jusqu'à la casse" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  ################
  ### password ###
  ################

  it "devrait exiger un mot de passe" do
    User.new(@attr.merge(:password => "", :password_confirmation => "")).
      should_not be_valid
  end

  it "devrait exiger une confirmation du mot de passe qui correspond" do
    User.new(@attr.merge(:password_confirmation => "invalid")).
      should_not be_valid
  end
  
  it "devrait rejeter les mots de passe (trop) courts" do
    short = "a" * 5
    hash = @attr.merge(:password => short, :password_confirmation => short)
    User.new(hash).should_not be_valid
  end
  
  it "devrait rejeter les (trop) longs mots de passe" do
    long = "a" * 41
    hash = @attr.merge(:password => long, :password_confirmation => long)
    User.new(hash).should_not be_valid
  end
  
  describe "password encryption" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "devrait avoir un attribut  mot de passe crypté" do
      @user.should respond_to(:encrypted_password)
    end

    it "devrait définir le mot de passe crypté" do
      @user.encrypted_password.should_not be_blank
    end

    describe "authenticate method" do

      it "devrait retourner nul en cas d'inéquation entre email/mot de passe" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "devrait retourner nil quand un email ne correspond à aucun utilisateur" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end

      it "devrait retourner l'utilisateur si email/mot de passe correspondent" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end

  end

  describe "Method has_password?" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "doit retourner true si les mots de passe coïncident" do
      @user.has_password?(@attr[:password]).should be_true
    end    
    
    it "doit retourner false si les mots de passe divergent" do
      @user.has_password?("invalide").should be_false
    end 
  end

  describe "date of birth validation" do

    it "requires a date of birth" do
      User.new(@attr.merge(:date_of_birth => "")).
        should_not be_valid
    end

    it "invalid date --> too many days" do
      User.new(@attr.merge(:date_of_birth => "35/01/1990")).
        should_not be_valid
    end

    it "invalid date --> not enough days" do
      User.new(@attr.merge(:date_of_birth => "00/01/1990")).
        should_not be_valid
    end

    it "invalid date --> too many months" do
      User.new(@attr.merge(:date_of_birth => "06/13/1990")).
        should_not be_valid
    end

    it "invalid date --> invalid format" do
      User.new(@attr.merge(:date_of_birth => "06011990")).
        should_not be_valid
    end

    it "invalid date --> too long" do
      User.new(@attr.merge(:date_of_birth => "06/01/19900")).
        should_not be_valid
    end

  end

end
