local component = require("component")
local event = require("event")
local computer = require("computer")

local function generateWaveform(waveform, frequency)
    local soundCard = component.sound_card
    if not soundCard then
        error("No sound card found.")
    end

    local sampleRate = 44100
    local duration = 1  -- 1 second
    local samples = math.floor(sampleRate * duration)
    local buffer = {}

    for i = 0, samples - 1 do
        local t = i / sampleRate
        local value = 0

        if waveform == "Sine" then
            value = math.sin(2 * math.pi * frequency * t)
        elseif waveform == "Sawtooth" then
            value = 2 * (t * frequency - math.floor(t * frequency + 0.5))
        elseif waveform == "Square" then
            value = (t * frequency % 1 < 0.5) and 1 or -1
        elseif waveform == "Triangle" then
            value = 2 * math.abs(2 * (t * frequency % 1) - 1) - 1
        elseif waveform == "AM" then
            value = (0.5 * math.sin(2 * math.pi * frequency * t) + 0.5) * math.sin(2 * math.pi * 440 * t)
        elseif waveform == "FM" then
            value = math.sin(2 * math.pi * (440 * t + 0.5 * math.sin(2 * math.pi * frequency * t)))
        elseif waveform == "FSK" then
            value = (t * frequency % 1 < 0.5) and 1 or -1
        elseif waveform == "PWM" then
            value = (t * frequency % 1 < 0.5) and 1 or 0
        else
            error("Invalid waveform type.")
        end

        buffer[i + 1] = value
    end

    soundCard.playSound(buffer, sampleRate)
end

-- Example usage
generateWaveform("Sine", 440)  -- Generate a 440Hz sine wave
