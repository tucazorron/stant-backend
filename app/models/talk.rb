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

    def self.create_schedule(talks)
        schedule = []
        track_model = {
            next_morning_talk_time: '09:00',
            morning_time_left: 180,
            morning_schedule: [],
            next_afternoon_talk_time: '13:00',
            afternoon_time_left: 240,
            afternoon_schedule: []
        }
        schedule << Marshal.load(Marshal.dump(track_model))
        sorted_talks = talks.sort_by { |t| -t["duration"] }
        sorted_talks.each do |talk|
            is_talk_scheduled = false
            schedule.each do |track|
                if talk.duration <= track[:morning_time_left]
                    track[:morning_schedule] << {"time": track[:next_morning_talk_time], "title": talk.title, "duration": talk.duration}
                    track[:morning_time_left] -= talk.duration
                    track[:next_morning_talk_time] = (Time.parse(track[:next_morning_talk_time]) + talk.duration * 60).strftime('%H:%M')
                    is_talk_scheduled = true
                elsif talk.duration <= track[:afternoon_time_left]
                    track[:afternoon_schedule] << {"time": track[:next_afternoon_talk_time], "title": talk.title, "duration": talk.duration}
                    track[:afternoon_time_left] -= talk.duration
                    track[:next_afternoon_talk_time] = (Time.parse(track[:next_afternoon_talk_time]) + talk.duration * 60).strftime('%H:%M')
                    is_talk_scheduled = true
                end
            end
            if !is_talk_scheduled
                schedule << Marshal.load(Marshal.dump(track_model))
                new_track = schedule.last
                new_track[:morning_schedule] << {"time": new_track[:next_morning_talk_time], "title": talk.title, "duration": talk.duration}
                new_track[:morning_time_left] -= talk.duration
                new_track[:next_morning_talk_time] = (Time.parse(new_track[:next_morning_talk_time]) + talk.duration * 60).strftime('%H:%M')
            end
        end
        schedule
    end
end
