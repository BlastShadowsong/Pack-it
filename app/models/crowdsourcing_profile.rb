class CrowdsourcingProfile < Profile
  include Mongoid::Document
  include Mongoid::Timestamps

  field :credit, type: Integer
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