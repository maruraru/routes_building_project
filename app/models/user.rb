# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Validation
  validates_presence_of :organisation_name
  validates_presence_of :email
  validates_uniqueness_of :email
  validates :password, presence: true
  validates :password_confirmation, presence: true, on: :create
end
