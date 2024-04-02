class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
 
  #belongs_to :user
    has_many :expenses, dependent: :destroy
    has_many :expense_reports, dependent: :destroy

    /def admin?
      admin
    end /

    
  end