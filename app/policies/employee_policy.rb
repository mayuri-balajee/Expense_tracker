# app/policies/employee_policy.rb
class EmployeePolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user.admin? || record == user
  end

  def create?
    user.admin?
  end

  def update?
    user.admin? || record == user
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(id: user.id)
      end
    end
  end
end
