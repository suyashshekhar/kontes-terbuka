require 'test_helper'

class UserContestsControllerTest < ActionController::TestCase
  setup :login_and_be_admin, :create_items

  test 'routes' do
    assert_equal stop_nag_user_contest_path(@uc),
                 "/user-contests/#{@uc.id}/stop-nag"
    assert_equal contest_user_contests_path(contest_id: @c.id),
                 "/contests/#{@c.id}/user-contests"
    assert_equal new_contest_user_contest_path(contest_id: @c.id),
                 "/contests/#{@c.id}/user-contests/new"
  end

  test 'new' do
    test_abilities UserContest, :new, [], [nil]
    get :new, contest_id: @c.id
    assert_response 200
  end

  test 'create' do
    test_abilities UserContest, :create, [], [nil]
    post :create, contest_id: @c.id
    assert_redirected_to contest_path(@c)

    assert_not_nil UserContest.find_by contest: @c, user: @user
  end

  test 'stop_nag' do
    test_abilities UserContest, :stop_nag, [], [nil]
    post :stop_nag, id: @uc.id
    assert_response 200
    assert_not @uc.reload.donation_nag
  end

  private

  def create_items
    @uc = create(:user_contest, user: @user)
    @c = @uc.contest
  end
end