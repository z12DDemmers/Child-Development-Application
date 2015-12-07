class AddReceptiveLanguageScoresToChildren < ActiveRecord::Migration
  def change
    add_column :children, :receptive_language_score, :float
    add_column :children, :objects_events_and_relationships_score, :float
    add_column :children, :body_parts_score, :float
    add_column :children, :understanding_directions_score, :float
  end
end
