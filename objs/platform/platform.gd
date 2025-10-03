@tool
extends StaticBody3D

# Configurable platform dimensions
@export var platform_length: float = 5.0:
    set(value):
        platform_length = value
        update_platform()

@export var platform_width: float = 2.5:
    set(value):
        platform_width = value
        update_platform()

@export var platform_height: float = 0.5:
    set(value):
        platform_height = value
        update_platform()

# References to child nodes
@onready var mesh_instance: MeshInstance3D = $mesh
@onready var collision_shape: CollisionShape3D = $collision

func _ready():
    # Initial setup
    update_platform()

func update_platform():
    # Only update if nodes exist (needed for editor updates)
    if not is_inside_tree():
        return

    if not mesh_instance or not collision_shape:
        return

    # Update mesh
    if mesh_instance.mesh is BoxMesh:
        mesh_instance.mesh.size = Vector3(platform_length, platform_height, platform_width)

    # Update collision
    if collision_shape.shape is BoxShape3D:
        collision_shape.shape.size = Vector3(platform_length, platform_height, platform_width)

# This allows live updates in the editor
func _get_configuration_warnings() -> PackedStringArray:
    var warnings = PackedStringArray()

    if not has_node("mesh"):
        warnings.append("Platform needs a MeshInstance3D child node named $mesh")

    if not has_node("collision"):
        warnings.append("Platform needs a CollisionShape3D child node named $collision")

    return warnings
