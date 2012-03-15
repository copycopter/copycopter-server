class AddHierarchyTextToTextCache < ActiveRecord::Migration
  def up
    add_column :text_caches, :hierarchichal_data, :text
  end

  def down
    remove_column :text_caches, :hierarchichal_data
  end
end
