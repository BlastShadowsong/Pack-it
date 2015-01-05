class BargainTag < Tag
  include Mongoid::Document

  def bargains
    Bargain.where(bargain_tag_ids: self.id)
  end
end
