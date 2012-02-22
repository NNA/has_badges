class Create<%= singular_camel_case user_name %><%= plural_camel_case badge_name %> < ActiveRecord::Migration
  def change
    create_table :<%= singular_lower_case user_name %>_<%= plural_lower_case badge_name %> do |t|
      t.integer :<%= singular_lower_case user_name %>_id
      t.integer :<%= singular_lower_case badge_name %>_id
      t.timestamps
    end
  end
end