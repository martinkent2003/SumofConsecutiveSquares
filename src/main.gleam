import argv
import gleam/float
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
            Ok(n2) -> logic(1, n1, n2)
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

fn check_sqrt(n: Int) -> Bool {
  case int.square_root(n) {
    Ok(root) -> {
      let root_int: Int = float.round(root)
      root_int * root_int == n
    }
    Error(_) -> False
  }
}

fn sum_squares_upto(n: Int) -> Int {
  n * { n + 1 } * { 2 * n + 1 }
  |> fn(x) { x / 6 }
}

fn check_i(i: Int, k: Int) {
  let end_val = i + k - 1
  let calc = sum_squares_upto(end_val) - sum_squares_upto(i - 1)
  case check_sqrt(calc) {
    True -> {
      io.println(string.inspect(i) <> ": " <> string.inspect(calc))
    }
    False -> Nil
  }
}

// Loop over all starting points
fn logic(i: Int, n: Int, k: Int) {
  check_i(i, k)
  case i < n {
    True -> {
      logic(i + 1, n, k)
    }
    False -> Nil
  }
}
