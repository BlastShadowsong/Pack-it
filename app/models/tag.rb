class Tag
  include Mongoid::Document

  field :name, type: String
  field :icon, type: String

  belongs_to :category

  validates_presence_of :name

  def tagged(queryable)
    queryable.where(tag_ids: self.id)
  end
end
