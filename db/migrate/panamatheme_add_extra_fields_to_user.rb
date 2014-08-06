class PanamathemeAddExtraFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :user_type, :string
    add_column :users, :phone_number, :string

    add_column :users, :national_id_number, :string
    add_column :users, :address, :string

    add_column :users, :company_name, :string
    add_column :users, :company_number, :string
    add_column :users, :incorporation_date, :date
  end

  def self.down
    remove_column :users, :user_type
    remove_column :users, :phone_number

    remove_column :users, :national_id_number
    remove_column :users, :address

    remove_column :users, :company_name
    remove_column :users, :company_number
    remove_column :users, :incorporation_date
  end
end