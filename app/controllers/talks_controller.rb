class TalksController < ApplicationController
    protect_from_forgery with: :null_session, only: [:upload_file]

    def index
        render json: Talk.all
    end

    def create
        talk = Talk.new(title: params[:title], duration: params[:duration])
        if talk.save
            render json: talk
        else
            render json: talk.errors, status: :unprocessable_entity
        end
    end

    def show
        talk = Talk.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: { message: 'Palestra não encontrada!' }, status: :not_found
    else
        render json: talk
    end

    def update
        talk = Talk.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: { message: 'Palestra não encontrada!' }, status: :not_found
    else
        if talk.update(title: params[:title], duration: params[:duration])
            render json: talk
        else
            render json: talk.errors, status: :unprocessable_entity
        end
    end

    def destroy
        talk = Talk.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        render json: { message: 'Palestra não encontrada!' }, status: :not_found
    else
        talk.destroy
        render json: { message: 'Palestra deletada com sucesso!' }
    end

    def destroy_all
        Talk.destroy_all
        render json: { message: 'Todas as palestras foram deletadas!' }
    end

    def upload_file
        talks = Talk.handle_file(params[:file])
        render json: talks
    end

    def schedule
        talks = Talk.all
        schedule = Talk.create_schedule(talks)
        render json: schedule
    end
end
