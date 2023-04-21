class Stat < ApplicationRecord

  belongs_to :user
  belongs_to :reservoir

  validates :reservoir_id, presence: true
  validates_numericality_of :min, :greater_than => 0, :less_than => 100, :message => "must be between 1 and 99", allow_blank: true
  validates_numericality_of :max, :greater_than => 0, :less_than => 100, :message => "must be between 1 and 99", allow_blank: true

end