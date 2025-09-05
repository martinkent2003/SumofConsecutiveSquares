import argv
import gleam/int
import gleam/io
import gleam/string

pub fn main() {
  let args = argv.load().arguments
  case args {
    // Parse arguments to int and check for errors
    [arg1, arg2] -> {
      let parsed1 = int.parse(arg1)
      let parsed2 = int.parse(arg2)
      case parsed1 {
        Ok(n1) ->
          case parsed2 {
            Ok(n2) -> logic(n1, n2)
            Error(_) -> io.println(arg2 <> " is not a valid integer")
          }
        Error(_) -> io.println(arg1 <> " is not a valid integer")
      }
    }

    // Handle case where not enough arguments are provided
    _ ->
      io.println("Please provide two int arguments, e.g. gleam run 1000000 4")
  }
}

fn logic(arg1: int, arg2: int) {
  io.println(
    "Doing logic with "
    <> string.inspect(arg1)
    <> " and "
    <> string.inspect(arg2),
  )
}


//