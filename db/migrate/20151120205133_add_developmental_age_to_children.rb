class AddDevelopmentalAgeToChildren < ActiveRecord::Migration
  def change
    add_column :children, :developmental_age, :float
  end
end
