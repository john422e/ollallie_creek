fun int findIndex( float x, float aList[] ) {
  // returns index of x; returns -1 if not found
  for( 0 => int i; i < aList.size(); i++ ) {
    if( aList[i] == x ) return i;
  }
  return -1;
}

fun int findIndex( float x, int aList[] ) {
  // returns index of x; returns -1 if not found
  for( 0 => int i; i < aList.size(); i++ ) {
    if( aList[i] == x ) return i;
  }
  return -1;
}

fun float linearInterpolation(float xVals[], float yVals[], float x) {
    /*
    xVals = array of length 2
    yVals = array of length 2
    x = value in between x1 and x2
    solving for y
    y = y1 + ( (y2-y1)/(x2-x1) ) * (x-x1)
    */
    yVals[0] => float y1;
    yVals[1] => float y2;
    xVals[0] => float x1;
    xVals[1] => float x2;
    y1 + ( (y2-y1)/(x2-x1) ) * (x-x1) => float y;
    return y;
}

fun int findLowerNeighbor(float x, float vals[]) {
    /*
    returns the index of the lower neighbor of the check_val (x)
    vals[n1] < x < vals[n2]
    */
    if( x < vals[0] || x > vals[vals.size()-1] ) {
        <<< "x val out of range" >>>;
        return 0;
    }
    for( 0 => int i; i < vals.size(); i++ ) {
        if( x > vals[i] && x < vals[i+1] ) {
            return i;
            //<<< vals[i], x, vals[i+1] >>>;
            // return i
        }
    }
}

fun float iso226_conversion( float freq ) {
    [20.0, 25.0, 31.5, 40.0, 50.0, 63.0, 80.0, 100.0, 125.0, 160.0,
    200.0, 250.0, 315.0, 400.0, 500.0, 630.0, 800.0, 1000.0, 1250.0, 1600.0,
    2000.0, 2500.0, 3150.0, 4000.0, 5000.0, 6300.0, 8000.0, 1000.0, 12500.0] @=> float freqs[];

    [114.26, 109.25, 104.38, 99.78, 95.87, 92.18, 88.64, 85.60, 82.85,
    80.17, 77.92, 75.94, 74.16, 72.58, 71.47, 70.50, 69.78, 70.01, 72.32, 73.47,
    70.28, 67.58, 66.76, 67.95, 71.26, 76.59, 81.54, 82.46, 77.04] @=> float spls[];

    // check to see if freq is in table and return that SPL if so
    findIndex(freq, freqs) => int index;
    if( index >= 0 ) return spls[index];
    // check to see if freq is in range
    else if( freq < freqs[0] || freq > freqs[freqs.size()-1] ) {
        <<< "freq out of table range. must be between 20.0 and 12500.0" >>>;
        return 0.0;
    }
    // else interpolate the SPL value
    else {
        findLowerNeighbor( freq, freqs ) => int i;
        linearInterpolation( [freqs[i], freqs[i+1]], [spls[i], spls[i+1]], freq ) => float spl;
        return spl;
      }
    }


SinOsc s => Envelope e => dac;
90 => float freq;
0.5 => float gain;

0.1 => e.time;

while( freq < 10000 ) {
  Std.rand2f(100, 5000) => freq;
  iso226_conversion(freq) => float spl;
  Std.dbtorms(spl) => gain;
  freq => s.freq;
  gain => s.gain;
  e.keyOn();
  <<< freq, gain >>>;
  100::ms => now;
  e.keyOff();
  100::ms => now;
  //1.125 *=> freq;
}
