class AddAssessmentNumberToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :assessment_number, :integer
  end
end
