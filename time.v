module vmsgp

import time 

#include <time.h>
#include <errno.h>


struct Timespec {
mut:
	tv_sec  i64
	tv_nsec i64
}


fn (mut e Encoder) write_time(t time.Time) !int {
	mut buf := []u8{len:0, cap:16}
	buf << 0xC7
	buf << 12
	buf << -1
 	put_unixput(mut buf, t.second, t.microsecond*1000)
	return e.bw.write_bytes(buf)
}

fn (mut d Decoder) read_time() !time.Time {
	mut ts := C.timespec{}
	time_format := d.read_byte() !
	match time_format {
		mfixext4 { //timestamp 32
			if d.read_byte()! != mexttime {
				return IError(ErrWrongType{
					dt: time_format	})
			}
			sec := d.read_data_size_bytes(muint32)!
			ts.tv_sec = get_muint32(sec)
		}
		mfixext8 { //timestamp 64
			if d.read_byte()! != mexttime {
				return IError(ErrWrongType{
					dt: time_format })
			}
		}
		mext8 { // timestamp 96
			if d.read_byte()! != mexttime || d.read_byte()! != u8(12) {
				return IError(ErrWrongType{
					dt: time_format })
			}
			nsec := d.read_data_size_bytes(muint32)!
			ts.tv_nsec = get_muint32(nsec)
			sec := d.read_data_size_bytes(muint64)!
			ts.tv_nsec = get_mint64(sec)
		} else {
				return IError(ErrWrongType{
					dt: time_format })
		}
	}

	loc_tm := C.tm{}
	C.localtime_r(voidptr(&ts.tv_sec), &loc_tm)
	return convert_ctime(loc_tm, int(ts.tv_nsec / 1000))
}



struct C.tm {
	tm_sec   int
	tm_min   int
	tm_hour  int
	tm_mday  int
	tm_mon   int
	tm_year  int
	tm_wday  int
	tm_yday  int
	tm_isdst int
}



struct C.timespec {
mut:
	tv_sec  i64
	tv_nsec i64
}

// convert_ctime converts a C time to V time.
fn convert_ctime(t C.tm, microsecond int) time.Time {
	return time.Time{
		year: t.tm_year + 1900
		month: t.tm_mon + 1
		day: t.tm_mday
		hour: t.tm_hour
		minute: t.tm_min
		second: t.tm_sec
		microsecond: microsecond
		unix: make_unix_time(t)
		// for the actual code base when we
		// call convert_ctime, it is always
		// when we manage the local time.
		is_local: true
	}
}

[inline]
fn make_unix_time(t C.tm) i64 {
	return i64(C.timegm(&t))
}

[inline]
fn get_unix(b []u8) (i64, i32) {
	mut sec := i64(0)
	mut nsec := i32(0)
	sec = i64((u64(b[0]) << 56) | (u64(b[1]) << 48) | (u64(b[2]) << 40) | (u64(b[3]) << 32) | (u64(b[4]) << 24) | (u64(b[5]) << 16) | (u64(b[6]) << 8) | (u64(b[7])))
	nsec = (i32(b[8]) << 24) | (i32(b[9]) << 16) | (i32(b[10]) << 8) | (i32(b[11]))
	return sec, nsec
}

[inline]
fn put_unixput(mut b []u8, sec i64, nsec i32) {
	b << u8(sec >> 56)
	b << u8(sec >> 48)
	b << u8(sec >> 40)
	b << u8(sec >> 32)
	b << u8(sec >> 24)
	b << u8(sec >> 16)
	b << u8(sec >> 8)
	b << u8(sec)
	b << u8(nsec >> 24)
	b << u8(nsec >> 16)
	b << u8(nsec >> 8)
	b << u8(nsec)
}
