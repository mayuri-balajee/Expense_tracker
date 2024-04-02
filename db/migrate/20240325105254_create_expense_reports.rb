class CreateExpenseReports < ActiveRecord::Migration[7.1]
  def change
    create_table :expense_reports do |t|
      t.string :name
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
