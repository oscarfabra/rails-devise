class AdminsController < ApplicationController

  before_filter :authenticate_admin!, only: [:index, :new]

  def index
  end
end
