class UsersController < ApplicationController
  include UserPasswordController

  load_resource

  guest_actions = [:new, :check_unique, :create, :forgot_password,
                   :process_forgot_password, :reset_password,
                   :process_reset_password, :verify]
  skip_before_action :require_login, only: guest_actions
  authorize_resource except: guest_actions

  def new
    if current_user.nil?
      redirect_to sign_users_path(anchor: 'register')
    else
      redirect_to root_path
    end
  end

  def create
    user = User.new(user_params)

    if verify_recaptcha(model: user) && user.save
      user.send_verify_email
      redirect_to root_path, notice: 'Registrasi berhasil! ' \
        'Sekarang, lakukan verifikasi dengan membuka link yang telah ' \
        'kami berikan di email Anda.'
    else
      Ajat.warn "register_fail|#{user.errors.full_messages}|" \
        "user:#{user.inspect}"
      flash.now[:alert] = 'Terdapat kesalahan dalam ' \
      ' registrasi. Jika registrasi masih tidak bisa dilakukan, ' \
        "#{ActionController::Base.helpers.link_to 'kontak kami',
                                                  contact_path}."
      render 'welcome/sign'
    end
  end

  def show
    @user_contests = Contest.where(id: @user.user_contests.pluck(:contest_id),
                                   result_released: true)
                            .order(id: :desc)
                            .includes(:long_problems)
    if can? :show_full, @user
      @user_contests = @user_contests.includes(:short_problems)
    end
    @user_contests = @user_contests.map do |c|
      c.results
       .find { |u| u.user_id == @user.id }
    end.paginate(page: params[:page_history],
                 per_page: 5)
    @point_transactions = PointTransaction.where(user: @user)
                                          .paginate(
                                            page: params[:page_transactions],
                                            per_page: 5
                                          ).order(created_at: :desc)
  end

  def index
    params[:search] ||= ''
    @users = User.where('username ILIKE ?', '%' + params[:search] + '%')
                 .paginate(page: params[:page], per_page: 50)
                 .order(:username)
                 .includes(:province, :status, :roles)
    return if (cannot? :index_full, User) || !params[:hide_disabled]
    @users = @users.where(enabled: true)
  end

  def edit; end

  def update
    if @user.update(user_edit_params)
      Ajat.info "user_full_update|user:#{@user.id}"
      redirect_to user_path(@user), notice: 'User berhasil diupdate!'
    else
      flash.now[:alert] = 'Terdapat kesalahan!'
      render :edit
    end
  end

  def referrer_update
    @user.update(referrer_id: params[:user][:referrer_id])
    redirect_to :back, notice: 'Terima kasih sudah mengisi!'
  end

  def mini_update
    if @user.update(user_mini_edit_params)
      redirect_to user_path(@user), notice: 'User berhasil diupdate!'
    else
      Ajat.warn "user_mini_update_fail|user:#{@user.id}"
      redirect_to user_path(@user),
                  alert: 'Terdapat kesalahan dalam mengupdate User!'
    end
  end

  def destroy
    if @user.destroy
      Ajat.warn "user_destroy|uid:#{params[:id]}"
      redirect_to users_path, notice: 'User berhasil didelete!'
    else
      redirect_to user_path(@user), alert: 'User tidak bisa didelete!'
    end
  end

  def check_unique
    users = User.all
    params[:username] && users = users.where(username: params[:username])
    params[:email] && users = users.where(email: params[:email])
    render json: !users.present?
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password,
                                 :password_confirmation, :fullname,
                                 :province_id, :status_id, :color_id,
                                 :school, :referrer_id, :terms_of_service,
                                 :osn)
  end

  def user_edit_params
    params.require(:user).permit(:username, :email, :timezone,
                                 :fullname, :province_id, :status_id, :color_id,
                                 :school)
  end

  def user_mini_edit_params
    params.require(:user).permit(:timezone, :color_id)
  end
end
