# frozen_string_literal: true

module Posts
  class Destroy < BaseInteractor
    param :post, model: Post

    def call
      Try {
        post.discard
      }.bind(method(:broadcast_event))
    end

    private

    def broadcast_event(post)
      ActiveRecord.after_all_transactions_commit { broadcast(:post_deleted, post) }

      Success()
    end
  end
end
