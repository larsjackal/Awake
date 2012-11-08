function love.load()
	love.filesystem.setIdentity("Awake")
	-- system variables
	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()
	--love.filesystem.setIdentity("data")
	
	-- main character variables
	img = love.graphics.newImage("soldierbrown.PNG")
	img:setFilter("nearest", "linear")
	n_link = love.graphics.newQuad(28, 6, 16, 26, img:getWidth(), img:getHeight())
	s_link = love.graphics.newQuad(28, 70, 16, 26, img:getWidth(), img:getHeight())
	w_link = love.graphics.newQuad(28, 102, 16, 26, img:getWidth(), img:getHeight())
	e_link = love.graphics.newQuad(28, 38, 16, 26, img:getWidth(), img:getHeight())
	link = s_link
	speed = 25
	x = 160
	y = 160
	destination_x = x
	destination_y = y
	movecheck_x = x
	movecheck_y = y
	mchar = {['x']=160,['y']=160,['xtile']=10,['ytile']=11,['facing']="s",['moving']=false}
	
	-- npc variables
	npc = love.graphics.newQuad(28, 70, 16, 26, img:getWidth(), img:getHeight())
	npc_x = 144
	npc_y = 144
	
	-- terrain variables
	ter = love.graphics.newImage("terrain.PNG")
	ter:setFilter("nearest", "linear")
	tile_size = 16
	tile1 = love.graphics.newQuad(52, 209, 16, 16, ter:getWidth(), ter:getHeight())
	map = {{0,0,tile1,1}}
	tile_num = 1
	xtile = 0
	ytile = 0
	contents = love.filesystem.read("map.txt")
	contents = split(contents, ";")
	load_process = 1
	while contents[load_process] ~= nil do
		contents[load_process] = split(contents[load_process], ",")
		if contents[load_process][3] == "tile1" then
			contents[load_process][3] = tile1
		end
		load_process = load_process + 1
	end
	load_process_two = 1
	while contents[load_process_two] ~= nil do
		table.insert(map,{tonumber(contents[load_process_two][1]),tonumber(contents[load_process_two][2]),contents[load_process_two][3],tonumber(contents[load_process_two][4])})
		load_process_two = load_process_two + 1
	end
	
	-- test variables
	test_function = 1
	
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

menu_color = {0,255,255,255}
menu_set = 1
full_screen = "Fullscreen on/off"
full_toggle = 0

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
	tile_num = 1
	while map[tile_num] ~= nil do
		love.graphics.drawq(ter,map[tile_num][3],map[tile_num][1]*16,map[tile_num][2]*16,0,1,1,0)
		tile_num = tile_num + 1
	end
	if(y > npc_y) then
	love.graphics.drawq(img, npc, npc_x, npc_y, 0, 1, 1, 0) -- This draws an npc.
	love.graphics.drawq(img, link, x, y, 0, 1, 1, 0)  -- This draws the character.
	end
	if(y <= npc_y) then
	love.graphics.drawq(img, link, x, y, 0, 1, 1, 0)  -- This draws the character.
	love.graphics.drawq(img, npc, npc_x, npc_y, 0, 1, 1, 0) -- This draws an npc.
	end
	--while full_toggle == 1 do -- This will make it fullscreen.
	--	love.graphics.toggleFullscreen()
	--	full_toggle = 0
	--end
	love.graphics.setColor(50,50,50)
	love.graphics.rectangle("fill",580,30,140,100)
	love.graphics.setColor(menu_color[1],255,255)
	love.graphics.print(full_screen,600,50)
	love.graphics.setColor(menu_color[2],255,255)
	love.graphics.print("Menu 2",600,65)
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
	love.graphics.print(destination_x,650,240)
	love.graphics.print("Y Tile:",600,250)
	love.graphics.print(mchar['ytile'],650,250)
	love.graphics.print("Dest:",600,260)
	love.graphics.print(destination_y,650,260)
	love.graphics.print("X:",600,270)
	love.graphics.print(x,650,270)
	love.graphics.print("Dest:",600,280)
	love.graphics.print(destination_x,650,280)
	love.graphics.print("Y:",600,290)
	love.graphics.print(y,650,290)
	love.graphics.print("Dest:",600,300)
	love.graphics.print(destination_y,650,300)
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
	get_next_x = mchar['xtile']
	get_next_y = mchar['ytile']
	if mchar['facing'] == 'n' then
		get_next_y = get_next_y - 1
	elseif mchar['facing'] == 's' then
		get_next_y = get_next_y + 1
	elseif mchar['facing'] == 'w' then
		get_next_x = get_next_x - 1
	elseif mchar['facing'] == 'e' then
		get_next_x = get_next_x + 1
	end
	love.graphics.print(get_next_x,650,340)
	love.graphics.print(',',665,340)
	love.graphics.print(get_next_y,675,340)
	-- checknext() test area
	checknext()
	love.graphics.print(test_function,625,355)
	-- end test area
	love.graphics.setColor(255,255,255)
	love.graphics.draw(img, 200,400)
end

dtotal = 0   -- this keeps track of how much time has passed
function love.update(dt)
	--dt = math.min(dt, 1/60) -- this limits the frame rate if needed
	movecheck_x = x
	movecheck_y = y
	tilecheck_x = destination_x
	tilecheck_y = destination_y
	if love.keyboard.isDown('w') and (mchar['facing'] == "n" or not mchar['moving']) then
		destination_y = math.floor(y/tile_size-0.5)*tile_size -- This math rounds to the nearest low increment of the tile_size.
		mchar['moving'] = true
		mchar['facing'] = "n"
		link = n_link
		if destination_y ~= tilecheck_y then
			mchar['ytile'] = mchar['ytile'] - 1
		end
	end
	if love.keyboard.isDown('s') and (mchar['facing'] == "s" or not mchar['moving']) then
		destination_y = math.floor(y/tile_size+1.5)*tile_size -- This math rounds to the nearest high increment of the tile_size.
		mchar['moving'] = true
		mchar['facing'] = "s"
		link = s_link
		if destination_y ~= tilecheck_y then
			mchar['ytile'] = mchar['ytile'] + 1
		end
	end
	if love.keyboard.isDown('a') and (mchar['facing'] == "w" or not mchar['moving']) then
		destination_x = math.floor(x/tile_size-0.5)*tile_size
		mchar['moving'] = true
		mchar['facing'] = "w"
		link = w_link
		if destination_x ~= tilecheck_x then
			mchar['xtile'] = mchar['xtile'] - 1
		end
	end
	if love.keyboard.isDown('d') and (mchar['facing'] == "e" or not mchar['moving']) then
		destination_x = math.floor(x/tile_size+1.5)*tile_size
		mchar['moving'] = true
		mchar['facing'] = "e"
		link = e_link
		if destination_x ~= tilecheck_x then
			mchar['xtile'] = mchar['xtile'] + 1
		end
	end
	if love.keyboard.isDown('lshift') then
		speed = 50
	end
	if x < destination_x then
		x = x + speed*dt
	end
	if x > destination_x then
		x = x - speed*dt
	end
	if y < destination_y then
		y = y + speed*dt
	end
	if y > destination_y then
		y = y - speed*dt
	end
	dtotal = dtotal + dt   -- we add the time passed since the last update, probably a very small number like 0.01
	if movecheck_x == x and movecheck_y == y then
		mchar['moving'] = false
		speed = 25
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
		map[60][1] = -500
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
	tile_num = 1
	tile_num_sub = 1
	save_map_prep = "-100,-100,tile1,0;"
	while map[tile_num] ~= nil do
		while map[tile_num][tile_num_sub] ~= nil do
			if tile_num_sub ~= 1 then
				save_map_prep = save_map_prep .. ','
			end
			if tile_num_sub == 3 then -- This is needed to catch the texture and convert it back for saving.
				save_map_prep = save_map_prep .. "tile1"
			else
				save_map_prep = save_map_prep .. map[tile_num][tile_num_sub]
			end
			tile_num_sub = tile_num_sub + 1
			if map[tile_num][tile_num_sub] == nil then
				save_map_prep = save_map_prep .. ';'
			end
		end
		tile_num = tile_num + 1
		tile_num_sub = 1
	end
	love.filesystem.write('map.txt', save_map_prep, #save_map_prep)
end

function checknext() -- This returns the difference in height between the main characters current position and its next position.
	-- get_next_x -- This is updating constantly in the draw function currently.
	-- get_next_y -- This is updating constantly in the draw function currently.
	local i = 1
	while map[i][1] ~= get_next_x or map[i][2] ~= get_next_y do
		i = i + 1
	end
	test_function = map[i][1] .. ',' .. map[i][2] --map[100][2]
end

--	Unused functions

--	function create tiles()
	--while tile_num <= 1900 do
	--	while ytile <= 37 and tile_num <= 1900 do
	--		table.insert(map,{xtile,ytile,tile1,1})
	--		tile_num = tile_num + 1
	--		ytile = ytile + 1
	--	end
	--	ytile = 0
	--	xtile = xtile + 1
	--end
-- end