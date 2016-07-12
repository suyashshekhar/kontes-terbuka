# == Schema Information
#
# Table name: long_problems
#
#  id         :integer          not null, primary key
#  contest_id :integer
#  problem_no :integer
#  statement  :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_long_problems_on_contest_id  (contest_id)
#

require 'test_helper'

class LongProblemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
