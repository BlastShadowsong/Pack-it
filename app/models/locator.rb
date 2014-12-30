class Locator
  include Mongoid::Document

  field :major, type: Integer
  field :minor, type: Integer
  field :name, type: String
  # field :floor, type: Integer

  embeds_one :outdoor_position, as: :locatable
  accepts_nested_attributes_for :outdoor_position

  belongs_to :business_complex
end
