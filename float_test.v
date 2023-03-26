module vmsgp

const (
	f64_f32_tuple = [u8(0xCB), 0xC0, 0x40, 0x2A, 0xAA, 0xAA, 0xAA, 0xAA, 0xA6, 0xCA, 0x3d, 0x4c,
		0xcc, 0xcd] //-32.3333333333333, 0.05
	test_val_f32  = f32(0.05)
	test_val_f64  = f64(-32.3333333333333)
)

fn test_read_f64_f32() ! {
	mut br := BufReader{
		buf: f64_f32_tuple
		len: f64_f32_tuple.len
	}
	mut s := Decoder{
		br: br
	}
	lval := s.read_f64()!
	assert lval == test_val_f64
	sval := s.read_f32()!
	assert sval == test_val_f32
}

fn test_write_f64_f32() ! {
	mut bw := make_buf_writer(32)
	mut w := Encoder{
		bw: bw
	}
	mut written := w.write_f64(test_val_f64)!
	assert written == 9

	written = w.write_f32(test_val_f32)!
	assert written == 5

	tmp := bw.bytes()
	assert tmp == f64_f32_tuple
}
