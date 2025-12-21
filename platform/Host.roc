hosted [
    FileReader,
    TcpStream,
    command_exec_output!,
    command_exec_exit_code!,
    current_arch_os!,
    cwd!,
    dir_create!,
    dir_create_all!,
    dir_delete_all!,
    dir_delete_empty!,
    dir_list!,
    env_dict!,
    env_var!,
    exe_path!,
    file_delete!,
    file_exists!,
    file_read_bytes!,
    file_reader!,
    file_read_line!,
    file_size_in_bytes!,
    file_write_bytes!,
    file_write_utf8!,
    file_is_executable!,
    file_is_readable!,
    file_is_writable!,
    file_time_accessed!,
    file_time_modified!,
    file_time_created!,
    file_rename!,
    get_locale!,
    get_locales!,
    hard_link!,
    path_type!,
    posix_time!,
    random_u64!,
    random_u32!,
    send_request!,
    set_cwd!,
    sleep_millis!,
    sqlite_bind!,
    sqlite_columns!,
    sqlite_column_value!,
    sqlite_prepare!,
    sqlite_reset!,
    sqlite_step!,
    gmp_int_from_i64!,
    gmp_int_from_str!,
    gmp_int_to_str!,
    gmp_int_add!,
    gmp_int_sub!,
    gmp_int_mul!,
    gmp_int_div!,
    gmp_int_mod!,
    gmp_int_cmp!,
    gmp_float_from_f64!,
    gmp_float_from_str!,
    gmp_float_to_str!,
    gmp_float_add!,
    gmp_float_sub!,
    gmp_float_mul!,
    gmp_float_div!,
    gmp_float_cmp!,
    gmp_float_sqrt!,
    gmp_float_exp!,
    gmp_float_ln!,
    gmp_float_log10!,
    gmp_float_sin!,
    gmp_float_cos!,
    gmp_float_tan!,
    stderr_line!,
    stderr_write!,
    stderr_write_bytes!,
    stdin_bytes!,
    stdin_line!,
    stdin_read_to_end!,
    stdout_line!,
    stdout_write!,
    stdout_write_bytes!,
    tcp_connect!,
    tcp_read_exactly!,
    tcp_read_until!,
    tcp_read_up_to!,
    tcp_write!,
    temp_dir!,
    tty_mode_canonical!,
    tty_mode_raw!,
]

import InternalHttp
import InternalCmd
import InternalPath
import InternalIOErr
import InternalSqlite
import InternalGmp
# COMMAND
command_exec_exit_code! : InternalCmd.Command => Result I32 InternalIOErr.IOErrFromHost
command_exec_output! : InternalCmd.Command => Result InternalCmd.OutputFromHostSuccess (Result InternalCmd.OutputFromHostFailure InternalIOErr.IOErrFromHost)

# FILE
file_write_bytes! : List U8, List U8 => Result {} InternalIOErr.IOErrFromHost
file_write_utf8! : List U8, Str => Result {} InternalIOErr.IOErrFromHost
file_delete! : List U8 => Result {} InternalIOErr.IOErrFromHost
file_read_bytes! : List U8 => Result (List U8) InternalIOErr.IOErrFromHost
file_size_in_bytes! : List U8 => Result U64 InternalIOErr.IOErrFromHost
file_exists! : List U8 => Result Bool InternalIOErr.IOErrFromHost
file_is_executable! : List U8 => Result Bool InternalIOErr.IOErrFromHost
file_is_readable! : List U8 => Result Bool InternalIOErr.IOErrFromHost
file_is_writable! : List U8 => Result Bool InternalIOErr.IOErrFromHost
file_time_accessed! : List U8 => Result U128 InternalIOErr.IOErrFromHost
file_time_modified! : List U8 => Result U128 InternalIOErr.IOErrFromHost
file_time_created! : List U8 => Result U128 InternalIOErr.IOErrFromHost
file_rename! : List U8, List U8 => Result {} InternalIOErr.IOErrFromHost

FileReader := Box {}
file_reader! : List U8, U64 => Result FileReader InternalIOErr.IOErrFromHost
file_read_line! : FileReader => Result (List U8) InternalIOErr.IOErrFromHost

dir_list! : List U8 => Result (List (List U8)) InternalIOErr.IOErrFromHost
dir_create! : List U8 => Result {} InternalIOErr.IOErrFromHost
dir_create_all! : List U8 => Result {} InternalIOErr.IOErrFromHost
dir_delete_empty! : List U8 => Result {} InternalIOErr.IOErrFromHost
dir_delete_all! : List U8 => Result {} InternalIOErr.IOErrFromHost

hard_link! : List U8, List U8 => Result {} InternalIOErr.IOErrFromHost
path_type! : List U8 => Result InternalPath.InternalPathType InternalIOErr.IOErrFromHost
cwd! : {} => Result (List U8) {}
temp_dir! : {} => List U8

# STDIO
stdout_line! : Str => Result {} InternalIOErr.IOErrFromHost
stdout_write! : Str => Result {} InternalIOErr.IOErrFromHost
stdout_write_bytes! : List U8 => Result {} InternalIOErr.IOErrFromHost
stderr_line! : Str => Result {} InternalIOErr.IOErrFromHost
stderr_write! : Str => Result {} InternalIOErr.IOErrFromHost
stderr_write_bytes! : List U8 => Result {} InternalIOErr.IOErrFromHost
stdin_line! : {} => Result Str InternalIOErr.IOErrFromHost
stdin_bytes! : {} => Result (List U8) InternalIOErr.IOErrFromHost
stdin_read_to_end! : {} => Result (List U8) InternalIOErr.IOErrFromHost

# TCP
send_request! : InternalHttp.RequestToAndFromHost => InternalHttp.ResponseToAndFromHost

TcpStream := Box {}
tcp_connect! : Str, U16 => Result TcpStream Str
tcp_read_up_to! : TcpStream, U64 => Result (List U8) Str
tcp_read_exactly! : TcpStream, U64 => Result (List U8) Str
tcp_read_until! : TcpStream, U8 => Result (List U8) Str
tcp_write! : TcpStream, List U8 => Result {} Str

# SQLITE
sqlite_prepare! : Str, Str => Result (Box {}) InternalSqlite.SqliteError
sqlite_bind! : Box {}, List InternalSqlite.SqliteBindings => Result {} InternalSqlite.SqliteError
sqlite_columns! : Box {} => List Str
sqlite_column_value! : Box {}, U64 => Result InternalSqlite.SqliteValue InternalSqlite.SqliteError
sqlite_step! : Box {} => Result InternalSqlite.SqliteState InternalSqlite.SqliteError
sqlite_reset! : Box {} => Result {} InternalSqlite.SqliteError

# GMP
gmp_int_from_i64! : I64 => Box {}
gmp_int_from_str! : Str => Result (Box {}) InternalGmp.GmpError
gmp_int_to_str! : Box {} => Str
gmp_int_add! : Box {}, Box {} => Box {}
gmp_int_sub! : Box {}, Box {} => Box {}
gmp_int_mul! : Box {}, Box {} => Box {}
gmp_int_div! : Box {}, Box {} => Result (Box {}) InternalGmp.GmpError
gmp_int_mod! : Box {}, Box {} => Result (Box {}) InternalGmp.GmpError
gmp_int_cmp! : Box {}, Box {} => I32

gmp_float_from_f64! : F64 => Box {}
gmp_float_from_str! : Str => Result (Box {}) InternalGmp.GmpError
gmp_float_to_str! : Box {} => Str
gmp_float_add! : Box {}, Box {} => Box {}
gmp_float_sub! : Box {}, Box {} => Box {}
gmp_float_mul! : Box {}, Box {} => Box {}
gmp_float_div! : Box {}, Box {} => Result (Box {}) InternalGmp.GmpError
gmp_float_cmp! : Box {}, Box {} => I32
gmp_float_sqrt! : Box {} => Box {}
gmp_float_exp! : Box {} => Box {}
gmp_float_ln! : Box {} => Box {}
gmp_float_log10! : Box {} => Box {}
gmp_float_sin! : Box {} => Box {}
gmp_float_cos! : Box {} => Box {}
gmp_float_tan! : Box {} => Box {}

# OTHERS
current_arch_os! : {} => { arch : Str, os : Str }

get_locale! : {} => Result Str {}
get_locales! : {} => List Str

posix_time! : {} => U128 # TODO why is this a U128 but then getting converted to a I128 in Utc.roc?

sleep_millis! : U64 => {}

tty_mode_canonical! : {} => {}
tty_mode_raw! : {} => {}

env_dict! : {} => List (Str, Str)
env_var! : Str => Result Str {}
exe_path! : {} => Result (List U8) {}
set_cwd! : List U8 => Result {} {}

random_u64! : {} => Result U64 InternalIOErr.IOErrFromHost
random_u32! : {} => Result U32 InternalIOErr.IOErrFromHost
