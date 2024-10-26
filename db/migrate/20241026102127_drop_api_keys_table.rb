class DropApiKeysTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :api_keys
  end
end
