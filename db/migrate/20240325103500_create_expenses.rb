class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses do |t|
      t.string :invoice_no
      t.date :date
      t.string :description
      t.decimal :amount
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
