# frozen_string_literal: true

class CreateMustHaveSurveys < ActiveRecord::Migration[6.1]
  def change
    create_table :must_have_surveys do |t|
      t.references :user, index: { unique: true }
      t.integer :must_have_level, null: false
      t.boolean :alternative_present, null: false
      t.string :alternative_detail, null: false
      t.string :core_value, null: false
      t.boolean :recommended, null: false
      t.string :recommended_detail, null: false
      t.string :target_user_detail, null: false
      t.string :feature_request, null: false
      t.boolean :interview_accept, null: false
      t.string :email, null: false
      t.string :locale, null: false

      t.timestamps
    end

    add_foreign_key :must_have_surveys, :users, on_delete: :nullify
  end
end
