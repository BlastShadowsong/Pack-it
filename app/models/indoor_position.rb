class IndoorPosition < Position
  include Mongoid::Document

  field :radius, type: Integer
  field :coordinator, type: String
end
