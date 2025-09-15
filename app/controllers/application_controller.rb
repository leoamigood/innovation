class ApplicationController < ActionController::Base
  include HandleResult

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def on_failure_result(error)
    respond_to do |format|
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: error, status: :unprocessable_entity }
    end
  end
end
