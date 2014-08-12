# Add a callback - to be executed before each request in development,
# and at startup in production - to patch existing app classes.
# Doing so in init/environment.rb wouldn't work in development, since
# classes are reloaded, but initialization is not run each time.
# See http://stackoverflow.com/questions/7072758/plugin-not-reloading-in-development-mode
#
Rails.configuration.to_prepare do
    User.instance_eval do
        validate :extra_fields_are_not_blank
    end

    User.class_eval do
        def is_company?
            self.user_type != "individual"
        end

        def is_individual?
            self.user_type == "individual"
        end

        private

        def extra_fields_are_not_blank
            unless self.email == AlaveteliConfiguration::contact_email
                if self.user_type.nil? or !["individual", "business"].include?(self.user_type)
                    errors.add(:user_type, _("User type must be 'business' or 'individual'"))
                end
                if self.phone_number.nil? or self.phone_number.strip.empty?
                    errors.add(:phone_number, _("Please enter a contact phone number"))
                end
                if self.is_individual?
                    if self.national_id_number.nil? or self.national_id_number.strip.empty?
                        errors.add(:national_id_number, _("Please enter your national ID number"))
                    end
                    if self.address.nil? or self.address.strip.empty?
                        errors.add(:address, _("Please enter your address"))
                    end
                else
                    if self.company_name.nil? or self.company_name.strip.empty?
                        errors.add(:company_name, _("Please enter your company name"))
                    end
                    if self.company_number.nil? or self.company_number.strip.empty?
                        errors.add(:company_number, _("Please enter your company number"))
                    end
                    if self.incorporation_date.nil?
                        errors.add(:incorporation_date, _("Please enter your company's incorporation date"))
                    end
                end
            end
        end
    end
end
