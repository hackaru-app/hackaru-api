class CreateUserSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :user_settings do |t|
      t.references :user,
                   null: false,
                   index: { unique: true }
      t.boolean :receive_weekly_report, null: false, default: true
      t.boolean :receive_monthly_report, null: false, default: true

      t.timestamps
    end

    add_foreign_key :user_settings, :users, on_delete: :cascade
  end
end
