class AddDomainRefToSubdomains < ActiveRecord::Migration
  def change
    add_reference :subdomains, :domain, index: true, foreign_key: true
  end
end
