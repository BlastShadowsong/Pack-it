class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Trackable

  extend Enumerize

  field :role
  enumerize :role, in: [:user, :admin], default: :user

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:login]

  ## Database authenticatable
  field :tel,                type: String
  field :email,              type: String
  field :encrypted_password, type: String

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

  validates_presence_of :tel, unless: 'email.present?'
  validates_presence_of :encrypted_password

  # index({ tel: 1 }, { unique: true, background: true })
  # index({ email: 1 }, { unique: true, background: true })

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
    self.email unless self.email.blank?
    self.tel unless self.tel.blank?
  end

  def to_key
    id.to_s
  end

  def email_required?
    false
  end

  def self.find_first_by_auth_conditions(tainted_conditions, opts={})
    conditions = tainted_conditions.dup
    puts conditions
    if login = conditions.delete(:login)
      self.any_of({ :tel =>  /^#{Regexp.escape(login)}$/i }, { :email =>  /^#{Regexp.escape(login)}$/i }).first
    else
      super
    end
  end
end