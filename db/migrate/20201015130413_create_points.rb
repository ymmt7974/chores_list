class CreatePoints < ActiveRecord::Migration[5.2]
  def change
    create_table :points do |t|
      t.integer :point
      t.integer :event
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
