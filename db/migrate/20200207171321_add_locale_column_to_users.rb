# frozen_string_literal: true

class AddLocaleColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :locale, :string, null: true
    change_column_null :users, :locale, false, 'ja'
  end
end
