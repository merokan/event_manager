class SessionsController < ApplicationController
    def create
        u = User.find_by(email: params[:email])
        if u && u.authenticate(params[:password])
            session[:user_id] = u.id
            redirect_to "/events"
        else
            flash[:messages] = ["Invalid Login"]
            redirect_to "/"
        end
    end
      
    def destroy
        session[:user_id] = nil
        redirect_to "/"
    end
end
