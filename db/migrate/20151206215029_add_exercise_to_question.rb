class AddExerciseToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :exercise, :text
  end
end
