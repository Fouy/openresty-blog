local cjson = require "cjson"
local mysql = require("libs.mysql")

local args = ngx.req.get_uri_args()
local name = args["userName"]

if name == nil or name == "" then
	name = "root"
end

name = ngx.quote_sql_str(name)

local db = mysql:new()

local sql = "select * from blog_user where user_name = " .. name

ngx.say(sql)
ngx.say("<br/>")

db:query("SET NAMES utf8")
local res, err, errno, sqlstate = db:query(sql)
db:close()
if not res then
	ngx.say(err)
	return {}
end

ngx.say(cjson.encode(res))
