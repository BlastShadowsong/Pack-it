class Locator
  include Mongoid::Document

  field :major, type: Integer
  field :minor, type: Integer
  field :name, type: String

  embeds_one :indoor_position, as: :indoor_locatable
  accepts_nested_attributes_for :indoor_position

  belongs_to :mall

  def as_json(options = nil)
    super(:include => {
              :mall => {:only => :uuid}
          })
  end
end
