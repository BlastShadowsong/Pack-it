class User
  include Mongoid::Document
  store_in database: 'membership'

  include Mongoid::Timestamps
  include Trackable

  extend Enumerize

  field :role
  enumerize :role, in: [:user, :admin], default: :user

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
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


  validates_presence_of :email
  validates_presence_of :encrypted_password

  ## Token authenticatable
  # field :authentication_token, :type => String
  # run 'rake db:mongoid:create_indexes' to create indexes
  # index({ email: 1 }, { unique: true, background: true })
  # field :name, :type => String
  # validates_presence_of :name
  # attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :created_at, :updated_at

  alias_method :name, :email

  has_many :profiles
  has_one :notification_profile, autobuild: true
  has_one :location_profile, autobuild: true
  has_one :social_profile, autobuild: true
  has_one :seeker_profile, autobuild: true
  has_one :crowdsourcing_profile, autobuild: true
  has_one :solver_profile, autobuild: true
  has_one :customer_profile, autobuild: true
  has_one :merchant_profile, autobuild: true

  def to_key
    id.to_s
  end
end