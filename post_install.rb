# This file is executed in the Rails evironment by the `rails-post-deploy` script

def column_exists?(table, column)
    # XXX ActiveRecord 3 includes "column_exists?" method on `connection`
    return ActiveRecord::Base.connection.columns(table.to_sym).collect{|c| c.name.to_sym}.include? column
end

# ATI officer info and Transparency links for bodies
if !column_exists?(:public_bodies, :ati_officer_details) || !column_exists?(:public_bodies, :transparency_info_url)
  # ../ is not wrong, it's a bit weird to require a relative file that works
  # in both 1.8 and 1.9. See: http://stackoverflow.com/a/4333552
  require File.expand_path('../db/migrate/panamatheme_add_ati_officer_and_transparency_info_to_public_body.rb', __FILE__)
  PanamathemeAddAtiOfficerAndTransparencyInfoToPublicBody.up
end
