platform "cli"
    requires {} { main! : List(Str) => Try({}, [Exit(I32)]) }
    exposes [
        Path,
        Arg,
        Dir,
        Env,
        File,
        Http,
        Stderr,
        Stdin,
        Stdout,
        Tcp,
        Url,
        Utc,
        Sleep,
        Cmd,
        Tty,
        Locale,
        Sqlite,
        Random,
    ]
    packages {}
    provides { main_for_host! : "main_for_host" }
    targets: {
        files: "targets/",
        exe: {
            x64mac: ["libhost.a", app],
            arm64mac: ["libhost.a", app],
            x64musl: ["crt1.o", "libhost.a", app, "libc.a"],
            arm64musl: ["crt1.o", "libhost.a", app, "libc.a"],
            x64win: ["host.lib", app],
            arm64win: ["host.lib", app],
        }
    }

import Arg
import Stderr
import InternalArg

main_for_host! : List(InternalArg.ArgToAndFromHost) => I32
main_for_host! = |raw_args| {
    args =
        raw_args
        |> List.map(InternalArg.to_os_raw)
        |> List.map(Arg.from_os_raw)

    result = main!(args)
    match result {
        Ok({}) => 0
        Err(Exit(code)) => code
    }
}
