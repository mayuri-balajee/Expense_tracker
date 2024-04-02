# app/policies/expense_policy.rb
class ExpensePolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user.admin? || record.employee == user
  end

  def create?
    user.admin?
  end

  def update?
    user.admin? || record.employee == user
  end

  def destroy?
    user.admin? || record.employee == user
  end

  def approve?
    user.present? && (user.admin? || record.employee == user)
  end
  
  def reject?
    user.present? && (user.admin? || record.employee == user)
  end
  
  def add_comment?
    user.present? && (user.admin? || record.employee == user)
  end
  
  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(employee_id: user.id)
      end
    end
  end
end
