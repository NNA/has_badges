class Create<%= plural_camel_case point_name %> < ActiveRecord::Migration
  def change
    create_table :<%= plural_lower_case point_name %> do |t|
      t.integer :amount
      t.integer :<%= singular_lower_case user_name %>_id
      t.datetime :date

      t.timestamps
    end

    add_index :<%= plural_lower_case point_name %>, :<%= singular_lower_case user_name %>_id
  end
end