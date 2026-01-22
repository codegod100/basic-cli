app [main!] { pf: platform "../platform/main.roc" }

import pf.Stdout

# How to handle command line arguments in Roc.

# To run this example: check the README.md in this folder

main! : List(Str) => Try({}, [Exit(I32)])
main! = |args| {
    # Print all arguments
    Stdout.line!("Received ${Num.to_str(List.len(args))} arguments:")

    List.for_each(args, |arg| Stdout.line!("  ${arg}"))
    Ok({})
}
