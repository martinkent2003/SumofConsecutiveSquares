import gleam/erlang/process
import gleam/float
import gleam/int
import gleam/list
import gleam/otp/actor

// What the parent will receive
pub type OutMsg {
  FoundIndexes(List(Int))
}

// Internal trigger for the worker
type Msg {
  Start
}

/// Spawns an actor that checks every n in [i..j], collects all i that match,
/// sends one FoundIndexes([...]) to `parent`, then terminates.
pub fn start(parent: process.Subject(OutMsg), i: Int, j: Int, k: Int) {
  let builder =
    actor.new(Nil)
    |> actor.on_message(fn(_state, msg) {
      case msg {
        Start -> {
          let results = find_squares(i, j, k, [])
          process.send(parent, FoundIndexes(list.reverse(results)))
          actor.stop()
        }
      }
    })

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

fn sum_squares(n: Int) -> Int {
  n * { n + 1 } * { 2 * n + 1 } |> fn(x) { x / 6 }
}

// True if the window starting at i of length k is a perfect-square sum
fn check_match(i: Int, k: Int) -> Bool {
  let end_val = i + k - 1
  let calc = sum_squares(end_val) - sum_squares(i - 1)
  check_sqrt(calc)
}

fn find_squares(i: Int, j: Int, k: Int, squares: List(Int)) -> List(Int) {
  case i <= j {
    True -> {
      let squares2 = case check_match(i, k) {
        True -> [i, ..squares]
        False -> squares
      }
      find_squares(i + 1, j, k, squares2)
    }
    False -> squares
  }
}
