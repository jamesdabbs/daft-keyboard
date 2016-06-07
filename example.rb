require "pry"
require "unimidi"

OutputDevice = UniMIDI::Output[1]
InputDevice  = UniMIDI::Input[1]

# Define base rgb values for each pad
Bases = {}
1.upto 8 do |row|
  1.upto 8 do |col|
    cell = 10 * row + col
    red  = (col / 9.0) * 64
    blue = (row / 9.0) * 64
    Bases[cell] = [red, 0, blue]
  end
end

# Define our sample map
Clips = {
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
}

# And translate up for versions 2 and 3
# N.B. we use clone so that we're not updating the
#   hash that we're iterating over while we're going
Clips.clone.each do |k, name|
  Clips[k + 20] = name.sub "1", "2"
  Clips[k + 40] = name.sub "1", "3"
end

# A helper function for triggering a given sample
def play_sample pad_number
  clip = Clips[pad_number]
  path = "./samples/#{clip}.mp3"
  if File.exists? path
    system "afplay #{path} &"
  end
end

# A helper function for setting a pad color
def set_color pad_number, r, g, b
  OutputDevice.puts 240, 0, 32, 41, 2, 16, 11, pad_number, r, g, b, 247
end


# Colorize all the cells their starting color
Bases.each do |cell, triple|
  r, g, b = triple
  set_color cell, *rgb
  sleep 0.01 # get a cool washing effect
end

loop do
  events = InputDevice.gets
  events.each do |event|
    puts event
    code, pad, val = event[:data]
    if code == 144
      if val > 0
        set_color pad, 0, 127, 0
        play_key pad
      else
        r, g, b = Bases[pad]
        set_color pad, r, g, b
      end
    end
  end
end
