extends Control

@onready var viewport_texture: TextureRect = %ViewportTexture
@onready var sub_viewport: SubViewport = %SubViewport
@onready var camera_3d: Camera3D = %Camera3D
@onready var middle: Node2D = %Middle

var world_viewport_container: SubViewportContainer
var world: Node3D
var moving: bool = false


func _ready() -> void:
	gui_input.connect(on_gui_input)
	set_world_viewport_container()
	set_world()
	set_camera()


func on_gui_input(event: InputEvent):
	if event.is_action_pressed("interact"):
		print("left click pressed")
		moving = true
	elif event.is_action_released("interact"):
		print("left click released")
		moving = false


func _unhandled_input(event):
	if moving && event is InputEventMouseMotion:
		global_position += Vector2(event.relative.x, event.relative.y)
		var pos = world.camera_3d.project_position(middle.global_position - world_viewport_container.global_position, 0) as Vector3
		camera_3d.global_position = pos
		print(pos)


func set_world_viewport_container():
	world_viewport_container = get_tree().get_first_node_in_group("world_viewport_container") as SubViewportContainer
	if !world_viewport_container:
		print("Could not find world viewport container during DynoScope setup")
		return


func set_world():
	var world_viewport = get_tree().get_first_node_in_group("world_viewport") as SubViewport
	if !world_viewport:
		print("Could not find world viewport during DynoScope setup")
		return

	sub_viewport.world_3d = world_viewport.world_3d
	sub_viewport.size = world_viewport.size
	
	
func set_camera():
	var curr_world = get_tree().get_first_node_in_group("world") as Node3D
	if !curr_world:
		print("Could not find world during DynoScope setup")
		return

	world = curr_world
	camera_3d.global_position = world.camera_3d.global_position
	camera_3d.rotation = world.camera_3d.rotation
	viewport_texture.texture = sub_viewport.get_texture()
