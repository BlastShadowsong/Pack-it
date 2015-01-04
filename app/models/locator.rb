class Locator
  include Mongoid::Document

  field :major, type: Integer
  field :minor, type: Integer
  field :name, type: String

  embeds_one :indoor_position, as: :locatable
  accepts_nested_attributes_for :indoor_position

  belongs_to :business_complex

  def as_json(options = nil)
    super(:include => {
              :business_complex => {:only => :uuid}
          })
  end
end
