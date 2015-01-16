class Passage
  include Mongoid::Document
  include Indoor::Route

  belongs_to :building

  validates_presence_of :building, :floor

  rails_admin do
    edit do
      field :route, :serialized
      include_all_fields
    end
  end
end
