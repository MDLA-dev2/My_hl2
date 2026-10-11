OasisRP = OasisRP or {}
OasisRP.Database = OasisRP.Database or {}

function OasisRP.Database:Initialize()
	-- Ensure basic tables exist
	self:Query([[
		CREATE TABLE IF NOT EXISTS oasis_players (
			steamid VARCHAR(32) PRIMARY KEY,
			name TEXT,
			job VARCHAR(64) DEFAULT 'citizen',
			money INTEGER DEFAULT 100,
			thirst REAL DEFAULT 100.0,
			inventory TEXT DEFAULT '[]',
			first_joined INTEGER DEFAULT 0,
			last_seen INTEGER DEFAULT 0
		);
	]])
end

function OasisRP.Database:Escape(str)
	return sql.SQLStr(str, false)
end

function OasisRP.Database:Query(queryStr, callback)
	local result = sql.Query(queryStr)

	if result == false then
		local err = sql.LastError()
		ErrorNoHalt("[OasisRP DB Error] " .. tostring(err) .. "\nQuery: " .. tostring(queryStr) .. "\n")
		if callback then
			callback(nil, err)
		end
		return nil
	end

	if callback then
		callback(result, nil)
	end

	return result
end

function OasisRP.Database:QueryRow(queryStr, callback)
	local result = sql.QueryRow(queryStr)

	if result == false then
		local err = sql.LastError()
		ErrorNoHalt("[OasisRP DB Error] " .. tostring(err) .. "\nQuery: " .. tostring(queryStr) .. "\n")
		if callback then
			callback(nil, err)
		end
		return nil
	end

	if callback then
		callback(result, nil)
	end

	return result
end
