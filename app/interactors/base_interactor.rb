# frozen_string_literal: true

require 'dry/monads'

class BaseInteractor
  include Wisper::Publisher

  class Error < StandardError; end

  extend Dry::Initializer
  include Dry::Monads[:result, :do, :try, :maybe, :validated, :list]

  def call_with_transaction
    ActiveRecord::Base.transaction do
      @result = call.to_result
      raise ActiveRecord::Rollback, @result.failure if @result.failure?
    end
    @result
  rescue ActiveRecord::Rollback => e
    Rails.logger.warn e.message
    @result
  end

  class << self
    def call(*, **, &)
      new(*, **).call_with_transaction(&)
    end

    def call!(*, **, &)
      result = new(*, **).call_with_transaction(&)
      raise result.failure if result.failure?

      result.value!
    end

    private

    # Accepts both symbolized and stringified attributes
    def new(*, **kwargs)
      kwargs = kwargs.symbolize_keys if kwargs.is_a?(Hash)
      super
    end
  end

  private

  def build_model(model, params)
    Success(model.new(params))
  end

  def save_model(model)
    Try { model.tap(&:save!) }.to_result
  end

  def validate_model(model)
    Try { model.tap(&:validate!) }.to_result
  end

  def error_message(key, **)
    I18n.t("interactors.#{self.class.name.underscore.tr('/', '.')}.errors.#{key}", **)
  end
end
