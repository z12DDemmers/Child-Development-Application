class AddChildRefToAnswers < ActiveRecord::Migration
  def change
    add_reference :answers, :child, index: true, foreign_key: true
  end
end
