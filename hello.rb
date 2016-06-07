require "pry"
require "unimidi"

puts "Hello world"

OutputDevice = UniMIDI::Output[1]
InputDevice  = UniMIDI::Input[1]

puts "This should clear the output device"
OutputDevice.puts 240, 0, 32, 41, 2, 16, 14, 0, 247

def set_rgb pad, r, g, b
  OutputDevice.puts 240, 0, 32, 41, 2, 16, 11, pad, r, g, b, 247
end

samples = {
  11 => "WorkIt1",
  12 => "MakeIt1",
  13 => "DoIt1",
  14 => "MakesUs1",
  15 => "Harder1",
  16 => "Better1",
  17 => "Faster1",
  18 => "Stronger1",

  21 => "MoreThan1",
  22 => "Hour1",
  23 => "Our1",
  24 => "Never1",
  25 => "Ever1",
  26 => "After1",
  27 => "WorkIs1",
  28 => "Over1"

  # 31 => "WorkIt2"
}

additions = {}
samples.each do |key, value|
  additions[ key + 20 ] = value.sub("1", "2")
  additions[ key + 40 ] = value.sub("1", "3")
end

samples.merge! additions

loop do
  events = InputDevice.gets
  events.each do |event|
    # puts event
    # [144, 11, 50]|
    data = event[:data]
    # pad_number = data[1]
    # velocity = data[2]
    type, pad_number, velocity = data
    if type == 144 && velocity > 0
      set_rgb pad_number, rand(0..127), rand(0..127), rand(0..127)
      sample_name = samples[pad_number]
      command = "afplay ./samples/#{sample_name}.mp3 &"
      system command
    elsif type == 144
      set_rgb pad_number, 0, 0, 0
    end
  end
end

# sample_name = "WorkIt2"
# puts "What sample?"
# sample_name = gets.chomp

# Hardcoded sample sequence
# ["WorkIt2", "Harder2", "MakeIt2"].each do |sample_name|
#   command = "afplay ./samples/#{sample_name}.mp3"
#   system command
# end

puts "We're done"
