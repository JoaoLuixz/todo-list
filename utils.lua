local utils = {};

function utils.createNecessaryFiles()
  local file = io.open(".\\db\\todos.json", "w");

  if not file then
    os.execute("mkdir db");
    os.execute("type nul > .\\db\\todos.json")
  end
    print("Files created!")
end


return utils
