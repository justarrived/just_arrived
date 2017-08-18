# frozen_string_literal: true

class JobDigestSubscriber < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :job_digest
end

# == Schema Information
#
# Table name: job_digest_subscribers
#
#  id            :integer          not null, primary key
#  email         :string
#  uuid          :string(36)
#  user_id       :integer
#  job_digest_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_job_digest_subscribers_on_job_digest_id  (job_digest_id)
#  index_job_digest_subscribers_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_digest_id => job_digests.id)
#  fk_rails_...  (user_id => users.id)
#
