-- Lua Obfuscation Decoder
-- Decodes wearedevs obfuscated Lua strings

local function decodeOctal(str)
    return (str:gsub("\\(%d%d?%d?)", function(oct)
        return string.char(tonumber(oct, 8))
    end))
end

local function decodeHex(str)
    return (str:gsub("\\x(%x%x)", function(hex)
        return string.char(tonumber(hex, 16))
    end))
end

-- Read the obfuscated file
local file = io.open("download.txt", "r")
local obfuscated = file:read("*a")
file:close()

-- Decode strings
local decoded = decodeOctal(obfuscated)
decoded = decodeHex(decoded)

-- Write decoded output
local outfile = io.open("download_decoded.txt", "w")
outfile:write(decoded)
outfile:close()

print("Decoding complete! Output: download_decoded.txt")
