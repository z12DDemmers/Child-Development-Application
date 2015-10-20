class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :question
      t.text :description
      t.real :minimum_age_to_ask
      t.real :maximum_age_to_ask

      t.timestamps null: false
    end
  end
end