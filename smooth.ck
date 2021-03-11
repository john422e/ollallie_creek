int num;
0 => int minRange;
30 => int maxRange;

0.0 => float last_reading;

fun float smooth_vals( float new_reading ) {
    (last_reading + new_reading) * 0.5 => float smoothed;
    <<< last_reading, new_reading, smoothed >>>;
    new_reading => last_reading;
    (smoothed - minRange) / (30) => float amp;
    return amp;
}

while( true ) {
    100::ms => now;
    Std.rand2(1, 30) => num;
    <<< smooth_vals( num ) >>>;
    }