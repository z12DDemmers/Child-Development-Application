class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :question
      t.text :description
      t.float :minimum_age_to_ask
      t.float :maximum_age_to_ask

      t.timestamps null: false
    end
  end
end