module vmsgp

import math

// ContainerHeader describes header record for container like format (array, map, string )
pub struct ContainerHeader {
pub:
	dtype byte
	size  u32
}

// read_container_header reads exact type of container( i.e.  prefix) and size of container or string .
pub fn (mut s Decoder) read_container_header() !ContainerHeader {
	mut size := u32(0)
	// get data type
	dtype := s.read_byte()!

	if isfixarray(dtype) {
		size = rfixarray(dtype)
	} else if isfixmap(dtype) {
		size = rfixmap(dtype)
	} else if isfixstr(dtype) {
		size = rfixstr(dtype)
	} else {
		fb := s.read_data_size_bytes(dtype) or { return err }
		match dtype {
			mext8, mbin8, mstr8 {
				size = get_muint8(fb)
			}
			marray16, mmap16, mext16, mbin16 {
				size = get_muint16(fb)
			}
			marray32, mmap32, mext32, mbin32 {
				size = get_muint32(fb)
			}
			else {
				return IError(ErrWrongType{
					dt: dtype
				})
			}
		}
	}

	return ContainerHeader{
		dtype: dtype
		size: size
	}
}

// write_container_header writes prefix and size of container or string . The exact type of container will be
// chosen by it's size.
pub fn (mut w Encoder) write_container_header(n i32, dkind DataKind) !int {
	mut buf := []u8{len: 0, cap: 8}
	mut prefix := u8(0)
	if n < 32 {
		match dkind {
			.msgp_string {
				prefix = wfixstr(u8(n))
			}
			.msgp_array {
				prefix = wfixarray(u8(n))
			}
			.msgp_map {
				prefix = wfixmap(u8(n))
			}
			else {
				return IError(err_wt)
			}
		}
		buf << prefix
	} else if n <= math.max_u8 {
		match dkind {
			.msgp_string {
				prefix = mstr8
			}
			.msgp_bin {
				prefix = mbin8
			}
			.msgp_ext {
				prefix = mext8
			}
			else {
				return IError(err_wt)
			}
		}
		prefixu8(mut buf, prefix, u8(n))
	} else if n <= math.max_u16 {
		match dkind {
			.msgp_string {
				prefix = mstr16
			}
			.msgp_array {
				prefix = marray16
			}
			.msgp_map {
				prefix = mmap16
			}
			.msgp_bin {
				prefix = mbin16
			}
			.msgp_ext {
				prefix = mext16
			}
			else {
				return IError(err_wt)
			}
		}
		prefixu16(mut buf, prefix, u16(n))
	} else {
		match dkind {
			.msgp_string {
				prefix = mstr32
			}
			.msgp_array {
				prefix = marray32
			}
			.msgp_map {
				prefix = mmap32
			}
			.msgp_bin {
				prefix = mbin32
			}
			.msgp_ext {
				prefix = mext32
			}
			else {
				return IError(err_wt)
			}
		}
		prefixu32(mut buf, prefix, u32(n))
	}
	return w.bw.write_bytes(buf)
}
