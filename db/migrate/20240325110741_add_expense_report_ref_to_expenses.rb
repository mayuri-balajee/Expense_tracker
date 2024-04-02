# db/migrate/xxxxxx_add_expense_report_ref_to_expenses.rb
class AddExpenseReportRefToExpenses < ActiveRecord::Migration[6.0]
  def change
    add_reference :expenses, :expense_report, foreign_key: true
  end
end
