function love.load()
	love.filesystem.setIdentity("Awake")
	-- system variables
	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()
	--love.filesystem.setIdentity("data")

	-- terrain variables
	ter = love.graphics.newImage("terrain.PNG")
	ter:setFilter("nearest", "linear")
	tile_size = 16
	tile1 = love.graphics.newQuad(52, 209, 16, 16, ter:getWidth(), ter:getHeight())
	tile2 = love.graphics.newQuad(52, 193, 16, 16, ter:getWidth(), ter:getHeight())
	tile3 = love.graphics.newQuad(52, 177, 16, 16, ter:getWidth(), ter:getHeight())
		load_map = {}--{{0,0,0,"0,0,0"}}
		map = {}
	contents = love.filesystem.read("map.txt")
	contents = split(contents, ";")
	load_process = 1
	while contents[load_process] ~= nil do
		contents[load_process] = split(contents[load_process], ",")
		if contents[load_process][4] == "tile1" then
			contents[load_process][4] = tile1
		end
		if contents[load_process][4] == "tile2" then
			contents[load_process][4] = tile2
		end
		if contents[load_process][4] == "tile3" then
			contents[load_process][4] = tile3
		end
		load_process = load_process + 1
	end
	loadxyz = 1
	-------- Create load_map and map for drawing all tiles in draw function --------
	---- load_map[num][x,y,tile,z,"x,y,z",obj]
	---- map[x,y,z,tile,load_map index,obj]
	while contents[loadxyz] ~= nil do
		table.insert(load_map,{tonumber(contents[loadxyz][1]),tonumber(contents[loadxyz][2]),tonumber(contents[loadxyz][3]),contents[loadxyz][4],contents[loadxyz][1] .. ',' .. contents[loadxyz][2] .. ',' .. contents[loadxyz][3]})
		map[contents[loadxyz][1] .. ',' .. contents[loadxyz][2] .. ',' .. contents[loadxyz][3]] = {contents[loadxyz][1], contents[loadxyz][2], contents[loadxyz][3], contents[loadxyz][4], loadxyz, nil} -- The last position is supposed to be for loading objects.
		loadxyz = loadxyz + 1
	end
	
	-- sprite variables
	img = love.graphics.newImage("soldierbrown.PNG")
	img:setFilter("nearest", "linear")
	brown_guard = {['n'] = love.graphics.newQuad(28, 6, 16, 26, img:getWidth(), img:getHeight()),['nw1'] = love.graphics.newQuad(4, 6, 16, 26, img:getWidth(), img:getHeight()), ['nw2'] = love.graphics.newQuad(28, 6, 16, 26, img:getWidth(), img:getHeight()), ['nw3'] = love.graphics.newQuad(52, 6, 16, 26, img:getWidth(), img:getHeight()), ['nw4'] = love.graphics.newQuad(28, 6, 16, 26, img:getWidth(), img:getHeight()), ['s'] = love.graphics.newQuad(28, 70, 16, 26, img:getWidth(), img:getHeight()), ['sw1'] = love.graphics.newQuad(4, 70, 16, 26, img:getWidth(), img:getHeight()), ['sw2'] = love.graphics.newQuad(28, 70, 16, 26, img:getWidth(), img:getHeight()), ['sw3'] = love.graphics.newQuad(52, 70, 16, 26, img:getWidth(), img:getHeight()), ['sw4'] = love.graphics.newQuad(28, 70, 16, 26, img:getWidth(), img:getHeight()), ['w'] = love.graphics.newQuad(28, 102, 16, 26, img:getWidth(), img:getHeight()), ['ww1'] = love.graphics.newQuad(4, 102, 16, 26, img:getWidth(), img:getHeight()), ['ww2'] = love.graphics.newQuad(28, 102, 16, 26, img:getWidth(), img:getHeight()), ['ww3'] = love.graphics.newQuad(52, 102, 16, 26, img:getWidth(), img:getHeight()), ['ww4'] = love.graphics.newQuad(28, 102, 16, 26, img:getWidth(), img:getHeight()), ['e'] = love.graphics.newQuad(28, 38, 16, 26, img:getWidth(), img:getHeight()), ['ew1'] = love.graphics.newQuad(4, 38, 16, 26, img:getWidth(), img:getHeight()), ['ew2'] = love.graphics.newQuad(28, 38, 16, 26, img:getWidth(), img:getHeight()), ['ew3'] = love.graphics.newQuad(52, 38, 16, 26, img:getWidth(), img:getHeight()), ['ew4'] = love.graphics.newQuad(28, 38, 16, 26, img:getWidth(), img:getHeight())}
	chars = {} -- This might replace mchar and npc
	
	-- main character variables
	n_link = love.graphics.newQuad(28, 6, 16, 26, img:getWidth(), img:getHeight())
	s_link = love.graphics.newQuad(28, 70, 16, 26, img:getWidth(), img:getHeight())
	w_link = love.graphics.newQuad(28, 102, 16, 26, img:getWidth(), img:getHeight())
	e_link = love.graphics.newQuad(28, 38, 16, 26, img:getWidth(), img:getHeight())
	link = s_link
	mchar = {['x']=384,['y']=240,['z']=4,['xtile']=24,['ytile']=16,['ztile']=1,['xdest']=384,['ydest']=240,['zdest']=4,['facing']="s",['moving']=false,['speed']=35,['image']=brown_guard['s'],['anim']=0,['animclock']=0.29}
	--speed = 25 -- not needed?
	--destination_x = mchar['x'] -- not needed?
	--destination_y = mchar['y'] -- not needed?
	--destination_z = mchar['z'] -- not needed?
	
	-- npc variables
	local npc_load = 1
	local load_npc = "" -- replace this with something else in the future.
	npc = {}
	table.insert(npc,{['x']=80,['y']=96,['z']=4,['xtile']=5,['ytile']=7,['ztile']=1,['xdest']=80,['ydest']=96,['zdest']=4,['facing']="s",['moving']=false,['speed']=35,['image']=s_link,['anim']=0,['animclock']=0.29})
	while npc[npc_load] ~= nil do
		npc[npc_load]['x'] = npc[npc_load]['xtile']*tile_size
		npc[npc_load]['y'] = (npc[npc_load]['ytile']-1)*tile_size
		npc[npc_load]['z'] = npc[npc_load]['ztile']*tile_size/4
		load_npc = npc[npc_load]['xtile'] .. ',' .. npc[npc_load]['ytile'] .. ',' .. npc[npc_load]['ztile']
		map[load_npc][6] = npc_load
		npc_load = npc_load + 1
	end
	load_npc = mchar['xtile'] .. ',' .. mchar['ytile'] .. ',' .. mchar['ztile']
	map[load_npc][6] = 2718
	
	-- test variables
	test_function = 1
	menu_color = {0,255,255,255}
	menu_set = 1
	full_screen = "Fullscreen on/off"
	full_toggle = 0
	xoffset = 0
	yoffset = 0
	zoffset = 0
	passnext = 2718
end

function split(s,re) -- code from http://snippets.luacode.org/?p=snippets/Split_a_string_into_a_list_5
	local i1 = 1
	local ls = {}
	local append = table.insert
	if not re then re = '%s+' end
	if re == '' then return {s} end
	while true do
		local i2,i3 = s:find(re,i1)
		if not i2 then
			local last = s:sub(i1)
			if last ~= '' then append(ls,last) end
			if #ls == 1 and ls[1] == '' then
				return {}
				else
				return ls
			end
		end
	append(ls,s:sub(i1,i2-1))
	i1 = i3+1
	end
end

--Standard 0.80 love.run function--
function love.run()

    math.randomseed(os.time())
    math.random() math.random()

    if love.load then love.load(arg) end

    local dt = 0

    -- Main loop time.
    while true do
        -- Process events.
        if love.event then
            love.event.pump()
            for e,a,b,c,d in love.event.poll() do
                if e == "quit" then
                    if not love.quit or not love.quit() then
                        if love.audio then
                            love.audio.stop()
                        end
                        return
                    end
                end
                love.handlers[e](a,b,c,d)
            end
        end

        -- Update dt, as we'll be passing it to update
        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta()
        end

        -- Call update and draw
        if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
        if love.graphics then
            love.graphics.clear()
            if love.draw then love.draw() end
        end

        if love.timer then love.timer.sleep(0.001) end
        if love.graphics then love.graphics.present() end

    end

end
---------------------------------------------------------------------------------

function love.draw()
	--love.graphics.drawq(ter, tile1, 160, 160, 0, 1, 1, 0) -- This draws a background tile.
	--local tile_num = 1
	local ytile_num = 0
	-- The following is testing drawing only a section around the character. --
	local xdraw = mchar['xtile'] - 10
	local ydraw = mchar['ytile'] - 10
	local zdraw = 0
	local xdrawend = mchar['xtile'] + 10
	local ydrawend = mchar['ytile'] + 10
	local zdrawend = 4
	local xyz = "0,0,1" -- This variable is used to concotinate the numbers for lua to understand the draw variables run together. This value is overwritten.
	while ydraw <= ydrawend do
		while xdraw <= xdrawend do
			while zdraw <= zdrawend do
				xyz = xdraw .. ',' .. ydraw .. ',' .. zdraw
				if map[xyz] ~= nil then
					love.graphics.drawq(ter,tile1,map[xyz][1]*16-xoffset,map[xyz][2]*16-map[xyz][3]*4-yoffset+zoffset,0,1,1,0)
					if map[xyz][6] ~= nil and map[xyz][6] ~= 2718 then
						love.graphics.drawq(img, npc[map[xyz][6]]['image'], npc[map[xyz][6]]['x']-xoffset, npc[map[xyz][6]]['y']-npc[map[xyz][6]]['z']-yoffset, 0, 1, 1, 0) -- This draws an npc.
					end
					if map[xyz][6] == 2718 then
						love.graphics.drawq(img, mchar['image'], mchar['x'], mchar['y']-mchar['z'], 0, 1, 1, 0)
					end
				end
				zdraw = zdraw + 1
			end
			zdraw = 0
			xdraw = xdraw + 1
		end
		xdraw = mchar['xtile'] - 10
		ydraw = ydraw + 1
	end
	
	-- The following is the original drawing section --
	-- while load_map[tile_num] ~= nil do -- original draw for the map
	--	while load_map[tile_num] ~= nil and load_map[tile_num][2] == ytile_num do
	--		love.graphics.drawq(ter,load_map[tile_num][4],load_map[tile_num][1]*16-xoffset,load_map[tile_num][2]*16-load_map[tile_num][3]*4-yoffset,0,1,1,0)
	--		tile_num = tile_num + 1
	--	end
	--	if npc[1]['ytile'] == ytile_num then
	--		love.graphics.drawq(img, npc[1]['image'], npc[1]['x']-xoffset, npc[1]['y']-npc[1]['z']-yoffset, 0, 1, 1, 0) -- This draws an npc.
	--	end
	--	if mchar['ytile'] == ytile_num then
	--		love.graphics.drawq(img, mchar['image'], mchar['x'], mchar['y']-mchar['z'], 0, 1, 1, 0) -- This draws the character right after the row is drawn.
	--	end
	--	if mchar['ytile'] + 1 == ytile_num and mchar['facing'] == 's' and mchar['moving'] then
	--		love.graphics.drawq(img, mchar['image'], mchar['x'], mchar['y']-mchar['z'], 0, 1, 1, 0)  -- This draws the character right after the row the character is moving into is drawn.
	--	end
	--	ytile_num = ytile_num + 1
	--end
	
	--while full_toggle == 1 do -- This will make it fullscreen.
	--	love.graphics.toggleFullscreen()
	--	full_toggle = 0
	--end
	love.graphics.setColor(50,50,50)
	love.graphics.rectangle("fill",580,30,140,100)
	love.graphics.setColor(menu_color[1],255,255)
	love.graphics.print(full_screen,600,50)
	love.graphics.setColor(menu_color[2],255,255)
	love.graphics.print("New Map",600,65)
	love.graphics.setColor(menu_color[3],255,255)
	love.graphics.print("Save Map",600,80)
	love.graphics.setColor(menu_color[4],255,255)
	love.graphics.print("Exit",600,95)
	love.graphics.setColor(50,50,50)
	love.graphics.rectangle("fill",580,210,140,160)
	love.graphics.setColor(200,200,200)
	love.graphics.print("X Tile:",600,230)
	love.graphics.print(mchar['xtile'],650,230)
	love.graphics.print("Dest:",600,240)
	love.graphics.print(map[nexttile()][1]*tile_size,650,240)
	love.graphics.print("Y Tile:",600,250)
	love.graphics.print(mchar['ytile'],650,250)
	love.graphics.print("Dest:",600,260)
	love.graphics.print(map[nexttile()][2]*tile_size,650,260)
	love.graphics.print("Z Tile:",600,270)
	love.graphics.print(mchar['ztile'],650,270)
	love.graphics.print("Dest:",600,280)
	love.graphics.print(map[nexttile()][3],650,280)
	love.graphics.print("Moving:",600,320)
	if mchar['moving'] == true then
		love.graphics.print("True",650,320)
	end
	if mchar['moving'] == false then
		love.graphics.print("False",650,320)
	end
	love.graphics.print("Facing:",600,330)
	love.graphics.print(mchar['facing'],650,330)
	love.graphics.print("Next:",600,340)
	checknext()
	love.graphics.print(map[nexttile()][1],650,340)
	love.graphics.print(',',665,340)
	love.graphics.print(map[nexttile()][2],675,340)
	
	-- start test area
	love.graphics.print(xoffset .. ',' .. yoffset,625,355)
	-- end test area
	love.graphics.setColor(255,255,255)
	love.graphics.draw(img, 200,400)
end

dtotal = 0   -- this keeps track of how much time has passed
function love.update(dt)
	--dt = math.min(dt, 1/60) -- this limits the frame rate if needed
	local movecheck_x = xoffset
	local movecheck_y = yoffset
	local npccheck_x = 0 -- this is a place holder
	local npccheck_y = 0 -- this is a place holder
	local tilecheck_x = mchar['xtile']
	local tilecheck_y = mchar['ytile']
	local xyz = nil
	-- movement of character --
	if love.keyboard.isDown('i') and (mchar['facing'] == "n" or not mchar['moving']) then
		mchar['facing'] = "n"
		if checknext() then
			mchar['ydest'] = (map[nexttile()][2]-1)*tile_size
			mchar['zdest'] = map[nexttile()][3]*4
			mchar['moving'] = true
		end
	end
	if love.keyboard.isDown('k') and (mchar['facing'] == "s" or not mchar['moving']) then
		mchar['facing'] = "s"
		if checknext() then
			mchar['ydest'] = (map[nexttile()][2]-1)*tile_size
			mchar['zdest'] = map[nexttile()][3]*4
			mchar['moving'] = true
		end
	end
	-- keyboard movement --
	if love.keyboard.isDown('w') and (mchar['facing'] == "n" or not mchar['moving']) then
		mchar['facing'] = "n"
		if checknext() then
			mchar['ydest'] = (map[nexttile()][2]-1)*tile_size
			mchar['zdest'] = map[nexttile()][3]*4
			mchar['moving'] = true
		end
	end
	if love.keyboard.isDown('s') and (mchar['facing'] == "s" or not mchar['moving']) then
		mchar['facing'] = "s"
		if checknext() then
			xyz = mchar['xtile'] .. ',' .. mchar['ytile'] .. ',' .. mchar['ztile'] -- This finds the current tile and removes the marker for the character.
			map[xyz][6] = nil
			mchar['ydest'] = (map[nexttile()][2]-1)*tile_size
			mchar['zdest'] = map[nexttile()][3]*4
			mchar['moving'] = true
			map[nexttile()][6] = 2718
		end
	end
	if love.keyboard.isDown('a') and (mchar['facing'] == "w" or not mchar['moving']) then
		mchar['facing'] = "w"
		if checknext() then
			mchar['xdest'] = map[nexttile()][1]*tile_size
			mchar['zdest'] = map[nexttile()][3]*4
			mchar['moving'] = true
		end
	end
	if love.keyboard.isDown('d') and (mchar['facing'] == "e" or not mchar['moving']) then
		mchar['facing'] = "e"
		if checknext() then
			xyz = mchar['xtile'] .. ',' .. mchar['ytile'] .. ',' .. mchar['ztile'] -- This finds the current tile and removes the marker for the character.
			map[xyz][6] = nil
			mchar['xdest'] = map[nexttile()][1]*tile_size
			mchar['zdest'] = map[nexttile()][3]*4
			mchar['moving'] = true
			map[nexttile()][6] = 2718
		end
	end
	if love.keyboard.isDown('lshift') then
		mchar['speed'] = 70 -- 70 appears to be too fast, though I do not know why. The character occasionally gets stuck moving right or down.
	end
	
	-- npc movement --
	-- auto movement --
	if love.keyboard.isDown('y') and (npc[1]['facing'] == "n" or not npc[1]['moving']) then
		npc[1]['facing'] = "n"
		if checknext() then
			npc[1]['ydest'] = (map[nexttile()][2]-1)*tile_size
			npc[1]['zdest'] = map[nexttile()][3]*4
			npc[1]['moving'] = true
		end
	end
	if love.keyboard.isDown('h') and (npc[1]['facing'] == "s" or not npc[1]['moving']) then
		npc[1]['facing'] = "s"
		if checknext() then
			xyz = npc[1]['xtile'] .. ',' .. npc[1]['ytile'] .. ',' .. npc[1]['ztile'] -- This finds the current tile and removes the marker for the character.
			map[xyz][6] = nil
			npc[1]['ydest'] = (map[nexttile()][2]-1)*tile_size
			npc[1]['zdest'] = map[nexttile()][3]*4
			npc[1]['moving'] = true
			map[nexttile()][6] = 2718
		end
	end
	if love.keyboard.isDown('g') and (npc[1]['facing'] == "w" or not npc[1]['moving']) then
		npc[1]['facing'] = "w"
		if checknext() then
			npc[1]['xdest'] = map[nexttile()][1]*tile_size
			npc[1]['zdest'] = map[nexttile()][3]*4
			npc[1]['moving'] = true
		end
	end
	if love.keyboard.isDown('j') and (npc[1]['facing'] == "e" or not npc[1]['moving']) then
		npc[1]['facing'] = "e"
		if checknext() then
			xyz = npc[1]['xtile'] .. ',' .. npc[1]['ytile'] .. ',' .. npc[1]['ztile'] -- This finds the current tile and removes the marker for the character.
			map[xyz][6] = nil
			npc[1]['xdest'] = map[nexttile()][1]*tile_size
			npc[1]['zdest'] = map[nexttile()][3]*4
			npc[1]['moving'] = true
			map[nexttile()][6] = 2718
		end
	end
	-- npc running --
	if love.keyboard.isDown('lshift') then
		npc[1]['speed'] = 70 -- 70 appears to be too fast, though I do not know why. The character occasionally gets stuck moving right or down.
	end
	
	if npc[1]['x'] < npc[1]['xdest'] then
		npc[1]['x'] = npc[1]['x'] + npc[1]['speed']*dt
	end
	if npc[1]['x'] > npc[1]['xdest'] then
		npc[1]['x'] = npc[1]['x'] - npc[1]['speed']*dt
	end
	if npc[1]['y'] < npc[1]['ydest'] then
		npc[1]['y'] = npc[1]['y'] + npc[1]['speed']*dt
	end
	if npc[1]['y'] > npc[1]['ydest'] then
		npc[1]['y'] = npc[1]['y'] - npc[1]['speed']*dt
	end
	if npc[1]['z'] < npc[1]['zdest'] then
		npc[1]['z'] = npc[1]['z'] + npc[1]['speed']/4*dt
	end
	if npc[1]['z'] > npc[1]['zdest'] then
		npc[1]['z'] = npc[1]['z'] - npc[1]['speed']/4*dt
	end
	if npc[1]['moving'] then
		npc[1]['animclock'] = npc[1]['animclock'] + dt
	end
	if npc[1]['animclock'] >= 0.3 then
		npc[1]['animclock'] = npc[1]['animclock'] - 0.3
		local anim_num = "nw"
		if npc[1]['anim'] >= 4 then
			npc[1]['anim'] = 0
		end
		npc[1]['anim'] = npc[1]['anim'] + 1
		anim_num = npc[1]['facing'] .. 'w' .. npc[1]['anim']
		npc[1]['image'] = brown_guard[anim_num]
	end
	if math.floor(npc[1]['x']+0.9+xoffset) == map[nexttile()][1]*tile_size and math.floor(npc[1]['y']+0.9+yoffset) == (map[nexttile()][2]-1)*tile_size then -- The +0.9 is too make the character not get stuck when moving quickly (speed > 40).
		xyz = npc[1]['xtile'] .. ',' .. npc[1]['ytile'] .. ',' .. npc[1]['ztile'] -- This finds the current tile and removes the marker for the character.
		map[xyz][6] = nil
		map[nexttile()][6] = 2718
		npc[1]['ztile'] = map[nexttile()][3]
		npc[1]['xtile'] = get_next_x
		npc[1]['ytile'] = get_next_y
	end
	
	-- main character movement --
	if mchar['x'] < mchar['xdest'] - xoffset then
		xoffset = xoffset + mchar['speed']*dt
		--mchar['x'] = mchar['x'] + mchar['speed']*dt -- original movement/npc movement
	end
	if mchar['x'] > mchar['xdest'] - xoffset then
		xoffset = xoffset - mchar['speed']*dt
		--mchar['x'] = mchar['x'] - mchar['speed']*dt -- original movement/npc movement
	end
	if mchar['y'] < mchar['ydest'] - yoffset then
		yoffset = yoffset + mchar['speed']*dt
		--mchar['y'] = mchar['y'] + mchar['speed']*dt -- original movement/npc movement
	end
	if mchar['y'] > mchar['ydest'] - yoffset then
		yoffset = yoffset - mchar['speed']*dt
		--mchar['y'] = mchar['y'] - mchar['speed']*dt -- original movement/npc movement
	end
	if mchar['z'] < mchar['zdest'] - zoffset then
		zoffset = zoffset + mchar['speed']/4*dt
		--mchar['z'] = mchar['z'] + mchar['speed']/4*dt -- original movement/npc movement
	end
	if mchar['z'] > mchar['zdest'] - zoffset then
		zoffset = zoffset - mchar['speed']/4*dt
		--mchar['z'] = mchar['z'] - mchar['speed']/4*dt -- original movement/npc movement
	end
	if mchar['moving'] then
		mchar['animclock'] = mchar['animclock'] + dt
	end
	if mchar['animclock'] >= 0.3 then
		mchar['animclock'] = mchar['animclock'] - 0.3
		local anim_num = "nw"
		if mchar['anim'] >= 4 then
			mchar['anim'] = 0
		end
		mchar['anim'] = mchar['anim'] + 1
		anim_num = mchar['facing'] .. 'w' .. mchar['anim']
		mchar['image'] = brown_guard[anim_num]
	end
	if math.floor(mchar['x']+0.9+xoffset) == map[nexttile()][1]*tile_size and math.floor(mchar['y']+0.9+yoffset) == (map[nexttile()][2]-1)*tile_size then -- The +0.9 is too make the character not get stuck when moving quickly (speed > 40).
		xyz = mchar['xtile'] .. ',' .. mchar['ytile'] .. ',' .. mchar['ztile'] -- This finds the current tile and removes the marker for the character.
		map[xyz][6] = nil
		map[nexttile()][6] = 2718
		mchar['ztile'] = map[nexttile()][3]
		mchar['xtile'] = get_next_x
		mchar['ytile'] = get_next_y
	end
	dtotal = dtotal + dt   -- we add the time passed since the last update, probably a very small number like 0.01
	--if movecheck_x == mchar['x'] and movecheck_y == mchar['y'] then
	if movecheck_x == xoffset and movecheck_y == yoffset then
		mchar['moving'] = false
		mchar['anim'] = 0
		mchar['animclock'] = 0.29
		mchar['image'] = brown_guard[mchar['facing']] -- sets the character to the stationary image for its facing
		mchar['speed'] = 30
	end
	-- testing running toggle
	mchar['speed'] = 30 -- This makes it so running is only active when the key is down.
end


function love.keypressed(key, unicode)
	if key == 'escape' then
	   os.exit() -- This is not the way it is supposed to be done. The line below if part of the correct way.
	   -- love.event.push("q")
	end
	if key == 'up' then
		menu(key)
	end
	if key == 'down' then
		menu(key)
	end
	if key == 'return' then
		menu(key)
	end
	if key == 'f' then -- This is to modify the terrain.
		load_map[map[nexttile()][5]][3] = load_map[map[nexttile()][5]][3] + 1 -- increase z in load_map
		map[load_map[map[nexttile()][5]][1] .. ',' .. load_map[map[nexttile()][5]][2] .. ',' .. load_map[map[nexttile()][5]][3]] = {load_map[map[nexttile()][5]][1], load_map[map[nexttile()][5]][2], load_map[map[nexttile()][5]][3], load_map[map[nexttile()][5]][4], map[nexttile()][5]} -- create the new map
		map[nexttile()] = nil -- erase the old map
	end
end

function menu(action)
	if action == 'up' then
		if menu_set > 1 then
			menu_set = menu_set - 1
		end
	elseif action == 'down' then
		if menu_set < 4 then
			menu_set = menu_set + 1
		end
	elseif action == 'return' and menu_set == 1 then
		full_toggle = 1
	elseif action == 'return' and menu_set == 2 then
		create_tiles()
	elseif action == 'return' and menu_set == 3 then
		save_map()
	elseif action == 'return' and menu_set == 4 then
		os.exit()
	end
	menu_color[1] = 255
	menu_color[2] = 255
	menu_color[3] = 255
	menu_color[4] = 255
	menu_color[menu_set] = 0
end

function save_map()
	local tile_num = 1
	local tile_num_sub = 1
	s_map = newmap -- This is a place holder.
	save_map_prep = ""
	while s_map[tile_num] ~= nil do
		while s_map[tile_num][tile_num_sub] ~= nil do
			if tile_num_sub ~= 1 then
				save_map_prep = save_map_prep .. ','
			end
			if tile_num_sub == 4 then -- This is needed to catch the texture and convert it back for saving.
				save_map_prep = save_map_prep .. "tile1"
			else
				save_map_prep = save_map_prep .. s_map[tile_num][tile_num_sub]
			end
			tile_num_sub = tile_num_sub + 1
			if s_map[tile_num][tile_num_sub] == nil then
				save_map_prep = save_map_prep .. ';'
			end
		end
		tile_num = tile_num + 1
		tile_num_sub = 1
	end
	love.filesystem.write('map.txt', save_map_prep, #save_map_prep)
end

function nexttile(passnext)
	get_next_x = mchar['xtile']
	get_next_y = mchar['ytile']
	local i = 0
	if mchar['facing'] == 'n' then
		get_next_y = get_next_y - 1
	elseif mchar['facing'] == 's' then
		get_next_y = get_next_y + 1
	elseif mchar['facing'] == 'w' then
		get_next_x = get_next_x - 1
	elseif mchar['facing'] == 'e' then
		get_next_x = get_next_x + 1
	end
	local xy = get_next_x .. ',' .. get_next_y .. ',' -- This needs to be after modifying the get_next variables.
	while map[xy .. i] == nil and i <= 10 do
		i = i + 1
	end
	return xy .. i
end

function checknext() -- This returns the difference in height between the main characters current position and its next position.
	--local zcheck = mchar['ztile']
	if mchar['ztile'] - map[nexttile()][3] >= -2 and mchar['ztile'] - map[nexttile()][3] <= 3 and map[nexttile()][6] == nil then -- It is possible to go up 2 steps and down 3 steps.
		--print(mchar['ztile'] - map[nexttile()][3])
		return true
	else
		--print(mchar['ztile'] - map[nexttile()][3])
		return false
	end
	--if map[get_next_x .. ',' .. get_next_y .. ',' .. (zcheck -2)] ~= nil or map[get_next_x .. ',' .. get_next_y .. ',' .. (zcheck -1)] ~= nil or map[get_next_x .. ',' .. get_next_y .. ',' .. (zcheck +0)] ~= nil or map[get_next_x .. ',' .. get_next_y .. ',' .. (zcheck +1)] ~= nil or map[get_next_x .. ',' .. get_next_y .. ',' .. (zcheck +2)] ~= nil then
	--	print("Clear")
	--	return true
	--else
	--	print("Blocked")
	--	return false
	--end
end

--	Unused functions

function create_tiles()
	-- 2969 can make 65 by 44 (add one due to 0)
	local xtile = 0
	local ytile = 0
	local tile_num = 0
	newmap = {}
	while tile_num <= 10000 do
		while xtile <= 100 and tile_num <= 10000 do
			table.insert(newmap,{xtile,ytile,1,tile1})
			tile_num = tile_num + 1
			xtile = xtile + 1
		end
		xtile = 0
		ytile = ytile + 1
	end
 end