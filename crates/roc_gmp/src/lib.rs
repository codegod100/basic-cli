//! This crate provides common functionality for Roc to interface with GMP via rug.
#![allow(non_snake_case)]

use roc_std::{RocBox, RocResult, RocStr};
use roc_std_heap::ThreadSafeRefcountedResourceHeap;
use rug::ops::CompleteRound;
use rug::{Float, Integer};
use std::cmp::Ordering;
use std::str::FromStr;
use std::sync::OnceLock;

const DEFAULT_FLOAT_PRECISION: u32 = 256;

pub struct BigInt {
    value: Integer,
}

pub struct BigFloat {
    value: Float,
}

pub fn int_heap() -> &'static ThreadSafeRefcountedResourceHeap<BigInt> {
    static INT_HEAP: OnceLock<ThreadSafeRefcountedResourceHeap<BigInt>> = OnceLock::new();
    INT_HEAP.get_or_init(|| {
        let default_max_ints = 65536;
        let max_ints = std::env::var("ROC_BASIC_CLI_MAX_GMP_INTS")
            .map(|v| v.parse().unwrap_or(default_max_ints))
            .unwrap_or(default_max_ints);
        ThreadSafeRefcountedResourceHeap::new(max_ints)
            .expect("Failed to allocate mmap for GMP integer references.")
    })
}

pub fn float_heap() -> &'static ThreadSafeRefcountedResourceHeap<BigFloat> {
    static FLOAT_HEAP: OnceLock<ThreadSafeRefcountedResourceHeap<BigFloat>> = OnceLock::new();
    FLOAT_HEAP.get_or_init(|| {
        let default_max_floats = 65536;
        let max_floats = std::env::var("ROC_BASIC_CLI_MAX_GMP_FLOATS")
            .map(|v| v.parse().unwrap_or(default_max_floats))
            .unwrap_or(default_max_floats);
        ThreadSafeRefcountedResourceHeap::new(max_floats)
            .expect("Failed to allocate mmap for GMP float references.")
    })
}

fn alloc_int(value: Integer) -> RocBox<()> {
    let heap = int_heap();
    let alloc_result = heap.alloc_for(BigInt { value });
    match alloc_result {
        Ok(out) => out,
        Err(_) => panic!("Ran out of memory allocating space for GMP integer"),
    }
}

fn alloc_float(value: Float) -> RocBox<()> {
    let heap = float_heap();
    let alloc_result = heap.alloc_for(BigFloat { value });
    match alloc_result {
        Ok(out) => out,
        Err(_) => panic!("Ran out of memory allocating space for GMP float"),
    }
}

pub fn int_from_i64(value: i64) -> RocBox<()> {
    alloc_int(Integer::from(value))
}

pub fn int_from_str(value: &RocStr) -> RocResult<RocBox<()>, RocStr> {
    match Integer::from_str(value.as_str()) {
        Ok(int) => RocResult::ok(alloc_int(int)),
        Err(_) => RocResult::err(RocStr::from("invalid integer")),
    }
}

pub fn int_to_str(int: RocBox<()>) -> RocStr {
    let int: &BigInt = ThreadSafeRefcountedResourceHeap::box_to_resource(int);
    let value = int.value.to_string();
    RocStr::from(value.as_str())
}

pub fn int_add(a: RocBox<()>, b: RocBox<()>) -> RocBox<()> {
    let a: &BigInt = ThreadSafeRefcountedResourceHeap::box_to_resource(a);
    let b: &BigInt = ThreadSafeRefcountedResourceHeap::box_to_resource(b);
    alloc_int((&a.value + &b.value).into())
}

pub fn int_sub(a: RocBox<()>, b: RocBox<()>) -> RocBox<()> {
    let a: &BigInt = ThreadSafeRefcountedResourceHeap::box_to_resource(a);
    let b: &BigInt = ThreadSafeRefcountedResourceHeap::box_to_resource(b);
    alloc_int((&a.value - &b.value).into())
}

pub fn int_mul(a: RocBox<()>, b: RocBox<()>) -> RocBox<()> {
    let a: &BigInt = ThreadSafeRefcountedResourceHeap::box_to_resource(a);
    let b: &BigInt = ThreadSafeRefcountedResourceHeap::box_to_resource(b);
    alloc_int((&a.value * &b.value).into())
}

pub fn int_div(a: RocBox<()>, b: RocBox<()>) -> RocResult<RocBox<()>, RocStr> {
    let a: &BigInt = ThreadSafeRefcountedResourceHeap::box_to_resource(a);
    let b: &BigInt = ThreadSafeRefcountedResourceHeap::box_to_resource(b);
    if b.value == 0 {
        return RocResult::err(RocStr::from("division by zero"));
    }
    RocResult::ok(alloc_int((&a.value / &b.value).into()))
}

pub fn int_mod(a: RocBox<()>, b: RocBox<()>) -> RocResult<RocBox<()>, RocStr> {
    let a: &BigInt = ThreadSafeRefcountedResourceHeap::box_to_resource(a);
    let b: &BigInt = ThreadSafeRefcountedResourceHeap::box_to_resource(b);
    if b.value == 0 {
        return RocResult::err(RocStr::from("division by zero"));
    }
    RocResult::ok(alloc_int((&a.value % &b.value).into()))
}

pub fn int_cmp(a: RocBox<()>, b: RocBox<()>) -> i32 {
    let a: &BigInt = ThreadSafeRefcountedResourceHeap::box_to_resource(a);
    let b: &BigInt = ThreadSafeRefcountedResourceHeap::box_to_resource(b);
    match a.value.cmp(&b.value) {
        Ordering::Less => -1,
        Ordering::Equal => 0,
        Ordering::Greater => 1,
    }
}

pub fn float_from_f64(value: f64) -> RocBox<()> {
    alloc_float(Float::with_val(DEFAULT_FLOAT_PRECISION, value))
}

pub fn float_from_str(value: &RocStr) -> RocResult<RocBox<()>, RocStr> {
    match Float::parse(value.as_str()) {
        Ok(parsed) => RocResult::ok(alloc_float(parsed.complete(DEFAULT_FLOAT_PRECISION.into()))),
        Err(_) => RocResult::err(RocStr::from("invalid float")),
    }
}

pub fn float_to_str(float: RocBox<()>) -> RocStr {
    let float: &BigFloat = ThreadSafeRefcountedResourceHeap::box_to_resource(float);
    let value = float.value.to_string();
    RocStr::from(value.as_str())
}

pub fn float_add(a: RocBox<()>, b: RocBox<()>) -> RocBox<()> {
    let a: &BigFloat = ThreadSafeRefcountedResourceHeap::box_to_resource(a);
    let b: &BigFloat = ThreadSafeRefcountedResourceHeap::box_to_resource(b);
    alloc_float((&a.value + &b.value).complete(DEFAULT_FLOAT_PRECISION.into()))
}

pub fn float_sub(a: RocBox<()>, b: RocBox<()>) -> RocBox<()> {
    let a: &BigFloat = ThreadSafeRefcountedResourceHeap::box_to_resource(a);
    let b: &BigFloat = ThreadSafeRefcountedResourceHeap::box_to_resource(b);
    alloc_float((&a.value - &b.value).complete(DEFAULT_FLOAT_PRECISION.into()))
}

pub fn float_mul(a: RocBox<()>, b: RocBox<()>) -> RocBox<()> {
    let a: &BigFloat = ThreadSafeRefcountedResourceHeap::box_to_resource(a);
    let b: &BigFloat = ThreadSafeRefcountedResourceHeap::box_to_resource(b);
    alloc_float((&a.value * &b.value).complete(DEFAULT_FLOAT_PRECISION.into()))
}

pub fn float_div(a: RocBox<()>, b: RocBox<()>) -> RocResult<RocBox<()>, RocStr> {
    let a: &BigFloat = ThreadSafeRefcountedResourceHeap::box_to_resource(a);
    let b: &BigFloat = ThreadSafeRefcountedResourceHeap::box_to_resource(b);
    if b.value == 0 {
        return RocResult::err(RocStr::from("division by zero"));
    }
    RocResult::ok(alloc_float(
        (&a.value / &b.value).complete(DEFAULT_FLOAT_PRECISION.into()),
    ))
}

pub fn float_cmp(a: RocBox<()>, b: RocBox<()>) -> i32 {
    let a: &BigFloat = ThreadSafeRefcountedResourceHeap::box_to_resource(a);
    let b: &BigFloat = ThreadSafeRefcountedResourceHeap::box_to_resource(b);
    match a.value.partial_cmp(&b.value) {
        Some(Ordering::Less) => -1,
        Some(Ordering::Equal) => 0,
        Some(Ordering::Greater) => 1,
        None => 0,
    }
}

pub fn float_sqrt(value: RocBox<()>) -> RocBox<()> {
    let value: &BigFloat = ThreadSafeRefcountedResourceHeap::box_to_resource(value);
    let out = value.value.clone().sqrt();
    alloc_float(out)
}

pub fn float_exp(value: RocBox<()>) -> RocBox<()> {
    let value: &BigFloat = ThreadSafeRefcountedResourceHeap::box_to_resource(value);
    let out = value.value.clone().exp();
    alloc_float(out)
}

pub fn float_ln(value: RocBox<()>) -> RocBox<()> {
    let value: &BigFloat = ThreadSafeRefcountedResourceHeap::box_to_resource(value);
    let out = value.value.clone().ln();
    alloc_float(out)
}

pub fn float_log10(value: RocBox<()>) -> RocBox<()> {
    let value: &BigFloat = ThreadSafeRefcountedResourceHeap::box_to_resource(value);
    let out = value.value.clone().log10();
    alloc_float(out)
}

pub fn float_sin(value: RocBox<()>) -> RocBox<()> {
    let value: &BigFloat = ThreadSafeRefcountedResourceHeap::box_to_resource(value);
    let out = value.value.clone().sin();
    alloc_float(out)
}

pub fn float_cos(value: RocBox<()>) -> RocBox<()> {
    let value: &BigFloat = ThreadSafeRefcountedResourceHeap::box_to_resource(value);
    let out = value.value.clone().cos();
    alloc_float(out)
}

pub fn float_tan(value: RocBox<()>) -> RocBox<()> {
    let value: &BigFloat = ThreadSafeRefcountedResourceHeap::box_to_resource(value);
    let out = value.value.clone().tan();
    alloc_float(out)
}
