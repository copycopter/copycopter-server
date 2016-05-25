class ChangeTextCachesTypes < ActiveRecord::Migration
  def up
    change_column(:text_caches, :data, :text, :limit => 16777217)
    change_column(:text_caches, :hierarchichal_data, :text, :limit => 16777217)
  end

  def down
  end
end
