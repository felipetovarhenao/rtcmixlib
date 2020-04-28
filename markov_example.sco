sr = 44100
outchans = 2
rtsetparams(sr, outchans)
control_rate(sr)
srand()
load("WAVETABLE")
tblsize = 1000

include risslib.sco // Risset-Math library

srand()
print_on(1)
pitchList = {0, 2, 4, 7, 4, 7, 4, 7, 4, 7, 4, 4, 0, 2, 4, 7, 4, 7, 4, 7, 5, 9, 16, 18, 16} + 60
durList = {1, 1, 1.5, 0.5, 1.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1, 2, 0.5, 0.5, 1.5, 0.5, 1.5, 0.5, 0.5, 0.5, 0.5, 0.5, 3, 1}
eventList = mattrans({pitchList, durList})

seq = indexmap2(eventList)
dictionary = thin2(eventList)
model = markov(seq, 2, 130)
print(model)

st = 0
env = maketable("curve", "nonorm", tblsize, 0,0,2, 1,1,-1, 2,0.5,-2, 300,0)
incr = 0.4
for (i = 0; i < len(model); i += 1) {
    wv = maketable("wave", tblsize, "tri" + trand(2, 13))
    dur = irand(0.7, 1.5)
    amp = trand(5000, 9000)
    event = dictionary[model[i]]
    fq = cpsmidi(event[0])
    
    incr = event[1] * 0.3
    WAVETABLE(st, dur * 2, amp * env, fq, random(), wv)
    WAVETABLE(st, dur * 2, amp * env / 2, fq + irand(-2, 2), random(), wv)
    WAVETABLE(st, dur * 2, amp * env / 2, fq + irand(-2, 2), random(), wv)
    st += incr
}

print(pickwrand(0,0,1,0,2,0,3,0))

