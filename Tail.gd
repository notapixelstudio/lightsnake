extends Line2D

var direction = Vector2(0,1)
export var speed = 150
var charge = 0
var boost = 0
export var step = 16

func _process(delta):
	points[-1] += direction*max(0, speed+boost)*delta
	
	if Input.is_action_pressed("ui_accept"):
		charge += 1200*delta # how much speed we store per millisecond
		boost -= 200*delta # how fast we brake while charging
	elif boost > 0:
		boost -= 1000*delta # how fast the boost bonus is depleted
	
func _input(event):
	if Input.is_action_just_pressed("ui_right") and direction.x == 0:
		turn(Vector2(1,0))
	elif Input.is_action_just_pressed("ui_left") and direction.x == 0:
		turn(Vector2(-1,0))
	elif Input.is_action_just_pressed("ui_up") and direction.y == 0:
		turn(Vector2(0,-1))
	elif Input.is_action_just_pressed("ui_down") and direction.y == 0:
		turn(Vector2(0,1))
		
	if Input.is_action_just_released("ui_accept"):
		boost = charge
		charge = 0

func turn(to):
	if boost > 0:
		boost = max(0, boost-200) # how much boost is lost when turning
		
	# snap
	points[-1] = Vector2(round(points[-1].x/step), round(points[-1].y/step))*step
	# leave a point here
	add_point(points[-1])
	direction = to
	
