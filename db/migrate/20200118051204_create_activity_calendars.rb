class CreateActivityCalendars < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_calendars do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token, null: false

      t.timestamps
    end

    add_index :activity_calendars, :token, unique: true
  end
end
