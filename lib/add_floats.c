int add(float a, float b) {
    int result = 0;

    int exp_a = a & 0x7F800000;
    exp_a >>= 23;
    int exp_b = a & 0x7F800000;
    exp_b >>= 23;

    int mantissa_a = a & f;
    mantissa_a |= 0x800000;

    int mantissa_b = b & 0x7FFFFF;
    mantissa_b |= 0x800000;
B 
    int sub = exp_a - exp_b;
    if (sub > 0) {
        result = exp_a;
        mantissa_b >>= sub;
    } else {
        result = exp_b;
        mantissa_a >>= (exp_b - exp_a);
    }

    int mantissa_sum = mantissa_a + mantissa_b;
    if (((mantissa_a ^ mantissa_sum) & (mantissa_b ^ mantissa_sum)) < 0) {
        result >>= 1;
        result += 1;        
    }

    result <<= 23;
    mantissa_sum &= ~0x800000;
    result |= (0 << 9) | mantissa_sum;
}

// 0000 0001 000 0000 0000 0000 0000 0000

// (9 bits) (23 bits)