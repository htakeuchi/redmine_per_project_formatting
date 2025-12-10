module RedminePerProjectFormatting
  class ProjectListener < Redmine::Hook::ViewListener
    def view_projects_form(context)
      p = context[:project]
      f = context[:form]
      options = p.module_options
      content_tag(:p, f.select(:text_formatting,
        Redmine::WikiFormatting.format_names.map {|n| [n, n.to_s]},
        :include_blank => "Redmine setting (#{Setting[:text_formatting]})", :label => :setting_text_formatting
      )) +
      content_tag(:p,
        label_tag(:project_wide_formatting, I18n.t(:project_wide_formatting)) +
        check_box_tag(nil, nil, p.project_wide_formatting, :id => :project_wide_formatting)
      ) +
      content_tag(:p, f.select(:modules_for_formatting, options,
        {}, {:multiple => true, :size => options.size}
      )) +
      javascript_tag(
        <<-EOT
          document.addEventListener("DOMContentLoaded", function() {
            var checkbox = document.getElementById("project_wide_formatting");
            var select = document.getElementById("project_modules_for_formatting");
            var textFormatting = document.getElementById("project_text_formatting");

            function toggleModules() {
              if (checkbox.checked) {
                for (var i = 0; i < select.options.length; i++) {
                  select.options[i].selected = false;
                }
                select.parentNode.style.display = 'none';
              } else {
                select.parentNode.style.display = 'block';
              }
            }

            checkbox.addEventListener("change", function() {
              toggleModules();
            });

            function updateVisibility() {
              if (textFormatting.value) {
                checkbox.parentNode.style.display = 'block';
                // We don't automatically trigger toggleModules here in the original code logic exactly? 
                // Original: checkbox.change().parent().show(); 
                // causing change event on checkbox -> which calls toggleModules. 
                // So yes, we should ensure state is correct.
                toggleModules();
              } else {
                checkbox.parentNode.style.display = 'none';
                select.parentNode.style.display = 'none';
              }
            }

            textFormatting.addEventListener("change", function() {
              updateVisibility();
            });

            // Initialize
            updateVisibility();
          });
        EOT
      )
    end
  end
end
