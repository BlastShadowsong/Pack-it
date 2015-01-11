class CrowdsourcingProfile < Profile
  include Mongoid::Document
  include Mongoid::Timestamps

  field :credit, type: Integer, default: 100
  enumerize :kind,
            in: [:customer, :shopkeeper, :officer],
            default: :customer

  def increase_credit(value)
    self.inc(credit: value)
  end

  def decrease_credit(value)
    self.inc(credit: (-1) * value)
  end
end