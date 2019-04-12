module OrganizationsHelper
  def export_with_params(parameters)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet :name => 'Endorsing Organizations'

    sheet.row(0).height = 20
    format = Spreadsheet::Format.new :weight => :bold, :size => 14
    sheet.row(0).default_format = format

    sheet.row(0).push "Organization", "Year", "Link", "Contact Name", "Contact Email", "Geographic Locations","Sector Specialization", "Office Locations"

    organizations = Organization.where(is_endorser: true).order(:name)

    x = 0
    organizations.each do |organization|
      contact_name = organization.contacts.map{ |contact| contact.name }.join(", ")
      contact_email = organization.contacts.map{ |contact| contact.email }.join(", ")
      sector_name = organization.sectors.map{ |sector| sector.name }.join(",")
      country_name = organization.locations.select {|location| location.location_type != 'point'}.map{|location| location.name}.join(", ")
      office_name = organization.locations.select {|location| location.location_type == 'point'}.pop
      sheet.row(x += 1).push organization.name, organization.when_endorsed.strftime("%m/%d/%Y"),
          organization.website.downcase.strip, contact_name, contact_email, country_name, sector_name, office_name.nil? ? "" : office_name.name
    end
    book.write 'public/export.xls'
  end
end
