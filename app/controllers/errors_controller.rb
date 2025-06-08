class ErrorsController < ApplicationController
  def not_found
    render "errors/not_found", status: :not_found
  end

  def forbidden
    render "errors/forbidden", status: :forbidden
  end
end
