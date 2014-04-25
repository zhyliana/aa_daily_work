class ChangeCatsSexColumn < ActiveRecord::Migration
  def change
    change_column(:cats, :sex, :string, limit: 1 )
  end
end
