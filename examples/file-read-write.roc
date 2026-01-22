app [main!] { pf: platform "../platform/main.roc" }

import pf.Stdout
import pf.File

# To run this example: check the README.md in this folder

main! : List(Str) => Try({}, [Exit(I32)])
main! = |_args| {
    # Note: you can also import files directly if you know the path: https://www.roc-lang.org/examples/IngestFiles/README.html
    out_file = "out.txt"

    file_write_read!(out_file)?

    # Cleanup
    File.delete!(out_file)
    Ok({})
}

file_write_read! : Str => Try({}, [Exit(I32)])
file_write_read! = |file_name| {
    Stdout.line!("Writing a string to out.txt")?

    File.write_utf8!("a string!", file_name)?

    contents = File.read_utf8!(file_name)?

    Stdout.line!("I read the file back. Its contents are: \"${contents}\"")
    Ok({})
}
