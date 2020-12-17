# frozen_string_literal: true

class AddOwnerToApplication < ActiveRecord::Migration[5.2]
  def change
    change_table :oauth_applications, bulk: true do |t|
      t.integer :owner_id, null: true
      t.string :owner_type, null: true
    end

    add_index :oauth_applications, %i[owner_id owner_type]
  end
end
