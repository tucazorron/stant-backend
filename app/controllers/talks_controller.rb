class TalksController < ApplicationController
    protect_from_forgery with: :null_session, only: [:upload_file]

    def upload_file
        Talk.delete_all
        talks = Talk.get_talks(params[:file])
        schedule = Talk.schedule_talks(talks)
        render json: schedule
    end

    def index
        render json: Talk.all
    end
end
