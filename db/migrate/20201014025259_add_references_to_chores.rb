class AddReferencesToChores < ActiveRecord::Migration[5.2]
  def change
    add_reference :chores, :user, index: true, foreign_key: true
  end
end
