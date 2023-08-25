class SessionsController < ApplicationController

    def create
        @user = Utente.find_by(email: params[:email])

        if !!@user && @user.authenticate(params[:password])

            session[:user_id] = @user.id 
            redirect_to home_index_path

        else 
            
            flash.alert = 'Email o Password, Riprovare'
            redirect_to login_path
        
        end
    end

    def destroy
        session[:user_id] = nil
        redirect_to login_path
    end

   
end