# frozen_string_literal: true

class PostPolicy < ApplicationPolicy
  relation_scope do |relation|
    relation.kept
  end

  def index?
    true
  end

  def manage?
    true
  end

  def create?
    true
  end

  def destroy?
    user.is_admin?
  end
end
