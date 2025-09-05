import gleam/io
import gleam/string
import gleam/list

pub fn main() {
  // Simple greeting
  io.println("Hello from Gleam! 🌟")
  
  // Working with strings
  let name = "World"
  let greeting = "Hello, " <> name <> "!"
  io.println(greeting)
  
  // Working with numbers
  let x = 42
  let y = 8
  let result = x + y
  io.println("42 + 8 = " <> string.inspect(result))
  
  // Working with lists
  let numbers = [1, 2, 3, 4, 5]
  let doubled = list.map(numbers, fn(n) { n * 2 })
  io.println("Original: " <> string.inspect(numbers))
  io.println("Doubled: " <> string.inspect(doubled))
  
  // Pattern matching
  let message = case x {
    42 -> "The answer to everything!"
    _ -> "Just a regular number"
  }
  io.println(message)
  
  // Custom function
  let sum = add_numbers(10, 15)
  io.println("10 + 15 = " <> string.inspect(sum))
}

// Custom function with type annotations
pub fn add_numbers(a: Int, b: Int) -> Int {
  a + b
}