import gleam/erlang/process
import gleam/float
import gleam/int
import gleam/otp/actor

pub type Msg {
  Start
}

/// Sends `k` back to `parent` for each n in [i..j], then stops.
pub fn start(parent: process.Subject(Int), i: Int, j: Int, k: Int) {
  let builder =
    actor.new(Nil)
    |> actor.on_message(fn(_state, msg) {
      case msg {
        Start -> {
          find_squares(parent, i, j, k)
          actor.stop()
        }
      }
    })

  // Start the actor and get its subject (2nd field!)
  let assert Ok(actor.Started(_pid, subject)) = actor.start(builder)
  process.send(subject, Start)
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

fn check_i(parent: process.Subject(Int), i: Int, k: Int) {
  let end_val = i + k - 1
  let calc = sum_squares_upto(end_val) - sum_squares_upto(i - 1)
  case check_sqrt(calc) {
    True -> {
      process.send(parent, i)
    }
    False -> Nil
  }
}

fn find_squares(parent: process.Subject(Int), i: Int, n: Int, k: Int) {
  check_i(parent, i, k)
  case i < n {
    True -> {
      find_squares(parent, i + 1, n, k)
    }
    False -> Nil
  }
}
