class EventsController < ApplicationController
    before_action :require_login

    def index
        @user = User.find(session[:user_id])
        @state_events = Event.joins(:user).where(state: @user.state)
        @other_state_events = Event.joins(:user).where.not(state: @user.state)
        @states = states_list
    end
    def create
        @user = User.find(session[:user_id])
        e = Event.new(name: params[:name], date: params[:date], location: params[:location], state: params[:state], user: @user)
        if e.valid?
          e.save
          redirect_to "/events"
        else
          flash[:messages] = e.errors.full_messages
          redirect_to "/events"
        end
    end
    def create_comments
        @user = User.find(session[:user_id])
        @event = Event.find(params[:event_id])
        c = Comment.new(content: params[:content], user: @user, event: @event)
          if c.valid?
            c.save
            redirect_to "/events/#{@event.id}"
          else
            flash[:messages] = c.errors.full_messages
            redirect_to "/events/#{@event.id}"
          end
    end
    def create_attendee
        @user = User.find(session[:user_id])
        @event = Event.find(params[:event_id])
        Attendee.create(user: @user, event: @event)
        redirect_to "/events/#{@event.id}"
    end
    def show
        @event = Event.find(params[:event_id])
        @comments = Comment.where(event: @event)
    end
    def edit
        @event = Event.find(params[:event_id])
        @states = states_list
    end
    def update
        e = Event.find(params[:event_id])
        e.name = params[:name]
        e.date = params[:date]
        e.location = params[:location]
        e.state = params[:state]
        if !e.valid?
            flash[:messages] = e.errors.full_messages
            redirect_to "/events/#{e.id}/edit"
        else
            e.save
            flash[:messages] = ["You have successfully updated your event."]
            redirect_to "/events"
        end
    end
    def destroy_attendee
        @user = User.find(session[:user_id])
        @event = Event.find(params[:event_id])
        Attendee.find_by(user: @user, event: @event).destroy
        redirect_to "/events/"
    end
    def destroy
        @event = Event.find(params[:event_id])
        @event.destroy
        redirect_to "/events/"
    end
end