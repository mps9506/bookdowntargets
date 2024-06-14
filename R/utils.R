# From tarchetypes:::`%|||%`
`%|||%` <- function(x, y) {
  if (is.null(x)) {
    y
  }
  else {
    x
  }
}

# From tarchetypes:::as_symbols
as_symbols <- function(x) {
  lapply(x, as.symbol)
}

# From tarchetypes:::call_function
call_function <- function(name, args) {
  as.call(c(as.symbol(name), args))
}

# From tarchetypes:::call_list
call_list <- function(args) {
  call_function("list", args)
}
