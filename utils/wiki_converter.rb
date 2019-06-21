require 'json'

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
end

converter = WikiConverter.new

#converter.convert_workflow_to_wiki("./workflows.json")
converter.convert_bb_to_wiki("./building_blocks.json")