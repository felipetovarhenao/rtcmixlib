/* 
    *****************
    *   fthlib.sco  *
    *****************
    Compilation of functions imported to RTcmix by Felipe Tovar-Henao © 2020

    Reference:
            function:       description:                                    input type/arguments:                                       output type:    source:                   
---------------------------------------------------------   Math functions  ------------------------------------------------------------------------------------------------------
            exp()           natural exponent                                float                                                       float           WolframMath
            log2()          log of 2                                        float                                                       float           WolframMath
            cos()           cosine function                                 float                                                       float           WolframMath
            sin()           sine function                                   float                                                       float           WolframMath
            tan()           tangent function                                float                                                       float           WolframMath
            cosh()          hyperbolic cosine function                      float                                                       float           WolframMath
            sinh()          hyperbolic sine function                        float                                                       float           WolframMath
            tanh()          hyperbolic tangent function                     float                                                       float           WolframMath
            fact()          factorial                                       float                                                       float           WolframMath
---------------------------------------------------------   Data processing  ------------------------------------------------------------------------------------------------------
            map()           linear value mapping                            float, inmin, inmax, outmin, outmax                         float           Diemo Schwarz
            clip()          value clipping                                  float, min, max                                             float           FTH
            rev()           reverse list                                    list                                                        list            FTH
            xtodx()         intervals of a list (delta of x)                list                                                        list            FTH
            dxtox()         list from intervals (x from delta)              list, start_val                                             list            FTH
            numdist()       linear or exponential numeric distoriton        list, dist_val, mode (0:linear, 1:exp)                      list            FTH
---------------------------------------------------------   Risset illusions ------------------------------------------------------------------------------------------------------
            rtodur()        playback rate to duration                       inputDuration, rate                                         float           FTH
            riss.onsets()   Risset accelerando time points (onsets)         inputDuration, outputDuration, voiceIndex                   list            Dan Stowell/Daniele Ghisi
            riss.rates()    Risset accelerando rates                        inputDuration, outputOnsets (from rissT()), voiceIndex      list            Dan Stowell
            riss.amps()     Risset accelerando amplitudes                   inputDuration, numVoices, voiceIndex                        list            FTH
---------------------------------------------------------   List processing  ------------------------------------------------------------------------------------------------------
            sort()          sorts a numeric list in ascending order         list                                                        list            John Gibson
            slice()         splits a list from given an index               list, index                                                 list of lists   David Zicarelli
            ecils()         same as slice() but index is nth-to-last        list, nth-to-lastIndex                                      list of lists   David Zicarelli
            group()         group list into sublists of n elements          list, sublistSize                                           list of lists   OpenMusic
            thin()          remove element duplicates                       list                                                        list            OpenMusic
            merge()         combines two lists into one                     listA, listB                                                list            OpenMusic
            mattrans()      matrix transposition (rows <-> columns)         list of lists                                               list of lists   John Gibson
            compare()       boolean equality of two lists                   listA, listB                                                int (0,1)       OpenMusic
            range()         extract elements within index range             listA, listB                                                int (0,1)       OpenMusic
            frames()        create sequence of frames/windows               listA, listB                                                int (0,1)       OpenMusic
            ltos()          list to string conversion                       listA, listB                                                list            OpenMusic
            merge()         combines two lists into one                     listA, listB                                                list            OpenMusic
            indexmap()      index list detecting element repetition         list                                                        list            OpenMusic
            getpos()        find index position of element in list          list, float                                                 list            OpenMusic
            getpos2()       find index position of list in list             list of lists, list                                         list            OpenMusic
---------------------------------------------------------   Machine learning  ------------------------------------------------------------------------------------------------------
            markov.build()  build a markov model from a data set            dataset, order                                              list of lists   FTH
            markov.run()    run a markov model                              states, matrix, numiterations                               list of lists   FTH
            markov()        build and run markov model                      dataset, order, numiterations                               list            FTH
*/

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
    n_ = abs(n_)
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

list numdist(list l_, float d_, float mode_) {
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

list riss.times(float T_, float tau_, float v_) {
    float tl_
    list teList_
    teList_ = {}
    for (tl_ = 0;  tl_ <= T_ * pow(2, v_);  tl_ += 1) {
        teList_[tl_] = tau_ * (log2((tl_/T_) + pow(2, v_)) - v_) 
    }
    return teList_ 
}

float riss.rates(float T_, list teList_, float v_) {
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

list riss.amps(float T_,  float numv_, float v_) {
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

list slice(list l_, float n_) {
    float i_
    list la_, lb_, lout_
    la_ = {}
    lb_ = {}
    for (i_ = 0; i_ < len(l_); i_ += 1) {
        if (i_ < n_) {
            la_[i_] = l_[i_]
        } else if (i_ >= n_) {
            lb_[i_ - n_] = l_[i_]
        }
    }
    lout_ = {la_, lb_}
    return lout_
} 

list ecils(list l_, float n_) {
    float i_
    n_ = len(l_) - n_
    list la_, lb_, lout_
    la_ = {}
    lb_ = {}
    for (i_ = 0; i_ < len(l_); i_ += 1) {
        if (i_ < n_) {
            la_[i_] = l_[i_]
        } else if (i_ >= n_) {
            lb_[i_ - n_] = l_[i_]
        }
    }
    lout_ = {la_, lb_}
    return lout_
} 

list group(list l_, float g_) {
    float i_, j_
    list lout_
    lout = {}
    j_ = 0
    for (i_ = 0; i_ < round(len(l_)/g_); i_ += 1) {
        list _tl
        tl_ = {}
        for (j_ = 0; j_ < g_; j_ += 1) {
            float li_
            li_ = j_ + (g_*i_)
            if (li_ < len(l_)) {
                tl_[j_] = l_[j_ + (g_*i_)]
            }
        }
        lout_[i_] = tl_
    }
    return lout_
}

list merge(list la_, list lb_) {
    float i_
    list lout_
    lout_ = la_
    for (i_ = 0; i_ < len(lb_); i_ += 1) {
        lout_[len(lout_)] = lb_[i_]
    }
    return lout_
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

list range(list l_, float st_, float end_) {
    float i_
    list out_
    out_ = {}
    for (i_ = 0; i_ <= abs(end_-st_); i_ += 1) {
        out_[i_] = l_[st_ + i_]
    }
    return out_
}

list frames(list l_, float ws_, float hs_) {
    list out_
    if (hs_ > 0) {
        float i_, k_
        out_ = {}
        k_ = 0
        for (i_ = 0; i_ < len(l_) - ws_ + 1; i_ += hs_) {
            out_[k_] = range(l_, i_, i_ + ws_ - 1)
            k_ += 1
        }
    }
    return out_
}

float compare(list la_, list lb_) {
    float out_
    if (len(la_) == len(lb_)) {
        float i_
        out_ = 1
        for (i_ = 0; i_ < len(la_); i_ += 1) {
            if ((type(la_[i_]) == type(lb_[i_])) && (type(la_[i_]) == "float" || type(la_[i_]) == "string")) {
                if (la_[i_] != lb_[i_]) {
                    out_ = 0
                    i_ = len(la_)
                }
            } else if (type(la_[i_]) == "list" && type(lb_[i_]) == "list") {
                if (!compare(la_[i_], lb_[i_])) {
                    out_ = 0
                    i_ = len(la_)
                }
            } else {
                out_ = 0
                i_ = len(la_)
            }
        }
    }
    return out_
}

list reduce(list l_) {
    float i_, out_
    out_ = 0
    for (i_ = 0; i_ < len(l_); i_ += 1) {
        if (type(l_[i_]) == "float") {
            out_ += l_[i_]
        } else if (type(l_[i_]) == "list") {
            out_ += reduce(l_[i_])
        }
    }
    return out_
}

list getpos(list l_, float e_) {
    float i_, j_
    list out_
    j_ = 0
    for (i_ = 0; i_ < len(l_); i_ += 1) {
        if (l_[i_] == e_) {
            out_[j_] = i_
            j_ += 1
        }
    }
    return out_
}

list getpos2(list l_, list e_) {
    float i_, j_
    list out_
    j_ = 0
    out_ = {}
    for (i_ = 0; i_ < len(l_); i_ += 1) {
        if (ltos(l_[i_]) == ltos(e_)) {
            out_[j_] = i_
            j_ += 1
        }
    }
    return out_
}

list modsets(list _l, list _s) {
    float _i, _j
    list _out
    for (_i = 0; _i < len(_l); _i += 1) {
        list _sl
        for (_j = 0; _j < len(_s); _j += 1) {
            _sl[_j] = _l[(_s[_j] + _i) % len(_l)]
        }
        _out[_i] = _sl
    }
    return _out
}


list thin(list l_) {
    float i_, j_, k_
    list lout_
    k_ = 1
    lout_ = {l_[0]}
    for (i_ = 1; i_ < len(l_); i_ += 1) {
        float count_
        count_ = 0
        for (j_ = 0; j_ < len(lout_); j_ += 1) {
            if ((type(l_[i_]) == "float" || type(lout_[j_]) == "string") && type(lout_[j_]) == type(l_[i_])) {
                if (l_[i_] == lout_[j_]) {
                    count_ += 1
                }
            } else if (type(l_[i_]) == "list" && type(lout_[j_]) == type(l_[i_])) {
                if (compare(l_[i_], lout_[j_])) {
                    count_ += 1
                } 
            }
        }
        if (count_ == 0) {
            lout_[k_] = l_[i_]
            k_ += 1
        }  
    }
    return lout_
}

list indexmap(list l_) {
    float i_, j_, k_
    list dict_, out_
    dict_ = thin(l_)
    out_ = {}
    k_ = 0
    for (j_ = i_; j_ < len(l_); j_ += 1) {
        for (i_ = 0; i_ < len(dict_); i_ += 1) {
            if (type(dict_[i_]) != "list" && type(dict_[i_]) == type(l_[j_])) {
                if (dict_[i_] == l_[j_]) {
                    out_[k_] = i_
                    k_ += 1
                }
            } else if (type(dict_[i_]) == "list" && type(dict_[i_]) == type(l_[j_])) {
                if (compare(dict_[i_], l_[j_])) {
                    out_[k_] = i_
                    k_ += 1
                } 
            }
        }
    }
    return out_
}

list markov.build(list data_, float order_) { // condensed trial
    float i_, j_, k_
    list matrix_, postrans_, ngrams_, dict_
    ngrams_ = frames(data_, order_, 1) // sequence of ngrams
    dict_ = thin(ngrams_) // dictionary of unique states
    postrans_ = {} // matrix of possible states
    matrix_ = {} // matrix of transition/probabilities

    // populate a list (postrans_) with lists of possible transitions for each unique ngram
    for (i_ = 0; i_ < len(dict_); i_ += 1) { // iterate through each unique state
        current_ = dict_[i_] // each unique state
        list pstates_, countList_ 
        pstates_ = {} // possible states
        countList_ = {} // count/number of repeated transitions per state
        k_ = 0 // index of possible states
        for (j_ = 0; j_ < len(ngrams_); j_ += 1) { // iterate through ngram sequence
            if (compare(current_, ngrams_[j_])) { // is current state = current ngram?
                if (j_ + 1 < len(ngrams_)) { // filter out indexing past number of ngrams in sequence
                    pstates_[k_] = ngrams_[j_ + 1] // include ngram as possible transition
                    k_ += 1
                }
            }
        }
        for (j_ = 0; j_ < len(dict_); j_ += 1) { // count repeated transition for each unique ngram
            float count_, m_
            count = 0
            list ngr_
            ngr_ = dict_[j_] // current unique ngram
            for (k_ = 0; k_ < len(pstates_); k_ += 1) { // iterate through possible transition states 
                if (compare(pstates_[k_], ngr_)) { // if current possible state = unique ngram
                    count_ += 1 // add to count
                }
            }
            countList_[j_] = count_ // include final count for given state
        }
        if (reduce(countList_) == 0) { // if no possible transitions
            float c_
            for (c_ = 0; c_ < len(countList_); c_ += 1) { // populate with 1 for equal probability
                countList_[c_] = 1
            }
        }
        countList_ = countList_ / reduce(countList_) // get probabilities as decimals (sum = 1)
        matrix_[i_] = countList_ // assign probability to each state
    }
    return  {dict_, matrix_}
}

list markov.run(list dict_, list m_, float init_, float times_) {
    float i_, j_, k_, s_
    list pl_, out_, e_
    s_ = init_ // initial state index
    k_ = 1 // output index
    e_ = dict_[s_] // element in output
    out_ = {e_[0]} // output list
    for (i_ = 0; i_ < times_ - 1; i_ += 1) {
        list tpl_ // temporary list
        tpl_ = {}
        tr_ = m_[s_] // transition row
        for (j_ = 0; j_ < len(tr_) * 2; j_ += 2) { // format list for pickwrand()
            tpl_[j_] = j_/2 // state index
            tpl_[j_ + 1] = tr_[j_/2] // transition probability
        }
        s_ = pickwrand(tpl_) // weighted random choosing of new state index
        e_ = dict_[s_]
        out_[k_] = e_[0]
        k_ += 1
    }
    return out_
}

list markov(list d_, float o_, float t_) {
    list l_
    l_ = markov.build(d_, o_)
    l_ = markov.run(l_[0], l_[1], 0, t_)
    return l_
}
