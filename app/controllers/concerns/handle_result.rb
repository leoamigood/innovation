# frozen_string_literal: true

module HandleResult
  def handle_result(interactor_klass, *params, rendering_options: {}, **, &block)
    interactor_klass.call(*params, **).either(
      block.presence || ->(args) { on_success_result(args, rendering_options:) },
      ->(error) { on_failure_result(error) }
    )
  end

  def on_success_result(_, _options = {})
    raise NotImplementedError
  end

  def on_failure_result(error)
    raise NotImplementedError
  end
end
