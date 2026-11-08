-- Protocol Buffers via buf.
return {
  parsers = { "proto" },
  servers = { buf_ls = true },
  formatters = { proto = { "buf" } },
  tools = { "buf" },
}
