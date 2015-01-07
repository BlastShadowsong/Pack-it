class Passage
  include Mongoid::Document
  include Locatable::Indoor::Route

  belongs_to :mall
end
