platform ""
    requires { main : {} -> I32 }
    exposes []
    packages {}
    provides { main_for_host : "main_for_host" }
    targets: {
        files: "targets/",
        exe: {
            x64musl: ["crt1.o", "libhost.a", app, "libc.a"],
        }
    }

main_for_host : {} -> I32
main_for_host = |{}| {
    main({})
}
