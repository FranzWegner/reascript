-- time in seconds for fading
fadeTime = 0.5

-- get current active mix configuration id to fade to
currentMix = tonumber(reaper.GetExtState("mixes", "currentMix"))

-- mix configurations, volume in amplitudes
mixes = {{1,1,0.1,0,0}, {0,0,1,1,0}}

-- set active mix configuration
mix = mixes[currentMix+1]

-- get active playhead position and add small buffer for the transition to start
currentTime = reaper.GetPlayPosition() + 0.3

-- iterate over the first envelope of each track (envelope needs to be created beforehand)
for i=0, #mix-1 do
  track = reaper.GetTrack(0,  i)
  envelope = reaper.GetTrackEnvelope(track, 0)
  -- get last envelope point before playhead position
  lastPoint = reaper.GetEnvelopePointByTime(envelope, currentTime)
  -- get the volume of that point (lastValue)
  retval, time, lastValue, shape, tension = reaper.GetEnvelopePoint(envelope, lastPoint, 0, 0, 0, 0, 0)
  -- create envelope point with same value as last point
  reaper.InsertEnvelopePoint(envelope, currentTime, lastValue, 0, 0 , false, false)
  -- create envelope point after fadeTime with according volume of the mix configuration
  reaper.InsertEnvelopePoint(envelope, currentTime + fadeTime, reaper.ScaleToEnvelopeMode(1, mix[i+1]), 0, 0, false, false)
end

 
