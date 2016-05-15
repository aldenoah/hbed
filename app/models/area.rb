class Area < ActiveRecord::Base
  belongs_to :location
  has_many :rooms

  DURATION_SELECT = [["3 hours", "3"], ["4 hours", "4"], ["5 hours", "5"], ["6 hours", "6"], ["7 hours", "7"], ["8 hours", "8"], ["9 hours", "9"]]

  def self.get_name(id)
    find_by_id(id).name
  end
end
