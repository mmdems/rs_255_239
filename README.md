# RS (255, 239)
Decoder for Reed-Solomon (255, 239) codes

# Summary
Decoder was implemented in fully accordance with ITU-T G.975 recommendations.
Input is 64-bit, output is 64-bit also. Decoder operates with OTN frames
described in ITU-T G.975

# Modules
All is standard except the Berlekamp-Massey module (kes.vhd). It was implemented
via using folding technique, also known as RiBM/SiBM algorithms, you can find it
at IEEE library
#
more to follow...
