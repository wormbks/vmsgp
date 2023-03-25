module msgp

pub interface Writer {
mut:
	write_bytes(wb []u8) !int
}

pub struct Encoder {
mut:
	bw Writer
}

pub struct BufWriter {
mut:
	buf []u8
}

// makes BufWriter with given capacity and 0 length
pub fn make_buf_writer(init_capacity int) BufWriter {
	if init_capacity > 0 {
		return BufWriter{
			buf: []u8{len: 0, cap: init_capacity}
		}
	}
	return BufWriter{}
}

// Writes bytes to buffer
pub fn (mut bw BufWriter) write_bytes(b []u8) !int {
	bw.buf << b
	return b.len
}

// Returns []u8 buffer
pub fn (bw BufWriter) bytes() []u8 {
	return bw.buf
}

// write prefix and u
[inline]
fn prefixu8(mut b []u8, pre u8, sz u8) {
	b << pre
	b << u8(sz)
}

// write prefix and big-endian ui
[inline]
fn prefixu16(mut b []u8, pre u8, sz u16) {
	b << pre
	b << u8(sz >> 8)
	b << u8(sz)
}

// write prefix and big-endian ui
[inline]
fn prefixu32(mut b []u8, pre u8, sz u32) {
	b << pre
	b << u8(sz >> 24)
	b << u8(sz >> 16)
	b << u8(sz >> 8)
	b << u8(sz)
}

[inline]
fn prefixu64(mut b []u8, pre u8, sz u64) {
	b << pre
	b << u8(sz >> 56)
	b << u8(sz >> 48)
	b << u8(sz >> 40)
	b << u8(sz >> 32)
	b << u8(sz >> 24)
	b << u8(sz >> 16)
	b << u8(sz >> 8)
	b << u8(sz)
}
