class AddUserRefToChildren < ActiveRecord::Migration
  def change
    add_reference :children, :user, index: true, foreign_key: true
  end
end
