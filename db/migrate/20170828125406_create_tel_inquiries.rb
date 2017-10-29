class CreateTelInquiries < ActiveRecord::Migration
  def change
    create_table :tel_inquiries do |t|
      t.boolean :setting
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
