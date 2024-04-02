class Api::V1::ExpensesController < ApplicationController
  #before_action :authenticate_employee
  before_action :set_current_user
  before_action :set_employee, except: [:index, :approve_expense, :reject_expense]
  before_action :set_expense, only: [:show, :update, :destroy, :approve_expense, :reject_expense, :add_comment]

#include pundit 
  def index
    if @current_user
      if @current_user.admin?
        expenses = Expense.all
      else
        expenses = @current_user.expenses
      end
      render json: expenses, status: :ok
    else
      render json: { error: "Employee not found" }, status: :not_found
    end
  end

  def show
    authorize @expense
    render json: @expense, status: :ok
  end

  def create
    if @employee.employment_status == 'Terminated' || @employee.employment_status == 'Separated'
      render json: { error: "Not allowed to create expense. Employment status: #{@employee.employment_status}" }, status: :unprocessable_entity
      return
    end
    expense = @employee.expenses.build(expense_params)
    uri = URI('https://my.api.mockaroo.com/invoices.json')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path)
    request['Content-Type'] = 'application/json'
    request['X-API-Key'] = 'b490bb80'
    request.body = { 'invoice_id': expense.invoice_no.to_i }.to_json
    response = http.request(request)
    if response.code == '200'
      json_response = JSON.parse(response.body)
      if json_response["status"] == true
        if expense.save
          render json: { status: "successful", expense: expense }, status: :created
        else
          render json: { error: "Failed to save expense." }, status: :unprocessable_entity
        end
      else
        render json: { error: "Failed to create expense. External API status: #{json_response["status"]}" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Failed to create expense. External API error: #{response.body}" }, status: :unprocessable_entity
    end
  end

  def update
    if @expense.update(expense_params)
      render json: @expense, status: :ok
    else
      render json: { error: @expense.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    render json: { message: "Expense has been deleted" }, status: :ok
  end

  def approve_expense
    #authorize @expense
    if @current_user.admin?
      @expense.update(approved: true)
      ExpenseApprovalMailer.expense_approved_email(@employee,@expense).deliver_now
      render json: { message: "Expense has been approved" }, status: :ok
    else
      render json: { error: "Unauthorized. Admin privileges required." }, status: :unauthorized
    end
  end

  def reject_expense
    #authorize @expense
    if @current_user.admin?
      @expense.update(approved: false)
      #ExpenseApprovalMailer.expense_rejected_email(@employee,@expense).deliver_now
      render file: "#{Rails.root}/app/views/expense_rejected.html.erb", layout: false, status: :ok and return
      render json: { message: "Expense has been rejected" }, status: :ok
    else
      render json: { error: "Unauthorized. Admin privileges required." }, status: :unauthorized
    end
  end


  def add_comment
    if @current_user.admin?
      if @expense.update(comment: params[:comment])
        render json: { message: "Comment added successfully" }, status: :ok
      else
        render json: { error: "Failed to add comment" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Unauthorized. Admin privileges required." }, status: :unauthorized
    end
  end


  private

  def authenticate_employee
    authenticate_or_request_with_http_basic do |username, password|
      @current_user = Employee.find_by(username: username)
      @current_user && @current_user.authenticate(password)
    end
  end

  def set_current_user
    if params[:employee_id].present?
      @current_user = Employee.find_by(id: params[:employee_id])
    else
      @current_user = nil
    end
  end

  def set_employee
      @employee = @current_user
  end
  
  def set_expense
    @expense = Expense.find(params[:id])
  end
  

  def expense_params
    params.require(:expense).permit(:invoice_no, :date, :description, :amount)
  end
end
