# frozen_string_literal: true

module OrganizationsHelper
  def export_with_params(with_contacts)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet(name: 'Endorsing Organizations')

    sheet.row(0).height = 20
    format = Spreadsheet::Format.new(weight: :bold, size: 14)
    sheet.row(0).default_format = format

    column_length = [0, 10, 0, 0, 0, 0]
    columns = ['Organization', 'Year', 'Link', 'Geographic Locations', 'Sector Specialization', 'Office Locations']
    column_offset = 0

    if with_contacts
      column_length.insert(3, 0, 0, 0)
      columns.insert(3, 'Contact Name', 'Contact Title', 'Contact Email')
      column_offset = 3
    end

    sheet.row(0).concat(columns)

    organizations = Organization.where(is_endorser: true).order(:name)

    x = 0
    organizations.each do |organization|
      column_length[0] = organization.name.length if column_length[0] < organization.name.length

      column_length[2] = organization.website.length if column_length[2] < organization.website.length

      contact_name = ''
      contact_title = ''
      contact_email = ''
      if with_contacts
        contact_name = organization.contacts.map(&:name).join(', ')
        column_length[3] = contact_name.length if column_length[3] < contact_name.length

        contact_title = organization.contacts.map(&:title).join(', ')
        column_length[4] = contact_title.length if column_length[4] < contact_title.length

        contact_email = organization.contacts.map(&:email).join(', ')
        column_length[5] = contact_email.length if column_length[5] < contact_email.length
      end

      country_name = organization.countries.map(&:name).join(', ')
      column_length[3 + column_offset] = country_name.length if column_length[3 + column_offset] < country_name.length

      sector_name = organization.sectors.map(&:name).join(',')
      column_length[4 + column_offset] = sector_name.length if column_length[4 + column_offset] < sector_name.length

      office = organization.offices.pop
      if !office.nil? && column_length[5 + column_offset] < office.name.length
        column_length[5 + column_offset] = office.name.length
      end

      row_data = [organization.name, organization.when_endorsed.strftime('%m/%d/%Y'),
                  organization.website.downcase.strip,
                  country_name, sector_name, office.nil? ? '' : office.name]

      row_data.insert(3, contact_name, contact_title, contact_email) if with_contacts

      sheet.row(x += 1).concat(row_data)
    end

    column_length.each.with_index do |c, index|
      sheet.column(index).width = c
    end

    toret = StringIO.new
    book.write(toret)
    toret.string
  end
end
