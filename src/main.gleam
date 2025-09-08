import argv
import gleam/erlang/process
import gleam/int
import gleam/io
import worker

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
            Ok(n2) -> {
              let inbox = process.new_subject()
              logic(inbox, 1, n1, n2)
              collect(inbox, 10_000)
            }
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

// Loop over all starting points
fn logic(inbox: process.Subject(Int), i: Int, n: Int, k: Int) {
  case i + 999 < n {
    True -> worker.start(inbox, i, i + 999, k)
    False -> worker.start(inbox, i, n, k)
  }
  case i < n {
    True -> {
      logic(inbox, i + 1000, n, k)
    }
    False -> Nil
  }
}

fn collect(inbox: process.Subject(Int), left: Int) {
  case left {
    0 -> Nil
    _ -> {
      let assert Ok(n) = process.receive(inbox, 2000)
      io.println(int.to_string(n))
      collect(inbox, left - 1)
    }
  }
}
