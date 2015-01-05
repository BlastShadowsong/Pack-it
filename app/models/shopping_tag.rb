class ShoppingTag < Tag
  include Mongoid::Document

  def shops
    Shop.where(shopping_tag_ids: self.id)
  end

  def bargains
    Bargain.where(shopping_tag_ids: self.id)
  end
end
