class Room < ActiveRecord::Base
  has_attached_file :cover, 
                    :styles => { :medium => "300x300>",:thumb => "100x100>" }, 
                    :s3_protocol => :https,
                    :url => ":s3_alias_url",
                    :s3_host_alias => "media.hourbeds.com",
                    :path => "/:class/covers/:id_partition/:style/:filename",
                    :default_url => "no-image.jpg"

  
  validates :name, :premise_name, :district, :location, :area_id, presence: true
  #validates_presence_of :title, :description, :on => [:update] 
  validates_attachment  :cover, 
        :content_type => { :content_type => /\Aimage\/.*\Z/ },
        :size => { :less_than => 1.megabyte }

  monetize :deposit_sens
  monetize :price_per_three_hour_sens#,
    #numericality: {
    #  greater_than_or_equal_to: 40,
      # less_than_or_equal_to: 10000
    #}
  monetize :price_per_extra_hour_sens, :price_per_extra_guest_sens#, 
    #numericality: {
    #  greater_than_or_equal_to: 5,
      # less_than_or_equal_to: 50
    #}

  belongs_to :area
	belongs_to :user
  has_many :uploads, dependent: :destroy
  accepts_nested_attributes_for :uploads, :reject_if => lambda { |t| t['image'].nil? }, :allow_destroy => true

    
  scope :located_at, -> (area_id) { where area_id: area_id}
  scope :districted_at, -> (district) { where district: district}
  scope :with_restaurant, -> { where restaurant: true }
  scope :with_bar, -> { where bar: true }
  scope :with_balcony, -> { where balcony: true }
  scope :with_free_parking, -> { where free_parking: true }
  scope :with_free_airport_shuttle, -> { where free_airport_shuttle: true}
  scope :with_free_wifi, -> { where free_wifi: true }
  scope :with_meeting_rooms, -> { where meeting_rooms: true }
  scope :with_outdoor_pool, -> { where outdoor_pool: true }
  scope :with_indoor_pool, -> { where indoor_pool: true }
  scope :with_spa, -> { where spa: true }
  scope :with_beauty_center, -> { where beauty_center: true }
  scope :with_fitness_room, -> { where fitness_room: true }
  scope :with_massage, -> { where massage: true }
  scope :with_sauna, -> { where sauna: true }
  scope :with_jacuzzi, -> { where jacuzzi: true }
  scope :with_kitchen, -> { where kitchen: true }

  scope :that_are_active, -> { where active: true }

  #scope :less_than, -> (max_price) { where('price_per_three_hour <= ?', max_price )}
  #scope :more_than, -> (min_price) { where('price_per_three_hour >= ?', min_price )}
  HOUR_SELECT = [ ["12:00 AM", "0"], ["1:00 AM", "1"], ["2:00 AM", "2"], ["3:00 AM", "3"], ["4:00 AM", "4"],
                  ["5:00 AM", "5"], ["6:00 AM", "6"], ["7:00 AM", "7"], ["8:00 AM", "8"], ["9:00 AM", "9"], 
                  ["10:00 AM", "10"], ["11:00 AM", "11"], ["12:00 PM", "12"], ["1:00 PM", "13"], ["2:00 PM", "14"], 
                  ["3:00 PM", "15"], ["4:00 PM", "16"], ["5:00 PM", "17"], ["6:00 PM", "18"], ["7:00 PM", "19"], 
                  ["8:00 PM", "20"], ["9:00 PM", "21"], ["10:00 PM", "22"], ["11:00 PM", "23"] 
                ]

  def self.district(area)
    where(area_id: area).pluck(:district).uniq.sort_by!{ |d| d }
  end
    
  def self.total_rooms(area)
    where(area_id: area).size
  end

  def room_rates(hour)
    extra_hour = hour.to_i - 3
    total = (extra_hour * price_per_extra_hour) + price_per_three_hour
    (total * 1.2)
  end

  #def self.timeslots_for(date, duration)
  #  (Date.parse(date).beginning_of_day.to_i..(Date.parse(date).end_of_day - duration.to_i.hour + 1.second).to_i).to_a.in_groups_of(60.minutes).collect(&:first).collect { |t| Time.at(t).utc }
  #end

  def self.timeslots_for(date, start_hour, end_hour)
    ((Date.parse(date).beginning_of_day + start_hour.hour).to_i..(Date.parse(date).beginning_of_day + end_hour.hour).to_i).to_a.in_groups_of(60.minutes).collect(&:first).collect { |t| Time.at(t).utc }
  end

  #def self.timeslot_select(date, duration)
  #  (Date.parse(date).beginning_of_day.to_i..(Date.parse(date).end_of_day - duration.to_i.hour + 1.second).to_i).to_a.in_groups_of(60.minutes).collect(&:first).collect { |t| Time.at(t).utc.strftime("%l:%M %p") }
  #end

  def self.timeslot_select(date, start_hour, end_hour)
    ((Date.parse(date).beginning_of_day + start_hour.hour).to_i..(Date.parse(date).beginning_of_day + end_hour.hour).to_i).to_a.in_groups_of(60.minutes).collect(&:first).collect { |t| Time.at(t).utc.strftime("%l:%M %p") }
  end

  def available?(date, duration)
    timeslots = Room.timeslots_for(date) #Room.timeslots_for(date)
    bookings = Booking.where(room_id: id)
    result = []

    timeslots.each do |timeslot|
      bookings.each do |booking|
        if (timeslot + "#{duration}".to_i.hour).between?(booking.check_in, booking.check_out)
          result << "N/A"
        else
          result << "Avail"
        end
      end
    end
    result
    result.any? {|r| r == "Avail"}
  end

  def booking_blank?(date)
    bookings = Booking.where(room_id: id, start_date: date).blank?
  end

end

