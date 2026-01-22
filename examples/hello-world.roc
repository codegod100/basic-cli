app [main] { pf: platform "../platform/main.roc" }

# Minimal pure hello world - just returns a number
main : {} -> I32
main = |{}| {
    42
}
