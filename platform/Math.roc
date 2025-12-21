module [pi!]

import Gmp

pi! : I64 => Result Gmp.BigFloat [GmpErr Gmp.GmpError]
pi! = |iterations|
    sum = chudnovsky_sum!(iterations)?
    twelve = Gmp.float_from_f64!(12.0)
    inv = Gmp.float_mul!(twelve, sum)
    Gmp.float_div!(Gmp.float_from_f64!(1.0), inv)

chudnovsky_sum! : I64 => Result Gmp.BigFloat [GmpErr Gmp.GmpError]
chudnovsky_sum! = |iterations|
    loop! = |k, acc|
        if k > iterations then
            Ok(acc)
        else
            term = chudnovsky_term!(k)?
            acc2 = Gmp.float_add!(acc, term)
            loop!(k + 1, acc2)
    loop!(0, Gmp.float_from_f64!(0.0))

chudnovsky_term! : I64 => Result Gmp.BigFloat [GmpErr Gmp.GmpError]
chudnovsky_term! = |k|
    sign =
        if (k % 2) == 0 then
            1
        else
            -1

    sign_big = Gmp.int_from_i64!(sign)
    fac6k = factorial!(6 * k)
    fac3k = factorial!(3 * k)
    fack = factorial!(k)
    top = 545140134 * k + 13591409
    top_big = Gmp.int_from_i64!(top)

    num_big1 = Gmp.int_mul!(sign_big, fac6k)
    num_big = Gmp.int_mul!(num_big1, top_big)

    fack3 = pow_int!(fack, 3)

    c_big = Gmp.int_from_i64!(640320)
    c_big3 = pow_int!(c_big, 3)
    c_big3_f = bigfloat_from_bigint!(c_big3)?
    sqrt_c3 = Gmp.float_sqrt!(c_big3_f)

    c_f = bigfloat_from_bigint!(c_big)?
    c_pow = pow_float_int!(c_f, 3 * k)

    fac3k_f = bigfloat_from_bigint!(fac3k)?
    fack3_f = bigfloat_from_bigint!(fack3)?
    num_f = bigfloat_from_bigint!(num_big)?

    den1 = Gmp.float_mul!(fac3k_f, fack3_f)
    den2 = Gmp.float_mul!(den1, c_pow)
    den = Gmp.float_mul!(den2, sqrt_c3)

    Gmp.float_div!(num_f, den)

bigfloat_from_bigint! : Gmp.BigInt => Result Gmp.BigFloat [GmpErr Gmp.GmpError]
bigfloat_from_bigint! = |value|
    str = Gmp.int_to_str!(value)
    Gmp.float_from_str!(str)

factorial! : I64 => Gmp.BigInt
factorial! = |n|
    if n <= 1 then
        Gmp.int_from_i64!(1)
    else
        prev = factorial!(n - 1)
        Gmp.int_mul!(prev, Gmp.int_from_i64!(n))

pow_int! : Gmp.BigInt, I64 => Gmp.BigInt
pow_int! = |base, exp|
    if exp <= 0 then
        Gmp.int_from_i64!(1)
    else
        prev = pow_int!(base, exp - 1)
        Gmp.int_mul!(prev, base)

pow_float_int! : Gmp.BigFloat, I64 => Gmp.BigFloat
pow_float_int! = |base, exp|
    if exp <= 0 then
        Gmp.float_from_f64!(1.0)
    else
        prev = pow_float_int!(base, exp - 1)
        Gmp.float_mul!(prev, base)
