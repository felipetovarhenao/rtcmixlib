/* 
    RTcmix functions compiled and imported by Felipe Tovar-Henao © 2020
    Reference:
        function:       description:                                    input type/arguments:                                       output type:    source:                   

        exp()           natural exponent                                float                                                       float           WolframMath
        log2()          log of 2                                        float                                                       float           WolframMath
        cos()           cosine function                                 float                                                       float           WolframMath
        sin()           sine function                                   float                                                       float           WolframMath
        tan()           tangent function                                float                                                       float           WolframMath
        cosh()          hyperbolic cosine function                      float                                                       float           WolframMath
        sinh()          hyperbolic sine function                        float                                                       float           WolframMath
        tanh()          hyperbolic tangent function                     float                                                       float           WolframMath
        fact()          factorial                                       int (+)                                                     float           WolframMath
        map()           linear value mapping                            float, inmin, inmax, outmin, outmax                         float           Diemo Schwarz
        clip()          value clipping                                  float, min, max                                             float           FTH
        rtodur()        playback rate to duration                       inputDuration, rate                                         float           FTH
        rev()           list reverse                                    list                                                        list            FTH
        xtodx()         intervals of a list (delta of x)                list                                                        list            FTH
        dxtox()         list from intervals (x from delta)              list, start_val                                             list            FTH
        dist()          linear or exponential numeric distoriton        list, dist_val, mode (0:linear, 1:exp)                      list            FTH
        rissT()         Risset accelerando time points (onsets)         inputDuration, outputDuration, voiceIndex                   list            Dan Stowell/Daniele Ghisi
        rissR()         Risset accelerando rates                        inputDuration, outputOnsets (from rissT()), voiceIndex      list            Dan Stowell
        rissA()         Risset accelerando amplitudes                   inputDuration, numVoices, voiceIndex                        list            FTH
        sort()          sorts a numeric list in ascending order         list                                                        list            John Gibson
        mattrans()      matrix transposition                            list of lists                                               list of lists   John Gibson
*/
//print_on(1)

PI = 3.14159265359 // Pi constant
e = 2.71828182845 //  Euler's number

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
    for (i_ = 0; i_ < 16; i_ += 1) {
        out_ += pow(-1, i_) * pow(x_, 2*i_) / fact(2*i_) 
    }
    return out_ 
}

float sin(float x_) {
    float out_, i_
    out_ = 0
    for (i_ = 0; i_ < 16; i_ += 1) {
        out_ += pow(-1, i_) * pow(x_, (2*i_) + 1) / fact((2*i_) + 1) 
    }
    return out_ 
}

float tan(float x_) {
    return sin(x_)/cos(x_)
}

float cosh(float x_) {
    float out_, i_
    out_ = 0
    for (i_ = 0; i_ < 8; i_ += 1) {
        out_ += pow(x_, 2*i_) / fact(2*i_) 
    }
    return out_ 
}

float sinh(float x_) {
    float out_, i_
    out_ = 0
    for (i_ = 0; i_ < 8; i_ += 1) {
        out_ += pow(x_, 2*i_+1) / fact(2*i_+1) 
    }
    return out_ 
}

float tanh(float x_) {
    return (exp(x_) - exp(-x_))/(exp(x_) + exp(-x_))
}

float map(float x_, float inmin_, float inmax_, float outmin_, float outmax_) {
    float mi_, ai_ 
    mi_ = ((outmax_ - outmin_) / (inmax_ - inmin_))
    ai_ = outmin_ - inmin_ * mi_
    return mi_ * x_ + ai_
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

float rtodur(float d_, float r_) {
    float t_, td_
    t_ = log2(r_)
    t_ = map(t_, 0, 1, 0, 0.012)
    t_ = t_ * 1000
    td_ = (t_ % 12) / 100
    t_ = trunc(t_/10)
    return translen(d_, t_ + td_)
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

list dist(list l_, float d_, float mode_) {
    float i_
    list out_
    l_ = sort(l_)
    if (mode_ == 0) { 
        for (i_ = 0; i_ < len(l_); i_ += 1) {
            out_[i_] = (l_[i_] - l_[0]) * d_ + l_[0]
        }
    } else if (mode_ == 1) {
        for (i_ = 0; i_ < len(l_); i_ += 1) {
            out_[i_] = l_[0] * pow(l_[i_] / l_[0], d_)
        }     
    }
    return out_
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

list rissA(float T_,  float numv_, float v_) {
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

list mattrans(list mat_) {
	list out_
	float row_, col_, nrows_, ncols_
	out_ = {}
	nrows_ = len(mat_)
	ncols_ = len(mat_[0])
	for (col_ = 0; col_ < ncols_; col_ += 1) {
		list outRow_
		outRow_ = {}
		for (row_ = 0; row_ < nrows_; row_ += 1) {
			list thisRow_
			thisRow_ = mat_[row_]
			outRow_[row_] = thisRow_[col_]
		}
		out_[col_] = outRow_
	}
	return out_
}

list sort(list inl_) {
    list l_
    l_ = inl_
	float i_, j_, n_
	n_ = len(l_)
	for (i_ = 0; i_ < n_ - 1; i_ += 1) {
		for (j_ = 0; j_ < n_ - i_ - 1; j_ += 1) {
			if (l_[j_] > l_[j_ + 1]) {
				float tmp_
				tmp_ = l_[j_]
				l_[j_] = l_[j_ + 1]
				l_[j_ + 1] = tmp_
			}
		}
	}
	return l_
}



