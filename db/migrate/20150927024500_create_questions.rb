class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.tinytext :question
      t.text :description
      t.float(3,1) :minimum_age_to_ask
      t.float(3,1) :maximum_age_to_ask

      t.timestamps null: false
    end
  end
end
