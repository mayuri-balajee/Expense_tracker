# app/models/expense_report.rb
class ExpenseReport < ApplicationRecord
  belongs_to :employee
  has_many :expenses
end
