require 'net/http'
require 'json'

class Api::V1::ExpensesController < ApplicationController
    before_action :set_employee
    before_action :set_expense, only: [:show, :update, :destroy]
    include Pundit

    # GET /api/v1/employees/:employee_id/expenses
    def index
      expenses = @employee.expenses
      #authorize Expense
      expenses = @employee.expenses
      render json: expenses, status: :ok
    end

     # GET /api/v1/employees/:employee_id/expenses/:id
    def show
      authorize @expense
      render json: @expense, status: :ok
    end

    def create
      # Load the employee
      @employee = Employee.find(params[:employee_id])
    
      # Check if employee is terminated/separated
      if @employee.employment_status == 'Terminated' || @employee.employment_status == 'Separated'
        render json: { error: "Not allowed to create expense. Employment status: #{@employee.employment_status}" }, status: :unprocessable_entity
        return
      end
    
      # Proceed with creating the expense
      expense = @employee.expenses.build(expense_params)
    
      #POST request to the external API  --- SERVICE OBJECTS 
      uri = URI('https://my.api.mockaroo.com/invoices.json')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.path)
      request['Content-Type'] = 'application/json'
      request['X-API-Key'] = 'b490bb80'
      request.body = { 'invoice_id': expense.invoice_no.to_i }.to_json
    
      response = http.request(request)
    
      # Handle the response from the external API
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
    
     # PATCH/PUT /api/v1/employees/:employee_id/expenses/:id
    def update
      if @expense.update(expense_params)
        render json: @expense, status: :ok
      else
        render json: { error: @expense.errors.full_messages }, status: :unprocessable_entity
      end
    end

     # DELETE /api/v1/employees/:employee_id/expenses/:id
    def destroy
      @expense.destroy
      render json: { message: "Expense has been deleted" }, status: :ok
    end


     private
     # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:employee_id])
    end


     def set_expense
      @expense = @employee.expenses.find(params[:id])
    end

     # Only allow a trusted parameter 
    def expense_params
      params.require(:expense).permit(:invoice_no, :date, :description, :amount)
    end
end