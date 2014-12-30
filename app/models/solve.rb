class Solve
  include Mongoid::Document

  field :quest, type: Integer
  field :solver, type: Integer
  field :status, type: Integer
  field :message, type: String
  field :answer, type: String

  belongs_to :quest

end