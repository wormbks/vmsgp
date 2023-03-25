module msgp

import math

// read_i64() reads i64 integer from the Decoder
pub fn (mut s Decoder) read_i64() !i64 {
	mut val := i64(0)

	dtype := s.read_byte()!

	if dtype < 128 {
		return i64(dtype)
	} else if dtype >= 224 {
		return i64(dtype)
	}
	fb := s.read_data_size_bytes(dtype)!
	match dtype {
		mint8, muint8 {
			val = i64(get_mint8(fb))
		}
		mint16, muint16 {
			val = i64(get_mint16(fb))
		}
		mint32, muint32 {
			val = i64(get_mint32(fb))
		}
		mint64 {
			val = get_mint64(fb)
		}
		else {
			return IError(ErrWrongType{
				dt: dtype
			})
		}
	}
	return val
}

// read_u64() reads u64 integer from the Decoder
pub fn (mut s Decoder) read_u64() !u64 {
	mut fb := []u8{len: 1}
	mut val := u64(0)

	dtype := s.read_byte()!

	if dtype < 128 {
		return u64(dtype)
	} else if dtype >= 224 {
		return u64(dtype) // TODO: ??? val
	}
	// get integer size
	fb = s.read_data_size_bytes(dtype) or { return err }
	match dtype {
		muint8, mint8 {
			val = u64(get_muint8(fb))
		}
		muint16, mint16 {
			val = u64(get_muint16(fb))
		}
		muint32, mint32 {
			val = u64(get_muint32(fb))
		}
		muint64, mint64 {
			val = u64(get_muint64(fb))
		}
		else {
			return IError(ErrWrongType{
				dt: dtype
			})
		}
	}
	return val
}

// write_u64() writes u64 integer to the Encoder
pub fn (mut w Encoder) write_u64(u u64) !int {
	mut buf := []u8{len: 0, cap: 9}
	if u <= math.max_u32 { // u < 4294967296
		return w.write_u32(mut buf, u32(u))
	} else {
		put_muint64(mut buf, u)
		return w.bw.write_bytes(buf)
	}
}

// write_i64() writes i64 integer to the Encoder
pub fn (mut w Encoder) write_i64(i i64) !int {
	mut buf := []u8{len: 0, cap: 9}
	if i > 0 {
		return w.write_u64(u64(i))
	} else if i < math.min_i32 { // i < -2147483647 ???
		put_mint64(mut buf, i)
		return w.bw.write_bytes(buf)
	} else {
		return w.write_i32(mut buf, int(i))
	}
}

[inline]
fn (mut w Encoder) write_u8(mut buf []u8, u u8) !int {
	if u <= math.max_i8 { // u < 128
		buf << u
	} else {
		put_muint8(mut buf, u)
	}
	return w.bw.write_bytes(buf)
}

[inline]
fn (mut w Encoder) write_i8(mut buf []u8, i i8) !int {
	if (i < -32) || (i > math.max_i8) { //(i > 127)
		put_mint8(mut buf, i)
	} else {
		buf << u8(i)
	}
	return w.bw.write_bytes(buf)
}

[inline]
fn (mut w Encoder) write_u16(mut buf []u8, u u16) !int {
	if u <= math.max_u8 { // u < 256
		return w.write_u8(mut buf, u8(u))
	} else {
		put_muint16(mut buf, u)
		return w.bw.write_bytes(buf)
	}
}

[inline]
fn (mut w Encoder) write_i16(mut buf []u8, i i16) !int {
	if i > 0 {
		return w.write_u16(mut buf, u16(i))
	} else if i < math.min_i8 { // i < -127  ????
		put_mint16(mut buf, i)
		return w.bw.write_bytes(buf)
	} else {
		return w.write_i8(mut buf, i8(i))
	}
}

[inline]
fn (mut w Encoder) write_u32(mut buf []u8, u u32) !int {
	if u <= math.max_u16 { // u < 65536
		return w.write_u16(mut buf, u16(u))
	} else {
		put_muint32(mut buf, u)
		return w.bw.write_bytes(buf)
	}
}

[inline]
fn (mut w Encoder) write_i32(mut buf []u8, i i32) !int {
	if i > 0 {
		return w.write_u32(mut buf, u32(i))
	} else if i < math.min_i16 { // i < -32768 {
		put_mint32(mut buf, i)
		return w.bw.write_bytes(buf)
	} else {
		return w.write_i16(mut buf, i16(i))
	}
}

[inline]
fn put_mint64(mut b []u8, i i64) {
	b << mint64
	b << u8(i >> 56)
	b << u8(i >> 48)
	b << u8(i >> 40)
	b << u8(i >> 32)
	b << u8(i >> 24)
	b << u8(i >> 16)
	b << u8(i >> 8)
	b << u8(i)
}

[inline]
fn get_mint64(b []u8) i64 {
	return (i64(b[0]) << 56) | (i64(b[1]) << 48) | (i64(b[2]) << 40) | (i64(b[3]) << 32) | (i64(b[4]) << 24) | (i64(b[5]) << 16) | (i64(b[6]) << 8) | (i64(b[7]))
}

[inline]
fn put_mint32(mut b []u8, i i32) {
	b << mint32
	b << u8(i >> 24)
	b << u8(i >> 16)
	b << u8(i >> 8)
	b << u8(i)
}

[inline]
fn get_mint32(b []u8) i32 {
	return (i32(b[0]) << 24) | (i32(b[1]) << 16) | (i32(b[2]) << 8) | (i32(b[3]))
}

[inline]
fn put_mint16(mut b []u8, i i16) {
	b << mint16
	b << u8(i >> 8)
	b << u8(i)
}

[inline]
fn get_mint16(b []u8) i16 {
	return (i16(b[0]) << 8) | i16(b[1])
}

[inline]
fn put_mint8(mut b []u8, i i8) {
	b << mint8
	b << u8(i)
}

[inline]
fn get_mint8(b []u8) i8 {
	return i8(b[0])
}

[inline]
fn put_muint64(mut b []u8, u u64) {
	b << muint64
	b << u8(u >> 56)
	b << u8(u >> 48)
	b << u8(u >> 40)
	b << u8(u >> 32)
	b << u8(u >> 24)
	b << u8(u >> 16)
	b << u8(u >> 8)
	b << u8(u)
}

[inline]
fn get_muint64(b []u8) u64 {
	return (u64(b[0]) << 56) | (u64(b[1]) << 48) | (u64(b[2]) << 40) | (u64(b[3]) << 32) | (u64(b[4]) << 24) | (u64(b[5]) << 16) | (u64(b[6]) << 8) | (u64(b[7]))
}

[inline]
fn put_muint32(mut b []u8, u u32) {
	b << muint32
	b << u8(u >> 24)
	b << u8(u >> 16)
	b << u8(u >> 8)
	b << u8(u)
}

[inline]
fn get_muint32(b []u8) u32 {
	return (u32(b[0]) << 24) | (u32(b[1]) << 16) | (u32(b[2]) << 8) | (u32(b[3]))
}

[inline]
fn put_muint16(mut b []u8, u u16) {
	b << muint16
	b << u8(u >> 8)
	b << u8(u)
}

[inline]
fn get_muint16(b []u8) u16 {
	return (u16(b[0]) << 8) | u16(b[1])
}

[inline]
fn put_muint8(mut b []u8, u u8) {
	b << muint8
	b << u8(u)
}

[inline]
fn get_muint8(b []u8) u8 {
	return u8(b[0])
}
