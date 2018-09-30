class CreateFascilities < ActiveRecord::Migration[5.2]
  def change
    create_table :fascilities do |t|
      t.string :name
      t.text :description
      t.integer :room_id

      t.timestamps
    end
  end
end
