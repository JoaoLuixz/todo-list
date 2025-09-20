local utils = {};

function utils.createNecessaryFiles()
  local db = io.open(".\\db\\todos.json", "w");

  if not file then
    os.execute("mkdir db");
  end

  db = io.open(".\\db\\todos.json", "w");
  db:write("[]");
  db:close();
  print("Files created!")
end

function utils.addTodo(content)
  local db = io.open(".\\db\\todos.json", "r");
  local allDbContent = db:read("*a");
  print(allDbContent)
  local formattedContent = string.format("{\"content\":\"%s\", \"status\":false},", content);
  db:close();
  db = io.open(".\\db\\todos.json", "w");
  print(formattedContent);
  db:write(string.format("%s %s %s", string.sub(allDbContent, 1, #allDbContent - 1), formattedContent, string.sub(allDbContent, -1) ))
  db:close()
end
return utils
