# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Posts::Create do
  subject(:interactor_call) { described_class.call(**params) }

  let(:params) { { title: 'Title', body: 'Body' } }

  it { is_expected.to be_success }
  it { expect { interactor_call }.to broadcast(:post_created) }

  context 'when title is blank' do
    let(:params) { { title: '', body: 'Body' } }

    it { is_expected.to be_failure }
    it { expect { interactor_call }.not_to broadcast(:post_created) }
  end
end
