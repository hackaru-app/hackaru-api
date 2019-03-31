# frozen_string_literal: true

class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project
      t.string :description, default: '', null: false
      t.datetime :started_at, null: false
      t.datetime :stopped_at
      t.integer :duration

      t.timestamps
    end

    add_foreign_key :activities, :projects, on_delete: :nullify
  end
end
