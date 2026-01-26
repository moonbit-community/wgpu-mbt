///|
/// A tiny in-process trace log ("beads") used by tests/examples to record a
/// linear sequence of events.

///|
let enabled : Ref[Bool] = @ref.new(true)

///|
let items : Ref[Array[String]] = @ref.new([])

///|
pub fn beads_set_enabled(v : Bool) -> Unit {
  enabled.val = v
}

///|
pub fn beads_record(msg : String) -> Unit {
  if enabled.val {
    items.val.push(msg)
  }
}

///|
pub fn beads_take() -> Array[String] {
  let out = items.val
  items.val = []
  out
}
