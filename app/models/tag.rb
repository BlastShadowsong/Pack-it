class Tag
  include Mongoid::Document

  field :name, type: String

  belongs_to :category

  validates :name, :presence => true

  def tagged(queryable)
    queryable.where(tag_ids: self.id)
  end
end
