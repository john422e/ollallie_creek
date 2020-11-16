//pi_one_player.ck
// John Eagle
// 1/12/19
// for still life: Ollallie Creek

// pi one

//   4 3 x 2 1
// osc
OscIn in;
OscMsg msg;
10001 => in.port;
in.listenAll();

// sound network
SinOsc s => dac;

// because of distortion 
dac.gain(0.9); // is this too high?

// initialize volume
0 => s.gain;

// GLOBAL VARIABLES

// frequency array
//0.      1.       2.       3.       4.       5.       6.       7.      8.       9.       10.      11. 
[1120.65, 1120.65, 1129.43, 1152.36, 1389.98, 1119.8, 1160.58, 1300.77, 1120.64, 1511.19, 1129.59, 1129.59] @=> float freqs1[];
[896.35,  896.35,  967.15,  768.33,  1086.66, 932.6,  992.07,  1073.35, 744.26,  1078.73, 755.43,  755.43] @=> float freqs2[];
//[448.88,  448.88,  379.21,  538.94,  977.06,  839.42, 868.88,  492.78,  420.84,  648.54,  677.2,   677.2] @=> float freqs3[];
//[372.7,   372.7,   338.71,  517.7,   869.16,  446.9,  385.73,  431.04,  371.28,  432.74,  453.18,  453.18] @=> float freqs4[];
// amplitude array
[0.0,     0.85,    0.7,     0.7,     0.85,    0.85,    0.85,    0.0,    0.73,    0.0,     0.87,    0.0] @=> float amps[];
// timing array
[0,       30,      90,      150,     210,     270,     330,     390,    450,     510,     570,     630] @=> int times[]; // 26 timing markers

// time variables
0 => int second_i; // current second
0 => int displayMinute => int displaySecond; // for display
720 => int end; // when to stop loop

0 => int index; // freq array index
0 => int soundOn; // switch for sound (0 or 1)
5.0 => float thresh1; // distance threshold (lower than values trigger sound)
10.0 => float thresh2; // distance threshold (lower than values trigger sound)

// adjust starting position if command line argument present
Std.atoi(me.arg(0)) => index; // user provides section number (same as index value)
times[index] => second_i; // sets second_i from index
<<< "start at index:", index, "second:", second_i >>>;

// gain variables
0.0 => float targetGain;
0.0 => float gainPosition;
0.005 => float gainInc;

// functions
fun void fadeIn()
{
    while( gainPosition <= targetGain )
    {
        gainPosition + gainInc => gainPosition;
        gainPosition => s.gain;
        //<<< gainPosition >>>;
        10::ms => now;
    }
    //<<< "end" >>>;
}

fun void fadeOut()
{
    while( gainPosition > 0.0 )
    {
        gainPosition - gainInc => gainPosition;
        gainPosition => s.gain;
        10::ms => now;
    }
}

fun void get_reading()
{
    while( second_i <= end )
    { 
        // check for osc messages
        in => now;
        while( in.recv(msg)) {
            // ultrasonic sensor distance
            if( msg.address == "/distance" )
            {
                <<< "/distance", msg.getFloat(0) >>>;
                // turn on sound if value below thresh
                if ( msg.getFloat(0) < thresh1 && msg.getFloat(0) > 0.0)
                {
                    //<<< "sound on!" >>>;
                    1 => soundOn;
                    freqs1[index-1] => s.freq;
                    amps[index-1] => targetGain; // index-1?
                    spork ~ fadeIn();
                }
                else if ( msg.getFloat(0) < thresh2 && msg.getFloat(0) > 0.0)
                {
                    //<<< "sound on!" >>>;
                    1 => soundOn;
                    freqs2[index-1] => s.freq;
                    amps[index-1]*0.5 => targetGain;
                    spork ~ fadeIn();
                }   
                else
                {
                    0 => soundOn;
                    0.0 => targetGain;
                    spork ~ fadeOut();
                }
            }
        }
    }
}


// MAIN PROGRAM

spork ~ get_reading();

// infinite loop
while( second_i <= end )
{
    second_i / 60 => displayMinute;
    second_i % 60 => displaySecond;
    
    // checks for timing interval to update s
    if( times[index] == second_i ) // only gets triggered at each timing interval
    {
        freqs1[index] => s.freq;
        <<< "Time: ", times[index], "Freq:", freqs1[index], "Target Gain:", amps[index] >>>;
        if( index < times.cap()-1 )
        {
            index++;
        }
    }
    <<< "Time:", displayMinute, displaySecond, "Index:", index, "Sound on: ", soundOn , freqs1[index-1] >>>;

    
    // now advance time
    second_i++;
    1::second => now;
}