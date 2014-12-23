class RegistrationsController < Devise::RegistrationsController

  def edit
  end

  def update
    new_params = params.require(:user).permit(:email,
                                              :username,
                                              :current_password,
                                              :password,
                                              :password_confirmation)

    # Edit data without needing to change the password
    change_password = true
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
      new_params = params.require(:user).permit(:email,
                                                :username)
      change_password = false
    end

    # Retrieves current_user from db and updates it with the new_params hash
    @user = User.find(current_user.id)
    is_valid = false

    # Changes password if fields were included and user is valid
    if change_password
      is_valid = @user.update_with_password(new_params)
    else
      @user.update_without_password(new_params)
    end

    if is_valid
      sign_in @user, :bypass => true
      set_flash_message :notice, :updated
      redirect_to after_update_path_for(@user)
    else
      flash.now.alert = "Could not update user. Check your details."
      render "edit"
    end
  end

  # Called when user cancels its account.
  def destroy
    @user = User.find(current_user.id)
    @user.is_active = 0  # not active
    if @user.save
      sign_out @user
      redirect_to root_path
    else
      render "edit"
    end
  end
end
