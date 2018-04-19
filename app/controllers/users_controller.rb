class UsersController < ApplicationController
    before_action :require_login, except: [:new, :create]
    before_action :require_correct_user, only: [:show, :edit, :update, :destroy]

    def new
        @states = states_list
    end
    def create
      u = User.new(first_name: params[:first_name], last_name: params[:last_name], location: params[:location], state: params[:state], email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
      if u.valid?
        u.save
        session[:user_id] = u.id
        redirect_to "/events"
      else
        flash[:messages] = u.errors.full_messages
        redirect_to "/"
      end
    end
    def edit
        @user = User.find(session[:user_id])
        @states = states_list
    end
    def update
        u = User.find(session[:user_id])
        u.first_name = params[:first_name]
        u.last_name = params[:last_name]
        u.email = params[:email]
        u.location = params[:location]
        u.state = params[:state]
        if !u.valid?
            flash[:messages] = u.errors.full_messages
            redirect_to "/users/#{u.id}"
        else
            u.save
            flash[:messages] = ["You have successfully updated your profile."]
            redirect_to "/events"
        end
    end
    private
    def require_correct_user
      user = User.find(params[:id])
      redirect_to current_user if current_user != user
    end
end
