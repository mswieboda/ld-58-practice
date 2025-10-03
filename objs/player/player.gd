extends CharacterBody3D

# Movement variables
@export var speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var acceleration: float = 10.0
@export var friction: float = 15.0

# Get the gravity from the project settings
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
    # Add gravity
    if not is_on_floor():
        velocity.y -= gravity * delta

    # Handle jump
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = jump_velocity

    # Get input direction
    var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
    # NOTE: ignore move_up, move_down in the y direction since it's a platformer
    var direction := (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()

    # Apply movement with acceleration/friction
    if direction:
        velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
        velocity.z = move_toward(velocity.z, direction.z * speed, acceleration * delta)
    else:
        velocity.x = move_toward(velocity.x, 0, friction * delta)
        velocity.z = move_toward(velocity.z, 0, friction * delta)

    move_and_slide()
