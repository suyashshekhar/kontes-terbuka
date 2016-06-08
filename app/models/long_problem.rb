class LongProblem < ActiveRecord::Base
	belongs_to :contest
	has_many :long_submissions, -> { order(page: :asc) }
	has_many :users, through: :long_submissions

	accepts_nested_attributes_for :long_submissions
end