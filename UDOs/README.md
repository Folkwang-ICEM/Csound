# UDOs
A directory for UDOs (file.udo) and examples (file.csd) how to use
them. In udo_collection.udo you can find every udo of this repo.

## Utilities
- ctrl_tbl: allows indexing of numeric data from a .txt file with
optional interpolation of the data
## Ambisonic
- ambi_encode: encode a mono signal up to 8th order ambisonics

## Synthesizer
- sine_oct: a sine wave spectrum synthesizer, similiar to hsboscil opcode
## Instruments
- sndfl_looper: flexible segment looping of soundfile	
- sndfl_looper2: like sndfl_looper but with masking of individual
segments
- sndfl_looper_ambi: like sndfl_looper but with internal ambisonics
encoding up to 8th order (needs ambi_encode.udo)
- sndfl_looper2_ambi: like sndfl_looper_ambi but with masking of
individual segments (needs ambi_encode.udo)
## Filter
## Other
- ambi_spectrum: spatialise a mono signal into a ambisonic field
(needs ambi_encode.udo)