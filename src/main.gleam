import gleam/io
import gleam/string
import gleam/int
import gleam/list

@external(erlang, "io", "get_line")
fn get_line(prompt: String) -> String

pub fn main() {
  io.println("Sum of Squares: Project 1")
  
  let input = get_line("Enter numbers separated by spaces: ")
  let numbers = parse_numbers(string.trim(input))
  case numbers{
    [_,_]-> {
      let sum_of_squares = calculate_sum_of_squares(numbers)
      io.println("Sum of squares: " <> int.to_string(sum_of_squares))
      }
    _->  io.println("Warning: Invalid, not two numbers")
  }
}

fn parse_numbers(input: String) -> List(Int) {
  input
  |> string.split(" ")
  |> list.filter_map(int.parse)
}

fn calculate_sum_of_squares(numbers: List(Int)) -> Int {
  numbers
  |> list.map(fn(n) { n * n })
  |> list.fold(0, fn(acc, x) { acc + x })
}
