sr = 44100
outchans = 2
rtsetparams(sr, outchans)
control_rate(sr)
srand()
load("SCRUB")
load("STEREO")
tblsize = 1000

include risslib.sco // Risset-Math library

rtinput("/Users/felipetovarhenao/Documents/Audio samples/prepared piano/0. Spectrum F/F0.aif") // load sample

env = maketable("curve", "nonorm", tblsize = 3000, 0,0,1, 1,1,2, 30,1,-2, 100,0)

insk = 0 // inskip
numv = 7 // number of voices
minbar = 1 // lowest number of repetitions on metabar 
metabar = DUR() //minbar // metabar duration
mode = 1 // 0: accelerando; 1: rallentando
bars = 30 // number of metabars

phasemode = 0 // traverse through inskip in slow increments
phasesize = 0.1 // increment amount for each metabar

pitchshift = 1 // scrub or stereo

for (v = 0; v < numv; v += 1) {
    phase = 0
    timeList = rissT(minbar, metabar, v) // get time points
    rateList = rissR(minbar, timeList, v) // rate must be derived first
    ampList = rissA(minbar, v, numv) // get amplitudes
    durList = xtodx(timeList) // get durations from time points (delta)

    if (mode) {
        rateList = rev(rateList) // reverse rates
        ampList = rev(ampList) // reverse amplitudes
        durList = rev(durList) // reverse durations
        timeList = dxtox(durList) // get new onsets from durations
    }

    pan = v/numv // pan each voice differenty throughout

    for (b = 0; b < bars; b += 1) { // iterate metabar
        for (i = 0; i < len(durList); i += 1) { // play each note/grain
            st = timeList[i]
            dur = durList[i]
            rate = rateList[i]
            amp = clip(ampList[i], 0, 1) // limit amplitude to the range of 0 to 1 (safety measures)

            if (pitchshift) {
                SCRUB(st + (metabar*b), insk, dur, amp, rate, 64, 32, 0, 0.5)
            } else {
                STEREO(st + (metabar*b), insk + phase, dur, amp * env * 0.2, pan)
            }

            if (phasemode) {
                if (insk < DUR() - dur) {
                    phase += (phasesize / (pow(2,v) * minbar)) // slow inskip phasing
                }
            }
        }
    }
}

