local utils = {};

function utils.getHighestTodoIndex()
  local db = io.open(".\\db\\todos.json", "r");
  local highestTodoId = 0;

  for line in db:lines() do
    if #line > 1 then
      local startIdIndex, endIdIndex = string.find(line, "%d+")
      local todoId = tonumber(line:sub(startIdIndex, endIdIndex));
      highestTodoId = highestTodoId > todoId and highestTodoId or todoId;
    end
  end
  db:close()

  return highestTodoId
end

utils.highestTodoIndex = utils.getHighestTodoIndex();

function utils.createNecessaryFiles()
  local db = io.open(".\\db\\todos.json", "r");

  if not db then
    os.execute("mkdir db");
    db = io.open(".\\db\\todos.json", "w"):write("[]")
    print("Database created")
  end

  db:close();
end

function utils:addTodo(content)
  local db = io.open(".\\db\\todos.json", "r");
  local allDbContent = db:read("*a");
  db:close();

  local formattedContent = string.format("{\"id\":%d, \"content\":\"%s\", \"status\":false}", self.highestTodoIndex, content);

  db = io.open(".\\db\\todos.json", "w");
  db:write(string.format("%s%s", string.sub(allDbContent, 1, #allDbContent - 1), self.highestTodoIndex ~= 0 and "," or "\n"));
  db:close();

  db = io.open(".\\db\\todos.json", "a");

  db:write(formattedContent)

  db:write("\n]");
  print(self.highestTodoIndex);
  self.highestTodoIndex = self.highestTodoIndex + 1;
  db:close();
end

function utils.removeTodo(id)
  local db = io.open(".\\db\\todos.json", "r");
  local updatedDbContent = "[";

  for line in db:lines() do
    if #line > 1 then
      local todoId = tonumber(string.match(line, "%d+"));
      if todoId ~= id then
        updatedDbContent = updatedDbContent .. "\n" .. line;
      end
    end
  end

  updatedDbContent = updatedDbContent .. "\n]";
  db:close()
  db = io.open(".\\db\\todos.json", "w"):write(updatedDbContent)
  db:close();
end

function utils.updateTodo(id) 
  local db = io.open(".\\db\\todos.json", "r");
  local updatedDbContent = "[";

  local finishedTodoPattern = "\"status\":true}"
  local unFinishedTodoPattern = "\"status\":false}"
  
  for line in db:lines() do
    if #line > 1 then
      local todoId = tonumber(string.match(line, "%d+"));
      if todoId == id then
        if string.find(line, finishedTodoPattern.."$") then
          line = string.gsub(line, finishedTodoPattern, unFinishedTodoPattern);
        else
          line = string.gsub(line, unFinishedTodoPattern, finishedTodoPattern);
      end
        print(line)
      end
      updatedDbContent = updatedDbContent .. "\n" .. line;
    end
  end
  updatedDbContent = updatedDbContent .. "\n]";

  db:close();
  db = io.open(".\\db\\todos.json", "w"):write(updatedDbContent);
  db:close();
end

return utils
