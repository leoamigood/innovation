class ApplicationController < ActionController::Base
  include ActionPolicy::Controller
  include HandleResult
  include HandleError
  include CheckPolicy

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :validate_policy!

  authorize :user, through: -> { Admin.new }

  private

  def on_failure_result(error)
    respond_to do |format|
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: error, status: :unprocessable_entity }
    end
  end
end
