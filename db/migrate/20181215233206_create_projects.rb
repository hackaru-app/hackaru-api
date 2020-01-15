# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :color

      t.timestamps
    end

    add_index :projects, %i[user_id name], unique: true
  end
end
