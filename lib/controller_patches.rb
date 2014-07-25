# Add a callback - to be executed before each request in development,
# and at startup in production - to patch existing app classes.
# Doing so in init/environment.rb wouldn't work in development, since
# classes are reloaded, but initialization is not run each time.
# See http://stackoverflow.com/questions/7072758/plugin-not-reloading-in-development-mode
#
Rails.configuration.to_prepare do
    GeneralController.class_eval do
        def request_statistics
            @stats = {
                :successful => 75.0,
                :not_successful => 20.0,
                :other => 5.0
            }
        end
    end
end
