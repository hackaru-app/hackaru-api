# frozen_string_literal: true

class RemoveDeviseTokenAuth < ActiveRecord::Migration[5.2]
  def up
    change_table :users, bulk: true do |t|
      t.remove :provider, type: :string, null: false, default: 'email'
      t.remove :uid, type: :string,  null: false, default: ''
      t.remove :reset_password_token, type: :string
      t.remove :reset_password_sent_at, type: :datetime
      t.remove :allow_password_change, type: :boolean, default: false
      t.remove :remember_created_at, type: :datetime
      t.remove :sign_in_count, type: :integer, default: 0, null: false
      t.remove :current_sign_in_at, type: :datetime
      t.remove :current_sign_in_ip, type: :string
      t.remove :last_sign_in_at, type: :datetime
      t.remove :last_sign_in_ip, type: :string
      t.remove :confirmation_token, type: :string
      t.remove :confirmed_at, type: :string
      t.remove :confirmation_sent_at, type: :datetime
      t.remove :unconfirmed_email, type: :string
      t.remove :name, type: :string
      t.remove :nickname, type: :string
      t.remove :image, type: :string
      t.remove :tokens, type: :json
    end

    rename_column :users, :encrypted_password, :password_digest
    change_column_null :users, :email, false
  end
end
