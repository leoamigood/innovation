# frozen_string_literal: true

module Posts
  class Create < BaseInteractor
    param :params do
      option :title, type: Types::Strict::String
      option :body, type: Types::Strict::String
      option :palette, type: Types::Palette, default: -> { Aqua.new }
    end

    def call
      build_model(Post, params.to_h)
        .bind(method(:save_model))
        # .tee(method(:censorship))
        .bind(method(:broadcast_event))
        .or { |error|
          Rails.logger.warn(error)
          Failure(error)
        }
    end

    private

    def censorship(post)
      Failure("Post #{post.title} has been censored by authorities...")
    end

    def broadcast_event(post)
      ActiveRecord.after_all_transactions_commit { broadcast(:post_created, post) }

      Success(post)
    end
  end
end
