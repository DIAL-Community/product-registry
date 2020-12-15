class AddLocaleToSectorsProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :sectors, :locale, :string, default: "en"
  end
end
