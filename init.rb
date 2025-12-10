require 'redmine'




Rails.configuration.after_initialize do
  # Ensure Project is loaded
  ::Project

  # Force load the patch file
  load File.expand_path('lib/redmine_per_project_formatting/project_patch.rb', __dir__)
  
  # Check if already included to avoid double inclusion if reloaded (though after_initialize runs once)
  unless ::Project.included_modules.include?(RedminePerProjectFormatting::ProjectPatch)
    ::Project.send(:include, RedminePerProjectFormatting::ProjectPatch)
  end

  load File.expand_path('lib/redmine_per_project_formatting/application_controller_patch.rb', __dir__)
  ::ApplicationController.prepend(RedminePerProjectFormatting::ApplicationControllerPatch)

  load File.expand_path('lib/redmine_per_project_formatting/setting_patch.rb', __dir__)
  ::Setting.singleton_class.prepend(RedminePerProjectFormatting::SettingPatch)

  if defined?(RedmineCkeditor)
    load File.expand_path('lib/redmine_per_project_formatting/mail_handler_patch.rb', __dir__)
    ::MailHandler.prepend(RedminePerProjectFormatting::MailHandlerPatch)
  end
end

Redmine::Plugin.register :redmine_per_project_formatting do
  name 'Redmine per project formatting plugin'
  author 'Akihiro Ono'
  description 'Redmine plugin for per-project text formatting'
  version '0.1.1'
  requires_redmine version_or_higher: '4.0.0'
  url 'https://github.com/a-ono/redmine_per_project_formatting'
end
