module msgp

import math

//{	10 }
const i8_tuple = [u8(0x0A), 0xCC, 0xFE] // 10, 254

fn test_read_i8() ! {
	mut br := BufReader{
		buf:  i8_tuple
		len:  i8_tuple.len
	}
	mut s := Decoder{
		br: br
	}
	sval := s.read_i64()!
	assert sval == 10
	uval := s.read_u64()!
	assert uval == 254
}

const u16_i16_tuple = [u8(0xCD), 0xFA, 0x00, 0xD1, 0x86, 0xE8] // 64000, -31000

fn test_read_u16_i16() ! {
	mut br := BufReader{
		buf:  u16_i16_tuple
		len:  u16_i16_tuple.len
	}
	mut s := Decoder{
		br: br
	}
	uval := s.read_u64()!
	assert uval == 64000
	sval := s.read_i64()!
	assert sval == -31000
}

fn test_write_i64() ! {
	mut bw := make_buf_writer(32)
	mut w := Encoder{
		bw: bw
	}
	mut buf := []u8{len: 0, cap: 12}
	written := w.write_i64(math.min_i64)!
	// print("$written, $buf")
	assert written == 9

	tmp := bw.bytes()

	mut br := BufReader{
		buf: tmp
		len: tmp.len
	}
	mut s := Decoder{
		br: br
	}
	sval := s.read_i64()!
	assert sval == i64(math.min_i64)
}

fn test_write_u64() ! {
	mut bw := make_buf_writer(32)
	mut w := Encoder{
		bw: bw
	}
	mut buf := []u8{len: 0, cap: 12}
	written := w.write_u64(math.max_u64)!
	// print("$written, $buf")
	assert written == 9

	tmp := bw.bytes()

	mut br := BufReader{
		buf: tmp
		len: tmp.len
	}
	mut s := Decoder{
		br: br
	}
	sval := s.read_u64()!
	assert sval == u64(math.max_u64)
}

fn test_write_i32() ! {
	mut bw := make_buf_writer(32)
	mut w := Encoder{
		bw: bw
	}
	mut buf := []u8{len: 0, cap: 12}
	written := w.write_i32(mut buf, math.min_i32)!
	// print("$written, $buf")
	assert written == 5

	tmp := bw.bytes()

	mut br := BufReader{
		buf: tmp
		len: tmp.len
	}
	mut s := Decoder{
		br: br
	}
	sval := s.read_i64()!
	assert sval == i64(math.min_i32)
}

fn test_write_u32() ! {
	mut bw := make_buf_writer(32)
	mut w := Encoder{
		bw: bw
	}
	mut buf := []u8{len: 0, cap: 12}
	written := w.write_u32(mut buf, math.max_u32)!
	// print("$written, $buf")
	assert written == 5

	tmp := bw.bytes()

	mut br := BufReader{
		buf: tmp
		len: tmp.len
	}
	mut s := Decoder{
		br: br
	}
	sval := s.read_u64()!
	assert sval == u64(math.max_u32)
}

fn test_write_i16() ! {
	mut bw := make_buf_writer(32)
	mut w := Encoder{
		bw: bw
	}
	mut buf := []u8{len: 0, cap: 12}
	written := w.write_i16(mut buf, math.min_i16)!
	// print("$written, $buf")
	assert written == 3

	tmp := bw.bytes()

	mut br := BufReader{
		buf: tmp
		len: tmp.len
	}
	mut s := Decoder{
		br: br
	}
	sval := s.read_i64()!
	assert sval == i64(math.min_i16)
}

fn test_write_u16() ! {
	mut bw := make_buf_writer(32)
	mut w := Encoder{
		bw: bw
	}
	mut buf := []u8{len: 0, cap: 12}
	written := w.write_u16(mut buf, math.max_u16)!
	// print("$written, $buf")
	assert written == 3

	tmp := bw.bytes()

	mut br := BufReader{
		buf: tmp
		len: tmp.len
	}
	mut s := Decoder{
		br: br
	}
	sval := s.read_u64()!
	assert sval == u64(math.max_u16)
}

fn test_write_i8() ! {
	mut bw := make_buf_writer(32)
	mut w := Encoder{
		bw: bw
	}
	mut buf := []u8{len: 0, cap: 12}
	written := w.write_i8(mut buf, math.min_i8)!
	// print("$written, $buf")
	assert written == 2

	tmp := bw.bytes()

	mut br := BufReader{
		buf: tmp
		len: tmp.len
	}
	mut s := Decoder{
		br: br
	}
	sval := s.read_i64()!
	assert sval == i64(math.min_i8)
}

fn test_write_u8() ! {
	mut bw := make_buf_writer(32)
	mut w := Encoder{
		bw: bw
	}
	mut buf := []u8{len: 0, cap: 12}
	written := w.write_u8(mut buf, math.max_u8)!
	// print("$written, $buf")
	assert written == 2

	tmp := bw.bytes()

	mut br := BufReader{
		buf: tmp
		len: tmp.len
	}
	mut s := Decoder{
		br: br
	}
	sval := s.read_u64()!
	assert sval == u64(math.max_u8)
}
