class CreateSubdomains < ActiveRecord::Migration
  def change
    create_table :subdomains do |t|
      t.tinytext :subdomain
      t.text :subdomain_description

      t.timestamps null: false
    end
  end
end
