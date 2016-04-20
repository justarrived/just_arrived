# frozen_string_literal: true
require 'administrate/base_dashboard'

class CompanyDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    users: Field::HasMany,
    id: Field::Number,
    frilans_finans_id: Field::Number,
    name: Field::String,
    cin: Field::String,
    website: Field::String,
    email: Field::String,
    street: Field::String,
    zip: Field::String,
    city: Field::String,
    country: Field::String,
    contact: Field::String,
    phone: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :users
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :users,
    :id,
    :website,
    :frilans_finans_id,
    :name,
    :cin,
    :created_at,
    :updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :users,
    :name,
    :website,
    :frilans_finans_id,
    :cin,
    :email,
    :street,
    :zip,
    :city,
    :country,
    :contact,
    :phone
  ].freeze

  # Overwrite this method to customize how skills are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(company)
    "##{company.id} #{company.name}"
  end
end
