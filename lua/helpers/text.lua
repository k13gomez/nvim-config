local M = {}

do
  local sec, usec = vim.uv.gettimeofday()
  math.randomseed(sec * 1000000 + usec)
end

local function rand_hex(n)
  local out = {}
  for i = 1, n do
    out[i] = string.format("%x", math.random(0, 15))
  end
  return table.concat(out)
end

local function uuid_v4()
  local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
  return (
    template:gsub("[xy]", function(c)
      local v = (c == "x") and math.random(0, 15) or math.random(8, 11)
      return string.format("%x", v)
    end)
  )
end

local function insert_at_cursor(text)
  vim.cmd("normal! i" .. text)
end

function M.guid()
  insert_at_cursor(uuid_v4())
end

function M.empty_guid()
  insert_at_cursor("00000000-0000-0000-0000-000000000000")
end

function M.hash()
  insert_at_cursor(rand_hex(32))
end

function M.datetime_now()
  local sec, usec = vim.uv.gettimeofday()
  local ms = math.floor(usec / 1000)
  local stamp = os.date("%Y-%m-%dT%H:%M:%S", sec)
  local tz = os.date("%z", sec)
  insert_at_cursor(string.format("%s.%03d%s", stamp, ms, tz))
end

function M.pretty_xml()
  vim.cmd("silent %!xmllint --format -")
end

function M.pretty_json()
  vim.cmd("silent %!jq .")
end

vim.api.nvim_create_user_command("PrettyXML", M.pretty_xml, {})
vim.api.nvim_create_user_command("PrettyJSON", M.pretty_json, {})

return M
