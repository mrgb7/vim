;; extends
;; Extra Go captures layered on top of nvim-treesitter's highlights.
;; priority 130 > LSP semantic tokens (125) so these win over gopls colors.

; `err` stands out so error paths are easy to follow
(((identifier) @variable.go.err
  (#eq? @variable.go.err "err"))
  (#set! priority 130))

; exported (public API) declarations are bold
((function_declaration
  name: (identifier) @function.go.exported)
  (#lua-match? @function.go.exported "^%u")
  (#set! priority 130))

((method_declaration
  name: (field_identifier) @function.go.exported)
  (#lua-match? @function.go.exported "^%u")
  (#set! priority 130))

((type_spec
  name: (type_identifier) @type.go.exported)
  (#lua-match? @type.go.exported "^%u")
  (#set! priority 130))

; interface vs struct definitions get different colors
((type_spec
  name: (type_identifier) @type.go.interface
  type: (interface_type))
  (#set! priority 131))

; struct tags: `json:"name,omitempty"`
((field_declaration
  tag: (raw_string_literal) @string.go.tag)
  (#set! priority 130))

; goroutines and defer change control flow: make them visible
(("go" @keyword.go.flow) (#set! priority 130))
(("defer" @keyword.go.flow) (#set! priority 130))
