class Api::V1::EmployeesController < ApplicationController
  include Pundit
  def index
    
    authorize Employee
    @employees = Employee.all
    render json: @employees, status: 200
  end
 
 
  def show
    @employee = Employee.find_by(id: params[:id])
    #authorize employee
  
    if @employee
      render json: @employee, status: 200
    else
      render json: {error: "Not Found"}, status: :not_found
    end
  end
 
  def create
    @employee = Employee.new(
      name: emp_params[:name],
      department: emp_params[:department],
      employment_status: emp_params[:employment_status],
      email: emp_params[:email]
    )

     if @employee.save
      render json: @employee, status: 200
    else
      render json: {error: "Employee not created"}
    end
  end


  def update
    @employee = Employee.find_by(id: params[:id])
    
    if @employee
      if @employee.update(emp_params)
        render json: "Employee details updated successfully"
      else
        render json: { error: @employee.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Employee not found" }, status: :not_found
    end
  end
  
  
 
  def destroy
    @employee = Employee.find_by(id: params[:id])
    if @employee
      employee.destroy
      render json: "Employee has been deleted"
    else
      render json: "Employee not found"
    end
  end


private


def emp_params
  params.require(:employee).permit([
    :name, :department, :employment_status, :email]
)
end
end

