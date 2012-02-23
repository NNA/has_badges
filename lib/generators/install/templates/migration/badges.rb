class Create<%= plural_camel_case badge_name %> < ActiveRecord::Migration
  def change
    create_table :<%= plural_lower_case badge_name %> do |t|
      t.string :name
      t.timestamps
    end
  end
end