require 'csv'

namespace :add_data_to_domain do
  desc "Add data from a comma delimited file to the domain database."
  task add_data: :environment do    
    CSV.foreach("lib/domains.csv", headers: true) do |row|
      Domain.create!(row.to_hash)
    end
  end
end