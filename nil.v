module vmsgp

// read_nil() reads nil value
pub fn (mut s Decoder) read_nil() !bool {
	b := s.read_byte()!
	return b == mnil
}

// write_nil() writes nil value
pub fn (mut e Encoder) write_nil() !int {
	mut buf := []u8{len: 0, cap: 1}
	buf[0] = mnil
	return e.bw.write_bytes(buf)
}
