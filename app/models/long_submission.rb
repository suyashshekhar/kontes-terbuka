class LongSubmission < ActiveRecord::Base
	belongs_to :user
	belongs_to :contest

	mount_uploader :attachment

	validates :name, presence: true
	validates :problem_id, presence: true
end