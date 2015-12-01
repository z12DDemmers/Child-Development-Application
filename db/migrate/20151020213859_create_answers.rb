class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.boolean :response
      t.float :age_achieved
    end
  end
end
