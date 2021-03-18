extends Sprite

var direction = Vector2(0,1)
export var speed = 100
var charge = 0
var boost = 0
export var step = 16

var energy_state = 'normal' setget set_energy_state

signal cell_completed

var last_integer_position = ipos(position)

func set_energy_state(v):
	energy_state = v
	match energy_state:
		'low': modulate = Color('#00ffff')
		'normal': modulate = Color('#ffff00')
		'high': modulate = Color('#ff00ff')

func _process(delta):
	position += direction*max(0, speed+boost)*delta
	
	var new_integer_position = ipos(position)
	if new_integer_position != last_integer_position:
		emit_signal('cell_completed', last_integer_position, energy_state)
		last_integer_position = new_integer_position
	
	if Input.is_action_pressed("ui_accept"):
		charge += 1200*delta # how much speed we store per millisecond
		boost -= 200*delta # how fast we brake while charging
		#set_energy_state('low')
	elif boost > 0:
		boost -= 1000*delta # how fast the boost bonus is depleted
		#set_energy_state('high')
	#else:
	#	set_energy_state('normal')
		
	#if energy_state != 'high' and charge > 1000:
	#	set_energy_state('high')
		
	#if energy_state != 'normal' and boost > 0 and boost < 400:
	#	set_energy_state('normal')
	
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

var last_cmd_t = 0
func turn(to):
	var cmd_t = OS.get_ticks_msec()
	if cmd_t - last_cmd_t < 100:
		yield(get_tree().create_timer(0.05), "timeout") # this is to avoid self-killing when rapidly changing direction -> TBI with pre-collision checking
		
	last_cmd_t = cmd_t
	
	
	if boost > 0:
		boost = max(0, boost-200) # how much boost is lost when turning
		
	# snap
	position = ipos(position)*step
	
	direction = to
	
func ipos(v):
	return Vector2(round(v.x/step), round(v.y/step))
	
