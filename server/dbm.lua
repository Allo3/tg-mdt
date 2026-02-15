local QBCore = exports['qb-core']:GetCoreObject()

TGDBM = {}

function TGDBM.Test()
    print("DBM loaded")
end

local function ToProfileFromPlayer(Player)
    local pd = Player.PlayerData
    return {
        citizenid = pd.citizenid,
        firstname = pd.charinfo.firstname or "",
        lastname  = pd.charinfo.lastname or "",
        dob       = pd.charinfo.birthdate,
        phone     = pd.charinfo.phone,
        job       = (pd.job and (pd.job.label or pd.job.name)) or nil,
    }
end

local function ToProfileFromRow(r)
    local charinfo = json.decode(r.charinfo or "{}") or {}
    local job = json.decode(r.job or "{}") or {}
    return {
        citizenid = r.citizenid,
        firstname = charinfo.firstname or "",
        lastname  = charinfo.lastname or "",
        dob       = charinfo.birthdate,
        phone     = charinfo.phone,
        job       = (job.label or job.name),
    }
end

-- Recherche DB simple et robuste (citizenid / firstname / lastname / fullname)
local function SearchProfilesDB(q)
    q = tostring(q or ""):gsub("^%s+", ""):gsub("%s+$", "")
    local like = "%" .. q .. "%"
    local likeLower = "%" .. q:lower() .. "%"

    local sql = [[
    SELECT citizenid, charinfo, job
    FROM players
    WHERE citizenid LIKE ?
       OR LOWER(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname'))) LIKE ?
       OR LOWER(JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname'))) LIKE ?
       OR LOWER(CONCAT(
            JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.firstname')),
            ' ',
            JSON_UNQUOTE(JSON_EXTRACT(charinfo, '$.lastname'))
          )) LIKE ?
    LIMIT 30
  ]]

    local rows = MySQL.query.await(sql, { like, likeLower, likeLower, likeLower }) or {}
    local out = {}
    for _, r in ipairs(rows) do out[#out+1] = ToProfileFromRow(r) end
    return out
end

-- Online-first: si q ressemble à un citizenid exact -> check live puis DB
local function GetProfileByCitizenId(cid)
    local Player = QBCore.Functions.GetPlayerByCitizenId(cid)
    if Player then return ToProfileFromPlayer(Player) end
    local row = MySQL.single.await("SELECT citizenid, charinfo, job FROM players WHERE citizenid = ? LIMIT 1", { cid })
    if row then return ToProfileFromRow(row) end
    return nil
end

return {
    SearchProfilesDB = SearchProfilesDB,
    GetProfileByCitizenId = GetProfileByCitizenId,
}