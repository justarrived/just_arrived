# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sweepers::UserSweeper do
  describe '#create_frilans_finans' do
    context 'active Frilans Finans client' do
      it 'sets user frilans finans id' do
        user = FactoryBot.create(:user, frilans_finans_id: nil)
        user_scope = User.where(id: user.id)

        allow(User).to receive(:needs_frilans_finans_id).and_return(user_scope)

        isolate_frilans_finans_client(FrilansFinansAPI::FixtureClient) do
          described_class.create_frilans_finans
          user.reload
          expect(user.frilans_finans_id).to eq(1)
        end
      end

      it 'does nothing with anonymized users' do
        user = FactoryBot.create(:user, frilans_finans_id: nil, anonymized: true)

        isolate_frilans_finans_client(FrilansFinansAPI::FixtureClient) do
          described_class.create_frilans_finans
          user.reload
          expect(user.frilans_finans_id).to be_nil
        end
      end
    end

    context 'Frilans Finans nil client' do
      it 'does nothing when frilans finans returns nil' do
        user = FactoryBot.create(:user, frilans_finans_id: nil)

        isolate_frilans_finans_client(FrilansFinansAPI::NilClient) do
          described_class.create_frilans_finans
          user.reload
          expect(user.frilans_finans_id).to be_nil
        end
      end
    end
  end
end
