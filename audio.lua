local audio = {}

local sources = {}

require "slam"

function findAudio(name)
  for k,v in pairs(sources) do
    if v.name == name then
      return v;
    end
  end
  return nil;
end

function audio.load(name, file)
  local newSource = {
    name = name,
    file = file,
    source = love.audio.newSource(file, "static")
  };

  local oldSource = findAudio(name);

  if (oldSource) then 
    oldSource = newSource;
  else
    table.insert(sources, newSource);
  end
end

function audio.play(name, loop, volume)
  loop = loop or false;
  volume = volume or 1.0;
  local source = findAudio(name);
  if (source) then 
    source.source:setLooping(loop);
    source.source:setVolume(volume);
    source.source:play() 
  end
end

return audio;