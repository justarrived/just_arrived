# == Schema Information
#
# Table name: job_skills
#
#  id         :integer          not null, primary key
#  job_id     :integer
#  skill_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_job_skills_on_job_id    (job_id)
#  index_job_skills_on_skill_id  (skill_id)
#
# Foreign Keys
#
#  fk_rails_514cd69e1b  (skill_id => skills.id)
#  fk_rails_94b0ff3621  (job_id => jobs.id)
#

class JobSkillSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :job
  belongs_to :skill
end
