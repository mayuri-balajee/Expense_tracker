class ApplicationController < ActionController::API
  
    include Pundit::Authorization
    def pundit_user
        # Return the current employee
        @employee
      end
end
