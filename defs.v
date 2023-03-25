module msgp

enum DataKind {
	msgp_unknown
	msgp_empty
	msgp_nil
	msgp_bool
	msgp_uint
	msgp_sint
	msgp_float
	msgp_string
	msgp_bin
	msgp_ext
	msgp_array
	msgp_map
}

// enum SizeKind {
// 	msgp_u8
// 	msgp_u16
// 	msgp_u32
// }

const (
	last4     = 0x0f
	first4    = 0xf0
	last5     = 0x1f
	first3    = 0xe0
	last7     = 0x7f

	mnfixint  = u8(0xe0)
	mfixmap   = u8(0x80)
	mfixarray = u8(0x90)
	mfixstr   = u8(0xa0)
	mfixint   = u8(0x00)
	mnil      = u8(0xc0)
	mfalse    = u8(0xc2)
	mtrue     = u8(0xc3)
	mbin8     = u8(0xc4)
	mbin16    = u8(0xc5)
	mbin32    = u8(0xc6)
	mext8     = u8(0xc7)
	mext16    = u8(0xc8)
	mext32    = u8(0xc9)
	mfloat32  = u8(0xca)
	mfloat64  = u8(0xcb)
	muint8    = u8(0xcc)
	muint16   = u8(0xcd)
	muint32   = u8(0xce)
	muint64   = u8(0xcf)
	mint8     = u8(0xd0)
	mint16    = u8(0xd1)
	mint32    = u8(0xd2)
	mint64    = u8(0xd3)
	mfixext1  = u8(0xd4)
	mfixext2  = u8(0xd5)
	mfixext4  = u8(0xd6)
	mfixext8  = u8(0xd7)
	mfixext16 = u8(0xd8)
	mstr8     = u8(0xd9)
	mstr16    = u8(0xda)
	mstr32    = u8(0xdb)
	marray16  = u8(0xdc)
	marray32  = u8(0xdd)
	mmap16    = u8(0xde)
	mmap32    = u8(0xdf)
	mexttime  = u8(-1)
)

fn isfixint(b u8) bool {
	return b >> 7 == 0
}

fn isnfixint(b u8) bool {
	return b & first3 == mnfixint
}

fn isfixmap(b u8) bool {
	return b & first4 == mfixmap
}

fn isfixarray(b u8) bool {
	return b & first4 == mfixarray
}

fn isfixstr(b u8) bool {
	return (b & first3) == mfixstr
}

fn wfixint(u u8) u8 {
	return u & last7
}

fn rfixint(b u8) u8 {
	return b
}

fn wnfixint(i i8) u8 {
	return u8(i) | mnfixint
}

fn rnfixint(b u8) i8 {
	return i8(b)
}

fn rfixmap(b u8) u8 {
	return b & last4
}

fn wfixmap(u u8) u8 {
	return mfixmap | (u & last4)
}

fn rfixstr(b u8) u8 {
	return b & last5
}

fn wfixstr(u u8) u8 {
	return (u & last5) | mfixstr
}

fn rfixarray(b u8) u8 {
	return b & last4
}

fn wfixarray(u u8) u8 {
	return (u & last4) | mfixarray
}
