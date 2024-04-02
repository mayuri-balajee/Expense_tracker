# config/routes.rb

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :expenses, only: [:index, :show, :create, :destroy, :update] 
      resources :employees, only: [:index, :show, :create, :update, :destroy] do
        resources :expenses, only: [:index, :show, :create, :destroy, :update]  # Nested routes for accessing expenses of a specific employee
        get 'expense_report', to: 'expense_reports#index'  # Custom route for expense report
        delete 'expenses/:id/delete', to: 'expenses#delete_report'  # Route for deleting expense reports
        patch 'expenses/:id/approve', to: 'expenses#approve_expense', as: 'approve_expense'  # Route for approving expenses
        patch 'expenses/:id/reject', to: 'expenses#reject_expense', as: 'reject_expense'  # Route for rejecting expenses
        post 'expenses/:id/add_comment', to: 'expenses#add_comment', as: 'add_comment'  # Route for adding comments to expenses
      end
    end
  end
  
  get "up" => "rails/health#show", as: :rails_health_check
end
