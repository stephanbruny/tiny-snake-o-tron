local audio = {}

local sources = {}

require "slam"

function findAudio(name)
  for k,v in pairs(sources) do
    if v.name == name then
      return k, v;
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

  local index, oldSource = findAudio(name);

  if (oldSource) then 
    table.remove(sources, index);
  end
  table.insert(sources, newSource);  
end

function audio.play(name, loop, volume)
  loop = loop or false;
  volume = volume or 1.0;
  local _, source = findAudio(name);
  if (source) then 
    source.source:setLooping(loop);
    source.source:setVolume(volume);
    return source.source:play() 
  end
  print("Could not find sound " .. name);
end

return audio;