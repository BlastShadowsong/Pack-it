class CrowdsourcingProfile < Profile
  include Mongoid::Document
  include Mongoid::Timestamps

  field :credit, type: Integer, default: 100
  field :prepared_credit, type: Integer, default: 0

  enumerize :kind,
            in: [:customer, :shopkeeper, :officer],
            default: :customer

  def increase_credit(value)
    self.inc(credit: value)
  end

  def decrease_credit(value)
    self.inc(credit: (-1) * value)
  end

  def increase_prepared_credit(value)
    self.inc(prepared_credit: value)
  end

  def decrease_prepared_credit(value)
    self.inc(prepared_credit: (-1) * value)
  end
end