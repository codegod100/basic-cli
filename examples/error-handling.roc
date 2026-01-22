app [main!] { pf: platform "../platform/main.roc" }

import pf.Stdout
import pf.Stdin

# To run this example: check the README.md in this folder

# Demonstrates handling of every possible error

main! : List(Str) => Try({}, [Exit(I32)])
main! = |_args| {
    Stdout.line!("Enter some text, press Enter:")
    text = Stdin.line!({})
    Stdout.line!("You entered: ${text}")
    Ok({})
}
