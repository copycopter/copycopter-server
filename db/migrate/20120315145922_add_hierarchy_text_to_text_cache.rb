class AddHierarchyTextToTextCache < ActiveRecord::Migration
  def up
    change_table :text_caches do |t|
      t.text :hierarchichal_data
    end
  end

  def down
    remove_column :text_cahces, :hierarchichal_data
  end
end
