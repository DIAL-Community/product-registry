# frozen_string_literal: true

require 'json'
require 'cgi'

class WikiConverter
  def convert_workflow_to_wiki(filename)
    input = File.open(filename)
    workflow_data = input.read

    workflow_json = JSON.parse(workflow_data, object_class: OpenStruct)
    workflow_json.each do |workflow|
      out_filename = "#{workflow.name.downcase.tr(' ', '_')}.xml"
      output = File.open(out_filename, 'w')
      output.write("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n<page xmlns=\"http://www.xwiki.org\">\n")
      output.write("<title>#{workflow.name}</title>\n")
      output.write("<syntax>xwiki/2.0</syntax>\n")
      output.write("<content>\n")
      output.write(
        "|(% style=\"background-color:#eff2fa; background:#eff2fa; border-color:#cccccc; border-style:dotted;" \
        " border-width:1px\" %)(((\n"
      )
      output.write("**Other names:** #{workflow.other_names}\n\n")
      output.write("**Short description:** #{workflow.short_desc}\n\n")
      output.write("**Full description:** \n\n#{workflow.full_desc}\n")
      output.write(")))\n\n")
      output.write("=== Sample mappings of WorkFlows to Use Case ===\n(((")
      workflow.sample_mappings.each do |mapping|
        output.write("**#{mapping.name}** - #{mapping.description}\n")
      end
      output.write(")))\n")
      output.write("</content>\n")
      output.write("</page>\n")

      # Now import into xwiki

      cmd = "curl -u T4DAdmin:t4dadmin -X PUT --data-binary \"@#{out_filename}\"" \
            " -H \"Content-Type: application/xml\"" \
            " http://159.65.239.248:8080/xwiki/rest/wikis/xwiki/spaces/Workflows/pages/#{workflow.name.delete(' ')}"
      puts cmd
    end
  end

  def convert_bb_to_wiki(filename)
    input = File.open(filename)
    bb_data = input.read

    bb_json = JSON.parse(bb_data, object_class: OpenStruct)
    bb_json.each do |bb|
      out_filename = "#{bb.name.downcase.tr(' ', '_')}.xml"
      output = File.open(out_filename, 'w')
      output.write("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n<page xmlns=\"http://www.xwiki.org\">\n")
      output.write("<title>#{bb.name}</title>\n")
      output.write("<syntax>xwiki/2.0</syntax>\n")
      output.write("<content>\n")
      output.write(
        "|(% style=\"background-color:#eff2fa; background:#eff2fa; border-color:#cccccc; border-style:dotted; "\
        " border-width:1px\" %)(((\n"
      )
      output.write("**Other names:** #{bb.other_names}\n\n")
      output.write("**Short description:** #{bb.short_desc}\n\n")
      output.write("**Full description:** \n\n#{bb.full_description}\n")
      output.write(")))\n\n")
      output.write("=== Key Digital functionalities ===\n\n#{bb.digital_function}\n")
      output.write("\n\n")
      output.write("=== Examples of use in different sectors ===\n")
      output.write(
        "|(% style=\"background-color:#eff2fa; background:#eff2fa; border-color:#cccccc; border-style:dotted;" \
        " border-width:1px; text-align:center\" %)(((\n==== Agriculture Sector ====\n)))"
      )
      output.write(
        "|(% style=\"background-color:#eff2fa; background:#eff2fa; border-color:#cccccc; border-style:dotted;" \
        "border-width:1px; text-align:center\" %)(((\n==== Education Sector ====\n)))"
      )
      output.write(
        "|(% style=\"background-color:#eff2fa; background:#eff2fa; border-color:#cccccc; border-style:dotted;" \
        "border-width:1px; text-align:center\" %)(((\n==== Health Sector ====\n)))\n"
      )
      output.write("|(% style=\"width:33%\" %)(((\n")
      bb.sector_use.each do |sector|
        output.write("#{sector.description}\n") if sector.name == 'Agriculture sector'
      end
      output.write(')))')
      output.write("|(% style=\"width:34%\" %)(((\n")
      bb.sector_use.each do |sector|
        output.write("#{sector.description}\n") if sector.name == 'Education sector'
      end
      output.write(')))')
      output.write("|(% style=\"width:33%\" %)(((\n")
      bb.sector_use.each do |sector|
        output.write("#{sector.description}\n") if sector.name == 'Health sector'
      end
      output.write(")))\n")
      output.write("=== Examples of existing software ===\n")
      bb.existing_software&.each do |software|
        output.write("#{software}\n")
      end
      output.write("\n")
      output.write("=== Sample mappings of ICT Building Blocks to Workflows ===\n")
      bb.workflow_mappings&.each do |mapping|
        output.write("#{mapping}\n")
      end
      output.write("\n")
      output.write("</content>\n")
      output.write("</page>\n")

      cmd = "curl -u T4DAdmin:t4dadmin -X PUT --data-binary \"@#{out_filename}\"" \
            " -H \"Content-Type: application/xml\"" \
            " http://159.65.239.248:8080/xwiki/rest/wikis/xwiki/spaces/BuildingBlocks/pages/#{bb.name.delete(' ')}"
      puts cmd
    end
  end

  def convert_sdg_to_wiki(filename)
    input = File.open(filename)
    sdg_data = input.read

    sdg_bg = [
      '#ea2031;',
      '#dba440;',
      '#4d9d3a;',
      '#c41e31;',
      '#fa3f2b;',
      '#35bbe0;',
      '#fabf1d;',
      '#a02345;',
      '#fa682e;',
      '#dc1867;',
      '#fa992d;',
      '#ba8735;',
      '#437c48;',
      '#3095d7;',
      '#56be32;',
      '#20689b;',
      '#234b6a;'
    ]

    first_element_style = 'border-top: 0; border-bottom: 1px dotted #ccc;'
    other_element_style = 'border-bottom: 1px dotted #ccc;'

    sdg_json = JSON.parse(sdg_data, object_class: OpenStruct)
    sdg_json.each_with_index do |sdg, index|
      out_filename = "SustainableDevelopmentGoals#{(index + 1).to_s.rjust(2, '0')}.xml"
      output = File.open(out_filename, 'w')
      output.puts('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
      output.puts('<page xmlns="http://www.xwiki.org">')
      output.puts("<title>#{sdg['description']}</title>")
      output.puts('<syntax>xwiki/2.1</syntax>')
      output.puts('<content>')

      output.puts "(% class='box' style='background: #{sdg_bg[index]}' %)"
      output.puts '((('
      output.puts '(% style="text-align:center" %)'

      image_url = "https://www.itu.int/en/sustainable-world/PublishingImages/icons-svg/sdg#{index + 1}.svg"

      output.puts "[[image:#{image_url}||alt='#{sdg['description']}' height='150' width='150']]"
      output.puts ')))'

      output.puts('|(% colspan="2" rowspan="1" %)(((=== Targets ===)))'\
                  '|(% colspan="2" rowspan="1" %)(((=== Indicators ===)))')

      sdg['targets'].each do |target|
        output.puts "|(% style='width: 5%;' %){{id name='SDG" +
                    sdg['code'].to_s.rjust(2, '0') +
                    '-T' + target['code'].gsub(/\./, '') +
                    "'/}}(((==== #{target['code']} ====)))" \
                    "|(% style='width: 45%;' %)(((#{target['description']})))|"
        output.puts '(% colspan="2" rowspan="1" %)((('
        target['indicators'].each_with_index do |indicator, i|
          code = indicator['code']
          description = CGI.escapeHTML(indicator['description'])
          if i.zero?
            output.puts "|(% style='width: 5%; #{first_element_style}' %)(((==== #{code} ====)))"\
                        "|(% style='width: 45%; #{first_element_style}' %)(((#{description})))"
          else
            output.puts "|(% style='width: 5%; #{other_element_style}' %)(((==== #{code} ====)))"\
                        "|(% style='width: 45%; #{other_element_style}' %)(((#{description})))"
          end
        end
        output.puts(')))')
      end

      output.puts('</content>')
      output.puts('</page>')

      cmd = "curl -u T4DAdmin:t4dadmin -X PUT --data-binary '@#{out_filename}' "\
            "-H 'Content-Type: application/xml' "\
            'http://159.65.239.248:8080/xwiki/rest/wikis/xwiki/spaces/SDGs'\
            "/pages/SustainableDevelopmentGoals#{(index + 1).to_s.rjust(2, '0')}"
      puts cmd
    end
  end

  def convert_usecase_to_wiki(filename)
    input = File.open(filename)
    usecase_data = input.read

    border_style = 'border-color:#cccccc; border-style:dotted; border-width:1px;'
    background_style = 'background-color:#eff2fa; background:#eff2fa;'

    usecase_json = JSON.parse(usecase_data, object_class: OpenStruct)
    usecase_json.each_with_index do |usecase, index|
      out_filename = "UseCase#{index + 1}.xml"
      output = File.open(out_filename, 'w')
      output.puts('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
      output.puts('<page xmlns="http://www.xwiki.org">')
      output.puts("<title>#{usecase['name']}</title>")
      output.puts('<syntax>xwiki/2.1</syntax>')
      output.puts('<content>')

      output.puts("|(% style='#{background_style} #{border_style}' %)")
      output.puts('(((')
      output.puts("**Summary:** #{usecase['summary']}")
      output.puts
      output.puts("**Sector:** #{usecase['sector']}")
      output.puts
      output.puts('**Mapped SDG Targets:**')

      usecase['sdgs'].each do |sdg|
        output.puts("* #{sdg['code']} #{sdg['description']}")
      end

      output.puts
      output.puts(')))')

      output.puts('===Use case steps===')

      usecase['steps'].each_with_index do |step, i|
        output.puts("**~#{i + 1}. #{step['title']} **")
        output.puts
        output.puts((step['description']).to_s)
        output.puts
      end
      output.puts

      # Output the table header.
      output.puts(
        "|(% style='text-align:center; #{background_style} #{border_style}' %)"\
        '(((==== Use Case Step ====)))'\
        "|(% style='text-align:center; #{background_style} #{border_style}' %)"\
        '(((==== Workflow ====)))'\
        "|(% style='text-align:center; #{background_style} #{border_style}' %)"\
        '(((==== ICT Building Blocks ====)))'
      )

      usecase['mappings'].each_with_index do |mapping, i|
        output.write('|(% style="width: 33%" %)(((')
        output.puts("**~#{i + 1}. #{mapping['step']['title']}**")
        output.puts
        output.puts((mapping['step']['description']).to_s)
        output.write(')))')
        output.write("|(% style='width: 34%' %)(((#{mapping['workflow']})))")
        output.write("|(% style='width: 33%' %)(((#{mapping['building block']})))")
        output.puts
      end

      output.puts('</content>')
      output.puts('</page>')

      cmd = "curl -u T4DAdmin:t4dadmin -X PUT --data-binary '@#{out_filename}' "\
            "-H 'Content-Type: application/xml' "\
            'http://159.65.239.248:8080/xwiki/rest/wikis/xwiki/spaces/UseCases'\
            "/pages/UseCases#{index + 1}"
      puts cmd
    end
  end
end

converter = WikiConverter.new

converter.convert_workflow_to_wiki('./workflows.json')
# converter.convert_bb_to_wiki("./building_blocks.json")
# converter.convert_sdg_to_wiki("./sdgs.json")
converter.convert_usecase_to_wiki('./use_case.json')
