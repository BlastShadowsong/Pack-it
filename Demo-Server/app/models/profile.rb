class Profile
  include Mongoid::Document
  include Mongoid::Timestamps
  # include Mongoid::Attributes::Dynamic

  extend Enumerize

  belongs_to :user
end
