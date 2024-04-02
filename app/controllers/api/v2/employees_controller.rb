class Api::V1::EmployeesController < ApplicationController
    include Pundit
    def index
      authorize Employee
      employees = Employee.all
      render json: employees, status: 200
    end
   
   
    def show
      employee = Employee.find_by(id: params[:id])
      authorize employee
      if employee
        render json: employee, status: 200
      else
        render json: {error: "Not Found"}
      end
    end
   
   
    def create
      employee = Employee.new(
        name: emp_params[:name],
        department: emp_params[:department],
        employment_status: emp_params[:employment_status]
      )
  
       if employee.save
        render json: employee, status: 200
      else
        render json: {error: "Employee not created"}
      end
    end
  
  
    def update
      employee = Employee.find_by(id: params[:id])
      if employee
        employee.update(
          name: params[:name],
          department: params[:department],
          employment_status: params[:employment_status])
        render json: "Employee details updated successfully"
      else
        render json: {
          error: "Employee not found"
        }
      end
    end
   
    def destroy
      employee = Employee.find_by(id: params[:id])
      if employee
        employee.destroy
        render json: "Employee has been deleted"
      else
        render json: "Employee not found"
      end
    end
  
  
  private
  
  
  def emp_params
    params.require(:employee).permit([
      :name, :department, :employment_status
  ])
  end
  end
  