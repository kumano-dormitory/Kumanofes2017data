require 'csv'

error = false

if !File.exist?("../list.csv")
  puts "[Error] list.csv does not exist."
  exit
end

File.open("../jsonapi/jsonfile.txt", "w+") do |f|

  f.write("[")

  csv_data = CSV.read('../list.csv', encoding: 'utf-8', headers: true)
  csv_data.each_with_index do |data, id|

    plan = "{";
    plan = plan + "\"id\":\"#{id}\","
    plan = plan + "\"Text\":\"#{data['title']}\","
    plan = plan + "\"description\":\"#{data['detail']}\","
    plan = plan + "\"place\":\"#{data['where']}\","

    if data[0] == "regular"
      plan = plan + "\"type\":\"regular\","
      plan = plan + "\"DateId\":\"#{data['start_day'].strip}\","

      date = ""
      if !data['start_day'].nil? && !data['start_at'].nil?
        date =  data['start_day'][0..1] + "/" + data['start_day'][2..3] + " " + data['start_at']
      end
      plan = plan + "\"start\":\"" + date + "\","

      date = ""
      if !data['end_day'].nil? && !data['end_at'].nil?
        date = data['end_day'][0..1] + "/" + data['end_day'][2..3] + " " + data['end_at']
      end
      plan = plan + "\"end\":\"" + date + "\","
    elsif data[0] == "permanent"
      plan = plan  + "\"type\":\"permanent\","
    elsif data[0] == "guerrilla"
      plan = plan + "\"type\":\"guerrilla\","
    else
      next
    end

    path = ""
    if data['file_path'] != nil
      path = File.basename(data['file_path'], ".*") + ".jpg"
    end
    plan = plan + "\"ImagePath\":\"#{path}\","

    plan = plan + "},"

    f.write(plan)

    if data['file_path'] != "" && !File.exist?("../#{data['file_path']}")
      error = true
      puts "[Error] image file does not exits. Title: #{data['title']} (#{data['file_path']})"
    end
  end

  f.write("]")

  if error
    puts "Creating json file ended with error."
  else
    puts "Creating json file successfully ended."
  end

end
