class AddQuestionIndexToQuestions < ActiveRecord::Migration
  def change
	add_index :questions, :question, unique: true
  end
end
