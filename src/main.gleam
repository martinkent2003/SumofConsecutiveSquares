import argv
import gleam/int
import gleam/io
import gleam/string
import gleam/otp/actor
import gleam/erlang/process.{type Subject}

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
  let assert Ok(actor) =
    actor.new([])
    |> actor.on_message(handle_message)
    |> actor.start()

  let subject = actor.data

  process.send(subject, Push("Joe"))
  process.send(subject, Push("Mike"))
  process.send(subject, Push("Robert"))
  //send some messages to the actor
  //actor.send(actor.data, Add(5))
  

  let assert Ok("Robert") = process.call(subject, 10, Pop)
  let assert Ok("Mike") = process.call(subject, 10, Pop)
  let assert Ok("Joe") = process.call(subject, 10, Pop)

  let assert Error(Nil) = process.call(subject, 10, Pop)
  process.send(subject, Shutdown)
  //send a message and get a reply
  //assert actor.call(actor.data, waiting:10, sending: Get) == 8

}

pub fn handle_message(stack: List(e), message: Message(e),) -> actor.Next(List(e), Message(e)) {
  case message{
    Shutdown -> actor.stop()
    Push(value) -> {
      let new_state = [value, ..stack]
      io.println("Pushed")
      io.println(string.inspect(stack))
      actor.continue(new_state)
    }
    Pop(client) -> {
      case stack{
        [] ->{
          process.send(client, Error(Nil))
          actor.continue([])
        }
        [first, ..rest] -> {
          process.send(client, Ok(first))
          actor.continue(rest)
        }
      }
    }
  }
}

pub type Message (element){
  Shutdown
  Push(push: element)
  Pop(reply_with: Subject(Result(element, Nil)))
}