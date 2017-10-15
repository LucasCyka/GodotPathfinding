extends Control

#script: A* algorithm

#grid size
export var tileWidth = 32
export var tileHeight = 32
export var rows = 4
export var columns = 2

#screen offset
var offset = 200

#draw controls
var drawGrid = false
var drawPath = false
var obstacle = false

var grid = {}
var star
var path = []
var obstacles = []

#make a square grid
func MakeGrid():
	
	var id = 0
	
	for y in range(columns):
		for x in range(rows):
			grid[id] = {
				#the POSSIBLE neighbours of each tile
				"neighbours":{
					"l": Vector3((x * tileWidth) - tileWidth,0,y * tileHeight),
					"r": Vector3((x * tileWidth) + tileWidth,0,y * tileHeight),
					"d": Vector3(x * tileWidth,0,(y * tileHeight) + tileHeight),
					"u": Vector3(x * tileWidth,0,(y * tileHeight) - tileHeight),
					"lu": Vector3((x * tileWidth) - tileWidth,0,(y * tileHeight) - tileHeight),
					"ld": Vector3((x * tileWidth) - tileWidth,0,(y * tileHeight) + tileHeight),
					"ru": Vector3((x * tileWidth) + tileWidth,0,(y * tileHeight) - tileHeight),
					"rd": Vector3((x * tileWidth) + tileWidth,0,(y * tileHeight) + tileHeight)
				},
				"gridPoint": Vector3(x*tileWidth,0,y*tileHeight),
				"centerPoint": Vector3(x*tileWidth + tileWidth/2,0,y*tileHeight + tileHeight/ 2)
			}
			star.add_point(id,grid[id]["gridPoint"],1)
			id += 1

#return neighbours for a tile
func GetNeighbours(id):
	var neighbours = []
	
	var l = grid[id]["neighbours"]["l"]
	var r = grid[id]["neighbours"]["r"]
	var d = grid[id]["neighbours"]["d"]
	var u = grid[id]["neighbours"]["u"]
	var lu = grid[id]["neighbours"]["lu"]
	var ld = grid[id]["neighbours"]["ld"]
	var ru = grid[id]["neighbours"]["ru"]
	var rd = grid[id]["neighbours"]["rd"]
	
	#this neihbour tile exist?
	for i in range(grid.size()):
		if l == grid[i]["gridPoint"]:
			neighbours.push_back(Vector2(i,id))
			
		if r == grid[i]["gridPoint"]:
			neighbours.push_back(Vector2(i,id))
			
		if d == grid[i]["gridPoint"]:
			neighbours.push_back(Vector2(i,id))
			
		if u == grid[i]["gridPoint"]:
			neighbours.push_back(Vector2(i,id))
		
		if lu == grid[i]["gridPoint"]:
			neighbours.push_back(Vector2(i,id))
		
		if ld == grid[i]["gridPoint"]:
			neighbours.push_back(Vector2(i,id))
			
		if ru == grid[i]["gridPoint"]:
			neighbours.push_back(Vector2(i,id))
			
		if rd == grid[i]["gridPoint"]:
			neighbours.push_back(Vector2(i,id))
	
	return neighbours


#connect neighbours points
func ConnectPoints():
	var debug = 0
	
	for id in range(grid.size()):
		var neighboursID = GetNeighbours(id)
		
		for i in range(neighboursID.size()):
			if ! star.are_points_connected(neighboursID[i].x,neighboursID[i].y):
				star.connect_points(neighboursID[i].x,neighboursID[i].y)

#make a path from a tile id to another
func MakePath(startID,endID):
	path = star.get_point_path(startID, endID)
	drawGrid = true
	drawPath = true
	update()

func AddObstacle():
	pass
	

#I'll draw the grid, path and obstacles here
func _draw():
	
	#draw the grid
	if drawGrid:
		
		for id in range(grid.size()):
			var rectPos = Vector2(0,0)
			rectPos.x = grid[id]["gridPoint"].x + offset
			rectPos.y = grid[id]["gridPoint"].z + offset
			var rect = Rect2(rectPos,Vector2(tileWidth,tileHeight))
			draw_rect(rect,Color(0,204,0))
			
			#draw a circle in the center of the grid
			var circlePos = Vector2(0,0)
			circlePos.x = grid[id]["centerPoint"].x + offset
			circlePos.y = grid[id]["centerPoint"].z + offset
			draw_circle(circlePos,8,Color(153,0,0))
			
			#add a label showing each grid center
			var label = Label.new()
			circlePos.x -= 4
			circlePos.y -= 5
			label.set_global_pos(circlePos)
			label.set_text(str(id))
			get_parent().add_child(label)
	if drawPath:
		#draw path in each tile
		for i in range(path.size()):
			
			var circlePos = Vector2()
			circlePos.x = path[i].x + tileWidth/2 + offset
			circlePos.y = path[i].z + tileHeight/2 + offset
			draw_circle(circlePos,8,Color(0,0,0))
	if obstacle:
		
		for i in range(obstacles.size()):
			var circlePos = Vector2()
			
			var obsPos = obstacles[i]
			
			circlePos.x = grid[obsPos]["centerPoint"].x + offset
			circlePos.y = grid[obsPos]["centerPoint"].z + offset
			
			draw_circle(circlePos,8,Color(0,0,204))
	

func _ready():
	#steps to make a pathfinding
	star = AStar.new()
	
	MakeGrid()
	drawGrid = true
	
	update()
	ConnectPoints()
	MakePath(0,6)
	
#create a new path
func _on_StartPath_pressed():
	var s = get_parent().get_node("UI/start").get_val()
	var e = get_parent().get_node("UI/end").get_val()
	MakePath(s,e)

#add a obstacle in a given tile
func _on_AddObstacle_pressed():
	var s = get_parent().get_node("UI/start").get_val()
	var e = get_parent().get_node("UI/end").get_val()
	star.remove_point(int(get_parent().get_node("UI/obstacles/position").get_text()))
	obstacle = true
	obstacles.push_back(int(get_parent().get_node("UI/obstacles/position").get_text()))
	MakePath(s,e)
	

