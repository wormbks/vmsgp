module vmsgp

interface Reader {
mut:
	read_bytes(mut rb []u8) !int
}

struct BufReader {
	buf []u8
	len int
mut:
	cursor int
}

struct Decoder {
mut:
	br Reader // interface
}

// internal functions to keep code readable ))

// read_data_size_bytes reads data size fild of strings, arrays etc.
// or bytes for integers and floats
fn (mut s Decoder) read_data_size_bytes(dtype u8) ![]u8 {
	size := data_size(dtype)
	if size == 0 {
		return IError(ErrWrongType{
			dt: dtype
		})
	}
	mut fb := []u8{len: size}
	s.br.read_bytes(mut fb)!
	return fb
}

fn (mut s Decoder) read_byte() !u8 {
	mut fb := []u8{len: 1}
	s.br.read_bytes(mut fb)!
	return fb[0]
}


pub fn make_buf_reader(in_buf []u8) BufReader {
	return BufReader{
		buf: in_buf
		len: in_buf.len
	}
}

[inline]
fn (s BufReader) peek() ?u8 {
	if s.cursor >= s.len {
		return IError(err_ob)
	}
	return s.buf[s.cursor]
}

pub fn (mut s BufReader) read_bytes(mut rb []u8) !int {
	if rb.len == 0 {
		return error(@FN + ': `rb.len` == 0')
	}
	n := rb.len
	mut delta := 0
	end := s.cursor + n
	if end > s.len {
		rb.clear()
		rb << s.buf[s.cursor..]
		delta = s.len - s.cursor
		s.cursor = s.len
		return IError(err_ob)
	} else {
		rb.clear()
		rb << s.buf[s.cursor..end]
		s.cursor = end
		delta = n
	}
	return delta
}

fn (s BufReader) str() string {
	return '{${s.len}, ${s.cursor}}'
}

// data_size returns the size of data for types like f32,f64,i32...
// or size of it's data size field for strings, arrays, maps etc.
[inline]
fn data_size(b u8) int {
	mut size := 0
	match b {
		mext8, mbin8, mstr8, mint8, muint8 {
			size = 1
		}
		mbin16, mext16, mmap16, marray16, mstr16, muint16, mint16 {
			size = 2
		}
		mbin32, mext32, mmap32, marray32, mstr32, muint32, mint32, mfloat32 {
			size = 4
		}
		muint64, mint64, mfloat64 {
			size = 8
		}
		else {}
	}
	return size
}
