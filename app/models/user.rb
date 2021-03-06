# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation,
    :date_of_birth, :weight, :ideal_weight, :height, :do_sport, :would_do_sport

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # j?j/mm/aaaa
  date_regex = /\A((3[0-1])|([1-2][0-9])|(0?[1-9]))\/((0[1-9])|(1[0-2]))\/[0-9]{4}\z/i
  float_regex = /\A[0-9]+(.[0-9]+)*\z/i
  
  validates :name, :presence => true,
                   :length   => { :maximum => 50 }
  
  validates :email, :presence => true,
                    :format   => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }

  # Crée automatique l'attribut virtuel 'password_confirmation'.
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }

  ################
  ### my stuff ###
  ################

  validates :date_of_birth, :presence => true,
                            :length   => { :maximum => 10 },
                            :format   => { :with => date_regex }

  # leave commented, otherwise forces the user to do sport...
  #validates :do_sport,       :presence => true
  #validates :would_do_sport, :presence => true

  validates :weight, :presence => true,
                     :format => { :with => float_regex }
  validates :ideal_weight, :presence => true,
                           :numericality => { :less_than => :weight },
                           :format => { :with => float_regex }

  validates :height, :presence => true,
                     :format => { :with => float_regex }

  #No time to test first
  def getAge()
    birth = Date.parse(self.date_of_birth)
    now = Date.today
    age = now.year - birth.year
    if now.month < birth.month
      age = age - 1
    elsif now.month == birth.month
      if now.day > birth.day
        age = age - 1
      end
    end
    return age
  end

  def getIMC()
    return (self.weight / ( self.height * self.height )).round(2)
  end

  ### end of my stuff ###
  before_save :encrypt_password

  # Retour true (vrai) si le mot de passe correspond.
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
