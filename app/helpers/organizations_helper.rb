module OrganizationsHelper
  def export_with_params(parameters)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet :name => 'Endorsing Organizations'

    sheet.row(0).height = 18
    format = Spreadsheet::Format.new :color => :blue, :weight => :bold, :size => 18
    sheet.row(0).default_format = format
    bold = Spreadsheet::Format.new :weight => :bold

    organizations = Organization.all

    x = 0
    organizations.each do |organization|
      sheet.row(x += 1).push(organization.name)
    end
    book.write 'public/export.xlsx'
  end
end
