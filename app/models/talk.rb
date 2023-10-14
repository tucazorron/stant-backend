class Talk < ApplicationRecord
    validates :title, presence: true
    validates :duration, presence: true

    def self.handle_file(file)
        talks = []
        file_content = file.read
        lines = file_content.split("\n")
        lines.each do |line|
            last_space_index = line.rindex(' ')
            title = line[0..last_space_index].strip
            duration_string = line[last_space_index..-1].strip
            if duration_string.end_with?('min')
                duration = duration_string[0..-4].to_i
            elsif duration_string.end_with?('lightning')
                duration = 5
            end
            talk = Talk.new(title: title, duration: duration)
            if talk.save
                talks << talk
            end
        end
        talks
    end

    def self.get_schedule(talks)
        schedule = []
        talks = talks.sort_by(&:duration).reverse
        talks.each do |talk|
            scheduled = false
            schedule.each do |slot|
                if slot[:duration] >= talk.duration
                    slot[:talks] << talk
                    slot[:duration] -= talk.duration
                    scheduled = true
                    break
                end
            end
            unless scheduled
                schedule << { duration: 180, talks: [talk] }
            end
        end
        schedule
    end
end
