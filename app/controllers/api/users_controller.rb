class Api::UsersController < ApiController
  def index
    users = User.all
    render json: users
  end
  
  def create
    user = User.new(username: user_params[:username], password: user_params[:password])
    if user.save
      render json: user_params
    else
      head 422
    end
  end
  
  private
  def user_params
    params.require(:new_user).permit!
  end
  
end
