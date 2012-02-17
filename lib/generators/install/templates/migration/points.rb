class CreatePoints < ActiveRecord::Migration
  def change
    create_table :<%= point_name.downcase.pluralize %> do |t|
      t.integer :amount
      t.integer :<%= user_name.downcase %>_id
      t.datetime :date

      t.timestamps
    end

    add_index :<%= point_name.downcase.pluralize %>, :<%= user_name.downcase %>_id
  end
end