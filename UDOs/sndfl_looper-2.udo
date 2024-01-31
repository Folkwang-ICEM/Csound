;;; sndfl looping
opcode sndfl_looper, aa, Skkkki
  SFile, kSpeed, kLoopStart, kLoopSize, kStereoOffset, iWndwFt xin
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
endop


opcode ft_looper, aa, iikkkki
  iFt1, iFt2, kSpeed, kLoopStart, kLoopSize, kStereoOffset, iWndwFt xin
  setksmps 1
  ;; read data from the ft
  iTableSizeSmps1 = ftlen(iFt1)    ; samples
  iTableSizeSecs1 = ftlen(iFt1)*sr ; seconds
  iTableSizeSmps2 = ftlen(iFt2)    ; samples
  iTableSizeSecs2 = ftlen(iFt2)*sr ; seconds

  ;; parameter for the table reading
  kChange changed kStereoOffset
  if kChange == 1 then
    reinit UPDATE
  endif

  kSpeed = kSpeed
  kStart = (kLoopStart*iTableSizeSmps1)
  kSize = kLoopSize*iTableSizeSmps1
  kPhasorSpeed = kSpeed/(kSize/sr)
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
    aSndfl1 table3 (aIndex1*kSize1)+kStart1,iFt1,0,0,1
    aSndfl2 table3 (aIndex2*kSize2)+kStart2,iFt2,0,0,1
    aWin1 table3 aIndex1,iWndwFt,1
    aWin2 table3 aIndex2,iWndwFt,1

    ;; output
    aSndfl1 *= aWin1
    aSndfl2 *= aWin2
    xout aSndfl1,aSndfl2 
endop

opcode sndfl_looper,aa,SSSkkkkiik[]k[]k[]
  SInFile,SOutFile1,SOutFile2,kSpeed,kLoopStart,kLoopSize,kStereoOffset,iWndwFt,iNchnls,kAziArr[],kAltiArr[],kMaskArr[] xin
  setksmps 1
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

  ;; create audio arrays
  aAudioArr1[] init iNchnls/2
  aAudioArr2[] init iNchnls/2
  kArrCount1 init 0
  kArrCount2 init 0
 
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
    kArrCount1 = kArrCount1 % (iNchnls/2)
    kArrCount2 = (k(aSyncOut2) == 1 ? kArrCount2+1 : kArrCount2)
    kArrCount2 = kArrCount2 % (iNchnls/2)
    aAudioArr1[kArrCount1] table3 (aIndex1*kSize1)+kStart1,iSndflTbl1,0,0,1
    aAudioArr2[kArrCount2] table3 (aIndex2*kSize2)+kStart2,iSndflTbl2,0,0,1
    
    aAudioArr1 *= aWin1
    aAudioArr2 *= aWin2

    ;; masking
    kMaskArr1[],kMaskArr2[] deinterleave kMaskArr
    kMaskCount1 init 0
    kMaskCount2 init 0
    kMaskCount1 = (k(aSyncOut1) == 1 ? kMaskCount1+1 : kMaskCount1)
    kMaskCount1 = kMaskCount1 % lenarray:i(kMaskArr1)
    kMaskCount2 = (k(aSyncOut2) == 1 ? kMaskCount2+1 : kMaskCount2)
    kMaskCount2 = kMaskCount2 % lenarray:i(kMaskArr2)
    aAudioArr1 *= kMaskArr1[kMaskCount1]
    aAudioArr2 *= kMaskArr2[kMaskCount2]
    
    ;; spatialization
    kAziArr1[],kAziArr2[] deinterleave kAziArr
    kAltiArr1[],kAltiArr2[] deinterleave kAltiArr
    kAziCount1 init 0
    kAziCount2 init 0
    kAltiCount1 init 0
    kAltiCount2 init 0
    kAziCount1 = (k(aSyncOut1) == 1 ? kAziCount1+1 : kAziCount1)
    kAziCount1 = kAziCount1 % lenarray:i(kAziArr1)
    kAziCount2 = (k(aSyncOut2) == 1 ? kAziCount2+1 : kAziCount2)
    kAziCount2 = kAziCount2 % lenarray:i(kAziArr2)

    kAltiCount1 = (k(aSyncOut1) == 1 ? kAltiCount1+1 : kAltiCount1)
    kAltiCount1 = kAltiCount1 % lenarray:i(kAltiArr1)
    kAltiCount2 = (k(aSyncOut2) == 1 ? kAltiCount2+1 : kAltiCount2)
    kAltiCount2 = kAltiCount2 % lenarray:i(kAltiArr2)
      
    kAzi1 = kAziArr1[kAziCount1]
    kAzi2 = kAziArr2[kAziCount2]

    kAlti1 = kAltiArr1[kAltiCount1]
    kAlti2 = kAltiArr2[kAltiCount2]
    aOutArr1[] init iNchnls
    aOutArr2[] init iNchnls
    aSpatialIn1 = aAudioArr1[kArrCount1]
    aSpatialIn2 = aAudioArr2[kArrCount2]
    aOutArr1 bformenc1 aSpatialIn1,kAzi1,kAlti1
    aOutArr2 bformenc1 aSpatialIn2,kAzi2,kAlti2

    ;; render file
    fout SOutFile1,-1,aOutArr1
    fout SOutFile2,-1,aOutArr2
    
    ;; output just for control
    aOut1 = aAudioArr1[kArrCount1]
    aOut2 = aAudioArr2[kArrCount2]
    xout aOut1,aOut2
endop
