/* 
    RTcmix functions imported by Felipe Tovar-Henao © 2020
    Documentation:
        function:       description:                                    arguments:                                                  output type:                   

        exp()           natural exponent                                float                                                       float
        log2()          log of 2                                        float                                                       float
        cos()           cosine function                                 float                                                       float
        fact()          factorial                                       int (+)                                                     float
        map()           scaling                                         float, inmin, inmax, outmin, outmax                         float
        clip()          value clipping                                  float, min, max                                             float
        rev()           list reverse                                    list                                                        list
        xtodx()         intervals of a list (delta of x)                list                                                        list
        dxtox()         list from intervals (x from delta)              list, start_val                                             list
        rissT()         Risset accelerando time points (onsets)         inputDuration, outputDuration, voiceIndex                   list
        rissR()         Risset accelerando rates                        inputDuration, outputOnsets (from rissT()), voiceIndex      list
        rissA()         Risset accelerando amplitudes                   inputDuration, voiceIndex, numVoices                        list
*/

PI = 3.14159265 // Pi constant
e = 2.71828182 //  Euler's number

float exp(float n_) {
    return pow(e, n_)
}

float log2(float n_) {
   return log(n_)/log(2) 
}

float fact(float n_) {
    float r_, i_
    r_ = 1
    if (n_ > 0) {
        for (i_ = 0; i_ < n_; i_ += 1) {
            r_ *= (n_ - i_) 
        }
    }
    return r_
}
float cos(float x_) {
    float out_, i_
    out_ = 0
    for (i_ = 0; i_ < 10; i_ += 1) {
        out_ += pow(-1, i_) * pow(x_, 2*i_) / fact(2*i_) 
    }
    return out_ 
}

float map(float x, float inmin, float inmax, float outmin, float outmax) {
    float mi, ai 
    mi = ((outmax - outmin) / (inmax - inmin))
    ai = outmin - inmin * mi
    return mi * x + ai
}

float clip(float i_, float min_, float max_) {
    float out_
    if (i_ < min_) {
        out_ = min_
    } else if (i_ > max_) {
        out_ = max_
    } else {
        out_ = i_
    }
    return out_
}

list rev(list l_) {
    float i_
    list out_
    out_ = {}
    for (i_ = 0; i_ < len(l_); i_ += 1) {
        out_[i_] = l_[len(l_) - 1 - i_]
    }
    return out_
}

list xtodx(list x_) {
    float i_
    list dx_
    dx_ = {}
    for (i_ = 0;  i_ < len(x_) - 1; i_ += 1) {
        dx_[i_] = x_[i_+1] - x_[i_] 
    }
    return dx_ 
}

list dxtox(list dx_, float st_) {
    float i_
    list x_
    x_ = {st_}
    for (i_ = 1; i_ < len(dx_); i_ += 1) {
        x_[i_] = x_[i_-1] + dx_[i_-1] 
    }
    return x_ 
}

list rissT(float T_, float tau_, float v_) {
    float tl_
    list teList_
    teList_ = {}
    for (tl_ = 0;  tl_ <= T_ * pow(2, v_);  tl_ += 1) {
        teList_[tl_] = tau_ * (log2((tl_/T_) + pow(2, v_)) - v_) 
    }
    return teList_ 
}

float rissR(float T_, list teList_, float v_) {
    float tau_, te_, i_
    list rList_
    rList_ = {}
    tau_ = teList_[len(teList_) - 1]
    for (i_ = 0; i_ < len(teList_); i_ += 1) {
        te_ = teList_[i_]
        rList_[i_] = T_ * log(2) / tau_ * pow(2, te_/tau_ + v_)
    }
    return rList_
}

list rissA(float T_, float v_, float numv_) {
    float i_, len_, incr_, st_
    list at_ 
    len_ = pow(2,v_)
    st_ = PI * 2 / numv_
    incr_ = st_ / pow(2,v_) / T_
    st_ *= v_
    at_ = {}
    for (i_ = 0; i_ < len_ * T_; i_ += 1) {
        at_[i_] = (cos((st_ + (incr_ * i_))) * -0.5) + 0.5
    }
    return at_
}



