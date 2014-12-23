class EmployeesController < ApplicationController

  before_filter :authenticate_employee!, only: [:index, :new]

  def index
  end
end
