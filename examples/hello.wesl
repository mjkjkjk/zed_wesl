// WESL example: imports, aliases, nested imports, and conditional compilation.
import package::utils::color::red;
import package::utils::color::{chartreuse, teal};
import random_wgsl::pcg_2u_3f as pcg;

@if(DEBUG)
import package::utils::debug;

struct Camera {
  view_proj: mat4x4f,
}

@group(0) @binding(0) var<uniform> camera: Camera;

@fragment
fn fs_main(@location(0) uv: vec2f) -> @location(0) vec4f {
  @if(DEBUG)
  debug::draw_grid(uv);

  var color = vec4f(0.0);
  @if(DEBUG && SHOW_HEATMAP)
  color = red();
  @elif(SHOW_HEATMAP)
  color = chartreuse();
  @else
  color = teal();

  let noise = pcg(1u, 2u);
  let light_count = constants::NumLights;
  return color * noise * f32(light_count);
}
