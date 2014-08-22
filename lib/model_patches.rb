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

    PublicBody.class_eval do
      def get_stats
        stats = {}

        # all the requests for the current public_body that have not been hidden
        stats[:total] = info_requests.where(
                             :prominence => 'normal'
                         ).count

        stats[:success] = info_requests.where(
                               :prominence => 'normal',
                               :described_state => 'successful'
                           ).count

        stats[:partial_success] = info_requests.where(
                                       :prominence => 'normal',
                                       :described_state => 'partially_successful'
                                   ).count

        # where the public body has sent a response but the user
        # hasn't responded yet
        stats[:waiting_classification] = info_requests.where(
                                              :prominence => 'normal',
                                              :awaiting_description => true
                                          ).count

        stats[:requires_admin] = info_requests.where(
                                     :prominence => 'normal',
                                     :described_state => 'requires_admin'
                                 ).count

        stats[:attention_requested] = info_requests.where(
                                          :prominence => 'normal',
                                          :described_state => 'attention_requested'
                                      ).count

        stats[:internal_review] = info_requests.where(
                                      :prominence => 'normal',
                                      :described_state => 'internal_review'
                                  ).count

        stats[:gone_postal] = info_requests.where(
                                  :prominence => 'normal',
                                  :described_state => 'gone_postal'
                              ).count

        stats[:in_error] = info_requests.where(
                               :prominence => 'normal',
                               :described_state => 'error_message'
                           ).count

        stats[:waiting_clarification] = info_requests.where(
                                            :prominence => 'normal',
                                            :described_state => 'waiting_clarification'
                                        ).count

        stats[:rejected] = info_requests.where(
                                :prominence => 'normal',
                                :described_state => 'rejected'
                            ).count

        stats[:not_held] = info_requests.where(
                                :prominence => 'normal',
                                :described_state => 'not_held'
                            ).count

        stats[:withdrawn] = info_requests.where(
                                 :prominence => 'normal',
                                 :described_state => 'user_withdrawn'
                             ).count

        stats[:waiting_response] = info_requests.where(
                                       :prominence => 'normal',
                                       :described_state => 'waiting_response',
                                       :awaiting_description => false
                                   ).count
        stats
      end
    end

    # A new class for storing alerts that are made to bodies
    class BodyInfoRequestSentAlert < ActiveRecord::Base
        belongs_to :public_body
        belongs_to :info_request
        belongs_to :info_request_event
        attr_accessible :alert_type

        validates_inclusion_of :alert_type, :in => [
            'nearing_overdue_1', # tell body that info request is about to become overdue
            'overdue_1', # tell body that info request has become overdue
        ]
    end

    # Patch InfoRequestEvent to connect it to BodyInfoRequestSentAlert
    InfoRequestEvent.instance_eval do
        has_many :body_info_request_sent_alerts
    end

    InfoRequest.class_eval do
        # Add an extra date calculation method which tells us when a request
        # is "nearly" overdue - calculated from the config setting
        # REPLY_NEARLY_LATE_AFTER_DAYS
        def date_nearly_overdue_by
            Holiday.due_date_from(self.date_initial_request_last_sent_at, AlaveteliConfiguration::reply_nearly_late_after_days, AlaveteliConfiguration::working_or_calendar_days)
        end
    end

    PublicBody.class_eval do

        # Add some new fields to the csv_import_fields
        self.csv_import_fields << ['ati_officer_details', ''] << ['transparency_info_url', '']
    end
end
