class MigrateMarkdownToCommonMark < ActiveRecord::Migration[6.1]
  def up
    Project.where(text_formatting: 'markdown').update_all(text_formatting: 'common_mark')
  end

  def down
    Project.where(text_formatting: 'common_mark').update_all(text_formatting: 'markdown')
  end
end
