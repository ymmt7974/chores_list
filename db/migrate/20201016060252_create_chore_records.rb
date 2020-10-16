class CreateChoreRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :chore_records do |t|
      t.date :actual_date
      t.string :comment
      t.references :chore, null: false, foreign_key: true
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
