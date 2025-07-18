extends CharacterBody2D

@export var speed = 300
@export var jump_force = -400.0
@export var gravity = 980.0

var screen_size
var can_jump = true

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_jump = true
	
	# Movimiento horizontal (ahora continuo mientras se mantenga la tecla)
	var horizontal_input = 0
	if Input.is_action_pressed("p2move_right"):
		horizontal_input = 1
	if Input.is_action_pressed("p2move_left"):
		horizontal_input = -1
	
	velocity.x = horizontal_input * speed
	
	# Salto (solo si está en el suelo)
	if Input.is_action_just_pressed("p2move_up") and can_jump:
		velocity.y = jump_force
		can_jump = false
	
	# Mover el personaje usando la física integrada
	move_and_slide()
	
	# Mantener dentro de la pantalla
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# Animaciones
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "quiet"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.y < 0  # Esto volteará el sprite cuando se mueva a la izquierda
		$AnimatedSprite2D.play()
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "quick"
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
