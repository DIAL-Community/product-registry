require 'json'
require 'cgi'

class WikiConverter
    def convert_workflow_to_wiki(filename)
        input = open(filename)
        workflowData = input.read()

        workflowJson = JSON.parse(workflowData, object_class: OpenStruct)
        workflowJson.each do | workflow |
            outFilename = workflow.name.downcase.tr(" ", "_") + ".xml"
            output = open(outFilename, 'w')
            output.write('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'+"\n"+'<page xmlns="http://www.xwiki.org">'+"\n")
            output.write('<title>'+workflow.name+'</title>'+"\n")
            output.write('<syntax>xwiki/2.0</syntax>'+"\n")
            output.write('<content>'+"\n")
            output.write('(% class="table-bordered" %)'+"\n")
            output.write('|=Other names |'+workflow.other_names+"\n")
            output.write('|=(% style="white-space: nowrap;" %)Short description|'+workflow.short_desc+"\n")
            output.write('|=(% style="white-space: nowrap;" %)Full description|((('+workflow.full_desc+"\n")
            output.write(')))'+"\n")
            output.write('|=(% style="white-space: nowrap;" %)(((Sample mappings'+"\n"+'of WorkFlows'+"\n"+'to Use Case)))|((('+"\n")
            workflow.sample_mappings.each do |mapping|
                output.write('**'+mapping.name+'** - '+mapping.description+"\n")
            end
            output.write(')))'+"\n")
            output.write('</content>'+"\n")
            output.write('</page>'+"\n")

            # Now import into xwiki

            cmd = 'curl -u T4DAdmin:t4dadmin -X PUT --data-binary "@'+outFilename+'" -H "Content-Type: application/xml" http://159.65.239.248:8080/xwiki/rest/wikis/xwiki/spaces/Workflows/pages/'+workflow.name.delete(' ')
            puts cmd
        end
    end

    def convert_bb_to_wiki(filename)
        input = open(filename)
        bbData = input.read()

        bbJson = JSON.parse(bbData, object_class: OpenStruct)
        bbJson.each do | bb |
            outFilename = bb.name.downcase.tr(" ", "_") + ".xml"
            output = open(outFilename, 'w')
            output.write('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'+"\n"+'<page xmlns="http://www.xwiki.org">'+"\n")
            output.write('<title>'+bb.name+'</title>'+"\n")
            output.write('<syntax>xwiki/2.0</syntax>'+"\n")
            output.write('<content>'+"\n")
            output.write('(% class="table-bordered" %)'+"\n")
            output.write('|=Other names |'+bb.other_names+"\n")
            output.write('|=(% style="white-space: nowrap;" %)Short description|'+bb.short_desc+"\n")
            output.write('|=(% style="white-space: nowrap;" %)Full description|((('+bb.full_description+"\n")
            output.write(')))'+"\n")
            output.write('|=(% style="white-space: nowrap;" %)Key Digital'+"\n"+'functionalities|((('+bb.digital_function+"\n")
            output.write(')))'+"\n")
            output.write('|=(% style="white-space: nowrap;" %)(((Examples of use in'+"\n"+'different sectors)))|((('+"\n")
            bb.sector_use.each do |sector|
                output.write('**'+sector.name+'** - '+sector.description+"\n")
            end
            output.write(')))'+"\n")
            output.write('|=(% style="white-space: nowrap;" %)(((Examples of'+"\n"+'existing software)))|((('+"\n")
            bb.existing_software && bb.existing_software.each do |software|
                output.write(software+"\n")
            end
            output.write(')))'+"\n")
            output.write('|=(% style="white-space: nowrap;" %)(((Sample mappings'+"\n"+'of ICT Building'+"\n"+'Blocks to Workflows)))|((('+"\n")
            bb.workflow_mappings && bb.workflow_mappings.each do |mapping|
                output.write(mapping+"\n")
            end
            output.write(')))'+"\n")
            output.write('</content>'+"\n")
            output.write('</page>'+"\n")

            cmd = 'curl -u T4DAdmin:t4dadmin -X PUT --data-binary "@'+outFilename+'" -H "Content-Type: application/xml" http://159.65.239.248:8080/xwiki/rest/wikis/xwiki/spaces/BuildingBlocks/pages/'+bb.name.delete(' ')
            puts cmd
        end
    end

    def convert_sdg_to_wiki(filename)
      input = open(filename)
      sdgData = input.read()

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
      ];

      first_element_style = 'border-top: 0; border-bottom: 1px dotted #ccc;'
      other_element_style = 'border-bottom: 1px dotted #ccc;'

      sdgJson = JSON.parse(sdgData, object_class: OpenStruct)
      sdgJson.each_with_index do | sdg, index |
        outFilename = "SustainableDevelopmentGoals#{(index + 1).to_s.rjust(2, "0")}.xml"
        output = open(outFilename, 'w')
        output.puts('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
        output.puts('<page xmlns="http://www.xwiki.org">')
        output.puts("<title>#{sdg["description"]}</title>")
        output.puts('<syntax>xwiki/2.1</syntax>')
        output.puts('<content>')

        output.puts "(% class='box' style='background: #{sdg_bg[index]}' %)"
        output.puts '((('
        output.puts '(% style="text-align:center" %)'

        image_url = "https://www.itu.int/en/sustainable-world/PublishingImages/icons-svg/sdg#{index + 1}.svg"

        output.puts "[[image:#{image_url}||alt='" + sdg['description'] + "' height='150' width='150']]"
        output.puts ')))'

        output.puts('|(% colspan="2" rowspan="1" %)(((=== Targets ===)))'\
                    '|(% colspan="2" rowspan="1" %)(((=== Indicators ===)))')
        
        sdg['targets'].each do |target|
          output.puts "|(% style='width: 5%;' %){{id name='SDG" + sdg['code'].to_s.rjust(2, '0') + "-T" + target['code'].gsub(/\./, '') + "'/}}(((==== #{target['code']} ====)))"\
                      "|(% style='width: 45%;' %)(((#{target['description']})))|"
          output.puts '(% colspan="2" rowspan="1" %)((('
          target['indicators'].each_with_index do |indicator, index|
            code = indicator['code']
            description = CGI.escapeHTML(indicator['description'])
            if index == 0
              output.puts "|(% style='width: 5%; #{first_element_style}' %)(((==== #{code} ====)))"\
                          "|(% style='width: 45%; #{first_element_style}' %)(((#{description})))"
            else
              output.puts "|(% style='width: 5%; #{other_element_style}' %)(((==== #{code} ====)))"\
                          "|(% style='width: 45%; #{other_element_style}' %)(((#{description})))"
            end
          end
          output.puts(")))")
        end

        output.puts('</content>')
        output.puts('</page>')

        cmd = "curl -u T4DAdmin:t4dadmin -X PUT --data-binary '@#{outFilename}' "\
              "-H 'Content-Type: application/xml' "\
              "http://159.65.239.248:8080/xwiki/rest/wikis/xwiki/spaces/SDGs"\
              "/pages/SustainableDevelopmentGoals#{(index + 1).to_s.rjust(2, "0")}"
        puts cmd
      end
    end
end

converter = WikiConverter.new

#converter.convert_workflow_to_wiki("./workflows.json")
#converter.convert_bb_to_wiki("./building_blocks.json")
converter.convert_sdg_to_wiki("./sdgs.json")