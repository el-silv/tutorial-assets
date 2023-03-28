extends CharacterBody2D

@export var max_speed := Vector2(180, 500)
@export var walk_acceleration := 1200
@export var jump := 400
@export var gravity := 850

var initial_pos := Vector2.ZERO

func _ready() -> void:
	initial_pos = position

func _physics_process(delta):
	# Dir + Vel -> 2
	var walk_direction = Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left")
	
	velocity += Vector2(walk_direction * walk_acceleration * delta, 0)
	
	# Drag -> 4
	var drag = walk_acceleration * abs(sign(velocity.x) - walk_direction) * delta
	if abs(velocity.x) < drag:
		velocity.x = 0
	else:
		velocity.x -= drag * sign(velocity.x)
	
	# Gravity -> 5
	velocity.y += gravity * delta
	
	# Jump -> 6
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump
#		gravity = gravity_jumping
		
#	if not is_on_floor() and Input.is_action_just_released("jump"):
#		gravity = gravity_normal
	
	# Clamp -> 3
	velocity.x = clamp(velocity.x, -max_speed.x, max_speed.x)
	velocity.y = clamp(velocity.y, -jump, max_speed.y)
	
	# Apply -> 1
	set_velocity(velocity)
	move_and_slide()
	
	# Extra
	if is_on_floor():
		if velocity.x == 0:
			$Sprite.animation = "idle"
		else:
			$Sprite.animation = "walk"
	else:
		$Sprite.animation = "jump"
	
	if velocity.x > 0:
		$Sprite.flip_h = true
	elif velocity.x < 0:
		$Sprite.flip_h = false

#func _on_Hazards_body_entered(body: Node) -> void:
#	if body == self:
#		position = initial_pos
#		OverDraw.get_child(0).deaths += 1


#func _on_Flag_body_entered(body: Node) -> void:
#	if body == self:
#		print("yay")
