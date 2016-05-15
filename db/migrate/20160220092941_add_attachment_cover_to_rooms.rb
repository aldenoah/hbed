class AddAttachmentCoverToRooms < ActiveRecord::Migration
  def self.up
    change_table :rooms do |t|
      t.attachment :cover
    end
  end

  def self.down
    remove_attachment :rooms, :cover
  end
end
