class AddSubdomainRefToQuestions < ActiveRecord::Migration
  def change
    add_reference :questions, :subdomain, index: true, foreign_key: true
  end
end
