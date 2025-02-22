class User < ApplicationRecord
    before_validation :strip_extraneous_whitespaces
  
    VALID_EMAIL_REGEX = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\z/
  
    validates :name, presence: true
    validates :email, presence: true, 
                      format: { with: VALID_EMAIL_REGEX, message: "must be a valid email" },
                      uniqueness: { case_sensitive: false }
    validates :password, presence: true, length: { minimum: 8 }, confirmation: true
  
    has_many :memberships, dependent: :destroy
    has_many :organizations, through: :memberships
  
    has_secure_password

    has_many :app_sessions

    def self.create_app_session(email:, password:)
      return nil unless user = User.find_by(email: email.downcase)

      user.app_sessions.create if user.authenticate(password)
    end
  
    private
  
    def strip_extraneous_whitespaces
      self.name = name&.strip
      self.email = email&.strip
    end
  end
  
  
