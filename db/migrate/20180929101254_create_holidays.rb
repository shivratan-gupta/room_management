class CreateHolidays < ActiveRecord::Migration[5.2]
  def change
    create_table :holidays do |t|
      t.string :title
      t.datetime :holiday_date

      t.timestamps
    end
  end
end
