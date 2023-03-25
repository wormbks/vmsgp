module msgp

fn test_read_array_size() ! {
	//{[1,2,3]}
	array_int := [u8(0x93), 0x01, 0x02, 0x03]
	mut br := make_buf_reader(array_int)
	mut s := Decoder{
		br: br
	}
	val := s.read_container_header()?
	assert val.size == 3
}

fn test_read_map_size() ! {
	//{"a":[1,2,3],"b":0.5}
	map_int := [u8(0x82), 0xA1, 0x61, 0x93, 0x01, 0x02, 0x03, 0xA1, 0x62, 0xCB, 0x3F, 0xE0, 0x00,
		0x00, 0x00, 0x00, 0x00, 0x00]
	mut br := make_buf_reader(map_int)
	mut s := Decoder{
		br: br
	}
	val := s.read_container_header()?
	assert val.size == 2
}
