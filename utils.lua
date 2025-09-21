local utils = {};
utils.todoCount = 0;

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

  local formattedContent = string.format("{\"id\":%d, \"content\":\"%s\", \"status\":false}", self.todoCount, content);

  db = io.open(".\\db\\todos.json", "w");
  db:write(string.format("%s%s", string.sub(allDbContent, 1, #allDbContent - 1), self.todoCount ~= 0 and "," or "\n"));
  db:close();

  db = io.open(".\\db\\todos.json", "a");

  db:write(formattedContent)

  db:write("\n]");
  print(self.todoCount);
  self.todoCount = self.todoCount + 1;
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

  db = io.open(".\\db\\todos.json", "w"):write(updatedDbContent)
  db:close();

end

return utils
