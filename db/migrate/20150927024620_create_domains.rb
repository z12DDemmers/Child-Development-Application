class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.text :domain
      t.text :domain_description

      t.timestamps null: false
    end
  end
end
