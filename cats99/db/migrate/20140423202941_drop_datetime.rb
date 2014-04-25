class DropDatetime < ActiveRecord::Migration
  def change
    change_column :cats, :age, :integer, null: false
    change_column :cats, :birth_date, :date, null: false
    change_column :cats, :color, :string, null: false
    change_column :cats, :name, :string, null: false
    change_column :cats, :sex, :string, null: false, limit: 1
  end
end
