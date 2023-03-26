module vmsgp

// read_string reads string from the Decoder
pub fn (mut s Decoder) read_string() !string {
	size := s.string_length() or { return err }

	mut fb := []u8{len: int(size)}
	s.br.read_bytes(mut fb) or { return err }
	str := fb.bytestr()
	return str
}

// write_string writes string to the Encoder
pub fn (mut w Encoder) write_sring(str string) !int {
	w.write_sring_lenght(str.len)!
	return w.bw.write_bytes(str.bytes())
}

[inline]
fn (mut s Decoder) string_length() !u32 {
	ch := s.read_container_header() or { return err }
	match ch.dtype {
		mstr8, mstr16, mstr32 {
			return ch.size
		}
		else {
			if isfixstr(ch.dtype) {
				return ch.size
			}
		}
	}
	return IError(ErrWrongType{
		dt: ch.dtype
	})
}

[inline]
fn (mut w Encoder) write_sring_lenght(n i32) !int {
	return w.write_container_header(n, .msgp_string)
}
