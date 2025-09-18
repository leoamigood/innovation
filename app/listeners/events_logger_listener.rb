# frozen_string_literal: true

class EventsLoggerListener
  attr_accessor :logger

  def initialize
    @logger = ActiveSupport::Logger.new($stdout)
                                   .tap  { |logger| logger.formatter = Logger::Formatter.new }
                                   .then { |logger| ActiveSupport::TaggedLogging.new(logger) }
    @logger.level = ENV.fetch('EVENTS_LOG_LEVEL', Rails.logger.level)
  end

  def method_missing(*args)
    logger.info "Event: #{args[0]} with args: #{args}"
  end

  def respond_to_missing?(_method_name, _include_private = false)
    true
  end

  def to_ary
    [logger]
  end
end
