extends Camera3D

# Reference to the player node
@export var player_path: NodePath
var player: Node3D

# Offset from player position
@export var offset: Vector3 = Vector3(0, 2, 5)

# Smoothing (set to 0 for instant follow)
@export var follow_smoothness: float = 10.0

func _ready():
    # Get reference to the player
    if player_path:
        player = get_node(player_path)
    else:
        # Try to find player in parent or scene
        player = get_parent()

func _process(delta: float) -> void:
    if not player:
        return

    # Calculate target position based on player position + offset
    var target_position = player.global_position + offset

    # Lock X and Y, follow horizontally (X and Z in 3D space)
    # This keeps the camera at the same X and Z as player, but maintains the offset Y height
    target_position.x = player.global_position.x + offset.x
    target_position.z = player.global_position.z + offset.z
    target_position.y = player.global_position.y + offset.y

    # Smooth follow or instant
    if follow_smoothness > 0:
        global_position = global_position.lerp(target_position, follow_smoothness * delta)
    else:
        global_position = target_position

    # Make camera look at player
    look_at(player.global_position + Vector3(0, offset.y / 2, 0), Vector3.UP)
