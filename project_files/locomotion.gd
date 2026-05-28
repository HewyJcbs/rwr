extends XROrigin3D

@export var move_speed: float = 2.5
@export var deadzone: float = 0.15
@export var rotation_angle: float = 45.0

@onready var xr_camera: XRCamera3D = $XRCamera3D
@onready var left_ctrl: XRController3D = $LeftController
@onready var right_ctrl: XRController3D = $RightController

var rotation_cooldown: bool = false

func _physics_process(delta: float) -> void:
    var dir := Vector3.ZERO

    var fwd := -xr_camera.global_transform.basis.z
    fwd.y = 0.0
    fwd = fwd.normalized()

    var right := xr_camera.global_transform.basis.x
    right.y = 0.0
    right = right.normalized()

    var v: Vector2 = left_ctrl.get_vector2("thumbstick")
    if v.length() < deadzone:
        v = Vector2.ZERO

    dir += fwd * v.y + right * v.x

    if dir.length() > 0.0:
        global_translate(dir.normalized() * move_speed * delta)

    var r_v: Vector2 = right_ctrl.get_vector2("thumbstick")
    
    if abs(r_v.x) > 0.5:
        if not rotation_cooldown:
            var turn_sign = -sign(r_v.x)
            var cam_pos = xr_camera.global_position
            global_translate(-cam_pos)
            global_rotate(Vector3.UP, deg_to_rad(rotation_angle * turn_sign))
            global_translate(cam_pos)
            rotation_cooldown = true
    else:
        if abs(r_v.x) < deadzone:
            rotation_cooldown = false
