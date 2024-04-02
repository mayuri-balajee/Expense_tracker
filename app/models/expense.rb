class Expense < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  belongs_to :employee
  belongs_to :expense_report, optional: true
end