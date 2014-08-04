class PanamathemeAddAtiOfficerAndTransparencyInfoToPublicBody < ActiveRecord::Migration
  def self.up
    # Add fields to public_bodies
    add_column :public_bodies, :ati_officer_details, :string
    add_column :public_bodies, :transparency_info_url, :string
    # Add versioning fields
    add_column :public_body_versions, :ati_officer_details, :string
    add_column :public_body_versions, :transparency_info_url, :string
  end

  def self.down
    remove_column :public_bodies, :ati_officer_details
    remove_column :public_bodies, :transparency_info_url
    remove_column :public_body_versions, :ati_officer_details
    remove_column :public_body_versions, :transparency_info_url
  end
end