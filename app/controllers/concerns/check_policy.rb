# frozen_string_literal: true

module CheckPolicy
  private

  def policy_class
    "#{controller_resource}Policy".constantize
  end

  def validate_policy!
    authorize! with: policy_class
  end

  def controller_resource
    controller_name.classify.constantize
  end

  def default_authorized_scope(resource = nil)
    authorized_scope((resource || controller_resource).all)
  end
end
