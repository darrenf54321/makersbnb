class Booking
  include DataMapper::Resource

  property :id,          Serial
  property :check_in,    Date
  property :check_out,   Date
  property :status,      String
  property :price,       Integer


  belongs_to :space
  belongs_to :user

  def confirmed?
    self.status == "confirmed"
  end

  def rejected?
    self.status == "rejected"
  end

  def unconfirmed?
    self.status == "unconfirmed"
  end
end
