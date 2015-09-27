class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.tinytext :domain
      t.text :domain_description

      t.timestamps null: false
    end
  end
end
