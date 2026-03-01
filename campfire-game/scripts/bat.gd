extends Node2D

const SPEED = 60

var direction = 1

@onready var rayRight: RayCast2D = $RayRight
@onready var rayLeft: RayCast2D = $RayLeft
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta):
	if rayRight.is_colliding():
		direction = -1
		animatedSprite.flip_h = false
		
	if rayLeft.is_colliding():
		direction = 1
		animatedSprite.flip_h = true
	
	position.x += direction * SPEED * delta
	 
	
