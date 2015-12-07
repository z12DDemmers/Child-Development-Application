class AddCognitiveScoresToChildren < ActiveRecord::Migration
  def change
    add_column :children, :cognitive_score, :float
    add_column :children, :development_of_symbolic_play_score, :float
    add_column :children, :gestural_imitation_score, :float
    add_column :children, :sound_awareness_score, :float
    add_column :children, :object_permanence_score, :float
    add_column :children, :means_end_score, :float
    add_column :children, :cause_effect_score, :float
    add_column :children, :spatial_relationships_score, :float
    add_column :children, :number_sense_score, :float
    add_column :children, :classification_score, :float
    add_column :children, :attention_maintanence_score, :float
  end
end
