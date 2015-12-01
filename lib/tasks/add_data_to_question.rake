require 'roo'

namespace :add_data_to_question do
  desc "Get data from a csv file and add to questions table"
  task add_data: :environment do    
    questions = Roo::Spreadsheet.open('lib/questions.xlsx')
	header = questions.row(1)
	(2..questions.last_row).each do |i|
	  Question.create! Hash[[header, questions.row(i)].transpose]
	end
  end
end