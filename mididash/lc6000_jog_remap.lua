local out_bytes = {}

-- Copy the message so the incoming bytes remain unchanged
for i, byte in ipairs(bytes) do
  out_bytes[i] = byte
end

local status = bytes[1]
local cc = bytes[2]
local input = bytes[3]

-- 0xB0–0xBF are Control Change messages on channels 1–16
if status >= 0xB0 and status <= 0xBF and cc == 34 then
  local output

  if input == 0 then
  	output = 0
  elseif input < 64 then
    -- Forward: 1-63 dec
    -- slow to fast
    output = 64 + input
  else  -- input > 64
  	--- Reverse: 127-64 dec
  	--- slow to fast
    output = input - 64
  end
  -- MIDI CC values must be in the range 0–127.
  -- The formula gives -1 when input is 65, so clamp that case to 0.
  if output < 0 then
    output = 0
  end
  if output > 127 then
    output = 127
  end
  out_bytes[3] = output
end

-- Hardcode DT1 for DDJ-SX: 33d = 0x21
out_bytes[2] = 33


table.insert(res, {
  port = "out",
  bytes = out_bytes
})
