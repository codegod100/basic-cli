module [
    GmpError,
    BigInt,
    BigFloat,
    int_from_i64!,
    int_from_str!,
    int_to_str!,
    int_add!,
    int_sub!,
    int_mul!,
    int_div!,
    int_mod!,
    int_cmp!,
    float_from_f64!,
    float_from_str!,
    float_to_str!,
    float_add!,
    float_sub!,
    float_mul!,
    float_div!,
    float_cmp!,
    float_sqrt!,
    float_exp!,
    float_ln!,
    float_log10!,
    float_sin!,
    float_cos!,
    float_tan!,
]

import Host
import InternalGmp

## Errors returned by GMP-backed operations.
GmpError : [
    ParseErr Str,
    DivByZero,
]

handle_err : InternalGmp.GmpError -> [GmpErr GmpError]
handle_err = |msg|
    if msg == "division by zero" then
        GmpErr(DivByZero)
    else
        GmpErr(ParseErr(msg))

BigInt := Box {}
BigFloat := Box {}

int_from_i64! : I64 => BigInt
int_from_i64! = |value|
    @BigInt(Host.gmp_int_from_i64!(value))

int_from_str! : Str => Result BigInt [GmpErr GmpError]
int_from_str! = |value|
    Host.gmp_int_from_str!(value)
    |> Result.map_ok(@BigInt)
    |> Result.map_err(handle_err)

int_to_str! : BigInt => Str
int_to_str! = |@BigInt(value)|
    Host.gmp_int_to_str!(value)

int_add! : BigInt, BigInt => BigInt
int_add! = |@BigInt(a), @BigInt(b)|
    @BigInt(Host.gmp_int_add!(a, b))

int_sub! : BigInt, BigInt => BigInt
int_sub! = |@BigInt(a), @BigInt(b)|
    @BigInt(Host.gmp_int_sub!(a, b))

int_mul! : BigInt, BigInt => BigInt
int_mul! = |@BigInt(a), @BigInt(b)|
    @BigInt(Host.gmp_int_mul!(a, b))

int_div! : BigInt, BigInt => Result BigInt [GmpErr GmpError]
int_div! = |@BigInt(a), @BigInt(b)|
    Host.gmp_int_div!(a, b)
    |> Result.map_ok(@BigInt)
    |> Result.map_err(handle_err)

int_mod! : BigInt, BigInt => Result BigInt [GmpErr GmpError]
int_mod! = |@BigInt(a), @BigInt(b)|
    Host.gmp_int_mod!(a, b)
    |> Result.map_ok(@BigInt)
    |> Result.map_err(handle_err)

int_cmp! : BigInt, BigInt => I32
int_cmp! = |@BigInt(a), @BigInt(b)|
    Host.gmp_int_cmp!(a, b)

float_from_f64! : F64 => BigFloat
float_from_f64! = |value|
    @BigFloat(Host.gmp_float_from_f64!(value))

float_from_str! : Str => Result BigFloat [GmpErr GmpError]
float_from_str! = |value|
    Host.gmp_float_from_str!(value)
    |> Result.map_ok(@BigFloat)
    |> Result.map_err(handle_err)

float_to_str! : BigFloat => Str
float_to_str! = |@BigFloat(value)|
    Host.gmp_float_to_str!(value)

float_add! : BigFloat, BigFloat => BigFloat
float_add! = |@BigFloat(a), @BigFloat(b)|
    @BigFloat(Host.gmp_float_add!(a, b))

float_sub! : BigFloat, BigFloat => BigFloat
float_sub! = |@BigFloat(a), @BigFloat(b)|
    @BigFloat(Host.gmp_float_sub!(a, b))

float_mul! : BigFloat, BigFloat => BigFloat
float_mul! = |@BigFloat(a), @BigFloat(b)|
    @BigFloat(Host.gmp_float_mul!(a, b))

float_div! : BigFloat, BigFloat => Result BigFloat [GmpErr GmpError]
float_div! = |@BigFloat(a), @BigFloat(b)|
    Host.gmp_float_div!(a, b)
    |> Result.map_ok(@BigFloat)
    |> Result.map_err(handle_err)

float_cmp! : BigFloat, BigFloat => I32
float_cmp! = |@BigFloat(a), @BigFloat(b)|
    Host.gmp_float_cmp!(a, b)

float_sqrt! : BigFloat => BigFloat
float_sqrt! = |@BigFloat(value)|
    @BigFloat(Host.gmp_float_sqrt!(value))

float_exp! : BigFloat => BigFloat
float_exp! = |@BigFloat(value)|
    @BigFloat(Host.gmp_float_exp!(value))

float_ln! : BigFloat => BigFloat
float_ln! = |@BigFloat(value)|
    @BigFloat(Host.gmp_float_ln!(value))

float_log10! : BigFloat => BigFloat
float_log10! = |@BigFloat(value)|
    @BigFloat(Host.gmp_float_log10!(value))

float_sin! : BigFloat => BigFloat
float_sin! = |@BigFloat(value)|
    @BigFloat(Host.gmp_float_sin!(value))

float_cos! : BigFloat => BigFloat
float_cos! = |@BigFloat(value)|
    @BigFloat(Host.gmp_float_cos!(value))

float_tan! : BigFloat => BigFloat
float_tan! = |@BigFloat(value)|
    @BigFloat(Host.gmp_float_tan!(value))
