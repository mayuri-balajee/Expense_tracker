class AddApprovedToExpenses < ActiveRecord::Migration[6.0]
  def change
    add_column :expenses, :approved, :boolean, default: false
  end
end
