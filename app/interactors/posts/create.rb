# frozen_string_literal: true

module Posts
  class Create < BaseInteractor
    param :params do
      option :title, type: Types::Strict::String
      option :body, type: Types::Strict::String
    end

    def call
      build_model(Post, params.to_h)
        .bind(method(:save_model))
        .bind(method(:broadcast_event))
    end

    private

    def broadcast_event(post)
      ActiveRecord.after_all_transactions_commit { broadcast(:post_created, post) }

      Success(post)
    end
  end
end
