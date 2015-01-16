class Passage
  include Mongoid::Document
  include Locatable::Indoor::Route

  belongs_to :building

  validates_presence_of :building, :floor
end
