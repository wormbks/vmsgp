module vmsgp

// read_bool reads bool value from the Decoder
pub fn (mut s Decoder) read_bool() !bool {
	mut fb := []u8{len: 1}
	s.br.read_bytes(mut fb) or { return err }
	val := fb[0]
	if (val != mfalse) && (val != mtrue) {
		return IError(ErrWrongType{
			dt: val
		})
	}
	return val == mtrue
}

// write_bool writes  bool value to  the Encoder
pub fn (mut e Encoder) write_bool(b bool) !int {
	mut buf := []u8{len: 0, cap: 1}
	if b {
		buf[0] = mtrue
	} else {
		buf[0] = mfalse
	}
	return e.bw.write_bytes(buf)
}
