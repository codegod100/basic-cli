app [main!] { pf: platform "../platform/main.roc" }

import pf.Stdout

# To run this example: check the README.md in this folder

main! : List(Str) => Try({}, [Exit(I32)])
main! = |_args| {
    Stdout.line!("Hello, World!")
    Ok({})
}
