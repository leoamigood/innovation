class PostListener
  def post_created(post)
    Rails.logger.info("Send email to subscribers about #{post.title}...")
  end
end
