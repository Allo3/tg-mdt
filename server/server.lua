TGDBM.Test()

local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback("tg-mdt:server:searchProfiles", function(source, cb, query)
  query = tostring(query or ""):gsub("^%s+", ""):gsub("%s+$", "")
  if query == "" then return cb({}) end

  local qLower = query:lower()
  local starts = qLower .. "%"
  local contains = "%" .. qLower .. "%"

  -- On cherche d'abord ceux qui commencent par (prénom/nom),
  -- puis on complète avec contains si besoin (limite 30)
  local sql = [[
        SELECT citizenid, charinfo, job
        FROM players
        WHERE LOWER(charinfo) LIKE ?
        ORDER BY
          CASE
            WHEN LOWER(charinfo) LIKE ? THEN 0
            ELSE 1
          END
        LIMIT 30
    ]]

  -- le ORDER BY "starts" (0) avant le reste (1)
  local rows = MySQL.query.await(sql, { contains, starts }) or {}

  local out = {}
  for _, r in ipairs(rows) do
    local charinfo = json.decode(r.charinfo or "{}") or {}
    local job = json.decode(r.job or "{}") or {}

    out[#out+1] = {
      citizenid = r.citizenid,
      firstname = charinfo.firstname or "",
      lastname  = charinfo.lastname or "",
      dob       = charinfo.birthdate,
      phone     = charinfo.phone,
      job       = (job.label or job.name),
    }
  end

  cb(out)
end)

QBCore.Functions.CreateCallback("tg-mdt:server:searchVehicles", function(source, cb, query)
  query = tostring(query or ""):gsub("^%s+", ""):gsub("%s+$", "")
  local like = "%" .. query .. "%"

  local rows = MySQL.query.await([[
        SELECT plate, vehicle, citizenid, state
        FROM player_vehicles
        WHERE plate LIKE ?
           OR citizenid LIKE ?
        LIMIT 30
    ]], { like, like }) or {}

  local out = {}

  for _, r in ipairs(rows) do
    local vehData = QBCore.Shared.Vehicles[r.vehicle]

    out[#out+1] = {
      plate = r.plate,
      model = vehData and vehData.name or r.vehicle,
      owner = r.citizenid,
      state = r.state
    }
  end

  cb(out)
end)