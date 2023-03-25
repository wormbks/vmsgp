module msgp

fn test_make_without_value() {
	bb := make_buf_writer(0)
	assert bb.buf.len == 0
}

fn test_make_with_value() {
	bb := make_buf_writer(64)
	assert bb.buf.len == 0
	assert bb.buf.cap == 64
}

fn test_write() {
	b := [u8(0x0A), 0xCC, 0xFE] // 10, 254
	mut bw := make_buf_writer(2)
	bw.write_bytes(b) or { -1 }
	assert bw.buf.len == 3
}

fn test_prefix() {
	mut buf := []u8{len: 0, cap: 12}
	prefixu16(mut buf, mstr16, u16(432))
	// println("${buf} $buf.len")
	assert buf.len == 3
}
