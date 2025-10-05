@tool
extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		print("run script")
		
		var st = SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)

		var normal = Vector3(0, 1, 0)  # Facing up

		# Vertex 1 (Top)
		st.set_normal(normal)
		st.set_uv(Vector2(0.5, 0))
		st.add_vertex(Vector3(0, 0.5, 0))

		# Vertex 2 (Bottom-right)
		st.set_normal(normal)
		st.set_uv(Vector2(1, 1))
		st.add_vertex(Vector3(0.5, 0.5, 0.5))

		# Vertex 3 (Bottom-left)
		st.set_normal(normal)
		st.set_uv(Vector2(0, 1))
		st.add_vertex(Vector3(-0.5, 0.5, 0.5))

		var mesh = st.commit()

		# Save it
		var save_path = "res://triangle_upward.mesh"
		var result = ResourceSaver.save(mesh, save_path)

		if result == OK:
			print("Triangle mesh saved to: ", save_path)
		else:
			print("Failed to save mesh. Error code: ", result)
