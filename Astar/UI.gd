extends Container

#script: manager user interface

var labelStart
var labelEnd
var labelPosition

var sliderStart
var sliderEnd
var sliderObstacle
var lineEdit

func _ready():
	
	labelStart = get_node("start/Start")
	labelEnd = get_node("end/End")
	labelPosition = get_node("obstacles/position")
	sliderStart = get_node("start")
	sliderEnd = get_node("end")
	sliderObstacle = get_node("obstacles")
	lineEdit = get_node("LineEdit")
	
	set_fixed_process(true)

#called every frame
func _fixed_process(delta):
	
	labelStart.set_text(str(sliderStart.get_val()))
	labelEnd.set_text(str(sliderEnd.get_val()))
	labelPosition.set_text(str(sliderObstacle.get_val()))
	sliderObstacle.set_val(int(lineEdit.get_text()))
	pass





