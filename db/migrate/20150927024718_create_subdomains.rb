class CreateSubdomains < ActiveRecord::Migration
  def change
    create_table :subdomains do |t|
      t.text :subdomain
      t.text :subdomain_description

      t.timestamps null: false
    end
  end
end
