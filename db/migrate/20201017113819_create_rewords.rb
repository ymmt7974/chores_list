class CreateRewords < ActiveRecord::Migration[5.2]
  def change
    create_table :rewords do |t|
      t.string :name
      t.string :description
      t.integer :cost_point
      t.string :asin
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
