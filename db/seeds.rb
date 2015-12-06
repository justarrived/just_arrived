# Development seed

max_langs           = ENV.fetch('MAX_LANGS', 5).to_i
max_skills          = ENV.fetch('MAX_SKILLS', 5).to_i
max_addresses       = ENV.fetch('MAX_ADDRESSES', 5).to_i
max_skills          = ENV.fetch('MAX_SKILLS', 10).to_i
max_users           = ENV.fetch('MAX_USERS', 10).to_i
max_jobs            = ENV.fetch('MAX_JOBS', 10).to_i
max_job_users       = ENV.fetch('MAX_JOB_USERS', 10).to_i

# Seed languages
max_langs.times do
  Language.create!(lang_code: Faker::Company.bs[0..1])
end

# Seed skills
max_skills.times do
  Skill.create!(name: Faker::Name.title)
end

# Seed addresses
addresses = []
max_addresses.times do |i|
  addresses << "Stora Nygatan 36 #{i}, Malmö"
  addresses << "Wollmar Yxkullsgatan #{i}, Stockholm"
end

# Seed users
skills = Skill.all
languages = Language.all
max_users.times do
  address = addresses.sample
  user = User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    phone: Faker::PhoneNumber.cell_phone,
    description: Faker::Hipster.paragraph(2),
    address: address,
  )
  user.skills << skills.sample
  user.languages << languages.sample
  Comment.create!(
    body: Faker::Company.bs,
    owner_user_id: user.id,
    commentable: User.all.sample
  )
end

# Seed jobs
days_from_now_range = (1..10).to_a
rates = (100..1000).to_a
users = User.all

max_jobs.times do
  address = addresses.sample
  job = Job.create!(
    name: Faker::Name.name,
    max_rate: rates.sample,
    description: Faker::Hipster.paragraph(2),
    job_date: (days_from_now_range.sample).days.from_now,
    owner: users.sample,
    address: address
  )
  job.skills << skills.sample
  Comment.create!(
    body: Faker::Company.bs,
    owner_user_id: users.sample.id,
    commentable: users.sample
  )
end

# Seed job users
jobs = Job.all
max_job_users.times do
  job = jobs.sample
  owner = job.owner

  user = users.sample
  max_retries = 5
  until owner != user
    user = users.sample
    max_retries += 1
    break if max_retries < 1
  end

  job = jobs.sample
  JobUser.create!(
    user: user,
    job: job,
    rate: rates.sample,
  )
end
