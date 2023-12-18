shader_type spatial;
uniform sampler2D albedo_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    // Fetch the color from the texture
    vec4 albedo_color = texture(albedo_texture, UV);
    // Mix the texture color with white for the highlight effect
    ALBEDO = mix(albedo_color.rgb, vec3(1.0, 1.0, 1.0), 0.3); // The 0.3 value can be adjusted for the highlight intensity
}

