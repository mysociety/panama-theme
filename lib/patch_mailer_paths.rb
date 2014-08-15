# Add a callback - to be executed before each request in development,
# and at startup in production - to patch existing app classes.
# See http://stackoverflow.com/questions/7072758/plugin-not-reloading-in-development-mode
#
Rails.configuration.to_prepare do
  # Override mailer templates with theme ones. Note doing this in a before_filter,
  # as we do with the controller paths, doesn't seem to have any effect when
  # running in production
  ActionMailer::Base.prepend_view_path File.join(File.dirname(__FILE__), "views")

  # Add new method to alert public bodies about requests nearing their due
  # date
  RequestMailer.class_eval do

    # Send email alerts to bodies for nearing overdue requests
    def self.alert_body_nearing_overdue_requests()
      # Select the requests eligible for alerting. Because in the db we just
      # store the state "waiting_response", not exactly how long we've been
      # waiting, we can't select them directly, but we can filter out requests
      # where we've already sent the alert.
      info_requests = InfoRequest.find(:all,
        :conditions => [
            "described_state = 'waiting_response'
             AND awaiting_description = ?
             AND public_body_id IS NOT NULL
             AND (SELECT id
                  FROM body_info_request_sent_alerts
                  WHERE alert_type = 'nearing_overdue_1'
                  AND info_request_id = info_requests.id
                  AND public_body_id = info_requests.public_body_id
                  AND info_request_event_id = (SELECT max(id)
                                               FROM info_request_events
                                               WHERE event_type in ('sent',
                                                                    'followup_sent',
                                                                    'resent',
                                                                    'followup_resent')
                  )
             ) IS NULL", false
        ],
        :include => [ :public_body ]
      )
      now = Time.now
      for info_request in info_requests
        begin
        alert_event_id = info_request.last_event_forming_initial_request.id
        rescue => e
          logger.error "An error occured trying to get the last event from: #{info_request}"
          logger.error e.message
          logger.error e.backtrace.join("\n")
          next
        end
        calculated_status = info_request.calculate_status
        alert_type = 'nearing_overdue_1'
        if calculated_status == 'waiting_response' && now > info_request.date_nearly_overdue_by
          sent_already = BodyInfoRequestSentAlert.find(:first, :conditions => [ "alert_type = ?
                                                                                 AND public_body_id = ?
                                                                                 AND info_request_id = ?
                                                                                 AND info_request_event_id = ?",
                                                                                 alert_type,
                                                                                 info_request.public_body.id,
                                                                                 info_request.id,
                                                                                 alert_event_id])

          if sent_already.nil?
            store_sent = BodyInfoRequestSentAlert.new
            store_sent.info_request = info_request
            store_sent.public_body = info_request.public_body
            store_sent.alert_type = alert_type
            store_sent.info_request_event_id = alert_event_id
            RequestMailer.body_nearing_overdue_alert(info_request).deliver
            store_sent.save!
          end
        end
      end
    end

    # Send email alerts to bodies for overdue requests
    def self.alert_body_overdue_requests()
      # Select the requests eligible for alerting. Because in the db we just
      # store the state "waiting_response", not exactly how long we've been
      # waiting, we can't select them directly, but we can filter out requests
      # where we've already sent the alert.
      info_requests = InfoRequest.find(:all,
        :conditions => [
            "described_state = 'waiting_response'
             AND awaiting_description = ?
             AND public_body_id IS NOT NULL
             AND (SELECT id
                  FROM body_info_request_sent_alerts
                  WHERE alert_type = 'overdue_1'
                  AND info_request_id = info_requests.id
                  AND public_body_id = info_requests.public_body_id
                  AND info_request_event_id = (SELECT max(id)
                                               FROM info_request_events
                                               WHERE event_type in ('sent',
                                                                    'followup_sent',
                                                                    'resent',
                                                                    'followup_resent')
                  )
             ) IS NULL", false
        ],
        :include => [ :public_body ]
      )
      for info_request in info_requests
        begin
        alert_event_id = info_request.last_event_forming_initial_request.id
        rescue => e
          logger.error "An error occured trying to get the last event from: #{info_request}"
          logger.error e.message
          logger.error e.backtrace.join("\n")
          next
        end
        alert_type = 'overdue_1'
        if info_request.calculate_status == 'waiting_response_overdue'
          sent_already = BodyInfoRequestSentAlert.find(:first, :conditions => [ "alert_type = ?
                                                                                 AND public_body_id = ?
                                                                                 AND info_request_id = ?
                                                                                 AND info_request_event_id = ?",
                                                                                 alert_type,
                                                                                 info_request.public_body.id,
                                                                                 info_request.id,
                                                                                 alert_event_id])

          if sent_already.nil?
            store_sent = BodyInfoRequestSentAlert.new
            store_sent.info_request = info_request
            store_sent.public_body = info_request.public_body
            store_sent.alert_type = alert_type
            store_sent.info_request_event_id = alert_event_id
            RequestMailer.body_overdue_alert(info_request).deliver
            store_sent.save!
          end
        end
      end
    end

    def body_nearing_overdue_alert(info_request)
      @info_request = info_request

      headers('Return-Path' => blackhole_email, 'Reply-To' => contact_from_name_and_email, # not much we can do if the user's email is broken
              'Auto-Submitted' => 'auto-generated', # http://tools.ietf.org/html/rfc3834
              'X-Auto-Response-Suppress' => 'OOF')

      mail(:from => contact_from_name_and_email,
           :to => info_request.public_body.request_email,
           :subject => (_("You haven't yet responded to the FOI request - ") + info_request.title).html_safe)
    end

    def body_overdue_alert(info_request)
      @info_request = info_request

      headers('Return-Path' => blackhole_email, 'Reply-To' => contact_from_name_and_email, # not much we can do if the user's email is broken
              'Auto-Submitted' => 'auto-generated', # http://tools.ietf.org/html/rfc3834
              'X-Auto-Response-Suppress' => 'OOF')

      mail(:from => contact_from_name_and_email,
           :to => info_request.public_body.request_email,
           :subject => (_("Your response to the FOI request - ") + info_request.title).html_safe + " - is overdue")
    end
  end
end
