function love.load()
	xoffset = 0
	yoffset = 0
	zoffset = 0
	love.filesystem.setIdentity("Awake")
	-- system variables
	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()
	--love.filesystem.setIdentity("data")
	load_terrain() -- terrain variables
	load_sprites() -- sprite variables
--	load_cardgame() -- card game variables
	-- test variables
	test_function = 1
	menu_color = {0,255,255,255}
	menu_set = 1
	full_screen = "Fullscreen on/off"
	full_toggle = 0
	passnext = 0 -- This is used with the nexttile(passnext) function.
	npc_ai = "s"
	show_menu = false
	dtotal = 0   -- this keeps track of how much time has passed
end

function load_terrain()
	ter = love.graphics.newImage("terrain.PNG")
	ter:setFilter("nearest", "linear")
	tile_size = 16
	tile1 = love.graphics.newQuad(52, 209, 16, 16, ter:getWidth(), ter:getHeight())
	wall1 = love.graphics.newQuad(52, 205, 16, 4, ter:getWidth(), ter:getHeight())
	tile2 = love.graphics.newQuad(52, 193, 16, 16, ter:getWidth(), ter:getHeight())
	tile3 = love.graphics.newQuad(52, 177, 16, 16, ter:getWidth(), ter:getHeight())
		load_map = {}
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
end

function load_sprites()
	-- sprite variables
	-- This loads the sprite art --
	img = love.graphics.newImage("soldierbrown.PNG")
	img:setFilter("nearest", "linear")
	enemy = love.graphics.newImage("ghost.png")
	enemy:setFilter("nearest", "linear")
	crystalmap = love.graphics.newImage("crystal.png")
	crystalmap:setFilter("nearest", "linear")
	-- The following is the quad template map for how the utilized npc art files are organized.
	npcplate = {['n'] = love.graphics.newQuad(28, 6, 16, 26, img:getWidth(), img:getHeight()),['nw1'] = love.graphics.newQuad(4, 6, 16, 26, img:getWidth(), img:getHeight()), ['nw2'] = love.graphics.newQuad(28, 6, 16, 26, img:getWidth(), img:getHeight()), ['nw3'] = love.graphics.newQuad(52, 6, 16, 26, img:getWidth(), img:getHeight()), ['nw4'] = love.graphics.newQuad(28, 6, 16, 26, img:getWidth(), img:getHeight()), ['s'] = love.graphics.newQuad(28, 70, 16, 26, img:getWidth(), img:getHeight()), ['sw1'] = love.graphics.newQuad(4, 70, 16, 26, img:getWidth(), img:getHeight()), ['sw2'] = love.graphics.newQuad(28, 70, 16, 26, img:getWidth(), img:getHeight()), ['sw3'] = love.graphics.newQuad(52, 70, 16, 26, img:getWidth(), img:getHeight()), ['sw4'] = love.graphics.newQuad(28, 70, 16, 26, img:getWidth(), img:getHeight()), ['w'] = love.graphics.newQuad(28, 102, 16, 26, img:getWidth(), img:getHeight()), ['ww1'] = love.graphics.newQuad(4, 102, 16, 26, img:getWidth(), img:getHeight()), ['ww2'] = love.graphics.newQuad(28, 102, 16, 26, img:getWidth(), img:getHeight()), ['ww3'] = love.graphics.newQuad(52, 102, 16, 26, img:getWidth(), img:getHeight()), ['ww4'] = love.graphics.newQuad(28, 102, 16, 26, img:getWidth(), img:getHeight()), ['e'] = love.graphics.newQuad(28, 38, 16, 26, img:getWidth(), img:getHeight()), ['ew1'] = love.graphics.newQuad(4, 38, 16, 26, img:getWidth(), img:getHeight()), ['ew2'] = love.graphics.newQuad(28, 38, 16, 26, img:getWidth(), img:getHeight()), ['ew3'] = love.graphics.newQuad(52, 38, 16, 26, img:getWidth(), img:getHeight()), ['ew4'] = love.graphics.newQuad(28, 38, 16, 26, img:getWidth(), img:getHeight())}
		
	-- This creates the variables for the characters --
	chars = {}
	---- Main Character the player controls
	-- Note: This character is created without using the createnpc() function since it couldn't hit [0] the way I have it written.
	chars[0] = {['x']=384,['y']=240,['z']=4,['xtile']=24,['ytile']=16,['ztile']=1,['xdest']=384,['ydest']=240,['zdest']=4,['xtarget']=nil,['ytarget']=nil,['ztarget']=nil,['facing']="s",['moving']=false,['speed']=35,['imagemap']=img,['image']=npcplate['s'],['anim']=0,['animclock']=0.29,['movecheck_x']=nil,['movecheck_y']=nil,['faction']="home",['inventindex']=nil,['equipped']=nil}
	load_npc = 1 -- variale used throughout game to track npc creation and give them unique numbers
	---- This section will eventually be loaded from a file. For now, it will be loaded here.
		-- allies --
	createnpc(25,7,1,'s',img,npcplate['s'],"home","destroy")
		-- enemies --
	createnpc(20,6,1,'s',enemy,npcplate['s'],"undead","destroy")
	createnpc(27,6,1,'s',enemy,npcplate['s'],"undead","destroy")
		-- crystal --
	createnpc(22,16,1,'s',crystalmap,npcplate['s'],"zaaz","crystal")
	-- end of temporary character listing --
	activechars = {} -- This is the list of characters that could need to move or take actions.
	
	local xyz

	xyz = chars[0]['xtile'] .. ',' .. chars[0]['ytile'] .. ',' .. chars[0]['ztile']
	map[xyz][6] = 0

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
-- This was cut and pasted in. If love.run() was completely removed from this file it would run exactly as shown here anyway.
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
	activechars = nil -- This clears the list of acting characters so there won't be any holes when they are added again
	activechars = {} -- This preps the variable to hold table entries
	local ytile_num = 0
	local bubble = 6
	local xdraw = chars[0]['xtile'] - bubble
	local ydraw = chars[0]['ytile'] - bubble
	local zdraw = chars[0]['ztile'] - bubble
	local xdrawend = chars[0]['xtile'] + bubble
	local ydrawend = chars[0]['ytile'] + bubble
	local zdrawend = chars[0]['ztile'] + bubble -- This defines the ceiling 
	local xyz = nil -- This variable is used to concotinate the numbers for lua to understand the draw variables run together. This value is overwritten.
	for xdraw = xdraw, xdrawend, 1 do
		for ydraw = ydraw, ydrawend, 1 do
			for zdraw = zdraw, zdrawend, 1 do
				xyz = xdraw .. ',' .. ydraw .. ',' .. zdraw
				if map[xyz] ~= nil then
					drawworld(xyz)
				end
			end
		end
	end

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
	love.graphics.setColor(255,255,255) -- daytime setting
	if show_menu then
		drawdebug()
	end
end

function drawworld(xyz)
	-- The following draws the top of the tile.
	love.graphics.drawq(ter,tile1,map[xyz][1]*tile_size,map[xyz][2]*tile_size-map[xyz][3]*4,0,1,1,xoffset,yoffset-zoffset)
	-- The following draws the verticle part of the tile (only visible when it has a higher z value than the tile in front of it.)
	love.graphics.drawq(ter,wall1,map[xyz][1]*tile_size,(map[xyz][2]+1)*tile_size-map[xyz][3]*4,0,1,1,xoffset,yoffset-zoffset) -- This is for the vertical wall of the tile.
	-- The following triggers npc's to be drawn.
	if map[xyz][6] ~= nil and map[xyz][6] ~= 0 then
		table.insert(activechars,(map[xyz][6]))
		love.graphics.drawq(chars[map[xyz][6]]['imagemap'], chars[map[xyz][6]]['image'], chars[map[xyz][6]]['x'], chars[map[xyz][6]]['y']-chars[map[xyz][6]]['z'], 0, 1, 1,xoffset,yoffset-zoffset) -- This draws an npc.
	end
	-- The following triggers the main character to be drawn.
	if map[xyz][6] == 0 then
		love.graphics.drawq(img, chars[0]['image'], chars[0]['x'], chars[0]['y']-chars[0]['z'], 0, 1, 1)
	end
end

function drawdebug() -- This function displays hopefully useful information for debugging
	love.graphics.setColor(50,50,50)
	love.graphics.rectangle("fill",580,210,140,160)
	love.graphics.setColor(200,200,200)
	love.graphics.print("Xoffset",600,220)
	love.graphics.print(xoffset,650,220)
	love.graphics.print("X Tile:",600,230)
	love.graphics.print(chars[0]['xtile'],650,230)
	love.graphics.print("Dest:",600,240)
	love.graphics.print(map[nexttile(0)][1]*tile_size,650,240)
	love.graphics.print("Yoffset",600,250)
	love.graphics.print(yoffset,650,250)
	love.graphics.print("Y Tile:",600,260)
	love.graphics.print(chars[0]['ytile'],650,260)
	love.graphics.print("Dest:",600,270)
	love.graphics.print(map[nexttile(0)][2]*tile_size,650,270)
	love.graphics.print("Zoffset",600,280)
	love.graphics.print(zoffset,650,280)
	love.graphics.print("Z Tile:",600,290)
	love.graphics.print(chars[0]['ztile'],650,290)
	love.graphics.print("Dest:",600,300)
	love.graphics.print(map[nexttile(0)][3],650,300)
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
	checknext(0)
	love.graphics.print(map[nexttile(0)][1],650,340)
	love.graphics.print(',',665,340)
	love.graphics.print(map[nexttile(0)][2],675,340)
	love.graphics.print("Time",600,350)
	love.graphics.print(dtotal,650,350)
	love.graphics.setColor(255,255,255) -- This sets the color back to normal.
end

function love.update(dt)
	--dt = math.min(dt, 1/60) -- this limits the frame rate if needed
	local movecheck_x = xoffset
	local movecheck_y = yoffset
	local tilecheck_x = chars[0]['xtile']
	local tilecheck_y = chars[0]['ytile']
	local xyz = nil
	-- movement of character --
		-- keyboard movement --
	if love.keyboard.isDown('w') and (chars[0]['facing'] == "n" or not chars[0]['moving']) then
		chars[0]['facing'] = "n"
		startmove(0)
	end
	if love.keyboard.isDown('s') and (chars[0]['facing'] == "s" or not chars[0]['moving']) then
		chars[0]['facing'] = "s"
		startmove(0)
	end
	if love.keyboard.isDown('a') and (chars[0]['facing'] == "w" or not chars[0]['moving']) then
		chars[0]['facing'] = "w"
		startmove(0)
	end
	if love.keyboard.isDown('d') and (chars[0]['facing'] == "e" or not chars[0]['moving']) then
		chars[0]['facing'] = "e"
		startmove(0)
	end
	if love.keyboard.isDown('lshift') then
		chars[0]['speed'] = 2 -- 70 appears to be too fast, though I do not know why. The character occasionally gets stuck moving right or down.
	end
	-- main character movement --
	moveworld(0,dt)
	
	dtotal = dtotal + dt   -- we add the time passed since the last update, probably a very small number like 0.01
	movecheck(0,movecheck_x,xoffset,movecheck_y,yoffset)
	
	-- npc movement --
	-- auto movement --
--	local npc_move = 1
--	while activechars[npc_move] ~= nil do
--	ai(activechars[npc_move],dt)
--	chars[activechars[npc_move]]['movecheck_x'] = chars[activechars[npc_move]]['x']
--	chars[activechars[npc_move]]['movecheck_y'] = chars[activechars[npc_move]]['y']
--		if chars[activechars[npc_move]]['action'] == "walkn" and (chars[activechars[npc_move]]['facing'] == "n" or not chars[activechars[npc_move]]['moving']) then
--			chars[activechars[npc_move]]['facing'] = "n"
--			startmove(activechars[npc_move])
--		end
--		if chars[activechars[npc_move]]['action'] == "walks" and (chars[activechars[npc_move]]['facing'] == "s" or not chars[activechars[npc_move]]['moving']) then
--			chars[activechars[npc_move]]['facing'] = "s"
--			startmove(activechars[npc_move])
--		end
--		if chars[activechars[npc_move]]['action'] == "walkw" and (chars[activechars[npc_move]]['facing'] == "w" or not chars[activechars[npc_move]]['moving']) then
--			chars[activechars[npc_move]]['facing'] = "w"
--			startmove(activechars[npc_move])
--		end
--		if chars[activechars[npc_move]]['action'] == "walke" and (chars[activechars[npc_move]]['facing'] == "e" or not chars[activechars[npc_move]]['moving']) then
--			chars[activechars[npc_move]]['facing'] = "e"
--			startmove(activechars[npc_move])
--		end
--		movenpc(activechars[npc_move],dt)
--		
--		if chars[activechars[npc_move]]['moving'] then
--			chars[activechars[npc_move]]['animclock'] = chars[activechars[npc_move]]['animclock'] + dt
--		end
--		if chars[activechars[npc_move]]['animclock'] >= 0.3 then
--			chars[activechars[npc_move]]['animclock'] = chars[activechars[npc_move]]['animclock'] - 0.3
--			if chars[activechars[npc_move]]['anim'] >= 4 then
--				chars[activechars[npc_move]]['anim'] = 0
--			end
--			chars[activechars[npc_move]]['anim'] = chars[activechars[npc_move]]['anim'] + 1
--			anim_num = chars[activechars[npc_move]]['facing'] .. 'w' .. chars[activechars[npc_move]]['anim']
--			chars[activechars[npc_move]]['image'] = npcplate[anim_num]
--		end
		--if math.floor(chars[activechars[npc_move]]['x']+0.9) == map[nexttile(activechars[npc_move])][1]*tile_size and math.floor(chars[activechars[npc_move]]['y']+0.9) == (map[nexttile(activechars[npc_move])][2]-1)*tile_size then -- The +0.9 is too make the character not get stuck when moving quickly (speed > 40).
--		if math.abs(chars[activechars[npc_move]]['x'] - map[nexttile(activechars[npc_move])][1]*tile_size) <= 1 and math.abs(chars[activechars[npc_move]]['y'] - (map[nexttile(activechars[npc_move])][2]-1)*tile_size) <= 1 then
--			xyz = chars[activechars[npc_move]]['xtile'] .. ',' .. chars[activechars[npc_move]]['ytile'] .. ',' .. chars[activechars[npc_move]]['ztile'] -- This finds the current tile and removes the marker for the character.
--			map[xyz][6] = nil
--			map[nexttile(activechars[npc_move])][6] = activechars[npc_move]
--			chars[activechars[npc_move]]['ztile'] = map[nexttile(activechars[npc_move])][3]
--			chars[activechars[npc_move]]['xtile'] = get_next_x
--			chars[activechars[npc_move]]['ytile'] = get_next_y
--		end
--		movecheck(activechars[npc_move],chars[activechars[npc_move]]['movecheck_x'],chars[activechars[npc_move]]['x'],chars[activechars[npc_move]]['movecheck_y'],chars[activechars[npc_move]]['y'])
--		npc_move = npc_move + 1
--	end

	chars[0]['speed'] = 1 -- This makes it so running is only active when the key is down.
end

function startmove(npc)
	if checknext(npc) then
		local xyz = chars[npc]['xtile'] .. ',' .. chars[npc]['ytile'] .. ',' .. chars[npc]['ztile'] -- This finds the current tile and removes the marker for the character.
		chars[npc]['xdest'] = map[nexttile(npc)][1]*tile_size
		chars[npc]['ydest'] = (map[nexttile(npc)][2]-1)*tile_size
		chars[npc]['zdest'] = map[nexttile(npc)][3]*tile_size/4
		chars[npc]['moving'] = true
		--if chars[npc]['facing'] == 's' or chars[npc]['facing'] == 'e' then -- This draws them ahead, in the direction that gets drawn next. Going the other two directions isn't a problem.
			map[nexttile(npc)][6] = npc
--			map[xyz][6] = nil
		--end
	end
end

function moveworld(npc,dt) --This will move the camera based on the movement of the main charater, keeping the screen centered on it.
	local xyz = nil
	if chars[0]['x'] < chars[0]['xdest'] - xoffset then
		xoffset = xoffset + chars[0]['speed']*30*dt
	end
	if chars[0]['x'] > chars[0]['xdest'] - xoffset then
		xoffset = xoffset - chars[0]['speed']*30*dt
	end
	if chars[0]['y'] < chars[0]['ydest'] - yoffset then
		yoffset = yoffset + chars[0]['speed']*30*dt
	end
	if chars[0]['y'] > chars[0]['ydest'] - yoffset then
		yoffset = yoffset - chars[0]['speed']*30*dt
	end
	if chars[0]['z'] < chars[0]['zdest'] - zoffset then
		zoffset = zoffset + chars[0]['speed']*30/4*dt
	end
	if chars[0]['z'] > chars[0]['zdest'] - zoffset then
		zoffset = zoffset - chars[0]['speed']*30/4*dt
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
		chars[0]['image'] = npcplate[anim_num]
	end
	--if math.floor(chars[0]['x']+0.9+xoffset) == map[nexttile(0)][1]*tile_size and math.floor(chars[0]['y']+0.9+yoffset) == (map[nexttile(0)][2]-1)*tile_size then -- The +0.9 is too make the character not get stuck when moving quickly (speed > 40).
	if math.abs(chars[0]['x']+xoffset - map[nexttile(0)][1]*tile_size) <= 1 and math.abs(chars[0]['y']+yoffset - (map[nexttile(0)][2]-1)*tile_size) <= 1 then
		xyz = chars[0]['xtile'] .. ',' .. chars[0]['ytile'] .. ',' .. chars[0]['ztile'] -- This finds the current tile and removes the marker for the character.
		map[xyz][6] = nil
		map[nexttile(0)][6] = 0
		chars[0]['ztile'] = map[nexttile(0)][3]
		chars[0]['xtile'] = get_next_x
		chars[0]['ytile'] = get_next_y
	end
end

function movenpc(npc,dt)
	if chars[npc]['x'] < chars[npc]['xdest'] then
		chars[npc]['x'] = chars[npc]['x'] + chars[npc]['speed']*30*dt
	end
	if chars[npc]['x'] > chars[npc]['xdest'] then
		chars[npc]['x'] = chars[npc]['x'] - chars[npc]['speed']*30*dt
	end
	if chars[npc]['y'] < chars[npc]['ydest'] then
		chars[npc]['y'] = chars[npc]['y'] + chars[npc]['speed']*30*dt
	end
	if chars[npc]['y'] > chars[npc]['ydest'] then
		chars[npc]['y'] = chars[npc]['y'] - chars[npc]['speed']*30*dt
	end
	if chars[npc]['z'] < chars[npc]['zdest'] then
		chars[npc]['z'] = chars[npc]['z'] + chars[npc]['speed']*30/4*dt
	end
	if chars[npc]['z'] > chars[npc]['zdest'] then
		chars[npc]['z'] = chars[npc]['z'] - chars[npc]['speed']*30/4*dt
	end
end

function movecheck(npc,movecheck_x,current_x,movecheck_y,current_y)
	if movecheck_x == current_x and movecheck_y == current_y then -- If the character's x and y values are the same as they were before the movement functions, then it is stationary.
		chars[npc]['moving'] = false
		chars[npc]['anim'] = 0
		if chars[npc]['goal'] ~= "crystal" then
			chars[npc]['animclock'] = 0.29
		end
		chars[npc]['image'] = npcplate[chars[npc]['facing']] -- sets the character to the stationary image for its facing
		chars[npc]['speed'] = 1
	end
end

function ai(npc,dt)
	chars[npc]['action'] = "stationary"
	local xdiff = nil
	local ydiff = nil
	if chars[npc]['goal'] == "crystal" then
		rotate(npc,"left",dt)
	else
		if determinetarget(npc) == -1 then
			chars[npc]['action'] = "stationary"
		else
			xdiff = chars[npc]['xtile'] - chars[determinetarget(npc)]['xtile']
			ydiff = chars[npc]['ytile'] - chars[determinetarget(npc)]['ytile']
			if math.abs(ydiff) >= math.abs(xdiff) then
				if 0 > ydiff then
					chars[npc]['action'] = "walks"
				end
				if 0 < ydiff then
					chars[npc]['action'] = "walkn"
				end
			else --if math.abs(ydiff) <= math.abs(xdiff) then
				if 0 > xdiff then
					chars[npc]['action'] = "walke"
				end
				if 0 < xdiff then
					chars[npc]['action'] = "walkw"
				end
			end
		end
	end
end

function rotate(npc,direction,dt)
	chars[npc]['animclock'] = chars[npc]['animclock'] + dt
	if chars[npc]['animclock'] >= 0.3 then
		chars[npc]['animclock'] = chars[npc]['animclock'] - 0.3
		if direction == "left" then
			if chars[npc]['facing'] == 'n' then
				chars[npc]['facing'] = 'w'
			elseif chars[npc]['facing'] == 's' then
				chars[npc]['facing'] = 'e'
			elseif chars[npc]['facing'] == 'w' then
				chars[npc]['facing'] = 's'
			elseif chars[npc]['facing'] == 'e' then
				chars[npc]['facing'] = 'n'
			end
		elseif direction == "right" then
			if chars[npc]['facing'] == 'n' then
				chars[npc]['facing'] = 'e'
			elseif chars[npc]['facing'] == 's' then
				chars[npc]['facing'] = 'w'
			elseif chars[npc]['facing'] == 'w' then
				chars[npc]['facing'] = 'n'
			elseif chars[npc]['facing'] == 'e' then
				chars[npc]['facing'] = 's'
			end
		end
	end
end

function determinetarget(npc)
	-- This will determine the target for the NPC. Currently, it just sets them to targetting npc 4.
	local find = 1 -- used to rotate through the active characters to find possible targets
	local targets = {}
	local process = 1 -- used to rotate through targets
	local shortest = {}
	shortest[1] = {['dist']=10000,['npc']=-1} -- a table that holds two values, the shortest distance and the target number
	local xdiff = nil
	local ydiff = nil
	if chars[npc]['faction'] == "undead" then
		while activechars[find] ~= nil do
			if chars[activechars[find]]['faction'] == "home" then
				xdiff = math.abs(chars[npc]['xtile'] - chars[activechars[find]]['xtile'])
				ydiff = math.abs(chars[npc]['ytile'] - chars[activechars[find]]['ytile'])
				if (xdiff^2+ydiff^2)^0.5 < shortest[1]['dist'] then
					shortest[1]={['dist']=(xdiff^2+ydiff*2)^0.5,['npc']=activechars[find]}
				end
			end
			find = find + 1
			-- This section is only needed for factions that will target the main character
			xdiff = math.abs(chars[npc]['xtile'] - chars[0]['xtile'])
			ydiff = math.abs(chars[npc]['ytile'] - chars[0]['ytile'])
			if (xdiff^2+ydiff^2)^0.5 < shortest[1]['dist'] then
				shortest[1]={['dist']=(xdiff^2+ydiff*2)^0.5,['npc']=0}
			end
			-- end of section
		end
		return shortest[1]['npc']
	end
	if chars[npc]['faction'] == "home" then
		while activechars[find] ~= nil do
			if chars[activechars[find]]['faction'] == "undead" then
				xdiff = math.abs(chars[npc]['xtile'] - chars[activechars[find]]['xtile'])
				ydiff = math.abs(chars[npc]['ytile'] - chars[activechars[find]]['ytile'])
				if (xdiff^2+ydiff^2)^0.5 < shortest[1]['dist'] then
					shortest[1]={['dist']=(xdiff^2+ydiff*2)^0.5,['npc']=activechars[find]}
				end
			end
			find = find + 1
		end
		return shortest[1]['npc']
	end
	if chars[npc]['faction'] == "zaaz" then
		--temporary
		find = -1
		-- temporary
		return find
	end
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
		addtile(0)
		--load_map[map[nexttile(0)][5]][3] = load_map[map[nexttile(0)][5]][3] + 1 -- increase z in load_map
		--map[nexttile(0)] = {load_map[map[nexttile(0)][5]][1], load_map[map[nexttile(0)][5]][2], load_map[map[nexttile(0)][5]][3], load_map[map[nexttile(0)][5]][4], map[nexttile(0)][5]} -- create the new map
		--map[nexttile(0)] = nil -- erase the old map tile
	end
	if key == 'e' then
		erasenpc(determinetarget(0))
	end
	if key == '`' then -- This is to show the extra attributes
		if show_menu == false then
			show_menu = true
		else
			show_menu = false
		end
	end
	if key == 'c' then -- This is a way to test start the card game
		cardgame = true
	end
end

function erasenpc(npc) -- This erases the specified npc
	local bubble = 10
	local xdraw = chars[0]['xtile'] - bubble
	local ydraw = chars[0]['ytile'] - bubble
	local zdraw = chars[0]['ztile'] - bubble
	local xdrawend = chars[0]['xtile'] + bubble
	local ydrawend = chars[0]['ytile'] + bubble
	local zdrawend = chars[0]['ztile'] + bubble -- This defines the ceiling 
	local xyz = nil -- This variable is used to concotinate the numbers for lua to understand the draw variables run together. This value is overwritten.
	while ydraw <= ydrawend do
		while xdraw <= xdrawend do
			while zdraw <= zdrawend do
				xyz = xdraw .. ',' .. ydraw .. ',' .. zdraw
				if map[xyz] ~= nil then
					if map[xyz][6] == npc then
						map[xyz][6] = nil
					end
				end
				zdraw = zdraw + 1
			end
			zdraw = 0
			xdraw = xdraw + 1
		end
		xdraw = chars[0]['xtile'] - bubble -- if the xdraw - value is changed this will need to be made to be the same.
		ydraw = ydraw + 1
	end
	--local removeactive = 1
	--while activechars[removeactive] ~= removenpc do
	--	removeactive = removeactive + 1
	--end
	activechars = nil
	activechars = {}
	chars[npc] = nil
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

function nexttile(passnext) -- this function return the "x,y,z" of the next tile
	if passnext == 0 then
		passnext = 0
	end
		get_next_x = chars[passnext]['xtile']
		get_next_y = chars[passnext]['ytile']
		if chars[passnext]['facing'] == 'n' then
			get_next_y = get_next_y - 1
		elseif chars[passnext]['facing'] == 's' then
			get_next_y = get_next_y + 1
		elseif chars[passnext]['facing'] == 'w' then
			get_next_x = get_next_x - 1
		elseif chars[passnext]['facing'] == 'e' then
			get_next_x = get_next_x + 1
		end
		local i = chars[passnext]['ztile'] + 6
		local xy = get_next_x .. ',' .. get_next_y .. ',' -- This needs to be after modifying the get_next variables.
		while map[xy .. i] == nil and i >= 0 do
			i = i - 1
		end
		return xy .. i
end

function addtile(passnext)
	get_next_x = chars[passnext]['xtile']
	get_next_y = chars[passnext]['ytile']
	if chars[passnext]['facing'] == 'n' then
		get_next_y = get_next_y - 1
	elseif chars[passnext]['facing'] == 's' then
		get_next_y = get_next_y + 1
	elseif chars[passnext]['facing'] == 'w' then
		get_next_x = get_next_x - 1
	elseif chars[passnext]['facing'] == 'e' then
		get_next_x = get_next_x + 1
	end
	local i = chars[passnext]['ztile'] + 6
	local xy = get_next_x .. ',' .. get_next_y .. ',' -- This needs to be after modifying the get_next variables.
	while map[xy .. i] == nil and i >= 0 do
		i = i - 1
	end
	i = i + 1
	local xyz
	xyz = xy .. i
	map[xyz] = {map[nexttile(passnext)][1], map[nexttile(passnext)][2], map[nexttile(passnext)][3]+1, map[nexttile(passnext)][4], loadxyz, nil} -- This may not be correct.
	table.insert(load_map,{map[nexttile(passnext)][1],map[nexttile(passnext)][2],map[nexttile(passnext)][3]+1,map[nexttile(passnext)][4],xyz}) -- This may not be correct.
	loadxyz = loadxyz + 1
end

function checknext(passnext) -- This returns the true or false based on the difference in height between the character's current position and its next position. It also checks to see if another object is already occupying the next space.
	if passnext == 0 then
		passnext = 0
	end
	if chars[passnext]['ztile'] - map[nexttile(passnext)][3] >= -2 and chars[passnext]['ztile'] - map[nexttile(passnext)][3] <= 3 and map[nexttile(passnext)][6] == nil then -- It is possible to go up 2 steps and down 3 steps.
		return true
	else
		return false
	end
end

function createnpc(xtile,ytile,ztile,facing,imagemap,image,faction,goal)
---- Character stats ----
--['x']=320					x coordinate position -- calculate from xtile
--['y']=96					y coordinate position -- calculate from ytile
--['z']=4					z coordinate position -- calculate from ztile
--['xtile']=20				The character is on this x tile
--['ytile']=6				The character is on this y tile
--['ztile']=1				The character is on this z tile
--['xdest']=320				The x coordinate destination -- at start is equal to x
--['ydest']=96				The y coordinate destination -- at start is equal to y
--['zdest']=4				The z coordinate destination -- at start is equal to z
--['xtarget']=nil			-- still used?
--['ytarget']=nil			-- still used?
--['ztarget']=nil			-- still used?
--['facing']="s"			The facing of the character
--['moving']=false			Is the character moving
--['speed']=35				The speed multiplier of the character
--['imagemap']=enemy		This is the large image the sprites are taken from
--['image']=ghost['s']		Current sprite image
--['anim']=0				The animation counter
--['animclock']=0.29		The animation clock
--['movecheck_x']=nil		This is used to check if the character moved in the x direction
--['movecheck_y']=nil		This is used to check if the character moved in the x direction		
--['faction']="undead"		The character's faction
--['inventindex']=nil		This is the index value for the character's inventory
--['equipped']=nil			This is the index velue for the item the character has equipped from their inventory
--['goal']=nil				This is the ai's goal/objective
--['action']=nil			This is the action the ai is taking towards the goal
	table.insert(chars,{['xtile']=xtile,['ytile']=ytile,['ztile']=ztile,['facing']=facing,['moving']=false,['speed']=1,['imagemap']=imagemap,['image']=image,['anim']=0,['animclock']=0.29,['movecheck_x']=nil,['movecheck_y']=nil,['faction']=faction,['inventindex']=nil,['equipped']=nil,['goal']=goal,['action']=nil}) -- This should eventually be loaded from a file.

	chars[load_npc]['x'] = chars[load_npc]['xtile']*tile_size
	chars[load_npc]['y'] = (chars[load_npc]['ytile']-1)*tile_size
	chars[load_npc]['z'] = chars[load_npc]['ztile']*tile_size/4
	chars[load_npc]['xdest'] = chars[load_npc]['x']
	chars[load_npc]['ydest'] = chars[load_npc]['y']
	chars[load_npc]['zdest'] = chars[load_npc]['z']
	chars[load_npc]['xtarget'] = chars[load_npc]['x']
	chars[load_npc]['ytarget'] = chars[load_npc]['y']
	chars[load_npc]['ztarget'] = chars[load_npc]['z']
	local xyz = nil
	xyz = chars[load_npc]['xtile'] .. ',' .. chars[load_npc]['ytile'] .. ',' .. chars[load_npc]['ztile']
	map[xyz][6] = load_npc
	load_npc = load_npc + 1
end

--	Little used functions --

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

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
--[[
function load_cardgame()
 	-- card game
	cardgame = false -- Is the card game being played? Current default is yes.
	player1turn = true
	player2turn = false
	selectedcard=nil
	cardidmap = { -- the number will be 0 for no card, and otherwise will list the cardid from the cardset
		{ 0,0,0 },
		{ 0,0,0 },
		{ 0,0,0 }
	}
	cardcontrolmap = { -- 1 indicates player 1, 2 indicates player 2
		{ 0,0,0 },
		{ 0,0,0 },
		{ 0,0,0 }
	}
--	loadcardgameimages()
--	loadcardset()
end
 
 function loadcardgameimages()
	card_mat = love.graphics.newImage("mat.png")
 end
 
 function loadcardset()
	cardset = {}
	table.insert(cardset,{['n']=1,['s']=2,['w']=5,['e']=6,['imgmap']=img,['quarter']=npcplate['s'],['value']=14,['name']="test 1"})
	table.insert(cardset,{['n']=4,['s']=6,['w']=4,['e']=1,['imgmap']=img,['quarter']=npcplate['s'],['value']=15,['name']="test 1"})
	table.insert(cardset,{['n']=3,['s']=3,['w']=3,['e']=7,['imgmap']=img,['quarter']=npcplate['s'],['value']=16,['name']="test 1"})
	table.insert(cardset,{['n']=1,['s']=5,['w']=3,['e']=2,['imgmap']=img,['quarter']=npcplate['s'],['value']=11,['name']="test 1"})
	table.insert(cardset,{['n']=7,['s']=4,['w']=1,['e']=5,['imgmap']=img,['quarter']=npcplate['s'],['value']=16,['name']="test 1"})
	--{tonumber(contents[loadxyz][1]),tonumber(contents[loadxyz][2]),tonumber(contents[loadxyz][3]),contents[loadxyz][4],contents[loadxyz][1] .. ',' .. contents[loadxyz][2] .. ',' .. contents[loadxyz][3]})
	player1cards = {}
	table.insert(player1cards,{['cardid']=1,['r']=250,['g']=250,['b']=250})
	table.insert(player1cards,{['cardid']=2,['r']=250,['g']=250,['b']=250})
	table.insert(player1cards,{['cardid']=3,['r']=250,['g']=250,['b']=250})
	table.insert(player1cards,{['cardid']=4,['r']=250,['g']=250,['b']=250})
	table.insert(player1cards,{['cardid']=5,['r']=250,['g']=250,['b']=250})
	player2cards = {}
	table.insert(player2cards,{['cardid']=1,['r']=250,['g']=250,['b']=250})
	table.insert(player2cards,{['cardid']=1,['r']=250,['g']=250,['b']=250})
	table.insert(player2cards,{['cardid']=2,['r']=250,['g']=250,['b']=250})
	table.insert(player2cards,{['cardid']=2,['r']=250,['g']=250,['b']=250})
	table.insert(player2cards,{['cardid']=5,['r']=250,['g']=250,['b']=250})
 end
 
 function drawcardgame()
	drawmat()
	drawborder()
	drawcards()
 end
 
 function drawmat()
	love.graphics.draw(card_mat,0,75)
	-- reference prints
	love.graphics.setColor(255,255,255)
	love.graphics.print("1",0,100)
	love.graphics.print("2",0,210)
	love.graphics.print("3",0,320)
	love.graphics.print("4",112,100)
	love.graphics.print("5",112,210)
	-- end reference prints
	love.graphics.setColor(0,120,0)
	love.graphics.rectangle("fill",230,125,340,340)
 end
 
 function drawborder()
	-- currently, there is no border
 end
 
 function drawcards()
	local r = nil
	local g = nil
	local b = nil
	if player1turn then
		print("player 1's turn")
	end
	--draw player 1 cards
	drawcard(10 ,100,player1cards[1]['cardid'],player1cards[1]['r'],player1cards[1]['g'],player1cards[1]['b'])
	drawcard(10 ,210,player1cards[2]['cardid'],player1cards[2]['r'],player1cards[2]['g'],player1cards[2]['b'])
	drawcard(10 ,320,player1cards[3]['cardid'],player1cards[3]['r'],player1cards[3]['g'],player1cards[3]['b'])
	drawcard(120,100,player1cards[4]['cardid'],player1cards[4]['r'],player1cards[4]['g'],player1cards[4]['b'])
	drawcard(120,210,player1cards[5]['cardid'],player1cards[5]['r'],player1cards[5]['g'],player1cards[5]['b'])
	--draw player 2 cards
	drawcard(690,100,player2cards[1]['cardid'],player2cards[1]['r'],player2cards[1]['g'],player2cards[1]['b'])
	drawcard(690,210,player2cards[2]['cardid'],player2cards[2]['r'],player2cards[2]['g'],player2cards[2]['b'])
	drawcard(690,320,player2cards[3]['cardid'],player2cards[3]['r'],player2cards[3]['g'],player2cards[3]['b'])
	drawcard(580,100,player2cards[4]['cardid'],player2cards[4]['r'],player2cards[4]['g'],player2cards[4]['b'])
	drawcard(580,210,player2cards[5]['cardid'],player2cards[5]['r'],player2cards[5]['g'],player2cards[5]['b'])
	if cardidmap[1][1] ~= 0 then
		print(cardcontrolmap[1][1])
		if cardcontrolmap[1][1] == 1 then
			r = 0
			g = 0
			b = 255
		else
			r = 255
			g = 0
			b = 0
		end
		drawcard(240,135,cardidmap[1][1],r,g,b)
	end
	if cardidmap[1][2] ~= 0 then
		if cardcontrolmap[1][2] == 1 then
			r = 0
			g = 0
			b = 255
		else
			r = 255
			g = 0
			b = 0
		end
		drawcard(240,245,cardidmap[1][2],r,g,b)
	end
	if cardidmap[1][3] ~= 0 then
		if cardcontrolmap[1][3] == 1 then
			r = 0
			g = 0
			b = 255
		else
			r = 255
			g = 0
			b = 0
		end
		drawcard(240,355,cardidmap[1][3],r,g,b)
	end
	if cardidmap[2][1] ~= 0 then
		if cardcontrolmap[2][1] == 1 then
			r = 0
			g = 0
			b = 255
		else
			r = 255
			g = 0
			b = 0
		end
		drawcard(350,135,cardidmap[2][1],r,g,b)
	end
	if cardidmap[2][2] ~= 0 then
	if cardcontrolmap[2][2] == 1 then
			r = 0
			g = 0
			b = 255
		else
			r = 255
			g = 0
			b = 0
		end
		drawcard(350,245,cardidmap[2][2],r,g,b)
	end
	if cardidmap[2][3] ~= 0 then
		if cardcontrolmap[2][3] == 1 then
			r = 0
			g = 0
			b = 255
		else
			r = 255
			g = 0
			b = 0
		end
		drawcard(350,355,cardidmap[2][3],r,g,b)
	end
	if cardidmap[3][1] ~= 0 then
		if cardcontrolmap[3][1] == 1 then
			r = 0
			g = 0
			b = 255
		else
			r = 255
			g = 0
			b = 0
		end
		drawcard(460,135,cardidmap[3][1],r,g,b)
	end
	if cardidmap[3][2] ~= 0 then
		if cardcontrolmap[3][2] == 1 then
			r = 0
			g = 0
			b = 255
		else
			r = 255
			g = 0
			b = 0
		end
		drawcard(460,245,cardidmap[3][2],r,g,b)
	end
	if cardidmap[3][3] ~= 0 then
		if cardcontrolmap[3][3] == 1 then
			r = 0
			g = 0
			b = 255
		else
			r = 255
			g = 0
			b = 0
		end
		drawcard(460,355,cardidmap[3][3],r,g,b)
	end
 end
 
 function drawcard(x,y,cardid,r,g,b)
	love.graphics.setColor(r,g,b)
	love.graphics.rectangle("fill",x,y,100,100)
	love.graphics.setColor(255,255,255)
	love.graphics.drawq(cardset[cardid]['imgmap'],cardset[cardid]['quarter'],x+20,y+20)
	love.graphics.setColor(0,0,0)
	love.graphics.print(cardset[cardid]['n'],x+45,y)
	love.graphics.print(cardset[cardid]['s'],x+45,y+88)
	love.graphics.print(cardset[cardid]['e'],x,y+45)
	love.graphics.print(cardset[cardid]['w'],x+90,y+45)
 end
 
 function playcardgame(dt)
	--print(test_function)
 end
 
function love.mousepressed(x, y, button)
	if cardgame == true then
		if button == "l" then
			--test_function = x .. ',' .. y
			if player1turn == true then
				if x >= 10 and x <= 110 then
					if y >= 100 and y <= 200 then
						selectcard(1,1)--player1cards[1]['r'] = 0
					end
					if y >= 210 and y <= 310 then
						selectcard(1,2)--player1cards[2]['r'] = 0
					end
					if y >= 320 and y <= 420 then
						selectcard(1,3)--player1cards[3]['r'] = 0
					end
				end
				if x >= 120 and x <= 220 then
					if y >= 100 and y <= 200 then
						selectcard(1,4)--player1cards[4]['r'] = 0
					end
					if y >= 210 and y <= 310 then
						selectcard(1,5)--player1cards[5]['r'] = 0
					end
				end
				if selectedcard ~= nil then
					if x >= 240 and x <= 340 then
						if y >= 135 and y <= 235 then
						playcard(1,1)
						end
						if y >= 245 and y <= 345 then
						playcard(1,2)
						end
						if y >= 355 and y <= 455 then
						playcard(1,3)
						end
					end
					if x >= 350 and x <= 450 then
						if y >= 135 and y <= 235 then
						playcard(2,1)
						end
						if y >= 245 and y <= 345 then
						playcard(2,2)
						end
						if y >= 355 and y <= 455 then
						playcard(2,3)
						end
					end
					if x >= 460 and x <= 560 then
						if y >= 135 and y <= 235 then
						playcard(3,1)
						end
						if y >= 245 and y <= 345 then
						playcard(3,2)
						end
						if y >= 355 and y <= 455 then
						playcard(3,3)
						end
					end
				end
			end
		end
	end
end

function selectcard(player,card)
	if player == 1 then
		if selectedcard ~= nil then -- This clears the previous selection indication.
			player1cards[selectedcard]['r']=250
		end
		player1cards[card]['r']=0
		selectedcard=card
	end
	if player == 2 then
		if selectedcard ~= nil then -- This clears the previous selection indication.
			player2cards[selectedcard]['r']=250
		end
		player2cards[card]['r']=0
		selectedcard=card
	end
end

function playcard(xslot,yslot)
	if cardidmap[xslot][yslot] == 0 then
		cardidmap[xslot][yslot] = selectedcard
		if player1turn == true then
			cardcontrolmap[xslot][yslot] = 1
			print(xslot .. ',' .. yslot .. ',' .. cardcontrolmap[xslot][yslot])
			-- Check to see if anyting changed on the four sides.
			if cardidmap[xslot][yslot+1] ~= nil then
				if cardidmap[xslot][yslot+1] ~= 0 then
					if cardset[selected]['s'] > cardset[cardidmap[xslot][yslot+1]] -- this comment needs to be removed -- ['n'] then
--[[						cardcontrolmap[xslot][yslot+1] = 1
					end
				end
			end
			selected = nil
			player1turn = false
			player2turn = true
		end
		if player2turn == true then
			cardcontrolmap[xslot][yslot] = 2
			
			selected = nil
			player1turn = true
			player2turn = false
		end
		if player1turn == true then
			player1turn = false
			player2turn = true
		else
			player1turn = true
			player2turn = false
		end
	else
		-- play a sound indicating that was not a valid move
	end
end
--]]