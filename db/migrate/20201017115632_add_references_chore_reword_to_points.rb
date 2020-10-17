class AddReferencesChoreRewordToPoints < ActiveRecord::Migration[5.2]
  def change
    add_reference :points, :chore
    add_reference :points, :reword
  end
end
