class CreateDocuments < ActiveRecord::Migration[8.1]
  def change
    create_table :documents do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :document_type
      t.string :status
      t.string :title
      t.jsonb :metadata
      t.text :qr_code_data
      t.text :digital_stamp_data
      t.datetime :generated_at

      t.timestamps
    end
  end
end
