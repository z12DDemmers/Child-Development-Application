class AddScoresToChildren < ActiveRecord::Migration
  def change
    add_column :children, :prone_score, :float
    add_column :children, :supine_score, :float
    add_column :children, :responses_score, :float
    add_column :children, :reflexes_score, :float
    add_column :children, :sitting_score, :float
    add_column :children, :standing_score, :float
    add_column :children, :mobility_score, :float
    add_column :children, :throwing_and_catching_score, :float
  end
end
