@tool
# a 3D tool to draw lines
extends Path3D
class_name Line3D

@export_group("Line Properties")
@export_range(0.001, 2.0) var width : float = 0.2 : set = set_width
@export var segments : int = 4 : set = set_segments # make this range so your pc dont explode #TODO
@export var interval : float = 1.0 : set = set_interval # make this range so your pc dont explode #TODO

@export_group("Render Properties")
@export var smooth = false : set = set_smooth
@export var material : StandardMaterial3D : set = set_material

var point_a : Vector3
var point_b : Vector3

##
var instance
##

func set_width(prop):
	width = prop
	update_line(width,smooth,segments,interval,material)
func set_smooth(prop):
	smooth = prop
	update_line(width,smooth,segments,interval,material)
func set_segments(prop):
	segments = prop
	update_line(width,smooth,segments,interval,material)
func set_interval(prop):
	interval = prop
	update_line(width,smooth,segments,interval,material)
func set_material(prop):
	material = prop
	update_line(width,smooth,segments,interval,material)

func _ready():
	if curve == null:
		curve = load("res://addons/line_3d/default_curve.tres").duplicate()
		if point_a or point_b == null:
			curve.set_point_position(0,point_a)
			curve.set_point_position(1,point_b)
		#else:
			#curve.set_point_position(0,point_a)
			#curve.set_point_position(1,point_b)

	for child in get_children(): if child is CSGPolygon3D: child.queue_free()
	instance = CSGPolygon3D.new()
	instance.mode = CSGPolygon3D.MODE_PATH
	add_child(instance,true,0)
	instance.owner = self
	instance.path_node = get_path()
	update_line(width, smooth, segments, interval, material)

func update_line(width, smooth, segments, interval, material):

	var radius = width / 2.0
	var circle_polygon = []
	for i in range(segments):
		var angle = i * (2 * PI / segments)
		var x = radius * cos(angle)
		var y = radius * sin(angle)
		circle_polygon.append(Vector2(x, y))
	if instance == null:
		pass
	else:
		instance.polygon = PackedVector2Array(circle_polygon)
		instance.smooth_faces = smooth
		instance.material = material
		instance.path_interval = interval
		point_a = curve.get_point_position(0)
		point_b = curve.get_point_position(1)
	# TODO elif shape == 2: # Ribbon/Flat ??

