class RemoveEmailAndPasswordFromEmployees < ActiveRecord::Migration[7.1]
  def change
    remove_column :employees, :email
    remove_column :employees, :encrypted_password
  end
end
