: $Id: xtra.mod,v 1.4 2014/08/18 23:15:25 ted Exp ted $
: 2018/05/20 Modified by Aman Aberra 

NEURON {
	SUFFIX xtra
	RANGE es1 : (es1 = max amplitude of the potential)		
	RANGE es2 : (es2 = max amplitude of the potential)
	RANGE es3 : (es3 = max amplitude of the potential)
	RANGE ampratio	
	RANGE x, y, z, type, order
	GLOBAL stim1 : (stim1 = normalized waveform)
	GLOBAL stim2 : (stim2 = normalized waveform)
	GLOBAL stim3 : (stim3 = normalized waveform)
	POINTER ex 
}

PARAMETER {	
	es1 = 0 (mV)
  es2 = 0 (mV)
  es3 = 0 (mV)
	x = 0 (1) : spatial coords
	y = 0 (1)
	z = 0 (1)		
	type = 0 (1) : numbering system for morphological category of section - unassigned is 0
	order = 0 (1) : order of branch/collateral.
    ampratio = 0	
}

ASSIGNED {
	v (millivolts)
	ex (millivolts)
	stim1 (unitless)
	stim2 (unitless) 
	stim3 (unitless)  		
	area (micron2)
}

INITIAL {
	ex = (stim1*es1)+(stim2*es2)+(stim3*es3)	
}


BEFORE BREAKPOINT { : before each cy' = f(y,t) setup
  ex = (stim1*es1)+(stim2*es2)+(stim3*es3)
}

