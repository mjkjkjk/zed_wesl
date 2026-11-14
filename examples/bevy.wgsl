// Bevy / naga_oil example.
#import bevy_pbr::mesh_view_bindings::view
#import bevy_pbr::forward_io::{Vertex, VertexOutput}

#ifdef TONEMAP_IN_SHADER
#import bevy_core_pipeline::tonemapping::tone_mapping
#endif

struct VertexOutput {
  @builtin(position) clip_position: vec4<f32>,
}

@vertex
fn vertex(vertex: Vertex) -> VertexOutput {
  var out: VertexOutput;
  out.clip_position = view.view_proj * vec4<f32>(vertex.position, 1.0);
  return out;
}

@fragment
fn fragment(@location(0) world_position: vec4<f32>) -> @location(0) vec4<f32> {
  var color = vec4<f32>(world_position.xyz, 1.0);
  #ifdef TONEMAP_IN_SHADER
  color = tone_mapping(color);
  #endif
  return color;
}
