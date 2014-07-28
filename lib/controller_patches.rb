# Add a callback - to be executed before each request in development,
# and at startup in production - to patch existing app classes.
# Doing so in init/environment.rb wouldn't work in development, since
# classes are reloaded, but initialization is not run each time.
# See http://stackoverflow.com/questions/7072758/plugin-not-reloading-in-development-mode
#
Rails.configuration.to_prepare do
    GeneralController.class_eval do
        def request_statistics
            @stats = [
                {
                    :label => _('Successful'),
                    :data => 75
                },
                {
                    :label => _('Not successful'),
                    :data => 20
                },
                {
                    :label => _('Other'),
                    :data => 5
                }
            ]
        end
    end
end
