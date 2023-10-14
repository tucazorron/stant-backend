class TalksController < ApplicationController
    def create
        file = params[:file]
        imported_talks = []
        
        CSV.foreach(file.path) do |row|
            title, duration = row
            talk = Talk.new(title: title, duration: duration)
            if talk.save
                imported_talks << talk
            end
        end
        render json: imported_talks
    end

    def index
        talks = Talk.all
        render json: talks
    end
end
