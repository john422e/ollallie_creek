def linear_interpolation(x_vals, y_vals, x):
    """
    x_vals = array of length 2
    y_vals = array of length 2
    x = value in between x1 and x2
    solving for y
    y = y1 + ( (y2-y1)/(x2-x1) ) * (x-x1)
    """
    y1, y2 = y_vals
    x1, x2 = x_vals
    y = y1 + ( (y2-y1)/(x2-x1) ) * (x-x1)
    return y

def find_nearest_vals(x, vals):
    """
    returns the index of the lower neighbor of the check_val (x)
    vals[n1] < x < vals[n2]
    """
    for i, n in enumerate(vals):
        if x > n and x < vals[i+1]:
            return i
            #n1 = i
            #break
    #return n1 #n2 is just n1+1

def iso226_conversion(freq):
    # table
    freqs = [20.0, 25.0, 31.5, 40.0, 50.0, 63.0, 80.0, 100.0, 125.0, 160.0,
    200.0, 250.0, 315.0, 400.0, 500.0, 630.0, 800.0, 1000.0, 1250.0, 1600.0,
    2000.0, 2500.0, 3150.0, 4000.0, 5000.0, 6300.0, 8000.0, 1000.0, 12500.0]
    spls = [114.26, 109.25, 104.38, 99.78, 95.87, 92.18, 88.64, 85.60, 82.85,
    80.17, 77.92, 75.94, 74.16, 72.58, 71.47, 70.50, 69.78, 70.01, 72.32, 73.47,
    70.28, 67.58, 66.76, 67.95, 71.26, 76.59, 81.54, 82.46, 77.04]

    if freq < freqs[0] or freq > freqs[-1]:
        print("freq out of table range. must be between 20 and 12500")
        return None
    if freq not in freqs:
        # find nearest vals
        i = find_nearest_vals(freq, freqs)
        spl = round(linear_interpolation(freqs[i:i+2], spls[i:i+2], freq), 2)
        #print(freq, spl, freqs[i:i+2], spls[i:i+2])
    else:
        i = freqs.index(freq)
        spl = spls[i]
        #print(freq, spl)
    return spl

    #print(len(freqs), len(spls))

for freq in range(10, 2001, 10):
    spl = iso226_conversion(freq)
    print(freq, spl)
    input()
