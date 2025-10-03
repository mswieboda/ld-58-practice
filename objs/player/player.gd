extends CharacterBody3D

# Movement variables
@export var speed: float = 5.0
@export var crouch_speed: float = 2.5
@export var jump_velocity: float = 4.5
@export var acceleration: float = 10.0
@export var friction: float = 15.0

# Crouch variables
@export var normal_height: float = 2.0
@export var crouch_height: float = 1.0
@export var crouch_transition_speed: float = 10.0

# State
var is_crouching: bool = false
var current_height: float = 2.0

# Get the gravity from the project settings
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

# References (assign these in the editor or adjust as needed)
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

func _ready():
    # Initialize collision shape height
    if collision_shape and collision_shape.shape is CapsuleShape3D:
        collision_shape.shape.height = normal_height
        current_height = normal_height

func _physics_process(delta: float) -> void:
    # Handle crouch input
    handle_crouch(delta)

    # Add gravity
    if not is_on_floor():
        velocity.y -= gravity * delta

    # Handle jump
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = jump_velocity

    # Get input direction
    var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
    var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

    # Determine current speed based on crouch state
    var current_speed: float = crouch_speed if is_crouching else speed

    # Apply movement with acceleration/friction
    if direction:
        velocity.x = move_toward(velocity.x, direction.x * current_speed, acceleration * delta)
        velocity.z = move_toward(velocity.z, direction.z * current_speed, acceleration * delta)
    else:
        velocity.x = move_toward(velocity.x, 0, friction * delta)
        velocity.z = move_toward(velocity.z, 0, friction * delta)

    move_and_slide()

func handle_crouch(delta: float) -> void:
    # Toggle crouch state when C is held
    if Input.is_action_pressed("crouch"):  # You'll want to map C to a custom action
        is_crouching = true
    else:
        is_crouching = false

    # Smoothly transition collision shape height
    var target_height: float = crouch_height if is_crouching else normal_height
    current_height = lerp(current_height, target_height, crouch_transition_speed * delta)

    if collision_shape and collision_shape.shape is CapsuleShape3D:
        collision_shape.shape.height = current_height
        # Adjust position to keep feet on ground when crouching
        collision_shape.position.y = current_height / 2
