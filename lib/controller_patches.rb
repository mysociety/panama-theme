# Add a callback - to be executed before each request in development,
# and at startup in production - to patch existing app classes.
# Doing so in init/environment.rb wouldn't work in development, since
# classes are reloaded, but initialization is not run each time.
# See http://stackoverflow.com/questions/7072758/plugin-not-reloading-in-development-mode
#
Rails.configuration.to_prepare do
    GeneralController.class_eval do
        def request_statistics
            @overall_total = 100
            @overall_stats = [
                {
                    :label => _('Disclosed'),
                    :data => 55
                },
                {
                    :label => _('Denied'),
                    :data => 20
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
                    :data => 55
                },
                {
                    :label => _('Reason 2'),
                    :data => 20
                },
                {
                    :label => _('Reason 3'),
                    :data => 10
                }
            ]
        end
    end
end
