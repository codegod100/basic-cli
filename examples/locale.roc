app [main!] { pf: platform "../platform/main.roc" }

import pf.Stdout
import pf.Locale

# Getting the preferred locale and all available locales

# To run this example: check the README.md in this folder

main! : List(Str) => Try({}, [Exit(I32)])
main! = |_args| {
    locale_str = Locale.get!({})
    Stdout.line!("The most preferred locale for this system or application: ${locale_str}")

    all_locales = Locale.all!({})
    Stdout.line!("All available locales for this system or application: ${Inspect.to_str(all_locales)}")
    Ok({})
}