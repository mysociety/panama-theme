theme_name = File.split(File.expand_path("../..", __FILE__))[1]
theme_name.gsub!('-', '_')
THEME_NAME = theme_name

# Add in some new config values if they're not already set
AlaveteliConfiguration::DEFAULTS[:REPLY_NEARLY_LATE_AFTER_DAYS] ||= 10

class ActionController::Base
    before_filter :set_view_paths

    def set_view_paths
        self.prepend_view_path File.join(File.dirname(__FILE__), "views")
    end
end

# In order to have the theme lib/ folder ahead of the main app one,
# inspired in Ruby Guides explanation: http://guides.rubyonrails.org/plugins.html
%w{ . }.each do |dir|
  path = File.join(File.dirname(__FILE__), dir)
  $LOAD_PATH.insert(0, path)
  ActiveSupport::Dependencies.autoload_paths << path
  ActiveSupport::Dependencies.autoload_once_paths.delete(path)
end

# Monkey patch app code
for patch in ['controller_patches.rb',
              'model_patches.rb',
              'patch_mailer_paths.rb']
    require File.expand_path "../#{patch}", __FILE__
end

# Note you should rename the file at "config/custom-routes.rb" to
# something unique (e.g. yourtheme-custom-routes.rb":
$alaveteli_route_extensions << 'custom-routes.rb'

# Prepend the asset directories in this theme to the asset path:
['stylesheets', 'images', 'javascripts'].each do |asset_type|
    theme_asset_path = File.join(File.dirname(__FILE__),
                                 '..',
                                 'assets',
                                 asset_type)
    Rails.application.config.assets.paths.unshift theme_asset_path
end
# Tell Rails to pre-compile our JS files
Rails.application.config.assets.precompile += ['stats-authority.js', 'legal-summaries.js']

# Tell FastGettext about the theme's translations: look in the theme's
# locale-theme directory for a translation in the first place, and if
# it isn't found, look in the Alaveteli locale directory next:
repos = [
    FastGettext::TranslationRepository.build('app', :path=>File.join(File.dirname(__FILE__), '..', 'locale-theme'), :type => :po),
    FastGettext::TranslationRepository.build('app', :path=>'locale', :type => :po)
]
FastGettext.add_text_domain 'app', :type=>:chain, :chain=>repos
FastGettext.default_text_domain = 'app'
