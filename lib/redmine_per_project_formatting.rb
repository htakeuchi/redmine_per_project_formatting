

module RedminePerProjectFormatting
  def self.apply_patch
    ::ApplicationController.prepend ApplicationControllerPatch
    ::Project.send :include, ProjectPatch
    ::Setting.singleton_class.prepend SettingPatch
    if defined?(RedmineCkeditor)
      ::MailHandler.prepend MailHandlerPatch
    end
  end
end
