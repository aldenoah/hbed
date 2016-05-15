class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :rooms, dependent: :destroy
  has_many :sales, class_name: "Booking", foreign_key: "seller_id"
  has_many :purchases, class_name: "Booking", foreign_key: "buyer_id"

  ROLE_SELECT = ["Member", "Host", "Admin"]

  def member?
    self.role == "Member" 
  end

  def admin?
    self.role == "Admin"
  end

  def host?
    self.role == "Host"
  end

  def self.currency_codes
    currencies = []
    Money::Currency.table.values.each do |currency|
      currencies = currencies + [[currency[:name] + ' ('+ currency[:iso_code] +')', currency[:iso_code]]]
    end
    currencies
  end

end
