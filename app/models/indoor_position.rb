class IndoorPosition < Position
  include Mongoid::Document

  field :coordinator, type: String
end
