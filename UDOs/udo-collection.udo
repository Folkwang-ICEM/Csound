;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; collection of all UDOs in this repo
;;; maybe it needs some reorderning when some UDOs depend of each
;;; other
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/* utilities */


/* ambisonics */
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ambi_encode
;;; - encode a mono signal up to 8th order ambisonics
;;; - takes a mono signal and creates a audio-array in the size
;;; depending on iorder ((iorder+1)^2) as output
;;; - kaz = azimuth in degrees (0 - 360)
;;; - kel = eleveation in degrees (0 - 360)
;;; - render the file with 'fout' opcode in csound
opcode ambi_encode,a[],aikk		
  asnd,iorder,kaz,kel xin

  aOutArr[] init (iorder+1)^2

  kaz = $M_PI*kaz/180
  kel = $M_PI*kel/180

  kcos_el = cos(kel)
  ksin_el = sin(kel)
  kcos_az = cos(kaz)
  ksin_az = sin(kaz)

  aOutArr[0] = asnd							; W
  aOutArr[1] = kcos_el*ksin_az*asnd		; Y	 = Y(1,-1)
  aOutArr[2] = ksin_el*asnd				; Z	 = Y(1,0)
  aOutArr[3] = kcos_el*kcos_az*asnd		; X	 = Y(1,1)

  if		iorder < 2 goto	end

  i2	= sqrt(3)/2
  kcos_el_p2 = kcos_el*kcos_el
  ksin_el_p2 = ksin_el*ksin_el
  kcos_2az = cos(2*kaz)
  ksin_2az = sin(2*kaz)
  kcos_2el = cos(2*kel)
  ksin_2el = sin(2*kel)

  aOutArr[4] = i2*kcos_el_p2*ksin_2az*asnd	; V = Y(2,-2)
  aOutArr[5] = i2*ksin_2el*ksin_az*asnd		; S = Y(2,-1)
  aOutArr[6] = .5*(3*ksin_el_p2 - 1)*asnd		; R = Y(2,0)
  aOutArr[7] = i2*ksin_2el*kcos_az*asnd		; S = Y(2,1)
  aOutArr[8] = i2*kcos_el_p2*kcos_2az*asnd	; U = Y(2,2)

  if		iorder < 3 goto	end	

  i31 = sqrt(5/8)
  i32 = sqrt(15)/2
  i33 = sqrt(3/8)

  kcos_el_p3 = kcos_el*kcos_el_p2
  ksin_el_p3 = ksin_el*ksin_el_p2
  kcos_3az = cos(3*kaz)
  ksin_3az = sin(3*kaz)
  kcos_3el = cos(3*kel)
  ksin_3el = sin(3*kel)

  aOutArr[9] = i31*kcos_el_p3*ksin_3az*asnd					; Q = Y(3,-3)
  aOutArr[10] = i32*ksin_el*kcos_el_p2*ksin_2az*asnd		; O = Y(3,-2)
  aOutArr[11] = i33*kcos_el*(5*ksin_el_p2-1)*ksin_az*asnd	; M = Y(3,-1)
  aOutArr[12] = .5*ksin_el*(5*ksin_el_p2-3)*asnd		; K = Y(3,0)
  aOutArr[13] = i33*kcos_el*(5*ksin_el_p2-1)*kcos_az*asnd	; L = Y(3,1)
  aOutArr[14] = i32*ksin_el*kcos_el_p2*kcos_2az*asnd		; N = Y(3,2)
  aOutArr[15] = i31*kcos_el_p3*kcos_3az*asnd				; P = Y(3,3)

    if		iorder < 4 goto	end	

    ic41 = (1/8)*sqrt(35)
    ic42 =	(1/2)*sqrt(35/2)
    ic43 = sqrt(5)/4
    ic44 = sqrt(5/2)/4
    kcos_el_p4 = kcos_el*kcos_el_p3
    ksin_el_p4 = ksin_el*ksin_el_p3
    kcos_4az = cos(4*kaz)
    ksin_4az = sin(4*kaz)
    kcos_4el = cos(4*kel)
    ksin_4el = sin(4*kel)
    aOutArr[16] = ic41*kcos_el_p4*ksin_4az*asnd							; Y(4,-4)
    aOutArr[17] = ic42*ksin_el*kcos_el_p3*ksin_3az*asnd					; Y(4,-3)
    aOutArr[18] = ic43*(7.*ksin_el_p2 - 1.)*kcos_el_p2*ksin_2az*asnd	; Y(4,-2)
    aOutArr[19] = ic44*ksin_2el*(7.*ksin_el_p2 - 3.)*ksin_az*asnd		; Y(4,-1)
    aOutArr[20] = (1/8)*(35.*ksin_el_p4 - 30.*ksin_el_p2 + 3.)*asnd	; Y(4,0)
    aOutArr[21] = ic44*ksin_2el*(7.*ksin_el_p2 - 3.)*kcos_az*asnd		; Y(4,1)
    aOutArr[22] = ic43*(7.*ksin_el_p2 - 1.)*kcos_el_p2*kcos_2az*asnd	; Y(4,2)
    aOutArr[23] = ic42*ksin_el*kcos_el_p3*kcos_3az*asnd				; Y(4,3)
    aOutArr[24] = ic41*kcos_el_p4*kcos_4az*asnd							; Y(4,4)

      if		iorder < 5 goto	end	
      
      ic51 = (3/8)*sqrt(7/2)
      ic52 = (3/8)*sqrt(35)
      ic53 = (1/8)*sqrt(35/2)
      ic54 = sqrt(105)/4
      ic55 = sqrt(15)/8
      kcos_el_p5 = kcos_el*kcos_el_p4
      ksin_el_p5 = ksin_el*ksin_el_p4
      kcos_5az = cos(5*kaz)
      ksin_5az = sin(5*kaz)
      kcos_5el = cos(5*kel)
      ksin_5el = sin(5*kel)
      aOutArr[25] = ic51*kcos_el_p5*ksin_5az*asnd							; Y(5,-5)
      aOutArr[26] = ic52*ksin_el*kcos_el_p4*ksin_4az*asnd					; Y(5,-4)
      aOutArr[27] = ic53*(9*ksin_el_p2 - 1)*kcos_el_p3*ksin_3az*asnd					; Y(5,-3)
      aOutArr[28] = ic54*ksin_el*(3*ksin_el_p2 - 1)*kcos_el_p2*ksin_2az*asnd		; Y(5,-2)
      aOutArr[29] = ic55*(21*ksin_el_p4 - 14*ksin_el_p3 + 1)*kcos_el*ksin_az*asnd	; Y(5,-1)
      aOutArr[30] = (1/8)*(63*ksin_el_p5 - 70*ksin_el_p3 + 15*ksin_el)*asnd		; Y(5,0)
      aOutArr[31] = ic55*(21*ksin_el_p4 - 14*ksin_el_p3 + 1)*kcos_el*kcos_az*asnd	; Y(5,1)
      aOutArr[32] = ic54*ksin_el*(3*ksin_el_p2 - 1)*kcos_el_p2*kcos_2az*asnd	; Y(5,2)
      aOutArr[33] = ic53*(9*ksin_el_p2 - 1)*kcos_el_p3*kcos_3az*asnd				; Y(5,3)
      aOutArr[34] = ic52*ksin_el*kcos_el_p4*kcos_4az*asnd					; Y(5,4)	
      aOutArr[35] = ic51*kcos_el_p5*kcos_5az*asnd					; Y(5,5)

	if		iorder < 6 goto	end	
	
	ic61 = (1/16)*sqrt(231/2)
	ic62 = (3/8)*sqrt(77/2)
	ic63 = (3/16)*sqrt(7)
	ic64 = (1/8)*sqrt(105/2)
	ic65 = (1/16)*sqrt(105/2)
	ic66 = (1/16)*sqrt(21)
	kcos_el_p6 = kcos_el*kcos_el_p5
	ksin_el_p6 = ksin_el*ksin_el_p5
	kcos_6az = cos(6*kaz)
	ksin_6az = sin(6*kaz)
	kcos_6el = cos(6*kel)
	ksin_6el = sin(6*kel)
	aOutArr[36] = ic61*kcos_el_p6*ksin_6az*asnd
	aOutArr[37] = ic62*ksin_el*kcos_el_p5*ksin_5az*asnd
	aOutArr[38] = ic63*(11*ksin_el_p2 - 1)*kcos_el_p4*ksin_4az*asnd
	aOutArr[39] = ic64*ksin_el*(11*ksin_el_p2 - 3)*kcos_el_p3*ksin_3az*asnd
	aOutArr[40] = ic65*((33*ksin_el_p4) - 18*ksin_el_p2 + 1)*kcos_el_p2*ksin_2az*asnd
	aOutArr[41] = ic66*ksin_2el*(33*ksin_el_p4 - 30*ksin_el_p2 + 5)*ksin_az*asnd
	aOutArr[42] = (1/16)*(231*ksin_el_p6 - 315*ksin_el_p4 + 105*ksin_el_p2 - 5)*asnd
	aOutArr[43] = ic66*ksin_2el*(33*ksin_el_p4 - 30*ksin_el_p2 + 5)*kcos_az*asnd
	aOutArr[44] = ic65*((33*ksin_el_p4) - 18*ksin_el_p2 + 1)*kcos_el_p2*kcos_2az*asnd
	aOutArr[45] = ic64*ksin_el*(11*ksin_el_p2 - 3)*kcos_el_p3*kcos_3az*asnd
	aOutArr[46] = ic63*(11*ksin_el_p2 - 1)*kcos_el_p4*kcos_4az*asnd
	aOutArr[47] = ic62*ksin_el*kcos_el_p5*kcos_5az*asnd
	aOutArr[48] = ic61*kcos_el_p6*kcos_6az*asnd

	  if		iorder < 7 goto	end	
	  ic71 = (3/32)*sqrt(143/3)
	  ic72 = (3/16)*sqrt(101/3)
	  ic73 = (3/32)*sqrt(77/3)
	  ic74 = (3/16)*sqrt(77/3)
	  ic75 = (3/32)*sqrt(7/3)
	  ic76 = (3/16)*sqrt(7/6)
	  ic77 = (1/32)*sqrt(7)
	  kcos_el_p7 = kcos_el*kcos_el_p6
	  ksin_el_p7 = ksin_el*ksin_el_p6
	  kcos_7az = cos(7*kaz)
	  ksin_7az = sin(7*kaz)
	  kcos_7el = cos(7*kel)
	  ksin_7el = sin(7*kel)
	  aOutArr[49] = ic71*kcos_el_p7*ksin_7az*asnd
	  aOutArr[50] = ic72*ksin_el*kcos_el_p6*ksin_6az*asnd
	  aOutArr[51] = ic73*(13*ksin_el_p2 - 1)*kcos_el_p5*ksin_5az*asnd
	  aOutArr[52] = ic74*(13*ksin_el_p3 - 3*ksin_el)*kcos_el_p4*ksin_4az*asnd
	  aOutArr[53] = ic75*(143*ksin_el_p4 - 66*ksin_el_p2 + 3)*kcos_el_p3*ksin_3az*asnd
	  aOutArr[54] = ic76*(143*ksin_el_p5 - 110*ksin_el_p3 + 15*ksin_el)*kcos_el_p2*ksin_2az*asnd
	  aOutArr[55] = ic77*(429*ksin_el_p6 - 495*ksin_el_p4 + 135*ksin_el_p2 - 5)*kcos_el*ksin_az*asnd
	  aOutArr[56] = (1/16)*(429*ksin_el_p7 - 693*ksin_el_p5 + 315*ksin_el_p3 - 35*ksin_el)*asnd
	  aOutArr[57] = ic77*(429*ksin_el_p6 - 495*ksin_el_p4 + 135*ksin_el_p2 - 5)*kcos_el*kcos_az*asnd
	  aOutArr[58] = ic76*(143*ksin_el_p5 - 110*ksin_el_p3 + 15*ksin_el)*kcos_el_p2*kcos_2az*asnd
	  aOutArr[59] = ic75*(143*ksin_el_p4 - 66*ksin_el_p2 + 3)*kcos_el_p3*kcos_3az*asnd
	  aOutArr[60] = ic74*(13*ksin_el_p3 - 3*ksin_el)*kcos_el_p4*kcos_4az*asnd
	  aOutArr[61] = ic73*(13*ksin_el_p2 - 1)*kcos_el_p5*kcos_5az*asnd
	  aOutArr[62] = ic72*ksin_el*kcos_el_p6*kcos_6az*asnd
	  aOutArr[63] = ic71*kcos_el_p7*kcos_7az*asnd

	    if		iorder < 8 goto	end	
	    ic81 = (3/128)*sqrt(715)
	    ic82 = (3/32)*sqrt(715)
	    ic83 = (1/32)*sqrt(429/2)
	    ic84 = (3/32)*sqrt(1001) 
	    ic85 = (3/64)*sqrt(77)
	    ic86 = (1/32)*sqrt(1155)
	    ic87 = (3/32)*sqrt(35/2)
	    ic88 = (3/32)
	    kcos_el_p8 = kcos_el*kcos_el_p7
	    ksin_el_p8 = ksin_el*ksin_el_p7
	    kcos_8az = cos(8*kaz)
	    ksin_8az = sin(8*kaz)
	    kcos_8el = cos(8*kel)
	    ksin_8el = sin(8*kel)
	    aOutArr[64] = ic81*kcos_el_p8*ksin_8az*asnd
	    aOutArr[65] = ic82*ksin_el*kcos_el_p7*ksin_7az*asnd
	    aOutArr[66] = ic83*(15*ksin_el_p2 - 1)*kcos_el_p6*ksin_6az*asnd
	    aOutArr[67] = ic84*(5*ksin_el_p3 - ksin_el)*kcos_el_p5*ksin_5az*asnd
	    aOutArr[68] = ic85*(65*ksin_el_p4 - 26*ksin_el_p2 + 1)*kcos_el_p4*ksin_4az*asnd
	    aOutArr[69] = ic86*(39*ksin_el_p5 - 26*ksin_el_p3 + 3*ksin_el)*kcos_el_p3*ksin_3az*asnd
	    aOutArr[70] = ic87*(143*ksin_el_p6 - 143*ksin_el_p4 + 33*ksin_el_p2 - 1)*kcos_el_p2*ksin_2az*asnd
	    aOutArr[71] = ic88*(715*ksin_el_p7 - 1001*ksin_el_p5 + 385*ksin_el_p3 - 35*ksin_el)*kcos_el*ksin_az*asnd
	    aOutArr[72] = (1/128)*(6435*ksin_el_p8 - 12012*ksin_el_p6 + 6930*ksin_el_p4 - 1260*ksin_el_p2 + 35)*asnd
	    aOutArr[73] = ic88*(715*ksin_el_p7 - 1001*ksin_el_p5 + 385*ksin_el_p3 - 35*ksin_el)*kcos_el*kcos_az*asnd
	    aOutArr[74] = ic87*(143*ksin_el_p6 - 143*ksin_el_p4 + 33*ksin_el_p2 - 1)*kcos_el_p2*kcos_2az*asnd
	    aOutArr[75] = ic86*(39*ksin_el_p5 - 26*ksin_el_p3 + 3*ksin_el)*kcos_el_p3*kcos_3az*asnd
	    aOutArr[76] = ic85*(65*ksin_el_p4 - 26*ksin_el_p2 + 1)*kcos_el_p4*kcos_4az*asnd
	    aOutArr[77] = ic84*(5*ksin_el_p3 - ksin_el)*kcos_el_p5*kcos_5az*asnd
	    aOutArr[78] = ic83*(15*ksin_el_p2 - 1)*kcos_el_p6*kcos_6az*asnd
	    aOutArr[79] = ic82*ksin_el*kcos_el_p7*kcos_7az*asnd
	    aOutArr[80] = ic81*kcos_el_p8*kcos_8az*asnd

	  end:
	      
	      xout aOutArr

	      ; original by Martin Neukom
	      ; edit by Philipp Neumann

endop

/* synthesizer */

/* instruments */
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; sndfl_looper
;;; - loop segments from a soundfile with playback speed control
;;; (which alters the pitch), control of the loop start point, the
;;; size of the loop segment, a offset between two playheads to create
;;; a stereo effect and a predefined windowing function table
;;; - SFile -> path to soundfile
;;; - kSpeed -> factor for playback speed -> 1 = original speed, 2 =
;;; double speed, 0.5 = half speed, -1 = original speed but backwards
;;; - kLoopStart -> position of the loop playback (between 0 and 1)
;;; while 0 start of the file and 1 = end of the file
;;; - kLoopSize -> size of the loop segment as a factor (usually a value between
;;; 0.0001 and 1; 1 = the whole sound (factor*length of the soundfile)
;;; - kStereoOffset -> creates a offset between two playheads; a value
;;; between 0 and 1; when this value is changed, the instrument is
;;; reninitalisated, so be carefull with changing this parameter
;;; during playback, could resolve in clicks
/* sndfl looping */
opcode sndfl_looper, aa, Skkkki
  SFile,kSpeed,kLoopStart,kLoopSize,kStereoOffset,iWndwFt xin
  setksmps 1
  ;; read data from soundfil
  iSndflSec filelen SFile
  iSndflSr filesr SFile
  iSndflSamps = iSndflSec*iSndflSr
  
  ;; create the tables for the soundfile
  iSndflNumChnls filenchnls SFile
  if iSndflNumChnls == 1 then
    iSndflTbl1 ftgen 0,0,0,1,SFile,0,0,1
    iSndflTbl2 = iSndflTbl1 
  elseif iSndflNumChnls == 2 then
    iSndflTbl1 ftgen 0,0,0,1,SFile,0,0,1
    iSndflTbl2 ftgen 0,0,0,1,SFile,0,0,2
  endif

  ;; parameter for the table reading
  kChange changed kStereoOffset
  if kChange == 1 then
    reinit UPDATE
  endif

  kSpeed = kSpeed
  kStart = (kLoopStart*iSndflSamps)
  kSize = kLoopSize*iSndflSamps
  kPhasorSpeed = kSpeed/(kSize/iSndflSr)
  aSyncIn init 0
  aSyncOut1 init 1
  aSyncOut2 init 1
  kPhasorSpeed1 = (k(aSyncOut1) == 1 ? kPhasorSpeed : kPhasorSpeed1)
  kPhasorSpeed2 = (k(aSyncOut2) == 1 ? kPhasorSpeed : kPhasorSpeed2)

  UPDATE:
    aIndex1,aSyncOut1 syncphasor kPhasorSpeed1,aSyncIn
    aIndex2,aSyncOut2 syncphasor kPhasorSpeed2,aSyncIn,i(kStereoOffset)
    kSize1 = (k(aSyncOut1) == 1 ? kSize : kSize1)
    kSize2 = (k(aSyncOut2) == 1 ? kSize : kSize2)
    kStart1 = (k(aSyncOut1) == 1 ? kStart : kStart1)
    kStart2 = (k(aSyncOut2) == 1 ? kStart : kStart2)
    aSndfl1 table3 (aIndex1*kSize1)+kStart1,iSndflTbl1,0,0,1
    aSndfl2 table3 (aIndex2*kSize2)+kStart2,iSndflTbl2,0,0,1
    aWin1 table3 aIndex1,iWndwFt,1
    aWin2 table3 aIndex2,iWndwFt,1

    ;; output
    aSndfl1 *= aWin1
    aSndfl2 *= aWin2
    xout aSndfl1,aSndfl2
    ;; by philipp von neumann
endop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; sndfl_looper2
;;; - loop segments from a soundfile with playback speed control
;;; (which alters the pitch), control of the loop start point, the
;;; size of the loop segment, a offset between two playheads to create
;;; a stereo effect and a predefined windowing function table
;;; - sndfl_looper2 allows for individual segment masking to create
;;; rhythmic effects
;;; - SFile -> path to soundfile
;;; - kSpeed -> factor for playback speed -> 1 = original speed, 2 =
;;; double speed, 0.5 = half speed, -1 = original speed but backwards
;;; - kLoopStart -> position of the loop playback (between 0 and 1)
;;; while 0 start of the file and 1 = end of the file
;;; - kLoopSize -> size of the loop segment as a factor (usually a value between
;;; 0.0001 and 1; 1 = the whole sound (factor*length of the soundfile)
;;; - kStereoOffset -> creates a offset between two playheads; a value
;;; between 0 and 1; when this value is changed, the instrument is
;;; reninitalisated, so be carefull with changing this parameter
;;; during playback, could resolve in clicks
;;; - kMaskArr -> masking of the individual events; the array is
;;; deinterleaved into two arrays inside the UDO, one for each
;;; playbackhead; so take into account that when kStereoOffset is 0
;;; then you need to thinkg in value pairs for the masking, else you
;;; don't hear the masking how it is planned
/* sndfl looping with masking */
opcode sndfl_looper2, aa, Skkkkik[]
  SFile,kSpeed,kLoopStart,kLoopSize,kStereoOffset,iWndwFt,kMaskArr[] xin
  setksmps 1
  
  ;; read data from soundfil
  iSndflSec filelen SFile
  iSndflSr filesr SFile
  iSndflSamps = iSndflSec*iSndflSr
  
  ;; create the tables for the soundfile
  iSndflNumChnls filenchnls SFile
  if iSndflNumChnls == 1 then
    iSndflTbl1 ftgen 0,0,0,1,SFile,0,0,1
    iSndflTbl2 = iSndflTbl1 
  elseif iSndflNumChnls == 2 then
    iSndflTbl1 ftgen 0,0,0,1,SFile,0,0,1
    iSndflTbl2 ftgen 0,0,0,1,SFile,0,0,2
  endif

  ;; parameter for the table reading
  kChange changed kStereoOffset
  if kChange == 1 then
    reinit UPDATE
  endif

  kSpeed = kSpeed
  kStart = (kLoopStart*iSndflSamps)
  kSize = kLoopSize*iSndflSamps
  kPhasorSpeed = kSpeed/(kSize/iSndflSr)
  aSyncIn init 0
  aSyncOut1 init 1
  aSyncOut2 init 1
  kPhasorSpeed1 = (k(aSyncOut1) == 1 ? kPhasorSpeed : kPhasorSpeed1)
  kPhasorSpeed2 = (k(aSyncOut2) == 1 ? kPhasorSpeed : kPhasorSpeed2)

  UPDATE:
    aIndex1,aSyncOut1 syncphasor kPhasorSpeed1,aSyncIn
    aIndex2,aSyncOut2 syncphasor kPhasorSpeed2,aSyncIn,i(kStereoOffset)
    kSize1 = (k(aSyncOut1) == 1 ? kSize : kSize1)
    kSize2 = (k(aSyncOut2) == 1 ? kSize : kSize2)
    kStart1 = (k(aSyncOut1) == 1 ? kStart : kStart1)
    kStart2 = (k(aSyncOut2) == 1 ? kStart : kStart2)
    aSndfl1 table3 (aIndex1*kSize1)+kStart1,iSndflTbl1,0,0,1
    aSndfl2 table3 (aIndex2*kSize2)+kStart2,iSndflTbl2,0,0,1
    aWin1 table3 aIndex1,iWndwFt,1
    aWin2 table3 aIndex2,iWndwFt,1

    aSig1 = aWin1*aSndfl1
    aSig2 = aWin2*aSndfl2

    ;; masking
    kMaskArr1[],kMaskArr2[] deinterleave kMaskArr
    kMaskCount1 init 0
    kMaskCount2 init 0
    kMaskCount1 = (k(aSyncOut1) == 1 ? kMaskCount1+1 : kMaskCount1)
    kMaskCount1 = kMaskCount1 % lenarray:i(kMaskArr1)
    kMaskCount2 = (k(aSyncOut2) == 1 ? kMaskCount2+1 : kMaskCount2)
    kMaskCount2 = kMaskCount2 % lenarray:i(kMaskArr2)
    aSig1 *= kMaskArr1[kMaskCount1]
    aSig2 *= kMaskArr2[kMaskCount2]

    ;; output
    xout aSig1,aSig2
    ;; by philipp von neumann
endop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; sndfl_looper_ambi !needs the ambi_encode UDO!
;;; - loop segments from a soundfile with playback speed control
;;; (which alters the pitch), control of the loop start point, the
;;; size of the loop segment, a offset between two playheads to create
;;; a stereo effect and a predefined windowing function table
;;; - sndfl_looper_ambi puts out an encoded ambisonics audio array up
;;; to 8th order; every loop segment is having a fixed position
;;; defined by kAzi and kAlti
;;; - SInFile -> path to soundfile
;;; - kSpeed -> factor for playback speed -> 1 = original speed, 2 =
;;; double speed, 0.5 = half speed, -1 = original speed but backwards
;;; - kLoopStart -> position of the loop playback (between 0 and 1)
;;; while 0 start of the file and 1 = end of the file
;;; - kLoopSize -> size of the loop segment as a factor (usually a value between
;;; 0.0001 and 1; 1 = the whole sound (factor*length of the soundfile)
;;; - kStereoOffset -> creates a offset between two playheads; a value
;;; between 0 and 1; when this value is changed, the instrument is
;;; reninitalisated, so be carefull with changing this parameter
;;; during playback, could resolve in clicks
;;; - kAzi -> Azimuth value as degree value of a circle (0 - 360)
;;; - kAlti -> Altitude / elevation value as degree value of a circle (0 - 360)
;;; - kMask -> masking of the individual events; for example to create
;;; amplitude envelopes
;;; - iOrder -> order of the ambisonics encoding -> up to 8th order;
;;; defines the size of the output array
opcode sndfl_looper_ambi,a[],Skkkkikkki
  ;; inputs
  SInFile,kSpeed,kLoopStart,kLoopSize,kStereoOffset,iWndwFt,kAzi,kAlti,kMask,iOrder xin
  setksmps 1
  iAmbiChn = (iOrder+1)^2
  
  ;; read data from soundfil
  iSndflSec filelen SInFile
  iSndflSr filesr SInFile
  iSndflSamps = iSndflSec*iSndflSr
  
  ;; create the table for the soundfile
  iSndflNumChnls filenchnls SInFile
  if iSndflNumChnls == 1 then
    iSndflTbl1 ftgen 0,0,0,1,SInFile,0,0,1
    iSndflTbl2 = iSndflTbl1 
  elseif iSndflNumChnls == 2 then
    iSndflTbl1 ftgen 0,0,0,1,SInFile,0,0,1
    iSndflTbl2 ftgen 0,0,0,1,SInFile,0,0,2
  endif

  ;; parameter for the table reading
  kChange changed kStereoOffset
  if kChange == 1 then
    reinit UPDATE
  endif

  kSpeed = kSpeed
  kStart = (kLoopStart*iSndflSamps)
  kSize = kLoopSize*iSndflSamps
  kPhasorSpeed = kSpeed/(kSize/iSndflSr)
  aSyncIn init 0
  aSyncOut1 init 1
  aSyncOut2 init 1
  kPhasorSpeed1 = (k(aSyncOut1) == 1 ? kPhasorSpeed : kPhasorSpeed1)
  kPhasorSpeed2 = (k(aSyncOut2) == 1 ? kPhasorSpeed : kPhasorSpeed2)

  UPDATE:
    aIndex1,aSyncOut1 syncphasor kPhasorSpeed1,aSyncIn
    aIndex2,aSyncOut2 syncphasor kPhasorSpeed2,aSyncIn,i(kStereoOffset)
    kSize1 = (k(aSyncOut1) == 1 ? kSize : kSize1)
    kSize2 = (k(aSyncOut2) == 1 ? kSize : kSize2)
    kStart1 = (k(aSyncOut1) == 1 ? kStart : kStart1)
    kStart2 = (k(aSyncOut2) == 1 ? kStart : kStart2)

    aWin1 table aIndex1,iWndwFt,1
    aWin2 table aIndex2,iWndwFt,1

    kArrCount1 = (k(aSyncOut1) == 1 ? kArrCount1+1 : kArrCount1)
    kArrCount1 = kArrCount1 % iAmbiChn
    kArrCount2 = (k(aSyncOut2) == 1 ? kArrCount2+1 : kArrCount2)
    kArrCount2 = kArrCount2 % iAmbiChn
    aSig1 table3 (aIndex1*kSize1)+kStart1,iSndflTbl1,0,0,1
    aSig2 table3 (aIndex2*kSize2)+kStart2,iSndflTbl2,0,0,1
    
    aSig1 *= aWin1
    aSig2 *= aWin2    
    
    ;; masking
    kMaskReal1 init i(kMask)
    kMaskReal2 init i(kMask)
    kMaskReal1 = (k(aSyncOut1) == 1 ? kMask : kMaskReal1)
    kMaskReal2 = (k(aSyncOut2) == 1 ? kMask : kMaskReal2)
    aSig1 *= kMaskReal1
    aSig2 *= kMaskReal2
    
    ;; spatialization
    aEncArr1[] init iAmbiChn
    aEncArr2[] init iAmbiChn
    kAziReal1 init i(kAzi)
    kAziReal2 init i(kAzi)
    kAltiReal1 init i(kAlti)
    kAltiReal2 init i(kAlti)
    kAziReal1 = (k(aSyncOut1) == 1 ? kAzi : kAziReal1)
    kAziReal2 = (k(aSyncOut2) == 1 ? kAzi : kAziReal2)
    kAltiReal1 = (k(aSyncOut1) == 1 ? kAlti : kAltiReal1)
    kAltiReal2 = (k(aSyncOut2) == 1 ? kAlti : kAltiReal2)
    aEncArr1 ambi_encode aSig1,iOrder,kAziReal1,kAltiReal1
    aEncArr2 ambi_encode aSig2,iOrder,kAziReal2,kAltiReal2

    ;; sum arrays
    aOutArr[] init iAmbiChn
    trim aOutArr,iAmbiChn
    aOutArr[0] sum aEncArr1[0]/2,aEncArr2[0]/2
    aOutArr[1] sum aEncArr1[1]/2,aEncArr2[1]/2
    aOutArr[2] sum aEncArr1[2]/2,aEncArr2[2]/2
    aOutArr[3] sum aEncArr1[3]/2,aEncArr2[3]/2

      if iOrder < 2 goto end
      aOutArr[4] sum aEncArr1[4]/2,aEncArr2[4]/2
      aOutArr[5] sum aEncArr1[5]/2,aEncArr2[5]/2
      aOutArr[6] sum aEncArr1[6]/2,aEncArr2[6]/2
      aOutArr[7] sum aEncArr1[7]/2,aEncArr2[7]/2
      aOutArr[8] sum aEncArr1[8]/2,aEncArr2[8]/2
      
        if iOrder < 3 goto end
	aOutArr[9] sum aEncArr1[9]/2,aEncArr2[9]/2
	aOutArr[10] sum aEncArr1[10]/2,aEncArr2[10]/2
	aOutArr[11] sum aEncArr1[11]/2,aEncArr2[11]/2
	aOutArr[12] sum aEncArr1[12]/2,aEncArr2[12]/2
	aOutArr[13] sum aEncArr1[13]/2,aEncArr2[13]/2
	aOutArr[14] sum aEncArr1[14]/2,aEncArr2[14]/2
	aOutArr[15] sum aEncArr1[15]/2,aEncArr2[15]/2

	  if iOrder < 4 goto end
	  aOutArr[16] sum aEncArr1[16]/2,aEncArr2[16]/2
	  aOutArr[17] sum aEncArr1[17]/2,aEncArr2[17]/2
	  aOutArr[18] sum aEncArr1[18]/2,aEncArr2[18]/2
	  aOutArr[19] sum aEncArr1[19]/2,aEncArr2[19]/2
	  aOutArr[20] sum aEncArr1[20]/2,aEncArr2[20]/2
	  aOutArr[21] sum aEncArr1[21]/2,aEncArr2[21]/2
	  aOutArr[22] sum aEncArr1[22]/2,aEncArr2[22]/2
	  aOutArr[23] sum aEncArr1[23]/2,aEncArr2[23]/2
	  aOutArr[24] sum aEncArr1[24]/2,aEncArr2[24]/2

	    if iOrder < 5 goto end
	    aOutArr[25] sum aEncArr1[25]/2,aEncArr2[25]/2
	    aOutArr[26] sum aEncArr1[26]/2,aEncArr2[26]/2
	    aOutArr[27] sum aEncArr1[27]/2,aEncArr2[27]/2
	    aOutArr[28] sum aEncArr1[28]/2,aEncArr2[28]/2
	    aOutArr[29] sum aEncArr1[29]/2,aEncArr2[29]/2
	    aOutArr[30] sum aEncArr1[30]/2,aEncArr2[30]/2
	    aOutArr[31] sum aEncArr1[31]/2,aEncArr2[31]/2
	    aOutArr[32] sum aEncArr1[32]/2,aEncArr2[32]/2
	    aOutArr[33] sum aEncArr1[33]/2,aEncArr2[33]/2
	    aOutArr[34] sum aEncArr1[34]/2,aEncArr2[34]/2
	    aOutArr[35] sum aEncArr1[35]/2,aEncArr2[35]/2

	      if iOrder < 6 goto end
	      aOutArr[36] sum aEncArr1[36]/2,aEncArr2[36]/2
	      aOutArr[37] sum aEncArr1[37]/2,aEncArr2[37]/2
	      aOutArr[38] sum aEncArr1[38]/2,aEncArr2[38]/2
	      aOutArr[39] sum aEncArr1[39]/2,aEncArr2[39]/2
	      aOutArr[40] sum aEncArr1[40]/2,aEncArr2[40]/2
	      aOutArr[41] sum aEncArr1[41]/2,aEncArr2[41]/2
	      aOutArr[42] sum aEncArr1[42]/2,aEncArr2[42]/2
	      aOutArr[43] sum aEncArr1[43]/2,aEncArr2[43]/2
	      aOutArr[44] sum aEncArr1[44]/2,aEncArr2[44]/2
	      aOutArr[45] sum aEncArr1[45]/2,aEncArr2[45]/2
	      aOutArr[46] sum aEncArr1[46]/2,aEncArr2[46]/2
	      aOutArr[47] sum aEncArr1[47]/2,aEncArr2[47]/2
	      aOutArr[48] sum aEncArr1[48]/2,aEncArr2[48]/2

	        if iOrder < 7 goto end
		aOutArr[49] sum aEncArr1[49]/2,aEncArr2[49]/2
		aOutArr[50] sum aEncArr1[50]/2,aEncArr2[50]/2
		aOutArr[51] sum aEncArr1[51]/2,aEncArr2[51]/2
		aOutArr[52] sum aEncArr1[52]/2,aEncArr2[52]/2
		aOutArr[53] sum aEncArr1[53]/2,aEncArr2[53]/2
		aOutArr[54] sum aEncArr1[54]/2,aEncArr2[54]/2
		aOutArr[55] sum aEncArr1[55]/2,aEncArr2[55]/2
		aOutArr[56] sum aEncArr1[56]/2,aEncArr2[56]/2
		aOutArr[57] sum aEncArr1[57]/2,aEncArr2[57]/2
		aOutArr[58] sum aEncArr1[58]/2,aEncArr2[58]/2
		aOutArr[59] sum aEncArr1[59]/2,aEncArr2[59]/2
		aOutArr[60] sum aEncArr1[60]/2,aEncArr2[60]/2
		aOutArr[61] sum aEncArr1[61]/2,aEncArr2[61]/2
		aOutArr[62] sum aEncArr1[62]/2,aEncArr2[62]/2
		aOutArr[63] sum aEncArr1[63]/2,aEncArr2[63]/2

		  if iOrder < 8 goto end
		  aOutArr[64] sum aEncArr1[64]/2,aEncArr2[64]/2
		  aOutArr[65] sum aEncArr1[65]/2,aEncArr2[65]/2
		  aOutArr[66] sum aEncArr1[66]/2,aEncArr2[66]/2
		  aOutArr[67] sum aEncArr1[67]/2,aEncArr2[67]/2
		  aOutArr[68] sum aEncArr1[68]/2,aEncArr2[68]/2
		  aOutArr[69] sum aEncArr1[69]/2,aEncArr2[69]/2
		  aOutArr[70] sum aEncArr1[70]/2,aEncArr2[70]/2
		  aOutArr[71] sum aEncArr1[71]/2,aEncArr2[71]/2
		  aOutArr[72] sum aEncArr1[72]/2,aEncArr2[72]/2
		  aOutArr[73] sum aEncArr1[73]/2,aEncArr2[73]/2
		  aOutArr[74] sum aEncArr1[74]/2,aEncArr2[74]/2
		  aOutArr[75] sum aEncArr1[75]/2,aEncArr2[75]/2
		  aOutArr[76] sum aEncArr1[76]/2,aEncArr2[76]/2
		  aOutArr[77] sum aEncArr1[77]/2,aEncArr2[77]/2
		  aOutArr[78] sum aEncArr1[78]/2,aEncArr2[78]/2
		  aOutArr[79] sum aEncArr1[79]/2,aEncArr2[79]/2
		  aOutArr[80] sum aEncArr1[80]/2,aEncArr2[80]/2
		  
		end:
		  
		  ;; output
		  xout aOutArr
		  ;; by philipp von neumann
endop

/* filter */