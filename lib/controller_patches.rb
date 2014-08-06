# Add a callback - to be executed before each request in development,
# and at startup in production - to patch existing app classes.
# Doing so in init/environment.rb wouldn't work in development, since
# classes are reloaded, but initialization is not run each time.
# See http://stackoverflow.com/questions/7072758/plugin-not-reloading-in-development-mode
#
Rails.configuration.to_prepare do
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
end
