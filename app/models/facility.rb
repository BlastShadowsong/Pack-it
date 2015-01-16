class Facility < Place
  include Mongoid::Document

  rails_admin do
    edit do
      field :area, :serialized
      include_all_fields
    end
  end
end
