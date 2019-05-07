module OrganizationsHelper
  def export_with_params(parameters)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet :name => 'Endorsing Organizations'

    sheet.row(0).height = 20
    format = Spreadsheet::Format.new :weight => :bold, :size => 14
    sheet.row(0).default_format = format

    column_length = [0, 10, 0, 0, 0, 0, 0, 0, 0]

    sheet.row(0).push "Organization", "Year", "Link", "Contact Name", "Contact Title", "Contact Email",
     "Geographic Locations", "Sector Specialization", "Office Locations"

    organizations = Organization.where(is_endorser: true).order(:name)

    x = 0
    organizations.each do |organization|
      if (column_length[0] < organization.name.length)
        column_length[0] = organization.name.length
      end

      if (column_length[2] < organization.website.length)
        column_length[2] = organization.website.length
      end

      contact_name = organization.contacts.map{ |contact| contact.name }.join(", ")
      if (column_length[3] < contact_name.length)
        column_length[3] = contact_name.length
      end

      contact_title = organization.contacts.map{ |contact| contact.title }.join(", ")
      if (column_length[4] < contact_title.length)
        column_length[4] = contact_title.length
      end

      contact_email = organization.contacts.map{ |contact| contact.email }.join(", ")
      if (column_length[5] < contact_email.length)
        column_length[5] = contact_email.length
      end

      country_name = organization.locations.select {|location| location.location_type != 'point'}.map{|location| location.name}.join(", ")
      if (column_length[6] < country_name.length)
        column_length[6] = country_name.length
      end

      sector_name = organization.sectors.map{ |sector| sector.name }.join(",")
      if (column_length[7] < sector_name.length)
        column_length[7] = sector_name.length
      end

      office = organization.locations.select {|location| location.location_type == 'point'}.pop
      if (!office.nil? && column_length[8] < office.name.length)
        column_length[8] = office.name.length
      end

      sheet.row(x += 1).push organization.name, organization.when_endorsed.strftime("%m/%d/%Y"),
          organization.website.downcase.strip, contact_name, contact_title, contact_email,
          country_name, sector_name, office.nil? ? "" : office.name
    end

    column_length.each.with_index do |c, index|
      sheet.column(index).width = c
    end

    book.write 'public/export.xls'
  end
end
