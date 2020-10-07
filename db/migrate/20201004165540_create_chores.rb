class CreateChores < ActiveRecord::Migration[5.2]
  def change
    create_table :chores do |t|
      t.string :name, null:false
      t.text :description
      t.integer :point
      t.integer :date_type
      t.date :date
      t.date :start_date
      t.date :end_date
      t.integer :day_of_week
      t.integer :day_of_month

      t.timestamps
    end
  end
end
