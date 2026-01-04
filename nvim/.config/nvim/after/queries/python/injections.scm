; extends

(call
  function: (attribute
    object: (identifier) @object
    attribute: (identifier) @method)
  arguments: (argument_list
    (string
      (string_content) @injection.content))
  (#eq? @object "cr")
  (#eq? @method "execute")
  (#set! injection.language "sql"))
