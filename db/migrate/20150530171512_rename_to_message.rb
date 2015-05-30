class RenameToMessage < ActiveRecord::Migration
  def change
		rename_column :messages, :type, :classes
	end
end
