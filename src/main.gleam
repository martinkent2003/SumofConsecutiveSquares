import argv
import gleam/erlang/process
import gleam/int
import gleam/io
import gleam/list
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
              let inbox: process.Subject(worker.OutMsg) = process.new_subject()
              logic(inbox, 1, n1, n2)
              let worker_count = logic(inbox, 1, n1, n2)
              collect(inbox, worker_count)
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
fn logic(inbox: process.Subject(worker.OutMsg), i: Int, n: Int, k: Int) -> Int {
  // end of this chunk = min(i + 9999, n)
  let chunk_end = case i + 9999 <= n {
    True -> i + 9999
    False -> n
  }
  worker.start(inbox, i, chunk_end, k)

  // Recurse only if the *next* chunk would still start within range
  case i + 10_000 <= n {
    True -> 1 + logic(inbox, i + 10_000, n, k)
    False -> 1
  }
}

fn collect(inbox: process.Subject(worker.OutMsg), left: Int) {
  case left {
    0 -> Nil
    _ -> {
      case process.receive(inbox, 10_000) {
        Ok(worker.FoundIndexes(indexes)) -> {
          // Print each matching starting index
          list.each(indexes, fn(i) { io.println(int.to_string(i)) })
          collect(inbox, left - 1)
        }
        Error(Nil) -> {
          io.println("Timed out waiting for results")
          collect(inbox, left)
          // keep waiting, or return if you prefer
        }
      }
    }
  }
}
