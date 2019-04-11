module OrganizationsHelper
  def export_with_params(parameters)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet :name => 'Endorsing Organizations'

    sheet.row(0).height = 20
    format = Spreadsheet::Format.new :weight => :bold, :size => 14
    sheet.row(0).default_format = format

    sheet.row(0).push "Organization", "Year", "Active?", "Link", "Contact Name", "Contact Email", "Category", "Logo?",
        "Case Study 1", "Which Principle?", "Case Study 2", "Which Principle?", "Geographic Locations",
        "Sector Specialization", "Office Locations", "Main Offices"

    organizations = Organization.all

    x = 0
    organizations.each do |organization|
      contact_name = organization.contacts.map{ |contact| contact.name }.join(", ")
      contact_email = organization.contacts.map{ |contact| contact.email }.join(", ")
      sector_name = organization.sectors.map{ |sector| sector.name }.join(",")
      country_name = organization.locations.select {|location| location.location_type != 'point'}.map{|location| location.name}.join(", ")
      office_name = organization.locations.select {|location| location.location_type == 'point'}.pop
      sheet.row(x += 1).push organization.name, organization.when_endorsed.strftime("%m/%d/%Y"), "--Active--",
          organization.website.downcase.strip, contact_name, contact_email, "--Category--", "--Logo--",
          "--Case Study 1--", "--Which Principle--", "--Case Study 2--", "--Which Principle--", country_name,
          sector_name, "--Office Locations--", office_name.nil? ? "--No Office--" : office_name.name
    end
    book.write 'public/export.xlsx'
  end
end
