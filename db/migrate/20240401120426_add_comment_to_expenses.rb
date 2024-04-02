class AddCommentToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_column :expenses, :comment, :text
  end
end
