; Brace-delimited blocks.
(_
  "{"
  "}" @end) @indent

; Parenthesized argument and parameter lists.
(_
  "("
  ")" @end) @indent

; Indexing and array types.
(_
  "["
  "]" @end) @indent

; Template argument lists, e.g. `array<vec4<f32>, 4>`.
(_
  (template_args_start)
  (template_args_end) @end) @indent
