app [main!] { pf: platform "../platform/main.roc" }

import pf.Stdout
import pf.Stderr

# Printing to stdout and stderr

# To run this example: check the README.md in this folder

main! : List(Str) => Try({}, [Exit(I32)])
main! = |_args| {
    # # Print a string to stdout
    Stdout.line!("Hello, world!")

    # # Print without a newline
    Stdout.write!("No newline after me.")

    # # Print a string to stderr
    Stderr.line!("Hello, error!")

    # # Print a string to stderr without a newline
    Stderr.write!("Err with no newline after.")

    # # Print a list to stdout
    ["Foo", "Bar", "Baz"]
     List.for_each_try!(|str| Stdout.line!(str))

    Ok({})
}
