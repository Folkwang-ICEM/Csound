;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; channel-test
;;;
;;; This program provides simple channel-testing facilities to be used e.g. as
;;; a VST plugin insinde a DAW. It simply sends noise to the discrete outputs
;;; at a given interval.
;;; The limit of outputs can be changed by adjusting the nchnls variable.
;;;
;;; Author: Ruben Philipp <me@rubenphilipp.com>
;;; Created: 2023-11-02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

<Cabbage>
form caption("Channel-Test") size(510, 350), guiMode("queue") pluginId("chts") colour(200,200,200)

rslider bounds(312, 54, 81, 86), channel("gain"), range(0, 1, 0, 1, 0.01), text("Gain"), trackerColour(0, 255, 0, 255), outlineColour(0, 0, 0, 50), textColour(0, 0, 0, 255)
nslider bounds(108, 18, 70, 42) channel("time") range(0.5, 3, 0.5, 1, 0.25) text("time (sec)") 
button bounds(14, 86, 70, 44) channel("run") text("start", "stop") 

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d
</CsOptions>
<CsInstruments>

ksmps = 32
;; Change nchnls in case, more channels are needed.
nchnls = 32
0dbfs = 1


instr 1

;; add channel controls

cabbageCreate "nslider", sprintf("bounds(15, 18, 70, 42), channel(\"channels\"), range(2, %d, 2, 1, 1), text(\"# channels\")", nchnls)

iX init 15
iY init 170
iCount init 1

while iCount <= nchnls do
  SWidget sprintf "bounds(%d, %d, 10, 10), channel(\"mon%d\"), value(0)", iX, iY, iCount
  cabbageCreate "light", SWidget
  cabbageCreate "label", sprintf("bounds(%d, %d, 20, 10), text(\"%d\")", iX-5, iY+15, iCount)
  cabbageSetValue sprintf("mon%d", iCount), -1
  iX = iX + 15
  iCount += 1
  if iCount == 33 then
    iY = 200
    iX = 15
  elseif iCount == 65 then
    iY = 230
    iX = 15
  elseif iCount == 97 then
    iY = 260
    iX = 15
  endif
od

kGain cabbageGetValue "gain"
kTime chnget "time"
kChannels, kChannelsChanged cabbageGetValue "channels"
kRun, kRunChanged cabbageGetValue "run"

kTrig metro 1/kTime

kCount init 0
kOutch init 0

;; reset displays when kChannels changed
if kChannelsChanged == 1 then
  event "i", 3, 0, 1
endif

;; reset displays when state changed to stopped
if kRunChanged == 1 && kRun == 0 then
  event "i", 3, 0, 1
endif

;; reset counter
if kRunChanged == 1 && kRun == 1 then
  kCount = 0
endif

if kRun == 1 && kTrig == 1 then
  kOutch = (kCount % kChannels) + 1
  ;; monitoring
  event "i", 2, .001, kChannels, kOutch
  
  
  kCount += 1
endif

aNoise noise kGain*kRun, .99

outch kOutch, aNoise


endin


;; change monitor state
instr 2

  iMaxOuts, iCurrent passign 3
  
  if iCurrent == 1 then
    iPrevious = iMaxOuts
  else
    iPrevious = iCurrent - 1
  endif
      
  cabbageSetValue sprintf("mon%d", iPrevious), -1
  cabbageSetValue sprintf("mon%d", iCurrent), 1
  
endin

;; clear monitor state
instr 3
  
  iCount init 1
  while iCount <= nchnls do
    cabbageSetValue sprintf("mon%d", iCount), -1
    iCount += 1
  od
  
endin



</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z
;starts instrument 1 and runs it for a week
i1 0 [60*60*24*7] 
</CsScore>
</CsoundSynthesizer>


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; EOF channel-test.csd