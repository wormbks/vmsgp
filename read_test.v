module msgp

const (
	input_buf_size = 5
	fill_value     = 33
)

fn test_peek() {
	mut br := BufReader{
		buf: []u8{len:  input_buf_size}
		len:  input_buf_size
	}
	br.peek() or {
		assert false
		return
	}
	assert br.cursor == 0
}

fn test_read() ? {
	input := []u8{len:  input_buf_size, init:  fill_value}
	mut br := BufReader{
		buf: input
		len: input.len
		cursor: 0
	}
	mut rb := []u8{len: 3}
	br.read_bytes(mut rb) or { return err }
	assert rb[1] == 33
	assert br.cursor == 3
}

fn test_read_in_bounds() {
	input := []u8{len:  input_buf_size, init:  fill_value}
	mut br := BufReader{
		buf: input
		len: input.len
		cursor: 0
	}
	mut rb := []u8{len: 5}
	n := br.read_bytes(mut rb) or { -1 }
	// println("n = $n")
	assert n == 5
	assert br.cursor == 5
}

fn test_read_out_of_bounds() {
	input := []u8{len: 5, init: 33}
	mut br := BufReader{
		buf: input
		len: input.len
		cursor: 0
	}
	mut rb := []u8{len: 6}
	n := br.read_bytes(mut rb) or { -1 }
	assert n == -1
	assert br.cursor == 5
}

//{	"i8": 10,  "u16":32000 }
const i8_i16_named_tuple = [u8(0xA2), 0x69, 0x38, 0x0A, 0xA3, 0x69, 0x31, 0x36, 0xCD, 0x7D, 0x00]
