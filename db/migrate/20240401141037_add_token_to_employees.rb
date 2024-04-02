class AddTokenToEmployees < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :token, :string
  end
end
