class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_many :tasks

  before_update :set_uuid, unless: -> { self.uuid.present? }

  private

  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
