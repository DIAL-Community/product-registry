# frozen_string_literal: true

require 'json'

def sdg_reader
  input = open('sdgs.txt')
  output = open('sdgs.json', 'w')

  sdgs = []

  current_sdg = {}
  current_target = {}
  current_indicator = {}

  text = input.read
  text.gsub!(/\r\n?/, "\n")
  text.each_line do |line|
    elements = line.split("\t")
    if line.start_with?('Goal')
      current_sdg = {}
      current_sdg['code'] = (elements[1]).to_s
      current_sdg['description'] = (elements[2]).to_s.strip
      current_sdg['targets'] = []
      sdgs.push(current_sdg)
    elsif line.start_with?('Target')
      current_target = {}
      current_target['code'] = (elements[1]).to_s
      current_target['description'] = (elements[2]).to_s.strip
      current_target['indicators'] = []
      current_sdg['targets'].push(current_target)
    elsif line.start_with?('Indicator')
      current_indicator = {}
      current_indicator['code'] = (elements[1]).to_s
      current_indicator['description'] = (elements[2]).to_s.strip
      current_target['indicators'].push(current_indicator)
    else
      puts "Skipping: #{line}"
    end
  end

  json = JSON.pretty_generate(sdgs)
  output.write(json)
  output.close
  input.close
end

sdg_reader
