# WESL for Zed

Language support for [WESL](https://wesl-lang.dev), the WebGPU Extended Shading
Language, and for WGSL shaders that use [Bevy](https://bevyengine.org)'s
`naga_oil` preprocessor.

WESL is a strict superset of WGSL. This extension uses the
[`tree-sitter-wesl`](https://github.com/wgsl-tooling-wg/tree-sitter-wesl)
grammar, so the same language handles plain WGSL, WESL modules, and Bevy's
shader extensions.

## Features

- Syntax highlighting for WESL and WGSL
- WESL `import` statements, including nested imports, aliases, wildcards, and
  `public` / `private` visibility
- WESL conditional compilation with `@if`, `@elif`, and `@else`
- Qualified paths such as `package::utils::color`, `super::util`, and
  `constants::NumLights`
- Bevy / `naga_oil` extensions, including `#import`, `#define`, `#ifdef`,
  `#ifndef`, `#else`, `#endif`, and `virtual` / `override` functions
- Bracket matching, auto-indentation, code outline, text objects, and comment
  injection
- Both `.wesl` and `.wgsl` files are associated with the language

## Installation

### As a dev extension

1. Open Zed's extension page (`zed: extensions`).
2. Click **Install Dev Extension**.
3. Select this repository.

Zed compiles the Tree-sitter grammar on first install. This requires Rust and
Zed's normal extension toolchain; Zed downloads the
[WASI SDK](https://github.com/WebAssembly/wasi-sdk) automatically if needed.

### From a published extension

Once published, install **WESL** from the Zed extension registry.

## File associations

The language is registered for both `.wesl` and `.wgsl` files so that it works
out of the box in Bevy projects, which commonly use `.wgsl` files with
`naga_oil` directives:

| Extensions | Typical use |
| --- | --- |
| `.wesl` | WESL modules linked with `wesl-rs` / `wesl` |
| `.wgsl` | WGSL or Bevy shaders with `#import` / `#ifdef` |

If another WGSL extension is installed, it may also claim `.wgsl` files. Zed
lets you choose the language for a buffer from the language selector. To make
the association explicit, add this to your Zed settings:

```json
{
  "file_types": {
    "WESL": ["wesl", "wgsl"]
  }
}
```

## Bevy

Bevy's shader pipeline uses `naga_oil` directives in `.wgsl` files. The grammar
accepts these as part of the language and highlights them as preprocessor
directives:

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

The extension only provides syntax support. Linking or validating shaders is
done by Bevy and the `wesl` / `naga_oil` crates at build time.

## Language server (optional)

This extension intentionally does not bundle a language server. For
diagnostics, go-to-definition, and completions you can configure one yourself
in Zed's `settings.json`.

For WESL projects using [`wesl-lsp`](https://github.com/fdatoo/wesl-lsp):

```json
{
  "lsp": {
    "wesl-lsp": {
      "binary": {
        "path": "/path/to/wesl-lsp"
      }
    }
  },
  "languages": {
    "WESL": {
      "language_servers": ["wesl-lsp"]
    }
  }
}
```

[`wgsl-analyzer`](https://github.com/wgsl-analyzer/wgsl-analyzer) can be used
the same way. Note that it does not understand every WESL extension yet, so it
may report errors on valid WESL files.

## Development

The grammar is pinned in `extension.toml`:

```toml
[grammars.wesl]
repository = "https://github.com/wgsl-tooling-wg/tree-sitter-wesl"
rev = "b600a65818e4dd7f4d32407d1427643c27f3c389"
```

Queries live in `languages/wesl/`. To validate them against the grammar, clone
the grammar and run the Tree-sitter CLI:

```sh
git clone https://github.com/wgsl-tooling-wg/tree-sitter-wesl /tmp/tree-sitter-wesl
cd /tmp/tree-sitter-wesl
npx --yes tree-sitter-cli@0.25.8 query \
  /path/to/zed_wesl/languages/wesl/highlights.scm \
  examples/hello.wesl
```

## Credits

- [tree-sitter-wesl](https://github.com/wgsl-tooling-wg/tree-sitter-wesl) by the
  WESL project (MIT / Apache-2.0, with portions derived from
  [tree-sitter-wgsl](https://github.com/gpuweb/tree-sitter-wgsl) under the W3C
  Software and Document License).
- Query design was informed by
  [`lucascompython/wgsl-wesl-zed`](https://github.com/lucascompython/wgsl-wesl-zed)
  and [`fdatoo/wesl-zed`](https://github.com/fdatoo/wesl-zed), both MIT licensed.
