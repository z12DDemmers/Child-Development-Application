require 'roo'

namespace :add_data_to_subdomain do
  desc "Get data from a csv file to add to the subdomains table."
  task add_data: :environment do
    subdomains = Roo::Spreadsheet.open('lib/subdomains.xlsx')
	header = subdomains.row(1)
	(2..subdomains.last_row).each do |i|
	  Subdomain.create! Hash[[header, subdomains.row(i)].transpose]
	end
  end
end