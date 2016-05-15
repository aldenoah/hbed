class Booking < ActiveRecord::Base
  monetize :subtotal_sens, :service_fee_sens, :total_sens

  belongs_to :buyer, class_name: "User"
  belongs_to :seller, class_name: "User"

  #validates :first_name, :last_name, :email, :phone, presence: true

  scope :that_are_paid, -> { where paid: true }


  include DateTimeAttribute
  date_time_attribute :check_in, :check_out
  #scope :on, lambda {|day = Date.today| where('start > ? AND end < ?', day, day)}

  def start_time
    self.check_in ##Where 'start' is a attribute of type 'Date' accessible through MyModel's relationship
  end

  def paypal_url(return_path)
    values = {
              business: "phidiaslo@gmail.com",
              cmd: "_cart",
              upload: 1,
              return: "#{Rails.application.secrets.app_host}#{return_path}",
              invoice: id,
              currency_code: 'MYR',
              item_name_1: room.title,
              amount_1: room.service_fee,
              notify_url: "#{Rails.application.secrets.app_host}/payment_notifications"
            }
    "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query
  end

  def self.generate_booking_code(size = 4)
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
    (0...size).map{ charset.to_a[rand(charset.size)] }.join
  end

end
