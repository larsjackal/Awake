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
	-- This loads the sprite art --
	img = love.graphics.newImage("soldierbrown.PNG")
	img:setFilter("nearest", "linear")
	brown_guard = {['n'] = love.graphics.newQuad(28, 6, 16, 26, img:getWidth(), img:getHeight()),['nw1'] = love.graphics.newQuad(4, 6, 16, 26, img:getWidth(), img:getHeight()), ['nw2'] = love.graphics.newQuad(28, 6, 16, 26, img:getWidth(), img:getHeight()), ['nw3'] = love.graphics.newQuad(52, 6, 16, 26, img:getWidth(), img:getHeight()), ['nw4'] = love.graphics.newQuad(28, 6, 16, 26, img:getWidth(), img:getHeight()), ['s'] = love.graphics.newQuad(28, 70, 16, 26, img:getWidth(), img:getHeight()), ['sw1'] = love.graphics.newQuad(4, 70, 16, 26, img:getWidth(), img:getHeight()), ['sw2'] = love.graphics.newQuad(28, 70, 16, 26, img:getWidth(), img:getHeight()), ['sw3'] = love.graphics.newQuad(52, 70, 16, 26, img:getWidth(), img:getHeight()), ['sw4'] = love.graphics.newQuad(28, 70, 16, 26, img:getWidth(), img:getHeight()), ['w'] = love.graphics.newQuad(28, 102, 16, 26, img:getWidth(), img:getHeight()), ['ww1'] = love.graphics.newQuad(4, 102, 16, 26, img:getWidth(), img:getHeight()), ['ww2'] = love.graphics.newQuad(28, 102, 16, 26, img:getWidth(), img:getHeight()), ['ww3'] = love.graphics.newQuad(52, 102, 16, 26, img:getWidth(), img:getHeight()), ['ww4'] = love.graphics.newQuad(28, 102, 16, 26, img:getWidth(), img:getHeight()), ['e'] = love.graphics.newQuad(28, 38, 16, 26, img:getWidth(), img:getHeight()), ['ew1'] = love.graphics.newQuad(4, 38, 16, 26, img:getWidth(), img:getHeight()), ['ew2'] = love.graphics.newQuad(28, 38, 16, 26, img:getWidth(), img:getHeight()), ['ew3'] = love.graphics.newQuad(52, 38, 16, 26, img:getWidth(), img:getHeight()), ['ew4'] = love.graphics.newQuad(28, 38, 16, 26, img:getWidth(), img:getHeight())}
	enemy = love.graphics.newImage("ghost.png")
	enemy:setFilter("nearest", "linear")
	ghost = {['n'] = love.graphics.newQuad(28, 6, 16, 26, enemy:getWidth(), enemy:getHeight()),['nw1'] = love.graphics.newQuad(4, 6, 16, 26, enemy:getWidth(), enemy:getHeight()), ['nw2'] = love.graphics.newQuad(28, 6, 16, 26, enemy:getWidth(), enemy:getHeight()), ['nw3'] = love.graphics.newQuad(52, 6, 16, 26, enemy:getWidth(), enemy:getHeight()), ['nw4'] = love.graphics.newQuad(28, 6, 16, 26, enemy:getWidth(), enemy:getHeight()), ['s'] = love.graphics.newQuad(28, 70, 16, 26, enemy:getWidth(), enemy:getHeight()), ['sw1'] = love.graphics.newQuad(4, 70, 16, 26, enemy:getWidth(), enemy:getHeight()), ['sw2'] = love.graphics.newQuad(28, 70, 16, 26, enemy:getWidth(), enemy:getHeight()), ['sw3'] = love.graphics.newQuad(52, 70, 16, 26, enemy:getWidth(), enemy:getHeight()), ['sw4'] = love.graphics.newQuad(28, 70, 16, 26, enemy:getWidth(), enemy:getHeight()), ['w'] = love.graphics.newQuad(28, 102, 16, 26, enemy:getWidth(), enemy:getHeight()), ['ww1'] = love.graphics.newQuad(4, 102, 16, 26, enemy:getWidth(), enemy:getHeight()), ['ww2'] = love.graphics.newQuad(28, 102, 16, 26, enemy:getWidth(), enemy:getHeight()), ['ww3'] = love.graphics.newQuad(52, 102, 16, 26, enemy:getWidth(), enemy:getHeight()), ['ww4'] = love.graphics.newQuad(28, 102, 16, 26, enemy:getWidth(), enemy:getHeight()), ['e'] = love.graphics.newQuad(28, 38, 16, 26, enemy:getWidth(), enemy:getHeight()), ['ew1'] = love.graphics.newQuad(4, 38, 16, 26, enemy:getWidth(), enemy:getHeight()), ['ew2'] = love.graphics.newQuad(28, 38, 16, 26, enemy:getWidth(), enemy:getHeight()), ['ew3'] = love.graphics.newQuad(52, 38, 16, 26, enemy:getWidth(), enemy:getHeight()), ['ew4'] = love.graphics.newQuad(28, 38, 16, 26, enemy:getWidth(), enemy:getHeight())}
	-- This creates the variables for the characters --
	chars = {} -- This should replace mchar and npc
	chars[0] = {['x']=384,['y']=240,['z']=4,['xtile']=24,['ytile']=16,['ztile']=1,['xdest']=384,['ydest']=240,['zdest']=4,['xtarget']=nil,['ytarget']=nil,['ztarget']=nil,['facing']="s",['moving']=false,['speed']=35,['imagemap']=img,['image']=brown_guard['s'],['anim']=0,['animclock']=0.29}
	table.insert(chars,{['x']=400,['y']=96,['z']=4,['xtile']=25,['ytile']=6,['ztile']=1,['xdest']=400,['ydest']=96,['zdest']=4,['xtarget']=nil,['ytarget']=nil,['ztarget']=nil,['facing']="s",['moving']=false,['speed']=35,['imagemap']=img,['image']=brown_guard['s'],['anim']=0,['animclock']=0.29,['movecheck_x']=nil,['movecheck_y']=nil}) -- This should eventually be loaded from a file.
	table.insert(chars,{['x']=320,['y']=96,['z']=4,['xtile']=20,['ytile']=6,['ztile']=1,['xdest']=320,['ydest']=96,['zdest']=4,['xtarget']=nil,['ytarget']=nil,['ztarget']=nil,['facing']="s",['moving']=false,['speed']=35,['imagemap']=enemy,['image']=ghost['s'],['anim']=0,['animclock']=0.29,['movecheck_x']=nil,['movecheck_y']=nil}) -- This should eventually be loaded from a file.
	activechars = {} -- This is the list of characters that could need to move.
	
	-- npc variables
	local npc_load = 1
	local load_npc = "" -- replace this with something else in the future.
--	npc = {}
--	table.insert(npc,{['x']=400,['y']=96,['z']=4,['xtile']=25,['ytile']=6,['ztile']=1,['xdest']=400,['ydest']=96,['zdest']=4,['facing']="s",['moving']=false,['speed']=35,['image']=s_link,['anim']=0,['animclock']=0.29,['movecheck_x']=nil,['movecheck_y']=nil})
	while chars[npc_load] ~= nil do
		chars[npc_load]['x'] = chars[npc_load]['xtile']*tile_size
		chars[npc_load]['y'] = (chars[npc_load]['ytile']-1)*tile_size
		chars[npc_load]['z'] = chars[npc_load]['ztile']*tile_size/4
		chars[npc_load]['xtarget'] = chars[npc_load]['x']
		chars[npc_load]['ytarget'] = chars[npc_load]['y']
		chars[npc_load]['ztarget'] = chars[npc_load]['z']
		load_npc = chars[npc_load]['xtile'] .. ',' .. chars[npc_load]['ytile'] .. ',' .. chars[npc_load]['ztile']
		map[load_npc][6] = npc_load
		npc_load = npc_load + 1
	end
	load_npc = chars[0]['xtile'] .. ',' .. chars[0]['ytile'] .. ',' .. chars[0]['ztile']
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
	passnext = 2718 -- This is used with the nexttile(passnext) function.
	npc_ai = "s"
	show_menu = false
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
	local xdraw = chars[0]['xtile'] - 10
	local ydraw = chars[0]['ytile'] - 10
	local zdraw = 0
	local xdrawend = chars[0]['xtile'] + 10
	local ydrawend = chars[0]['ytile'] + 10
	local zdrawend = 4
	local xyz = "0,0,1" -- This variable is used to concotinate the numbers for lua to understand the draw variables run together. This value is overwritten.
	while ydraw <= ydrawend do
		while xdraw <= xdrawend do
			while zdraw <= zdrawend do
				xyz = xdraw .. ',' .. ydraw .. ',' .. zdraw
				if map[xyz] ~= nil then
					love.graphics.drawq(ter,tile1,map[xyz][1]*16-xoffset,map[xyz][2]*16-map[xyz][3]*4-yoffset+zoffset,0,1,1,0)
					if map[xyz][6] ~= nil and map[xyz][6] ~= 2718 then
						love.graphics.drawq(chars[map[xyz][6]]['imagemap'], chars[map[xyz][6]]['image'], chars[map[xyz][6]]['x']-xoffset, chars[map[xyz][6]]['y']-chars[map[xyz][6]]['z']-yoffset, 0, 1, 1, 0) -- This draws an npc.
					end
					if map[xyz][6] == 2718 then
						love.graphics.drawq(img, chars[0]['image'], chars[0]['x'], chars[0]['y']-chars[0]['z'], 0, 1, 1, 0)
					end
				end
				zdraw = zdraw + 1
			end
			zdraw = 0
			xdraw = xdraw + 1
		end
		xdraw = chars[0]['xtile'] - 10 -- if the xdraw - value is changed this will need to be made to be the same.
		ydraw = ydraw + 1
	end
	
	-- The following is the original drawing section --
	-- while load_map[tile_num] ~= nil do -- original draw for the map
	--	while load_map[tile_num] ~= nil and load_map[tile_num][2] == ytile_num do
	--		love.graphics.drawq(ter,load_map[tile_num][4],load_map[tile_num][1]*16-xoffset,load_map[tile_num][2]*16-load_map[tile_num][3]*4-yoffset,0,1,1,0)
	--		tile_num = tile_num + 1
	--	end
	--	if chars[1]['ytile'] == ytile_num then
	--		love.graphics.drawq(img, chars[1]['image'], chars[1]['x']-xoffset, chars[1]['y']-chars[1]['z']-yoffset, 0, 1, 1, 0) -- This draws an npc.
	--	end
	--	if chars[0]['ytile'] == ytile_num then
	--		love.graphics.drawq(img, chars[0]['image'], chars[0]['x'], chars[0]['y']-chars[0]['z'], 0, 1, 1, 0) -- This draws the character right after the row is drawn.
	--	end
	--	if chars[0]['ytile'] + 1 == ytile_num and chars[0]['facing'] == 's' and chars[0]['moving'] then
	--		love.graphics.drawq(img, chars[0]['image'], chars[0]['x'], chars[0]['y']-chars[0]['z'], 0, 1, 1, 0)  -- This draws the character right after the row the character is moving into is drawn.
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
	if show_menu then
		love.graphics.setColor(50,50,50)
		love.graphics.rectangle("fill",580,210,140,160)
		love.graphics.setColor(200,200,200)
		love.graphics.print("X Tile:",600,230)
		love.graphics.print(chars[0]['xtile'],650,230)
		love.graphics.print("Dest:",600,240)
		love.graphics.print(map[nexttile(2718)][1]*tile_size,650,240)
		love.graphics.print("Y Tile:",600,250)
		love.graphics.print(chars[0]['ytile'],650,250)
		love.graphics.print("Dest:",600,260)
		love.graphics.print(map[nexttile(2718)][2]*tile_size,650,260)
		love.graphics.print("Z Tile:",600,270)
		love.graphics.print(chars[0]['ztile'],650,270)
		love.graphics.print("Dest:",600,280)
		love.graphics.print(map[nexttile(2718)][3],650,280)
		love.graphics.print("Moving:",600,320)
		if chars[0]['moving'] == true then
			love.graphics.print("True",650,320)
		end
		if chars[0]['moving'] == false then
			love.graphics.print("False",650,320)
		end
		love.graphics.print("Facing:",600,330)
		love.graphics.print(chars[0]['facing'],650,330)
		love.graphics.print("Next:",600,340)
		checknext()
		love.graphics.print(map[nexttile(2718)][1],650,340)
		love.graphics.print(',',665,340)
		love.graphics.print(map[nexttile(2718)][2],675,340)
	
		-- start test area
		love.graphics.print(xoffset .. ',' .. yoffset,625,355)
		-- end test area
		love.graphics.setColor(255,255,255)
		love.graphics.draw(img, 200,400)
	end
end

dtotal = 0   -- this keeps track of how much time has passed
function love.update(dt)
	--dt = math.min(dt, 1/60) -- this limits the frame rate if needed
	local movecheck_x = xoffset
	local movecheck_y = yoffset
--	local npccheck_x = 0 -- this is a place holder
--	local npccheck_y = 0 -- this is a place holder
	local tilecheck_x = chars[0]['xtile']
	local tilecheck_y = chars[0]['ytile']
	local xyz = nil
	-- movement of character --
	-- keyboard movement --
	if love.keyboard.isDown('w') and (chars[0]['facing'] == "n" or not chars[0]['moving']) then
		chars[0]['facing'] = "n"
		if checknext(2718) then
			chars[0]['ydest'] = (map[nexttile(2718)][2]-1)*tile_size
			chars[0]['zdest'] = map[nexttile(2718)][3]*4
			chars[0]['moving'] = true
		end
	end
	if love.keyboard.isDown('s') and (chars[0]['facing'] == "s" or not chars[0]['moving']) then
		chars[0]['facing'] = "s"
		if checknext(2718) then
			xyz = chars[0]['xtile'] .. ',' .. chars[0]['ytile'] .. ',' .. chars[0]['ztile'] -- This finds the current tile and removes the marker for the character.
			map[xyz][6] = nil
			chars[0]['ydest'] = (map[nexttile(2718)][2]-1)*tile_size
			chars[0]['zdest'] = map[nexttile(2718)][3]*4
			chars[0]['moving'] = true
			map[nexttile(2718)][6] = 2718
		end
	end
	if love.keyboard.isDown('a') and (chars[0]['facing'] == "w" or not chars[0]['moving']) then
		chars[0]['facing'] = "w"
		if checknext(2718) then
			chars[0]['xdest'] = map[nexttile(2718)][1]*tile_size
			chars[0]['zdest'] = map[nexttile(2718)][3]*4
			chars[0]['moving'] = true
		end
	end
	if love.keyboard.isDown('d') and (chars[0]['facing'] == "e" or not chars[0]['moving']) then
		chars[0]['facing'] = "e"
		if checknext(2718) then
			xyz = chars[0]['xtile'] .. ',' .. chars[0]['ytile'] .. ',' .. chars[0]['ztile'] -- This finds the current tile and removes the marker for the character.
			map[xyz][6] = nil
			chars[0]['xdest'] = map[nexttile(2718)][1]*tile_size
			chars[0]['zdest'] = map[nexttile(2718)][3]*4
			chars[0]['moving'] = true
			map[nexttile(2718)][6] = 2718
		end
	end
	if love.keyboard.isDown('lshift') then
		chars[0]['speed'] = 70 -- 70 appears to be too fast, though I do not know why. The character occasionally gets stuck moving right or down.
	end
	-- main character movement --
	if chars[0]['x'] < chars[0]['xdest'] - xoffset then
		xoffset = xoffset + chars[0]['speed']*dt
	end
	if chars[0]['x'] > chars[0]['xdest'] - xoffset then
		xoffset = xoffset - chars[0]['speed']*dt
	end
	if chars[0]['y'] < chars[0]['ydest'] - yoffset then
		yoffset = yoffset + chars[0]['speed']*dt
	end
	if chars[0]['y'] > chars[0]['ydest'] - yoffset then
		yoffset = yoffset - chars[0]['speed']*dt
	end
	if chars[0]['z'] < chars[0]['zdest'] - zoffset then
		zoffset = zoffset + chars[0]['speed']/4*dt
	end
	if chars[0]['z'] > chars[0]['zdest'] - zoffset then
		zoffset = zoffset - chars[0]['speed']/4*dt
	end
	if chars[0]['moving'] then
		chars[0]['animclock'] = chars[0]['animclock'] + dt
	end
	if chars[0]['animclock'] >= 0.3 then
		chars[0]['animclock'] = chars[0]['animclock'] - 0.3
		local anim_num = "nw"
		if chars[0]['anim'] >= 4 then
			chars[0]['anim'] = 0
		end
		chars[0]['anim'] = chars[0]['anim'] + 1
		anim_num = chars[0]['facing'] .. 'w' .. chars[0]['anim']
		chars[0]['image'] = brown_guard[anim_num]
	end
	if math.floor(chars[0]['x']+0.9+xoffset) == map[nexttile(2718)][1]*tile_size and math.floor(chars[0]['y']+0.9+yoffset) == (map[nexttile(2718)][2]-1)*tile_size then -- The +0.9 is too make the character not get stuck when moving quickly (speed > 40).
		xyz = chars[0]['xtile'] .. ',' .. chars[0]['ytile'] .. ',' .. chars[0]['ztile'] -- This finds the current tile and removes the marker for the character.
		map[xyz][6] = nil
		map[nexttile(2718)][6] = 2718
		chars[0]['ztile'] = map[nexttile(2718)][3]
		chars[0]['xtile'] = get_next_x
		chars[0]['ytile'] = get_next_y
	end
	dtotal = dtotal + dt   -- we add the time passed since the last update, probably a very small number like 0.01
	--if movecheck_x == chars[0]['x'] and movecheck_y == chars[0]['y'] then
	if movecheck_x == xoffset and movecheck_y == yoffset then
		chars[0]['moving'] = false
		chars[0]['anim'] = 0
		chars[0]['animclock'] = 0.29
		chars[0]['image'] = brown_guard[chars[0]['facing']] -- sets the character to the stationary image for its facing
		chars[0]['speed'] = 30
	end
	
	-- npc movement --
	-- auto movement --
	local npc_move = 1
	while npc_move <= 2 do
	chars[npc_move]['movecheck_x'] = chars[npc_move]['x']
	chars[npc_move]['movecheck_y'] = chars[npc_move]['y']
		if npc_ai == 'n' and (chars[npc_move]['facing'] == "n" or not chars[npc_move]['moving']) then
			chars[npc_move]['facing'] = "n"
			if checknext(npc_move) then
				chars[npc_move]['ydest'] = (map[nexttile(npc_move)][2]-1)*tile_size
				chars[npc_move]['zdest'] = map[nexttile(npc_move)][3]*4
				chars[npc_move]['moving'] = true
			end
		end
		if npc_ai == 's' and (chars[npc_move]['facing'] == "s" or not chars[npc_move]['moving']) then
			chars[npc_move]['facing'] = "s"
			if checknext(npc_move) then
				xyz = chars[npc_move]['xtile'] .. ',' .. chars[npc_move]['ytile'] .. ',' .. chars[npc_move]['ztile'] -- This finds the current tile and removes the marker for the character.
				map[xyz][6] = nil
				chars[npc_move]['ydest'] = (map[nexttile(npc_move)][2]-1)*tile_size
				chars[npc_move]['zdest'] = map[nexttile(npc_move)][3]*4
				chars[npc_move]['moving'] = true
				map[nexttile(npc_move)][6] = npc_move
			end
		end
		if npc_ai == 'w' and (chars[npc_move]['facing'] == "w" or not chars[npc_move]['moving']) then
			chars[npc_move]['facing'] = "w"
			if checknext(npc_move) then
				chars[npc_move]['xdest'] = map[nexttile(npc_move)][1]*tile_size
				chars[npc_move]['zdest'] = map[nexttile(npc_move)][3]*4
				chars[npc_move]['moving'] = true
			end
		end
		if npc_ai == 'e' and (chars[npc_move]['facing'] == "e" or not chars[npc_move]['moving']) then
			chars[npc_move]['facing'] = "e"
			if checknext(npc_move) then
				xyz = chars[npc_move]['xtile'] .. ',' .. chars[npc_move]['ytile'] .. ',' .. chars[npc_move]['ztile'] -- This finds the current tile and removes the marker for the character.
				map[xyz][6] = nil
				chars[npc_move]['xdest'] = map[nexttile(npc_move)][1]*tile_size
				chars[npc_move]['zdest'] = map[nexttile(npc_move)][3]*4
				chars[npc_move]['moving'] = true
				map[nexttile(npc_move)][6] = 1
			end
		end
		-- npc running --
		if love.keyboard.isDown('rshift') then -- temporary: right shift makes npc[1] run
			chars[npc_move]['speed'] = 70 -- 70 appears to be too fast, though I do not know why. The character occasionally gets stuck moving right or down.
		end

		if chars[npc_move]['x'] < chars[npc_move]['xdest'] then
			chars[npc_move]['x'] = chars[npc_move]['x'] + chars[npc_move]['speed']*dt
		end
		if chars[npc_move]['x'] > chars[npc_move]['xdest'] then
			chars[npc_move]['x'] = chars[npc_move]['x'] - chars[npc_move]['speed']*dt
		end
		if chars[npc_move]['y'] < chars[npc_move]['ydest'] then
			chars[npc_move]['y'] = chars[npc_move]['y'] + chars[npc_move]['speed']*dt
		end
		if chars[npc_move]['y'] > chars[npc_move]['ydest'] then
			chars[npc_move]['y'] = chars[npc_move]['y'] - chars[npc_move]['speed']*dt
		end
		if chars[npc_move]['z'] < chars[npc_move]['zdest'] then
			chars[npc_move]['z'] = chars[npc_move]['z'] + chars[npc_move]['speed']/4*dt
		end
		if chars[npc_move]['z'] > chars[npc_move]['zdest'] then
			chars[npc_move]['z'] = chars[npc_move]['z'] - chars[npc_move]['speed']/4*dt
		end
		if chars[npc_move]['moving'] then
			chars[npc_move]['animclock'] = chars[npc_move]['animclock'] + dt
		end
		if chars[npc_move]['animclock'] >= 0.3 then
			chars[npc_move]['animclock'] = chars[npc_move]['animclock'] - 0.3
			local anim_num = "nw"
			if chars[npc_move]['anim'] >= 4 then
				chars[npc_move]['anim'] = 0
			end
			chars[npc_move]['anim'] = chars[npc_move]['anim'] + 1
			anim_num = chars[npc_move]['facing'] .. 'w' .. chars[npc_move]['anim']
			chars[npc_move]['image'] = brown_guard[anim_num]
		end
		if math.floor(chars[npc_move]['x']+0.9) == map[nexttile(npc_move)][1]*tile_size and math.floor(chars[npc_move]['y']+0.9) == (map[nexttile(npc_move)][2]-1)*tile_size then -- The +0.9 is too make the character not get stuck when moving quickly (speed > 40).
			xyz = chars[npc_move]['xtile'] .. ',' .. chars[npc_move]['ytile'] .. ',' .. chars[npc_move]['ztile'] -- This finds the current tile and removes the marker for the character.
			map[xyz][6] = nil
			map[nexttile(npc_move)][6] = npc_move
			chars[npc_move]['ztile'] = map[nexttile(npc_move)][3]
			chars[npc_move]['xtile'] = get_next_x
			chars[npc_move]['ytile'] = get_next_y
		end
		if chars[npc_move]['movecheck_x'] == chars[npc_move]['x'] and chars[npc_move]['movecheck_y'] == chars[npc_move]['y'] then
			chars[npc_move]['moving'] = false
			chars[npc_move]['anim'] = 0
			chars[npc_move]['animclock'] = 0.29
			chars[npc_move]['image'] = brown_guard[chars[npc_move]['facing']] -- sets the character to the stationary image for its facing
			chars[npc_move]['speed'] = 30
		end
		-- This section makes the npc move in a simple path --
		if chars[npc_move]['ytile'] == 15 and npc_ai == 's' then
			npc_ai = "e"
		end
		if chars[npc_move]['xtile'] == 35 and npc_ai == 'e' then
			npc_ai = "n"
		end
		if chars[npc_move]['ytile'] == 10 and npc_ai == 'n' then
			npc_ai = "w"
		end
		if chars[npc_move]['xtile'] == 25 and npc_ai == 'w' then
			npc_ai = "s"
		end
		-- end of ai section --
	npc_move = npc_move + 1
	end
	

	-- testing running toggle
	chars[0]['speed'] = 30 -- This makes it so running is only active when the key is down.
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
		load_map[map[nexttile(0)][5]][3] = load_map[map[nexttile(0)][5]][3] + 1 -- increase z in load_map
		map[load_map[map[nexttile(0)][5]][1] .. ',' .. load_map[map[nexttile(0)][5]][2] .. ',' .. load_map[map[nexttile(0)][5]][3]] = {load_map[map[nexttile(0)][5]][1], load_map[map[nexttile(0)][5]][2], load_map[map[nexttile(0)][5]][3], load_map[map[nexttile(0)][5]][4], map[nexttile(0)][5]} -- create the new map
		map[nexttile(0)] = nil -- erase the old map tile
	end
	if key == '`' then -- This is to show the extra attributes
		if show_menu == false then
			show_menu = true
		else
			show_menu = false
		end
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
	if passnext == 2718 then
		passnext = 0
	end
		get_next_x = chars[passnext]['xtile']
		get_next_y = chars[passnext]['ytile']
		local i = 0
		if chars[passnext]['facing'] == 'n' then
			get_next_y = get_next_y - 1
		elseif chars[passnext]['facing'] == 's' then
			get_next_y = get_next_y + 1
		elseif chars[passnext]['facing'] == 'w' then
			get_next_x = get_next_x - 1
		elseif chars[passnext]['facing'] == 'e' then
			get_next_x = get_next_x + 1
		end
		local xy = get_next_x .. ',' .. get_next_y .. ',' -- This needs to be after modifying the get_next variables.
		while map[xy .. i] == nil and i <= 10 do
			i = i + 1
		end
		return xy .. i
end

function checknext(passnext) -- This returns the difference in height between the main characters current position and its next position.
	if passnext == 2718 then
		passnext = 0
	end
	if chars[passnext]['ztile'] - map[nexttile(passnext)][3] >= -2 and chars[passnext]['ztile'] - map[nexttile(passnext)][3] <= 3 and map[nexttile(passnext)][6] == nil then -- It is possible to go up 2 steps and down 3 steps.
		return true
	else
		return false
	end
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