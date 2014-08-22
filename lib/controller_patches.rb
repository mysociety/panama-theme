require 'csv'

# Add a callback - to be executed before each request in development,
# and at startup in production - to patch existing app classes.
# Doing so in init/environment.rb wouldn't work in development, since
# classes are reloaded, but initialization is not run each time.
# See http://stackoverflow.com/questions/7072758/plugin-not-reloading-in-development-mode
#
Rails.configuration.to_prepare do
    HelpController.class_eval do
        def transparency
        end
    end

    UserController.class_eval do
        def signchangeaddress
            if not authenticated?(
                    :web => _("To change your address used on {{site_name}}",:site_name=>site_name),
                    :email => _("Then you can change your address used on {{site_name}}",:site_name=>site_name),
                    :email_subject => _("Change your address used on {{site_name}}",:site_name=>site_name)
                   )
                # "authenticated?" has done the redirect to signin page for us
                return
            end

            if !params[:submitted_signchangeaddress_do]
                render :action => 'signchangeaddress'
                return
            else
                @user.address = params[:signchangeaddress][:new_address]
                if not @user.valid?
                    @signchangeaddress = @user
                    render :action => 'signchangeaddress'
                else
                    @user.save!

                    # Now clear the circumstance
                    flash[:notice] = _("You have now changed your address used on {{site_name}}",:site_name=>site_name)
                    redirect_to user_url(@user)
                end
            end
        end

        def signchangenationalid
            if not authenticated?(
                    :web => _("To change your national ID number used on {{site_name}}",:site_name=>site_name),
                    :email => _("Then you can change your national ID number used on {{site_name}}",:site_name=>site_name),
                    :email_subject => _("Change your national ID number used on {{site_name}}",:site_name=>site_name)
                   )
                # "authenticated?" has done the redirect to signin page for us
                return
            end

            if !params[:submitted_signchangenationalid_do]
                render :action => 'signchangenationalid'
                return
            else
                @user.national_id_number = params[:signchangenationalid][:new_national_id]
                if not @user.valid?
                    @signchangenationalid = @user
                    render :action => 'signchangenationalid'
                else
                    @user.save!

                    # Now clear the circumstance
                    flash[:notice] = _("You have now changed your national ID number used on {{site_name}}",:site_name=>site_name)
                    redirect_to user_url(@user)
                end
            end
        end

        def signchangephone
            if not authenticated?(
                    :web => _("To change your contact phone number used on {{site_name}}",:site_name=>site_name),
                    :email => _("Then you can change your contact phone number used on {{site_name}}",:site_name=>site_name),
                    :email_subject => _("Change your contact phone number used on {{site_name}}",:site_name=>site_name)
                   )
                # "authenticated?" has done the redirect to signin page for us
                return
            end

            if !params[:submitted_signchangephone_do]
                render :action => 'signchangephone'
                return
            else
                @user.phone_number = params[:signchangephone][:new_phone_number]
                if not @user.valid?
                    @signchangephone = @user
                    render :action => 'signchangephone'
                else
                    @user.save!
                    # Now clear the circumstance
                    flash[:notice] = _("You have now changed your contact phone number used on {{site_name}}",:site_name=>site_name)
                    redirect_to user_url(@user)
                end
            end
        end

        def signchangecompanyname
            if not authenticated?(
                    :web => _("To change your company name used on {{site_name}}",:site_name=>site_name),
                    :email => _("Then you can change your company name used on {{site_name}}",:site_name=>site_name),
                    :email_subject => _("Change your company name used on {{site_name}}",:site_name=>site_name)
                   )
                # "authenticated?" has done the redirect to signin page for us
                return
            end

            if !params[:submitted_signchangecompanyname_do]
                render :action => 'signchangecompanyname'
                return
            else
                @user.company_name = params[:signchangecompanyname][:new_company_name]
                if not @user.valid?
                    @signchangecompanyname = @user
                    render :action => 'signchangecompanyname'
                else
                    @user.save!
                    # Now clear the circumstance
                    flash[:notice] = _("You have now changed your company name used on {{site_name}}",:site_name=>site_name)
                    redirect_to user_url(@user)
                end
            end
        end

        def signchangecompanynumber
            if not authenticated?(
                    :web => _("To change your company number used on {{site_name}}",:site_name=>site_name),
                    :email => _("Then you can change your company number used on {{site_name}}",:site_name=>site_name),
                    :email_subject => _("Change your company number used on {{site_name}}",:site_name=>site_name)
                   )
                # "authenticated?" has done the redirect to signin page for us
                return
            end

            if !params[:submitted_signchangecompanynumber_do]
                render :action => 'signchangecompanynumber'
                return
            else
                @user.company_number = params[:signchangecompanynumber][:new_company_number]
                if not @user.valid?
                    @signchangecompanynumber = @user
                    render :action => 'signchangecompanynumber'
                else
                    @user.save!
                    # Now clear the circumstance
                    flash[:notice] = _("You have now changed your company number used on {{site_name}}",:site_name=>site_name)
                    redirect_to user_url(@user)
                end
            end
        end

        def signchangecompanyincdate
            if not authenticated?(
                    :web => _("To change your company incorporation date used on {{site_name}}",:site_name=>site_name),
                    :email => _("Then you can change your company incorporation date used on {{site_name}}",:site_name=>site_name),
                    :email_subject => _("Change your company incorporation date used on {{site_name}}",:site_name=>site_name)
                   )
                # "authenticated?" has done the redirect to signin page for us
                return
            end

            if !params[:submitted_signchangecompanyincdate_do]
                render :action => 'signchangecompanyincdate'
                return
            else
                @user.incorporation_date = params[:signchangecompanyincdate][:new_incorporation_date]
                if not @user.valid?
                    @signchangecompanyincdate = @user
                    render :action => 'signchangecompanyincdate'
                else
                    @user.save!
                    # Now clear the circumstance
                    flash[:notice] = _("You have now changed your company incorporation date used on {{site_name}}",:site_name=>site_name)
                    redirect_to user_url(@user)
                end
            end
        end
    end

    AdminGeneralController.class_eval do
        def stats
            # Overview counts of things
            @public_body_count = PublicBody.count

            @info_request_count = InfoRequest.count
            @outgoing_message_count = OutgoingMessage.count
            @incoming_message_count = IncomingMessage.count

            @user_count = User.count
            @track_thing_count = TrackThing.count

            @comment_count = Comment.count
            @request_by_state = InfoRequest.count(:group => 'described_state')
            @tracks_by_type = TrackThing.count(:group => 'track_type')

            # Add some additional values to the stats page for use in
            # dropdowns
            @first_request_datetime = InfoRequest.minimum(:created_at)
        end

        def stats_monthly_transactions_csv
            start_year = params['date']['start_year'].to_i
            start_month = params['date']['start_month'].to_i
            end_year = params['date']['end_year'].to_i
            end_month = params['date']['end_month'].to_i

            month_starts = (Date.new(start_year, start_month)..Date.new(end_year, end_month)).select { |d| d.day == 1 }

            headers = ['Period',
                       'Requests sent',
                       'Annotations added',
                       'Track this request email signups',
                       'Comments on own requests',
                       'Follow up messages sent']
            header_row = CSV.generate_line(headers)
            header_row << "\n" unless RUBY_VERSION.to_f >= 1.9
            csv = header_row

            month_starts.each do |month_start|
                month_end = month_start.end_of_month
                period = "#{month_start}-#{month_end}"
                date_conditions = ['created_at >= ?
                                  AND created_at < ?',
                                  month_start, month_end+1]
                request_count = InfoRequest.count(:conditions => date_conditions)
                comment_count = Comment.count(:conditions => date_conditions)
                track_conditions = ['track_type = ?
                                   AND track_medium = ?
                                   AND created_at >= ?
                                   AND created_at < ?',
                                  'request_updates', 'email_daily', month_start, month_end+1]
                email_request_track_count = TrackThing.count(:conditions => track_conditions)
                comment_on_own_request_conditions = ['comments.user_id = info_requests.user_id
                                                    AND comments.created_at >= ?
                                                    AND comments.created_at < ?',
                                                    month_start, month_end+1]
                comment_on_own_request_count = Comment.count(:conditions => comment_on_own_request_conditions,
                                                           :include => :info_request)

                followup_conditions = ['message_type = ?
                                       AND created_at >= ?
                                       AND created_at < ?',
                                      'followup', month_start, month_end+1]
                follow_up_count = OutgoingMessage.count(:conditions => followup_conditions)
                csv << CSV.generate_line([period,
                                          request_count,
                                          comment_count,
                                          email_request_track_count,
                                          comment_on_own_request_count,
                                          follow_up_count])
                csv << "\n" unless RUBY_VERSION.to_f >= 1.9

            end

            send_data csv, :filename => 'monthly-transaction-totals.csv',
                                  :disposition => 'attachment'
        end
    end
end
