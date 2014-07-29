# Add a callback - to be executed before each request in development,
# and at startup in production - to patch existing app classes.
# Doing so in init/environment.rb wouldn't work in development, since
# classes are reloaded, but initialization is not run each time.
# See http://stackoverflow.com/questions/7072758/plugin-not-reloading-in-development-mode
#
Rails.configuration.to_prepare do
    GeneralController.class_eval do
        def request_statistics
            allowed_periods = ['month', 'quarter', 'year', 'all_time']
            if params[:period] and allowed_periods.include?(params[:period])
                @period = params[:period]
            else
                @period = 'all_time'
            end

            @locale = self.locale_from_params
            I18n.with_locale(@locale) do
                @overall_total = 200
                @overall_stats = [
                    {
                        :label => _('Disclosed'),
                        :data => 155
                    },
                    {
                        :label => _('Denied'),
                        :data => 25
                    },
                    {
                        :label => _('In progress'),
                        :data => 10
                    },
                    {
                        :label => _('Overdue'),
                        :data => 10
                    }
                ]
                @overall_denied_by_reason = [
                    {
                        :label => _('Reason 1'),
                        :data => 5
                    },
                    {
                        :label => _('Reason 2'),
                        :data => 7
                    },
                    {
                        :label => _('Reason 3'),
                        :data => 13
                    }
                ]

                @body_options = PublicBody.visible.collect {|p| [ p.name, p.url_name ]}
                if params[:body]
                    @body = PublicBody.find_by_url_name(params[:body])
                    if @body
                        @body_total = 105
                        @body_overall_stats = [
                            {
                                :label => _('Disclosed'),
                                :data => 35
                            },
                            {
                                :label => _('Denied'),
                                :data => 10
                            },
                            {
                                :label => _('In progress'),
                                :data => 40
                            },
                            {
                                :label => _('Overdue'),
                                :data => 20
                            }
                        ]
                        @body_denied_by_reason = [
                            {
                                :label => _('Reason 1'),
                                :data => 3
                            },
                            {
                                :label => _('Reason 2'),
                                :data => 3
                            },
                            {
                                :label => _('Reason 3'),
                                :data => 4
                            }
                        ]
                    end
                end
            end
        end
    end
end
