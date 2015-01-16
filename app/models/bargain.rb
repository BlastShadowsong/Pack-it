class Bargain
  include Mongoid::Document
  include Mongoid::Timestamps
  include Trackable

  field :name, type: String
  field :start, type: Time
  field :end, type: Time
  field :title, type: String
  field :content, type: String
  field :pictures, type: Array

  belongs_to :shop
  has_and_belongs_to_many :tags, inverse_of: nil



  validates_presence_of :name, :start, :end

  # FIXME: use validates_timeliness instead
  # validate :startTime_cannot_be_in_the_past,
  #          :endTime_cannot_be_in_the_past,
  #          :startTime_cannot_be_greater_than_endTime
  #
  #
  # def startTime_cannot_be_in_the_past
  #   if start.present? && start < Time.now
  #     errors.add(:start, "can't be in the past")
  #   end
  # end
  #
  # def endTime_cannot_be_in_the_past
  #   if self.end.present? && self.end < Time.now
  #     errors.add(:end, "can't be in the past")
  #   end
  # end
  #
  # def startTime_cannot_be_greater_than_endTime
  #   if start.present? && self.end.present? && self.end < start
  #       errors.add(:end, "must be greater than start time")
  #   end
  # end


  def customers
    CustomerProfile.where(bargain_ids: self.id)
  end

  def customers_count
    self.customers.count
  end
end
