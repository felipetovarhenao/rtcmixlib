sr = 44100
outchans = 2
rtsetparams(sr, outchans)
control_rate(sr)
srand()
load("SCRUB")
load("STEREO")
tblsize = 1000
//print_on(1)

include risslib.sco // Risset-Math library

rtinput("/Users/felipetovarhenao/Documents/Audio samples/prepared piano/3. Spectrum C/C3.aif") // load sample

env = maketable("curve", "nonorm", tblsize = 3000, 0,0,1, 1,1,2, 99,1,-2, 100,0)

insk = 0 // inskip
numv = 8 // number of voices
minbar = 1 // lowest number of repetitions on metabar 
metabar = DUR() * 1.5 //minbar // metabar duration
bars = 30 // number of metabars

mode = 0 // 0: rallentando; 1: accelerando

phasemode = 0 // traverse through inskip in slow increments
phasesize = 0.01 // increment amount for each metabar

pitchshift = 1 // scrub or stereo

dist = 0.1// onset distortion

for (v = 0; v < numv; v += 1) {
    phase = 0
    timeList = rissT(minbar, metabar, v) // get time points
    rateList = rissR(minbar, timeList, v) // rate must be derived first
    ampList = rissA(minbar, numv, v) // get amplitudes
    durList = xtodx(timeList) // get durations from time points (delta)

    if (!mode) {
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
            amp = ampList[i]
            if (pitchshift) {
                SCRUB(max(0, st + (metabar*b) + irand(-dist, dist)), insk + (phase*rate), dur, amp, rate, 64, 32, 0, 0.5)
            } else {
                STEREO(max(0, st + (metabar*b) + irand(-dist, dist)), insk + phase, dur, amp * env * 0.2, pan)
            }

            if (phasemode) {
                if (insk < DUR() - dur) {
                    phase += (phasesize / (pow(2,v) * minbar)) // slow inskip phasing
                }
            }
        }
    }
}

