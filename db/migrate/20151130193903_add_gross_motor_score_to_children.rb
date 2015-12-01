class AddGrossMotorScoreToChildren < ActiveRecord::Migration
  def change
    add_column :children, :gross_motor_score, :float
  end
end
