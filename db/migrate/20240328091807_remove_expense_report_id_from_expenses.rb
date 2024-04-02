class RemoveExpenseReportIdFromExpenses < ActiveRecord::Migration[6.0]
  def change
    remove_column :expenses, :expense_report_id
  end
end
