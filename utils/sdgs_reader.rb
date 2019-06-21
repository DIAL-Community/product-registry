require 'json'

def sdg_reader
  input = open("sdgs.txt")
  output = open("sdgs.json", "w")

  sdgs = []

  current_sdg = {}
  current_target = {}
  current_indicator = {}

  text = input.read
  text.gsub!(/\r\n?/, "\n")
  text.each_line do |line|
    elements = line.split("\t")
    if line.start_with? "Goal"
      current_sdg = {}
      current_sdg["code"] = "#{elements[1]}"
      current_sdg["description"] = "#{elements[2]}".strip 
      current_sdg["targets"] = []
      sdgs.push current_sdg
    elsif line.include? "Target"
      current_target = {}
      current_target["code"] = "#{elements[1]}"
      current_target["description"] = "#{elements[2]}".strip
      current_target["indicators"] = []
      current_sdg["targets"].push current_target
    else
      current_indicator = {}
      current_indicator["code"] = "#{elements[1]}"
      current_indicator["description"] = "#{elements[2]}".strip
      current_target["indicators"].push current_indicator
    end
  end

  json = JSON.pretty_generate(sdgs)
  output.write json
  output.close
  input.close
end

sdg_reader