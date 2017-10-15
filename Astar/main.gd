extends Control

#script: creates a pathfiding algorithm based on A*

var star = AStar.new()

var nodes = []
var id = 0
var draw = false
var drawPath = false
var path = []
var kinematic

func _ready():
	
	kinematic = get_parent().get_node("KinematicBody2D")
	
	#create the grid
	for x in range(20):
		for y in range(10):
			nodes.append(Vector3(x*32,0,y*32))
			#add the points to the grid
			star.add_point(id,nodes[id-1],1)
			id += 1
	
	#draw the grid
	draw = true
	update()
	
	#connect the points
	for i in range(id):
		
		#right,left,up,down,rightUp,rightDown,leftDown,leftUp
		var dirs = [Vector3(32,0,0),Vector3(-32,0,0),Vector3(0,0,-32),Vector3(0,0,32),
		Vector3(32,0,-32),Vector3(32,0,32),Vector3(-32,0,32),Vector3(-32,0,-32)]
		

		var r = nodes[i] + dirs[0]
		var l = nodes[i] + dirs[1]
		var u = nodes[i] + dirs[2]
		var d = nodes[i] + dirs[3]
		var ru = nodes[i] + dirs[4]
		var rd = nodes[i] + dirs[5]
		var ld = nodes[i] + dirs[6]
		var lu = nodes[i] + dirs[7]
		
		var currently = i
		
		#connect points
		#if the neighbours points exists in the grid, connect them.

		for n in range(id): #right
			if r == nodes[n]:
				if !star.are_points_connected(n,currently):
					star.connect_points(n,currently,true)
					break
				
		for n in range(id): #left
			if l == nodes[n]:
				if !star.are_points_connected(n,currently):
					star.connect_points(n,currently,true)
					break
		
		for n in range(id): #up
			if u == nodes[n]:
				if !star.are_points_connected(n,currently):
					star.connect_points(n,currently,true)
					break
		
		for n in range(id): #down
			if d == nodes[n]:
				if !star.are_points_connected(n,currently):
					star.connect_points(n,currently,true)
					break
				
		for n in range(id): #right up
			if ru == nodes[n]:
				if !star.are_points_connected(n,currently):
					star.connect_points(n,currently,true)
					break
				
		for n in range(id): #right down
			if rd == nodes[n]:
				if !star.are_points_connected(n,currently):
					star.connect_points(n,currently,true)
					break
				
		for n in range(id): #left down
			if ld == nodes[n]:
				star.connect_points(n,currently,true)
				break
				
		for n in range(id): #left up
			if lu == nodes[n]:
				if !star.are_points_connected(n,currently):
					star.connect_points(n,currently,true)
					break

	
	path = star.get_point_path(0,20)
	print(star.get_id_path(0,20))


	#center
	for i in range(path.size()):
		path[i].x += 16
		path[i].z += 16
		pass
	
	draw = true
	drawPath = true
	update()
	
	for i in range(path.size()):
		print(path[i])
	
	set_fixed_process(true)
	var initialPos = Vector2()
	initialPos.x = path[0].x + 200
	initialPos.y = path[0].z + 200
	kinematic.set_global_pos(initialPos)
	
func _fixed_process(delta):
	
	pass
	
func _draw():
	if draw:
		for i in range(nodes.size()):
			#draw a grid
			var pos = Vector2()
			pos.x = nodes[i].x + 200
			pos.y = nodes[i].z + 200
			
			var rec = Rect2(pos,Vector2(32,32))
			draw_rect(rec,Color(0,204,0))
			
			#draw a circle in the center of each tiles
			var pos2 = Vector2()
			pos2.x = (nodes[i].x+16) + 200
			pos2.y = (nodes[i].z+16) + 200
			draw_circle(pos2,5,Color(204,0,0))
			
			#tile number
			var label = Label.new()
			label.set_text(str(i))
			label.set_global_pos(pos2)
			get_parent().add_child(label)
			
			
	if drawPath:
		for i in range(path.size()):
			var pos = Vector2()
			pos.x = path[i].x + 200
			pos.y = path[i].z + 200
			
			draw_circle(pos,10,Color(0,0,0))
		
	
	








