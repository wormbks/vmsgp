// module msgp

// //Returns kind of data for the next element or error err_ob
// pub fn (s &Reader) what_is_next() ?DataKind {
// 	b := s.br.peek() or { return err }
// 	match b {
// 		-1 {
// 			return DataKind.msgp_empty
// 		}
// 		192 {
// 			return DataKind.msgp_nil
// 		}
// 		194 {
// 			return DataKind.msgp_bool
// 		}
// 		195 {
// 			return DataKind.msgp_bool
// 		}
// 		196 {
// 			return DataKind.msgp_bin
// 		}
// 		197 {
// 			return DataKind.msgp_bin
// 		}
// 		198 {
// 			return DataKind.msgp_bin
// 		}
// 		202 {
// 			return DataKind.msgp_float
// 		}
// 		203 {
// 			return DataKind.msgp_float
// 		}
// 		204 {
// 			return DataKind.msgp_uint
// 		}
// 		205 {
// 			return DataKind.msgp_uint
// 		}
// 		206 {
// 			return DataKind.msgp_uint
// 		}
// 		207 {
// 			return DataKind.msgp_uint
// 		}
// 		208 {
// 			return DataKind.msgp_sint
// 		}
// 		209 {
// 			return DataKind.msgp_sint
// 		}
// 		210 {
// 			return DataKind.msgp_sint
// 		}
// 		211 {
// 			return DataKind.msgp_sint
// 		}
// 		212 {
// 			return DataKind.msgp_ext
// 		}
// 		213 {
// 			return DataKind.msgp_ext
// 		}
// 		214 {
// 			return DataKind.msgp_ext
// 		}
// 		215 {
// 			return DataKind.msgp_ext
// 		}
// 		216 {
// 			return DataKind.msgp_ext
// 		}
// 		217 {
// 			return DataKind.msgp_string
// 		}
// 		218 {
// 			return DataKind.msgp_string
// 		}
// 		219 {
// 			return DataKind.msgp_string
// 		}
// 		220 {
// 			return DataKind.msgp_array
// 		}
// 		221 {
// 			return DataKind.msgp_array
// 		}
// 		222 {
// 			return DataKind.msgp_map
// 		}
// 		223 {
// 			return DataKind.msgp_map
// 		}
// 		else {
// 			if b >= 224 {
// 				return DataKind.msgp_uint
// 			}
// 			if b < 128 {
// 				return DataKind.msgp_sint
// 			}
// 			if (b >> 5) == 5 {
// 				return DataKind.msgp_string
// 			}
// 			if (b >> 4) == 8 {
// 				return DataKind.msgp_map
// 			}
// 			if (b >> 4) == 9 {
// 				return DataKind.msgp_array
// 			}
// 			return DataKind.msgp_unknown
// 		}
// 	}
// }

// pub fn (s &Reader) is_nil_next() ?bool {
// 	b := s.br.peek() or { return err }
// 	return (b == 192)
// }

// pub fn (s &Reader) is_bool_next() ?bool {
// 	b := s.br.peek() or { return err }
// 	return  ((b == 194) || (b == 195))
// }

// pub fn (s &Reader) is_integer_next() ?bool {
// 	b := s.br.peek() or { return err }
// 	return (b < 128) || (b >= 224) || (b == 204) || (b == 205) || (b == 206) || (b == 207)
// 		|| (b == 208) || (b == 209) || (b == 210) || (b == 211)
// }

// pub fn (s &Reader) is_signed_next() ?bool {
// 	b := s.br.peek() or { return err }
// 	return  ((b >= 224) || (b == 208) || (b == 209) || (b == 210) || (b == 211))
// }

// pub fn (s &Reader) is_float_next() ?bool {
// 	b := s.br.peek() or { return err }
// 	return  ((b == 202) || (b == 203))
// }

// pub fn (s &Reader) is_string_next() ?bool {
// 	b := s.br.peek() or { return err }
// 	return (((b >> 5) == 5) || (b == 217) || (b == 218) || (b == 219))
// }

// pub fn (s &Reader) is_bin_next() ?bool {
// 	b := s.br.peek() or { return err }
// 	return  ((b == 196) || (b == 197) || (b == 198))
// }

// pub fn (s &Reader) is_array_next() ?bool {
// 	b := s.br.peek() or { return err }
// 	return  (((b >> 4) == 9) || (b == 220) || (b == 221))
// }

// pub fn (s &Reader) is_map_next() ?bool {
// 	b := s.br.peek() or { return err }
// 	return  (((b >> 4) == 8) || (b == 222) || (b == 223))
// }
