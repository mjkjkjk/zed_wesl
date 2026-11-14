# WESL for Zed

[WESL](https://wesl-lang.dev) and Bevy [`naga_oil`](https://github.com/bevyengine/naga_oil)
shader support for Zed, powered by
[`tree-sitter-wesl`](https://github.com/wgsl-tooling-wg/tree-sitter-wesl).

Handles WESL modules, plain WGSL, and `.wgsl` files using Bevy's preprocessor.

## Features

- WESL imports, aliases, wildcards, visibility, and qualified paths
- `@if` / `@elif` / `@else` conditional compilation
- Bevy `#import`, `#define`, `#ifdef`, `#ifndef`, `#else`, `#endif`, `virtual`, and `override`
- Syntax highlighting, brackets, indentation, outline, text objects, and comment injection

## Install

Open **Extensions** in Zed, click **Install Dev Extension**, and select this
repository. Zed compiles the Tree-sitter grammar on first install.

## File associations

`.wesl` and `.wgsl` both use the WESL language. If another WGSL extension also
claims `.wgsl`, pick the language from the language selector or add:

```json
{
  "file_types": {
    "WESL": ["wesl", "wgsl"]
  }
}
```

## Bevy

```wgsl
#import bevy_pbr::mesh_view_bindings::view
#import bevy_pbr::forward_io::{Vertex, VertexOutput}

#ifdef TONEMAP_IN_SHADER
#import bevy_core_pipeline::tonemapping::tone_mapping
#endif

@vertex
fn vertex(vertex: Vertex) -> VertexOutput {
  var out: VertexOutput;
  out.clip_position = view.view_proj * vec4<f32>(vertex.position, 1.0);
  return out;
}
```

This extension is syntax-only. Linking and validation happen in Bevy through
the `wesl` / `naga_oil` crates.

## Optional language server

No LSP is bundled. To use
[`wesl-lsp`](https://github.com/fdatoo/wesl-lsp) or
[`wgsl-analyzer`](https://github.com/wgsl-analyzer/wgsl-analyzer), configure it
in `settings.json`:

```json
{
  "lsp": {
    "wesl-lsp": {
      "binary": { "path": "/path/to/wesl-lsp" }
    }
  },
  "languages": {
    "WESL": {
      "language_servers": ["wesl-lsp"]
    }
  }
}
```

`wgsl-analyzer` does not understand every WESL extension yet and may report
errors on valid files.

## Development

The grammar is pinned in `extension.toml`; queries are in `languages/wesl/`.
To check queries:

```sh
git clone https://github.com/wgsl-tooling-wg/tree-sitter-wesl /tmp/tree-sitter-wesl
cd /tmp/tree-sitter-wesl
npx --yes tree-sitter-cli@0.25.8 query \
  /path/to/zed_wesl/languages/wesl/highlights.scm \
  /path/to/zed_wesl/examples/hello.wesl
```

## Credits

- [tree-sitter-wesl](https://github.com/wgsl-tooling-wg/tree-sitter-wesl), MIT /
  Apache-2.0, with portions derived from
  [tree-sitter-wgsl](https://github.com/gpuweb/tree-sitter-wgsl) under the W3C
  Software and Document License.
- Query design inspired by
  [`lucascompython/wgsl-wesl-zed`](https://github.com/lucascompython/wgsl-wesl-zed)
  and [`fdatoo/wesl-zed`](https://github.com/fdatoo/wesl-zed), both MIT licensed.
