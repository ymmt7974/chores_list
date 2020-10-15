class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.string :name, null: false
      t.boolean :admin, null: false, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
