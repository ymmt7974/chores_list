class AddReferencesToPoints < ActiveRecord::Migration[5.2]
  def change
    add_reference :points, :chore_record
  end
end
