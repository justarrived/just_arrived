# frozen_string_literal: true

ActiveAdmin.register RecruiterActivity do
  menu parent: 'Users'

  permit_params do
    [
      :body, :user_id, :activity_id,
      document_attributes: %i[id document]
    ]
  end

  # rubocop:disable Metrics/LineLength
  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs(f.object.display_name) do
      f.input :activity, collection: Activity.order(name: :asc), hint: I18n.t('admin.recruiter_activity.activity_hint')
      f.input :user, collection: User.delivery_users, selected: current_active_admin_user.id
      f.has_many :document, new_record: I18n.t('admin.recruiter_activity.new_document_title') do |b|
        b.input :document, as: :file, hint: I18n.t('admin.recruiter_activity.document_hint')
      end
      f.input :body
    end

    f.actions
  end
  # rubocop:enable Metrics/LineLength
end
