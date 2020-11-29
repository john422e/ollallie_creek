SinOsc s => Envelope e => LPF f1 => BRF f2 => dac;

50 => s.freq;
250 => f1.freq;
0.1 => f1.Q;
600 => f2.freq;
0.9 => f2.Q;

for ( 0 => int i; s.freq() < 1500; i++ ) {
    e.keyOn();
    <<< s.freq() >>>;
    0.25::second => now;
    e.keyOff();
    s.freq() + 25 => s.freq;
}