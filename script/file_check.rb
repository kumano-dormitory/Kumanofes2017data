require 'csv'

error = false

if !File.exist?("../list.csv")
  puts "[Error] list.csv does not exist."
  exit
end

csv_data = CSV.read('../list.csv', encoding: 'utf-8', headers: true)
csv_data.each do |data|
  if data['file_path'] != "" && !File.exist?("../#{data['file_path']}")
    error = true
    puts "[Error] image file does not exits. Title: #{data['title']} (#{data['file_path']})"
  end
end

if error
  puts "file check ended with error."
else
  puts "file check successfully ended."
end
