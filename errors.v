module msgp

// Error out of bounds
pub struct ErrOutOfBounds {
	Error
}

fn (err ErrOutOfBounds) msg() string {
	return 'Out of bounds!'
}

// Error wrong type, contains type defenition as byte
pub struct ErrWrongType {
	Error
	dt u8
}

fn (err ErrWrongType) msg() string {
	return 'Wrong data type 0x${err.dt:X}!'
}

// Error wrong data field size
pub struct ErrWrongDataFieldSize {
	Error
}

fn (err ErrWrongDataFieldSize) msg() string {
	return 'Wrong data data field size!'
}

// short aliaases for the errors
pub const (
	err_ob   = ErrOutOfBounds{}
	err_wt   = ErrWrongType{}
	err_wdfs = ErrWrongDataFieldSize{}
)
