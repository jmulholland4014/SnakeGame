extends Node
var snake
var window_border
var apple_pos
var x 
var y
var safe = true
var upBlocked = false
var downBlocked = false
var rightBlocked = false
var leftBlocked = false
var decidingMove = false
var rng
var xBlocked = false
var yBlocked = false
onready var player = get_node("snake/body 1")

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	window_border = OS.get_window_size()
	var classLoad = load("res://Scripts/Snake.gd")
	snake = classLoad.new()
	draw_apple()
	$apple.visible = true

func moveX():	
	if(rightBlocked && leftBlocked):
		xBlocked = true
		return true
	elif(rightBlocked):
		move_left()
	elif(leftBlocked):
		move_right()
	else:
		if(apple_pos.x >=x):
			move_right()
		elif(!leftBlocked):
			move_left()
func moveY():
	if(upBlocked && downBlocked):
		yBlocked = true
		return true
	elif(downBlocked):
		move_up()
	elif(upBlocked):
		move_down()
	else:
		if(apple_pos.y >= y):
			move_down()
		else:
			move_up()
	return true
func get_random_pos_for_apple():
	randomize()
	var applex= (randi() % 20) * snake.width
	var appley= (randi() % 20) * snake.width
	apple_pos = Vector2(applex,appley)
	return Vector2(applex,appley)
	
func draw_apple():
	var new_rand_pos = get_random_pos_for_apple()
	for block in snake.body:
		if block == new_rand_pos:
			new_rand_pos = get_random_pos_for_apple()
			continue
		if(block == snake.body[snake.body.size()-1]):
			$apple.position = new_rand_pos
		


func draw_snake():
	if(snake.body.size() > $snake.get_child_count()):
		var lastChilde = $snake.get_child($snake.get_child_count()-1).duplicate()
		lastChilde.name = "body " + str($snake.get_child_count())
		$snake.add_child(lastChilde)	
	for index in range(0,snake.body.size()):
		$snake.get_child(index).rect_position = snake.body[index]

func is_apple_colide():
	if(snake.body[0] == $apple.position):
		return true
	return false
func move_right():
	print("Moving Right")
	snake.direction = Vector2(snake.width,0)
func move_left():
	print("Moving Left")
	snake.direction = Vector2(-snake.width,0)
func move_down():
	print("Moving down")
	snake.direction = Vector2(0,snake.width)
func move_up():
	print("Moving up")
	snake.direction = Vector2(0,-snake.width)
func is_game_over():
	if(snake.body[0].x < 0 || snake.body[0].x > window_border.x - snake.width):
		return true
	elif(snake.body[0].y < 0 || snake.body[0].y > window_border.y - snake.width):
		return true
	if(snake.body.size() >= 3):
		for block in snake.body.slice(1,snake.body.size()):
			if(snake.body[0] == block):
				return true
	return false
func choose_direction():
	x = player.get_position().x
	y = player.get_position().y
	var difX = abs(x - apple_pos.x)
	var difY = abs(y - apple_pos.y)
	if(((difX > difY) && !xBlocked) || yBlocked):
		moveX()
	else:
		moveY()
func checkSafety():
	for block in snake.body.slice(1,snake.body.size()):
		if(snake.body[0] + snake.direction == block):
			if snake.direction == Vector2(0,-snake.width):
				upBlocked = true
			elif snake.direction == Vector2(0,snake.width):
				downBlocked = true
			elif snake.direction == Vector2(snake.width,0):
				rightBlocked = true
			else:
				leftBlocked = true
			safe = false
	if((snake.body[0] + snake.direction).x < 0 || (snake.body[0] + snake.direction).x > window_border.x - snake.width):
		if snake.direction == Vector2(0,-snake.width):
			upBlocked = true
		elif snake.direction == Vector2(0,snake.width):
			downBlocked = true
		elif snake.direction == Vector2(snake.width,0):
			rightBlocked = true
		else:
			leftBlocked = true
		safe = false
	if((snake.body[0] + snake.direction).y < 0 || (snake.body[0] + snake.direction).y > window_border.y - snake.width):
		if snake.direction == Vector2(0,-snake.width):
			upBlocked = true
		elif snake.direction == Vector2(0,snake.width):
			downBlocked = true
		elif snake.direction == Vector2(snake.width,0):
			rightBlocked = true
		else:
			leftBlocked = true
		safe = false
	if(!safe):
		if(leftBlocked):
			print("LeftBlocked")
		if(rightBlocked):
			print("RightBlocked")
		if(upBlocked):
			print("UpBlocked")
		if(downBlocked):
			print("downBlocked")
		if(xBlocked):
			print("xBlocked")
		if(yBlocked):
			print("yBlocked")
		return true
	safe = true
func reset_variables():
	upBlocked = false
	downBlocked = false
	leftBlocked = false
	rightBlocked = false
	yBlocked = false
	xBlocked = false
	safe = true
		
func _on_Timer_timeout():
	if(is_game_over()):
		get_tree().paused = true
	choose_direction()
	checkSafety()
	if !safe:
		var timeout = 0
		while !safe:
			print(timeout)
			timeout+=1
			choose_direction()
			print ("Try" + str(snake.direction))
			checkSafety()
			if timeout == 4:
				safe =true
			if timeout == 5:
				get_tree().paused = true
	snake.move()
	reset_variables()
	draw_snake()
	if(is_apple_colide()):
		$AudioStreamPlayer2D.playing = true
		draw_apple()
		snake.is_apple_colide = true
	
