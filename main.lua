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
	wall1 = love.graphics.newQuad(52, 205, 16, 4, ter:getWidth(), ter:getHeight())
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
	chars[0] = {['x']=384,['y']=240,['z']=4,['xtile']=24,['ytile']=16,['ztile']=1,['xdest']=384,['ydest']=240,['zdest']=4,['xtarget']=nil,['ytarget']=nil,['ztarget']=nil,['facing']="s",['moving']=false,['speed']=35,['imagemap']=img,['image']=brown_guard['s'],['anim']=0,['animclock']=0.29,['movecheck_x']=nil,['movecheck_y']=nil,['faction']="home",['inventindex']=nil,['equipped']=nil}
	load_npc = 1
		-- allies --
	createnpc(25,7,1,'s',img,brown_guard['s'],"home")
		-- enemies --
	createnpc(20,6,1,'s',enemy,ghost['s'],"undead")
	createnpc(27,6,1,'s',enemy,ghost['s'],"undead")
	-- The following is a temporary character for alpha testing --
	createnpc(28,16,1,'s',img,brown_guard['s'],"home")

	-- end of temporary character --
	activechars = {} -- This is the list of characters that could need to move.
	
	-- npc variables
	local xyz
--	local load_npc = nil -- replace this with something else in the future.
--	while chars[load_npc] ~= nil do
--		chars[load_npc]['x'] = chars[load_npc]['xtile']*tile_size
--		chars[load_npc]['y'] = (chars[load_npc]['ytile']-1)*tile_size
--		chars[load_npc]['z'] = chars[load_npc]['ztile']*tile_size/4
--		chars[load_npc]['xtarget'] = chars[load_npc]['x']
--		chars[load_npc]['ytarget'] = chars[load_npc]['y']
--		chars[load_npc]['ztarget'] = chars[load_npc]['z']
--		load_npc = chars[load_npc]['xtile'] .. ',' .. chars[load_npc]['ytile'] .. ',' .. chars[load_npc]['ztile']
--		map[load_npc][6] = load_npc
--		load_npc = load_npc + 1
--	end


	xyz = chars[0]['xtile'] .. ',' .. chars[0]['ytile'] .. ',' .. chars[0]['ztile']
	map[xyz][6] = 0
	
	-- test variables
	test_function = 1
	menu_color = {0,255,255,255}
	menu_set = 1
	full_screen = "Fullscreen on/off"
	full_toggle = 0
	xoffset = 0
	yoffset = 0
	zoffset = 0
	passnext = 0 -- This is used with the nexttile(passnext) function.
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
					drawworld(xyz)
					
				end
				zdraw = zdraw + 1
			end
			zdraw = 0
			xdraw = xdraw + 1
		end
		xdraw = chars[0]['xtile'] - bubble -- if the xdraw - value is changed this will need to be made to be the same.
		ydraw = ydraw + 1
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
	if show_menu then
		drawdebug()
	end
end

function drawworld(xyz)
	love.graphics.drawq(ter,tile1,map[xyz][1]*tile_size-xoffset,map[xyz][2]*tile_size-map[xyz][3]*4-yoffset+zoffset,0,1,1,0)
	love.graphics.drawq(ter,wall1,map[xyz][1]*tile_size-xoffset,(map[xyz][2]+1)*tile_size-map[xyz][3]*4-yoffset+zoffset,0,1,1,0) -- This is for the vertical wall of the tile.
	if map[xyz][6] ~= nil and map[xyz][6] ~= 0 then
		print(map[xyz][6])
		love.graphics.drawq(chars[map[xyz][6]]['imagemap'], chars[map[xyz][6]]['image'], chars[map[xyz][6]]['x']-xoffset, chars[map[xyz][6]]['y']-chars[map[xyz][6]]['z']-yoffset, 0, 1, 1, 0) -- This draws an npc.
	end
	if map[xyz][6] == 0 then
		love.graphics.drawq(img, chars[0]['image'], chars[0]['x'], chars[0]['y']-chars[0]['z'], 0, 1, 1, 0)
	end
end

function drawdebug() -- This function displays hopefully useful information for debugging
	love.graphics.setColor(50,50,50)
	love.graphics.rectangle("fill",580,210,140,160)
	love.graphics.setColor(200,200,200)
	love.graphics.print("X Tile:",600,230)
	love.graphics.print(chars[0]['xtile'],650,230)
	love.graphics.print("Dest:",600,240)
	love.graphics.print(map[nexttile(0)][1]*tile_size,650,240)
	love.graphics.print("Y Tile:",600,250)
	love.graphics.print(chars[0]['ytile'],650,250)
	love.graphics.print("Dest:",600,260)
	love.graphics.print(map[nexttile(0)][2]*tile_size,650,260)
	love.graphics.print("Z Tile:",600,270)
	love.graphics.print(chars[0]['ztile'],650,270)
	love.graphics.print("Dest:",600,280)
	love.graphics.print(map[nexttile(0)][3],650,280)
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
	
	-- start test area
	love.graphics.print(xoffset .. ',' .. yoffset,625,355)
	-- end test area
	love.graphics.setColor(255,255,255)
	love.graphics.draw(img, 200,400)
	--love.graphics.drawq(enemy, ghost['e'], 200, 400, 0, 1, 1, 0)
end

dtotal = 0   -- this keeps track of how much time has passed
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
	if math.floor(chars[0]['x']+0.9+xoffset) == map[nexttile(0)][1]*tile_size and math.floor(chars[0]['y']+0.9+yoffset) == (map[nexttile(0)][2]-1)*tile_size then -- The +0.9 is too make the character not get stuck when moving quickly (speed > 40).
		xyz = chars[0]['xtile'] .. ',' .. chars[0]['ytile'] .. ',' .. chars[0]['ztile'] -- This finds the current tile and removes the marker for the character.
		map[xyz][6] = nil
		map[nexttile(0)][6] = 0
		chars[0]['ztile'] = map[nexttile(0)][3]
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
	while npc_move <= 3 do
	ai(npc_move)
	chars[npc_move]['movecheck_x'] = chars[npc_move]['x']
	chars[npc_move]['movecheck_y'] = chars[npc_move]['y']
		if chars[npc_move]['action'] == "walkn" and (chars[npc_move]['facing'] == "n" or not chars[npc_move]['moving']) then
			chars[npc_move]['facing'] = "n"
			startmove(npc_move)
		end
		if chars[npc_move]['action'] == "walks" and (chars[npc_move]['facing'] == "s" or not chars[npc_move]['moving']) then
			chars[npc_move]['facing'] = "s"
			startmove(npc_move)
		end
		if chars[npc_move]['action'] == "walkw" and (chars[npc_move]['facing'] == "w" or not chars[npc_move]['moving']) then
			chars[npc_move]['facing'] = "w"
			startmove(npc_move)
		end
		if chars[npc_move]['action'] == "walke" and (chars[npc_move]['facing'] == "e" or not chars[npc_move]['moving']) then
			chars[npc_move]['facing'] = "e"
			startmove(npc_move)
		end
		-- npc running --
--		if love.keyboard.isDown('rshift') then -- temporary: right shift makes npc[1] run
--			chars[npc_move]['speed'] = 70 -- 70 appears to be too fast, though I do not know why. The character occasionally gets stuck moving right or down.
--		end

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
	npc_move = npc_move + 1
	end

	chars[0]['speed'] = 30 -- This makes it so running is only active when the key is down.
end

function startmove(npc)
	if checknext(npc) then
		local xyz = chars[npc]['xtile'] .. ',' .. chars[npc]['ytile'] .. ',' .. chars[npc]['ztile'] -- This finds the current tile and removes the marker for the character.
		chars[npc]['xdest'] = map[nexttile(npc)][1]*tile_size
		chars[npc]['ydest'] = (map[nexttile(npc)][2]-1)*tile_size
		chars[npc]['zdest'] = map[nexttile(npc)][3]*tile_size/4
		chars[npc]['moving'] = true
		if chars[npc]['facing'] == 's' or chars[npc]['facing'] == 'e' then -- This draws them ahead, in the direction that gets drawn next. Going the other two directions isn't a problem.
			map[nexttile(npc)][6] = npc
			map[xyz][6] = nil
		end
	end
end

function ai(npc)
	chars[npc]['action'] = "stationary"
	local xdiff = nil
	local ydiff = nil
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

function determinetarget(npc)
	-- This will determine the target for the NPC. Currently, it just sets them to targetting npc 4.
	if chars[npc]['faction'] == "undead" then
		return 4
	end
	if chars[npc]['faction'] == "home" then
		return 3
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

function checknext(passnext) -- This returns the difference in height between the main characters current position and its next position.
	if passnext == 0 then
		passnext = 0
	end
	if chars[passnext]['ztile'] - map[nexttile(passnext)][3] >= -2 and chars[passnext]['ztile'] - map[nexttile(passnext)][3] <= 3 and map[nexttile(passnext)][6] == nil then -- It is possible to go up 2 steps and down 3 steps.
		return true
	else
		return false
	end
end

function createnpc(xtile,ytile,ztile,facing,imagemap,image,faction)
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
--['speed']=35				The speed of the character
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
	table.insert(chars,{['x']=nil,['y']=nil,['z']=nil,['xtile']=xtile,['ytile']=ytile,['ztile']=ztile,['facing']=facing,['moving']=false,['speed']=35,['imagemap']=imagemap,['image']=image,['anim']=0,['animclock']=0.29,['movecheck_x']=nil,['movecheck_y']=nil,['faction']="undead",['inventindex']=nil,['equipped']=nil,['goal']=nil,['action']=nil}) -- This should eventually be loaded from a file.


--	table.insert(chars,{['x']=400,['y']=96,['z']=4,['xtile']=25,['ytile']=6,['ztile']=1,['xdest']=400,['ydest']=96,['zdest']=4,['xtarget']=nil,['ytarget']=nil,['ztarget']=nil,['facing']="s",['moving']=false,['speed']=35,['imagemap']=img,['image']=brown_guard['s'],['anim']=0,['animclock']=0.29,['movecheck_x']=nil,['movecheck_y']=nil,['faction']="home",['inventindex']=nil,['equipped']=nil,['goal']=nil,['action']=nil})
	
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