# frozen_string_literal: true

class RemoveMustHaveSurveys < ActiveRecord::Migration[6.1]
  def up
    drop_table :must_have_surveys
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
