class Create<%= plural_camel_case achievement_name %> < ActiveRecord::Migration
  def change
    create_table :<%= plural_lower_case achievement_name %> do |t|
      t.string :name
      t.integer :points_rewarded
      t.timestamps
    end
  end
end