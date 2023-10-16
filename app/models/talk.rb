class Talk < ApplicationRecord
    validates :title, presence: true
    validates :duration, presence: true
  
    def self.handle_file(file)
        talks = []
        file_content = file.read
        lines = file_content.split("\n")
        lines.each do |line|
            title, duration = parse_line(line)
            talk = Talk.new(title: title, duration: duration)
            talk.save
            talks << talk
        end
        talks
    end
  
    def self.parse_line(line)
        title, _, duration_string = line.rpartition(' ')
        duration = parse_duration(duration_string)
        [title.strip, duration]
    end
  
    def self.parse_duration(duration_string)
        if duration_string.end_with?('min')
            duration_string.to_i
        elsif duration_string.end_with?('lightning')
            5
        else
            0
        end
    end
  
    def self.create_schedule(talks)
        schedule = [new_track_model]
        sorted_talks = talks.sort_by(&:duration).reverse
        sorted_talks.each do |talk|
            schedule, is_talk_scheduled = schedule_talk(talk, schedule)
            schedule << new_track_model unless is_talk_scheduled
        end
        handle_schedule(schedule)
    end
  
    def self.schedule_talk(talk, schedule)
        is_talk_scheduled = false
        schedule.each do |track|
            if schedule_talk_in_track(talk, track, :morning, :morning_time_left, :next_morning_talk_time)
                is_talk_scheduled = true
            elsif schedule_talk_in_track(talk, track, :afternoon, :afternoon_time_left, :next_afternoon_talk_time)
                is_talk_scheduled = true
            end
        end
        [schedule, is_talk_scheduled]
    end
  
    def self.schedule_talk_in_track(talk, track, time_slot, time_left_key, next_time_key)
        return false if talk.duration > track[time_left_key]
        track[:"#{time_slot}_schedule"] << {
            "time": track[next_time_key],
            "title": talk.title,
            "duration": talk.duration
        }
        track[time_left_key] -= talk.duration
        track[next_time_key] = (Time.parse(track[next_time_key]) + talk.duration * 60).strftime('%H:%M')
        true
    end
  
    def self.new_track_model
        {
            next_morning_talk_time: '09:00',
            morning_time_left: 180,
            morning_schedule: [],
            next_afternoon_talk_time: '13:00',
            afternoon_time_left: 240,
            afternoon_schedule: []
        }
    end
  
    def self.handle_schedule(schedule)
        treated_schedule = []
        schedule.each do |track|
            treated_track = []
            treated_track.concat(track[:morning_schedule])
            treated_track << { "time": '12:00', "title": 'Almoço', "duration": 60 }
            treated_track.concat(track[:afternoon_schedule])
            networking_time = track[:afternoon_time_left] > 60 ? '16:00' : track[:next_afternoon_talk_time]
            treated_track << { "time": networking_time, "title": 'Evento de Networking', "duration": 60 }
            treated_schedule << treated_track
        end
        treated_schedule
    end
  end
  