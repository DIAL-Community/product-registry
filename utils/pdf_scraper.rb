require 'pdf-reader'
require 'json'

class PDFScraper
    def extract_data_from_pdf(inFile, startPage, endPage, tags, outFile)
        input = open(inFile)
        reader = PDF::Reader.new(input)

        output = open(outFile, 'w')
        output.write("[{\n")
        
        # In PDF reader, pages are 0-indexed, so decrement start and end page
        reader.pages[startPage-1..endPage-1].each do |page|
            # Go through each line. If the first character is not a space, it denotes a new object
            lines = page.text.split("\n")
            # Strip the top 3 lines off each page - this is the header/page number
            lines[3..lines.count].each do |line|
                # remove extra whitespaces
                lineContent = line.split.join(" ")
                tags.each do |tag|
                    if lineContent.include?(tag)
                        lineContent.sub! tag, '"'+tag+'":"'
                    end
                end
                if !lineContent.empty?
                    output.write(lineContent+"\n")
                end
            end
        end
        output.write("\n}]")
        output.close()
    end
end

scraper = PDFScraper.new

# To extract data, specify the pdf file, the starting page, the ending page, tags to extract, and the output file
workflow_tags = ['Other names', 'Short description', 'Full description', 'Sample mappings']
bb_tags = ['Other names', 'Short description', 'Full description', 'Key digital', 'different sectors', 'existing software', 'Sample mappings']

# I am commenting out the actual calls to scrape the pdf, as I don't want the files to accidentally get overwritten
#scraper.extract_data_from_pdf("./ict4sdg.pdf", 67, 74, workflow_tags, "workflows.json")
#scraper.extract_data_from_pdf("./ict4sdg.pdf", 76, 105, bb_tags, "building_blocks.json")

