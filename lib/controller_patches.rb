# Add a callback - to be executed before each request in development,
# and at startup in production - to patch existing app classes.
# Doing so in init/environment.rb wouldn't work in development, since
# classes are reloaded, but initialization is not run each time.
# See http://stackoverflow.com/questions/7072758/plugin-not-reloading-in-development-mode
#
Rails.configuration.to_prepare do
    GeneralController.class_eval do
        def request_statistics
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
            if params[:body]
                # TODO, look this up properly
                @body = "Geraldine Quango"
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
