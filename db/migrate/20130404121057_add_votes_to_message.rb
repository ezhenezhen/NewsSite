class AddVotesToMessage < ActiveRecord::Migration
  def change
     remove_column :messages, :user
  end
end
