class Upload < ActiveRecord::Base
    has_attached_file :image, :styles => { :medium => "300x300>",:thumb => "100x100>" }, :default_url => "no-image.jpg"
	
	validates_attachment :image, 
				:content_type => { :content_type => /\Aimage\/.*\Z/ },
				:size => { :less_than => 1.megabyte }
				
	belongs_to :room
end
