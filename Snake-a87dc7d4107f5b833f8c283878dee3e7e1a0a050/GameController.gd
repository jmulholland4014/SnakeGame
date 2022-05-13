extends Node
var snake
var window_border
var apple_pos
var x 
var y
var blocked = false
onready var player = get_node("snake/body 1")

func _ready():
	window_border = OS.get_window_size()
	var classLoad = load("res://Scripts/Snake.gd")
	snake = classLoad.new()
	draw_apple()
	$apple.visible = true
func _physics_process(_delta):
	x = player.get_position().x
	y = player.get_position().y
	var difX = abs(x - apple_pos.x)
	var difY = abs(y - apple_pos.y)
	if(!blocked):
		if(difX > difY):
			moveX()
		else:
			moveY()
func moveX():
	blocked = false
	if(apple_pos.x > x):
		move_right()
	else:
		move_left()
func moveY():
	blocked = false
	if(apple_pos.y > y):
		move_up()
	else:
		move_down()
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
	for block in snake.body.slice(1,snake.body.size()):
			if(snake.body[0] + Vector2(snake.width, 0) == block):
				blocked = true
				moveY()
				return true
	snake.direction = Vector2(snake.width,0)
func move_left():
	for block in snake.body.slice(1,snake.body.size()):
			if(snake.body[0] + Vector2(-snake.width, 0) == block):
				blocked = true
				moveY()
				return true
	snake.direction = Vector2(-snake.width,0)
func move_up():
	for block in snake.body.slice(1,snake.body.size()):
		if(snake.body[0] + Vector2(0,snake.width) == block):
			blocked = true
			moveX()
			return true
	snake.direction = Vector2(0,snake.width)
func move_down():
	for block in snake.body.slice(1,snake.body.size()):
		if(snake.body[0] + Vector2(0,-snake.width) == block):
			blocked = true
			moveX()
			return true
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
func _on_Timer_timeout():
	if(is_game_over()):
		get_tree().reload_current_scene()
	snake.move()
	draw_snake()
	if(is_apple_colide()):
		$AudioStreamPlayer2D.playing = true
		draw_apple()
		snake.is_apple_colide = true
	
