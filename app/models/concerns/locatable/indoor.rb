module Locatable
  module Indoor
    extend ActiveSupport::Concern

    included do
      include Mongoid::Document

      field :building, type: String
      field :floor, type: Integer
    end
  end
end