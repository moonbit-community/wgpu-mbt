///|
pub fn rgba_bytes(r : UInt, g : UInt, b : UInt, a : UInt) -> Bytes {
  let b0 = (r & 0xFF).reinterpret_as_int().to_byte()
  let b1 = (g & 0xFF).reinterpret_as_int().to_byte()
  let b2 = (b & 0xFF).reinterpret_as_int().to_byte()
  let b3 = (a & 0xFF).reinterpret_as_int().to_byte()
  Bytes::from_array([b0, b1, b2, b3])
}
