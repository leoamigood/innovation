Rails.application.reloader.to_prepare do
  Wisper.clear

  Wisper.subscribe(EventsLoggerListener.new)

  Posts::Create.subscribe(PostListener.new)
end
