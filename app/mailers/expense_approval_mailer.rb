class ExpenseApprovalMailer < ApplicationMailer
    default to: 'example@example.com' # Add a default recipient email address
    
    def expense_approved_email(employee, expense)
        @employee = employee
        @expense = expense
        mail(to: @employee.email, subject: 'Expense Approved')
    end
  
    def expense_rejected_email(employee, expense)
        @employee = employee
        @expense = expense
        mail(to: @employee.email, subject: 'Expense Rejected')
    end
  end
  
