local mysql = require "resty.mysql"

local config = {
	-- host = "23.105.193.189",
	host = "127.0.0.1",
	-- host = "192.168.130.191",
	port = 3306,
	database = "moguhu_blog",
	user = "root",
	password = "123456",
	max_package_size = 1024,
	charset = "utf-8"
}

local _M = {}

function _M.new( self )
	local db, err = mysql:new()
	if not db then
		return nil
	end
	db:set_timeout(1000)

	local ok, err, errno, sqlstate = db:connect(config)

	if not ok then
		return nil
	end
	db.close = close
	return db
end


function close( self )
	local sock = self.sock
	if not sock then
		return nil, "not initialized"
	end
	if self.subscribed then
		return nil, "subscribed state"
	end
	return sock:setkeepalive(10000, 50)
end

return _M
