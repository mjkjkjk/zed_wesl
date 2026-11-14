; Comments

(line_comment) @comment
(block_comment) @comment

((line_comment) @comment.doc
  (#match? @comment.doc "^///"))

((block_comment) @comment.doc
  (#match? @comment.doc "^/\\*\\*"))

; Literals

(bool_literal) @boolean
(int_literal) @number
(hex_int_literal) @number
(float_literal) @number

; Imports (WESL)

(import_statement
  ["import"] @keyword.import)

(preproc_bevy_import
  ["#import"] @keyword.import)

[
  (import_path
    (identifier) @namespace)
  (ident_path
    (identifier) @namespace)
]

((ident_path
   (identifier) @type)
  (#match? @type "^[A-Z]"))

(import_item
  name: (identifier) @namespace)

((import_item
   name: (identifier) @type)
  (#match? @type "^[A-Z]"))

(import_item
  "as" @keyword.import)

(visibility) @keyword

; Declarations

(function_header
  name: (identifier) @function)

(call_expression
  (identifier) @function.call)

(func_call_statement
  (identifier) @function.call)

(struct_decl
  name: (identifier) @type)

(type_alias_decl
  name: (identifier) @type)

(variable_decl
  name: (identifier) @variable)

(global_value_decl
  name: (identifier) @constant)

(variable_or_value_statement
  name: (identifier) @variable)

(param
  name: (identifier) @variable.parameter)

(struct_member
  name: (identifier) @property)

(named_component_expression
  component: (identifier) @property)

(swizzle_name) @property

; Types

; All identifiers used in a type position are types.
(type_specifier
  (identifier) @type)

; Type arguments of built-in templates, e.g. `vec4<MyType>` or
; `array<vec4<f32>, 4>`.
(type_specifier
  (template_list
    (identifier) @type))

(type_specifier
  (template_list
    (template_list
      (identifier) @type)))

; Built-in scalar, vector, matrix, texture and container types.
((identifier) @type.builtin
  (#match? @type.builtin "^(bool|i32|u32|f32|f16|vec[234][fiuh]?|mat[234]x[234][fh]?|array|ptr|atomic|sampler|sampler_comparison|texture_[0-9a-z_]+)$"))

; Constructors of user-defined and built-in types, e.g. `Vertex(...)`.
((call_expression
   (identifier) @type)
  (#match? @type "^[A-Z]"))

; Constant-like identifiers, e.g. PI or MAX_LIGHTS.
((identifier) @constant
  (#match? @constant "^[A-Z][A-Z0-9_]*$"))

; Attributes

(attribute
  name: (identifier) @attribute)

((attribute
   name: (identifier) @keyword.directive)
  (#any-of? @keyword.directive "if" "elif" "else" "test"))

(attribute
  "@" @punctuation.special)

((attribute
   name: (identifier) @attribute
   arguments: (argument_list
     (identifier) @constant.builtin))
  (#eq? @attribute "builtin"))

(variable_decl
  (template_list
    (identifier) @keyword
    (#any-of? @keyword
      "function" "private" "workgroup" "uniform" "storage"
      "read" "write" "read_write")))

((template_list
   (identifier) @keyword)
  (#any-of? @keyword
    "function" "private" "workgroup" "uniform" "storage"
    "read" "write" "read_write"))

; Keywords

[
  "fn"
  "struct"
  "alias"
  "var"
  "let"
  "const"
  "override"
  "virtual"
  "public"
  "private"
] @keyword

[
  "if"
  "else"
  "switch"
  "case"
  "default"
  "loop"
  "for"
  "while"
  "break"
  "continue"
  "continuing"
  "return"
  "discard"
] @keyword.control

[
  "enable"
  "requires"
  "diagnostic"
  "const_assert"
] @keyword.directive

(preproc_directive) @preproc

; Operators

[
  "+"
  "-"
  "*"
  "/"
  "%"
  "&"
  "|"
  "^"
  "!"
  "~"
  "="
  "+="
  "-="
  "*="
  "/="
  "%="
  "&="
  "|="
  "^="
  "++"
  "--"
  "->"
  "&&"
  "||"
  "=="
  "!="
  (less_than)
  (greater_than)
  (less_than_equal)
  (greater_than_equal)
  (shift_left)
  (shift_right)
  (shift_left_assign)
  (shift_right_assign)
] @operator

; Punctuation

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
  (template_args_start)
  (template_args_end)
] @punctuation.bracket

[
  ","
  "."
  ":"
  "::"
  ";"
] @punctuation.delimiter
