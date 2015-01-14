require 'hybrid_crypt'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Trackable
  include ActiveModel::OneTimePassword
  extend Enumerize

  TEL_REGEXP = /(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}/


  field :role
  enumerize :role, in: [:user, :admin], default: :user

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :async,
         :registerable, :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:login]

  ## Database authenticatable
  field :tel,                type: String, default: ""
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  field :otp_secret_key, type: String
  has_one_time_password

  validates_presence_of :tel, if: :tel_required?
  validates_uniqueness_of :tel, allow_blank: true, if: :tel_changed?
  validates_format_of :tel, with: TEL_REGEXP, allow_blank: true, if: :tel_changed?


  has_many :profiles
  has_one :notification_profile, autobuild: true
  has_one :location_profile, autobuild: true
  has_one :social_profile, autobuild: true
  has_one :seeker_profile, autobuild: true
  has_one :crowdsourcing_profile, autobuild: true
  has_one :solver_profile, autobuild: true
  has_one :customer_profile, autobuild: true
  has_one :merchant_profile, autobuild: true


  # for login via tel or email
  attr_accessor :login

  def name
    (self.email unless self.email.blank?) || (self.tel unless self.tel.blank?)
  end

  def to_key
    id.to_s
  end

  def send_otp_code_to_tel
    # send to tel via sms
    UserOtpSmsJob.perform_later(self.id.to_s)
  end

  def send_otp_code_to_email
    UserMailer.otp(self.id.to_s).deliver_later
  end

  def send_otp_code
    self.send_otp_code_to_tel unless self.tel.blank?
    self.send_otp_code_to_email unless self.email.blank?
  end

  def password=(new_password)
    new_password = HybridCrypt.new.decrypt(new_password) if new_password.length > 20
    super
  end

  def self.find_first_by_auth_conditions(tainted_conditions, opts={})
    conditions = tainted_conditions.dup
    if login = conditions.delete(:login)
      self.any_of({ :tel =>  /^#{Regexp.escape(login)}$/i }, { :email =>  /^#{Regexp.escape(login)}$/i }).first
    else
      super
    end
  end

  def self.authenticate!(login, password)
    # the password must greater than 20 if it has been encrypted
    password = HybridCrypt.new.decrypt(password) if password.length > 20

    u = find_for_database_authentication(:login => login)
    return u if u && password.length == otp_digits && u.authenticate_otp(password, drift: 200)
    u if u && u.valid_password?(password)
  end

  protected
  def email_required?
    tel.blank?
  end

  def tel_required?
    email.blank?
  end

  def password_required?
    not new_record?
  end
end