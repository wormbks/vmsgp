module msgp

import math

// read_f64 reads f64 float form the Decoder
fn (mut s Decoder) read_f64() !f64 {
	mut fval := f64(0.0)
	dtype := s.read_byte()!

	if dtype == mfloat64 {
		read_size := 8
		mut fb := []u8{len: read_size}
		s.br.read_bytes(mut fb) or { return err }
		val := get_muint64(fb)
		fval = math.f64_from_bits(val)
	} else {
		return IError(ErrWrongType{
			dt: dtype
		})
	}

	return fval
}

// read_f32 reads f32 float form the Decoder
pub fn (mut s Decoder) read_f32() !f32 {
	dtype := s.read_byte()!
	mut fval := f32(0.0)
	if dtype == mfloat32 {
		read_size := 4
		mut fb := []u8{len: read_size}
		s.br.read_bytes(mut fb) or { return err }
		val := get_muint32(fb)
		fval = math.f32_from_bits(val)
	} else {
		return IError(ErrWrongType{
			dt: dtype
		})
	}

	return fval
}

// write_f32 writes f32 float to the Encoder
pub fn (mut w Encoder) write_f32(f f32) !int {
	mut buf := []u8{len: 0, cap: 5}
	put_f32(mut buf, f)
	return w.bw.write_bytes(buf)
}

// write_f64 writes f64 float to the Writer
pub fn (mut w Encoder) write_f64(f f64) !int {
	mut buf := []u8{len: 0, cap: 9}
	put_f64(mut buf, f)
	return w.bw.write_bytes(buf)
}

[inline]
fn put_f32(mut b []u8, f f32) {
	u := math.f32_bits(f)
	b << mfloat32
	b << u8(u >> 24)
	b << u8(u >> 16)
	b << u8(u >> 8)
	b << u8(u)
}

[inline]
fn put_f64(mut b []u8, f f64) {
	u := math.f64_bits(f)
	b << mfloat64
	b << u8(u >> 56)
	b << u8(u >> 48)
	b << u8(u >> 40)
	b << u8(u >> 32)
	b << u8(u >> 24)
	b << u8(u >> 16)
	b << u8(u >> 8)
	b << u8(u)
}
