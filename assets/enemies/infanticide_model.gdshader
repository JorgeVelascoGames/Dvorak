shader_type spatial;
render_mode cull_disabled;

// Ahora los colores incluyen el canal alfa (vec4).
uniform vec4 base_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 inside_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float dissolve_amount: hint_range(0.0, 1.0) = 0.0;

uniform vec3 glow_color: source_color = vec3(1.0, 0.0, 0.0);
uniform float glow_intensity = 5.0;
uniform float glow_border_width: hint_range(0.0, 0.25) = 0.05;
uniform float glow_border_smoothness: hint_range(0.0, 0.1) = 0.04;

uniform sampler2D noise_texture;

void fragment() {
    float dissolve_noise = texture(noise_texture, UV).r;

    float border_mask = 0.0;
    if (dissolve_amount > 0.0) {
        float border_size = dissolve_amount + glow_border_width;

        border_mask = 1.0 - smoothstep(
            border_size - glow_border_smoothness,
            border_size + glow_border_smoothness,
            dissolve_noise
        );
    }

    // Mezcla para el color de emisión (rojo por defecto).
    vec3 surface_emission = mix(vec3(0.0), glow_color, border_mask);

    // Mezclamos el color base con "negro" (o vacío) según el border_mask.
    // Ojo: ahora base_color es un vec4.
    vec4 surface_color = mix(base_color, vec4(0.0), border_mask);

    // Al mirar la cara posterior, usamos inside_color
    if (!FRONT_FACING) {
        surface_color = inside_color;
    }

    // ALBEDO solo usa la parte rgb
    ALBEDO = surface_color.rgb;
    
    // El alfa final mezcla la alpha original con la máscara de disolución
    ALPHA = surface_color.a * dissolve_noise;
    
    // Usamos dissolve_amount para cortar píxeles si lo deseas
    ALPHA_SCISSOR_THRESHOLD = dissolve_amount;

    // Ajustes de iluminación
    EMISSION = surface_emission * glow_intensity;
    ROUGHNESS = 0.5;
}

