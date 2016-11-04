class Space
  include DataMapper::Resource

  property :id,             Serial
  property :name,           String
  property :description,    Text
  property :price,          Integer
  property :available_from, Date
  property :available_to,   Date

  has n, :bookings
  belongs_to :user

  def self.search_availability(available_from, available_to)
    all(:available_from.lte => available_from,
        :available_to.gte => available_to)
  end

  def calculate_price(check_in, check_out)
    due = 0
    (check_in...check_out).each {|night| due += self.price }
    return due
  end

end
