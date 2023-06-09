-- Parameters

local YLIMIT = 1 -- Set to world's water level
-- Particles are timed to disappear at this y
-- Particles do not spawn when player's head is below this y
local GSCYCLE = 0.4   -- Globalstep cycle (seconds)
local FLAKES = 24     -- Snowflakes per cycle
local DROPS = 48      -- Raindrops per cycle
local RAINGAIN = 0.15 -- Rain sound volume
local COLLIDE = true  -- Whether particles collide with nodes

precipitation = {}
precipitation.players = {}
precipitation.set_precipitation = function(player, precip)
    precipitation.players[player:get_player_name()] = precip
end
-- Globalstep function
local csound = {}
local handles = {}
local timer = 0

minetest.register_globalstep(function(dtime)
    timer = timer + dtime
    if timer < GSCYCLE then
        return
    end

    timer = 0

    for _, player in ipairs(minetest.get_connected_players()) do
        local player_name = player:get_player_name()
        local ppos = player:get_pos()
        local pposy = math.floor(ppos.y) + 2 -- Precipitation when swimming
        local cloud_height = player:get_clouds().height or 120
        if pposy < cloud_height and pposy > -75 then
            local pposx = math.floor(ppos.x)
            local pposz = math.floor(ppos.z)
            local precip = precipitation.players[player_name]
            if precip == "storm" then
                for _ = 1, DROPS * 2 do
                    local spawny = pposy + 10 + math.random(0, 40) / 10
                    local extime = math.min((spawny - YLIMIT) / 10, 1.8)
                    local dpos = {
                        x = pposx - 16 + math.random(0, 32),
                        y = spawny,
                        z = pposz - 16 + math.random(0, 32)
                    }
                    local tpos = {
                        x = dpos.x,
                        y = cloud_height - 1,
                        z = dpos.z
                    }
                    local los, _ = minetest.line_of_sight(dpos, tpos)
                    if los then
                        minetest.add_particle({
                            pos = dpos,
                            velocity = {
                                x = 0.0,
                                y = -12.0,
                                z = 0.0
                            },
                            acceleration = { x = 0, y = 0, z = 0 },
                            expirationtime = extime,
                            size = 2.8,
                            collisiondetection = COLLIDE,
                            collision_removal = true,
                            vertical = true,
                            texture = "precipitation_raindrop.png",
                            playername = player:get_player_name()
                        })
                    end
                end
                if handles[player_name] and csound[player_name] ~= "storm" then
                    minetest.sound_stop(handles[player_name])
                    handles[player_name] = nil
                    csound[player_name] = nil
                end
                if not handles[player_name] then
                    -- Start sound if not playing
                    local handle = minetest.sound_play(
                        "precipitation_rain",
                        {
                            to_player = player_name,
                            gain = RAINGAIN * 1.5,
                            loop = true,
                        }
                    )
                    if handle then
                        csound[player_name] = "storm"
                        handles[player_name] = handle
                    end
                end
            elseif precip == "rain" then
                for _ = 1, DROPS do
                    local spawny = pposy + 10 + math.random(0, 40) / 10
                    local extime = math.min((spawny - YLIMIT) / 10, 1.8)
                    local dpos = {
                        x = pposx - 16 + math.random(0, 32),
                        y = spawny,
                        z = pposz - 16 + math.random(0, 32)
                    }
                    local clouds = player:get_clouds()
                    local cloud_height = clouds and clouds.height or 120
                    local tpos = {
                        x = dpos.x,
                        y = cloud_height - 1,
                        z = dpos.z
                    }
                    local los, _ = minetest.line_of_sight(dpos, tpos)
                    if los then
                        minetest.add_particle({
                            pos = dpos,
                            velocity = {
                                x = 0.0,
                                y = -11.0,
                                z = 0.0
                            },
                            acceleration = { x = 0, y = 0, z = 0 },
                            expirationtime = extime,
                            size = 2.4,
                            collisiondetection = COLLIDE,
                            collision_removal = true,
                            vertical = true,
                            texture = "precipitation_raindrop.png",
                            playername = player:get_player_name()
                        })
                    end
                end
                if handles[player_name] and csound[player_name] ~= "rain" then
                    minetest.sound_stop(handles[player_name])
                    handles[player_name] = nil
                    csound[player_name] = nil
                end
                if not handles[player_name] then
                    -- Start sound if not playing
                    local handle = minetest.sound_play(
                        "precipitation_rain",
                        {
                            to_player = player_name,
                            gain = RAINGAIN,
                            loop = true,
                        }
                    )
                    if handle then
                        csound[player_name] = "rain"
                        handles[player_name] = handle
                    end
                end
            elseif precip == "sprinkle" then
                for _ = 1, DROPS / 4 do
                    local spawny = pposy + 10 + math.random(0, 40) / 10
                    local extime = math.min((spawny - YLIMIT) / 10, 1.8)
                    local dpos = {
                        x = pposx - 12 + math.random(0, 24),
                        y = spawny,
                        z = pposz - 12 + math.random(0, 24)
                    }
                    local tpos = {
                        x = dpos.x,
                        y = cloud_height - 1,
                        z = dpos.z
                    }
                    local los, _ = minetest.line_of_sight(dpos, tpos)
                    if los then
                        minetest.add_particle({
                            pos = dpos,
                            velocity = {
                                x = 0.0,
                                y = -10.0,
                                z = 0.0
                            },
                            acceleration = { x = 0, y = 0, z = 0 },
                            expirationtime = extime,
                            size = 2.0,
                            collisiondetection = COLLIDE,
                            collision_removal = true,
                            vertical = true,
                            texture = "precipitation_raindrop.png",
                            playername = player:get_player_name()
                        })
                    end
                end
                if handles[player_name] and csound[player_name] ~= "sprinkle" then
                    minetest.sound_stop(handles[player_name])
                    handles[player_name] = nil
                    csound[player_name] = nil
                end
                if not handles[player_name] then
                    -- Start sound if not playing
                    local handle = minetest.sound_play(
                        "precipitation_rain",
                        {
                            to_player = player_name,
                            gain = RAINGAIN * 0.5,
                            loop = true,
                        }
                    )
                    if handle then
                        csound[player_name] = "sprinkle"
                        handles[player_name] = handle
                    end
                end
            elseif precip == "snow_storm" then
                local spawny = pposy + 12
                local extime = math.min((pposy + 12 - YLIMIT) / 2, 9)
                for _ = 1, FLAKES * 2 do
                    local dpos = {
                        x = pposx - 24 + math.random(0, 48),
                        y = spawny,
                        z = pposz - 24 + math.random(0, 48)
                    }

                    local tpos = {
                        x = dpos.x,
                        y = cloud_height - 1,
                        z = dpos.z
                    }
                    local los, _ = minetest.line_of_sight(dpos, tpos)
                    if los then
                        minetest.add_particle({
                            pos = {
                                x = pposx - 24 + math.random(0, 48),
                                y = spawny,
                                z = pposz - 24 + math.random(0, 48)
                            },
                            velocity = {
                                x = (-20 + math.random(0, 40)) / 100,
                                y = -2.0,
                                z = (-20 + math.random(0, 40)) / 100
                            },
                            acceleration = { x = 0, y = 0, z = 0 },
                            expirationtime = extime,
                            size = 2.8,
                            collisiondetection = COLLIDE,
                            collision_removal = true,
                            vertical = false,
                            texture = "precipitation_snowflake" ..
                                math.random(1, 12) .. ".png",
                            playername = player:get_player_name()
                        })
                    end
                end
                if handles[player_name] and csound[player_name] ~= nil then
                    minetest.sound_stop(handles[player_name])
                    handles[player_name] = nil
                    csound[player_name] = nil
                end
            elseif precip == "snow" then
                local spawny = pposy + 12
                local extime = math.min((pposy + 12 - YLIMIT) / 2, 9)
                for _ = 1, FLAKES do
                    local dpos = {
                        x = pposx - 24 + math.random(0, 48),
                        y = spawny,
                        z = pposz - 24 + math.random(0, 48)
                    }

                    local tpos = {
                        x = dpos.x,
                        y = cloud_height - 1,
                        z = dpos.z
                    }
                    local los, _ = minetest.line_of_sight(dpos, tpos)
                    if los then
                        minetest.add_particle({
                            pos = dpos,
                            velocity = {
                                x = (-20 + math.random(0, 40)) / 100,
                                y = -2.0,
                                z = (-20 + math.random(0, 40)) / 100
                            },
                            acceleration = { x = 0, y = 0, z = 0 },
                            expirationtime = extime,
                            size = 2.8,
                            collisiondetection = COLLIDE,
                            collision_removal = true,
                            vertical = false,
                            texture = "precipitation_snowflake" ..
                                math.random(1, 12) .. ".png",
                            playername = player:get_player_name()
                        })
                    end
                end
                if handles[player_name] and csound[player_name] ~= nil then
                    minetest.sound_stop(handles[player_name])
                    handles[player_name] = nil
                    csound[player_name] = nil
                end
            elseif precip == "flurry" then
                local spawny = pposy + 12
                local extime = math.min((pposy + 12 - YLIMIT) / 2, 9)
                for _ = 1, FLAKES / 2 do
                    local dpos = {
                        x = pposx - 24 + math.random(0, 48),
                        y = spawny,
                        z = pposz - 24 + math.random(0, 48)
                    }
                    local tpos = {
                        x = dpos.x,
                        y = cloud_height - 1,
                        z = dpos.z
                    }
                    local los, _ = minetest.line_of_sight(dpos, tpos)
                    if los then
                        minetest.add_particle({
                            pos = {
                                x = pposx - 24 + math.random(0, 48),
                                y = pposy + 12,
                                z = pposz - 24 + math.random(0, 48)
                            },
                            velocity = {
                                x = (-20 + math.random(0, 40)) / 100,
                                y = -2.0,
                                z = (-20 + math.random(0, 40)) / 100
                            },
                            acceleration = { x = 0, y = 0, z = 0 },
                            expirationtime = extime,
                            size = 2.8,
                            collisiondetection = COLLIDE,
                            collision_removal = true,
                            vertical = false,
                            texture = "precipitation_snowflake" ..
                                math.random(1, 12) .. ".png",
                            playername = player:get_player_name()
                        })
                    end
                end
                if handles[player_name] and csound[player_name] ~= nil then
                    minetest.sound_stop(handles[player_name])
                    handles[player_name] = nil
                    csound[player_name] = nil
                end
            elseif precip == "none" then
                if handles[player_name] then
                    minetest.sound_stop(handles[player_name])
                    handles[player_name] = nil
                    csound[player_name] = nil
                end
                return
            end
        else
            if handles[player_name] then
                minetest.sound_stop(handles[player_name])
                handles[player_name] = nil
                csound[player_name] = nil
            end
            return
        end
    end
end)


-- Stop sound and remove player handle on leaveplayer

minetest.register_on_leaveplayer(function(player)
    local player_name = player:get_player_name()
    if handles[player_name] then
        minetest.sound_stop(handles[player_name])
        handles[player_name] = nil
    end
end)
