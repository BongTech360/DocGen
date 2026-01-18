class CreateOrganizations < ActiveRecord::Migration[8.1]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :organization_type
      t.string :subdomain

      t.timestamps
    end
  end
end
