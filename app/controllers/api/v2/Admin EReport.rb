class Api::V1::ExpenseReportsController < ApplicationController
    include Pundit
  
    def index
      employee = Employee.find_by(id: params[:employee_id])
      if employee
        if employee.admin
          expenses = Expense.all
        else
          expenses = employee.expenses
        end
        render json: { expense_report: generate_expense_report(expenses, employee.admin) }, status: 200
      else
        render json: { error: "Employee not found" }, status: 404
      end
    end
  
    private
  
    def generate_expense_report(expenses, is_admin)
      if is_admin
        # For admin, return all expenses grouped by employee id
        return expenses.group_by(&:employee_id).map do |employee_id, employee_expenses|
          {
            employee_id: employee_id,
            expenses: employee_expenses.map do |expense|
              {
                id: expense.id,
                amount: expense.amount,
                description: expense.description,
                date: expense.date
              }
            end
          }
        end
      else
        # For non-admin, return expenses of the current employee
        if expenses.empty?
          return [{ message: "No data" }]
        else
          return [{
            employee_id: expenses.first.employee_id,
            expenses: expenses.map do |expense|
              {
                id: expense.id,
                amount: expense.amount,
                description: expense.description,
                date: expense.date
              }
            end
          }]
        end
      end
    end
  end
  