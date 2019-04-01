onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider DECODER
add wave -noupdate /rs_255_decoder_tb/T_Clk
add wave -noupdate /rs_255_decoder_tb/T_StartFrame
add wave -noupdate /rs_255_decoder_tb/T_DataIn
add wave -noupdate /rs_255_decoder_tb/Err
add wave -noupdate /rs_255_decoder_tb/DataCor
add wave -noupdate -divider SYND
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/CLC/DataIn
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/CLC/StartWord
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/CLC/SyndromeOut
add wave -noupdate -expand /rs_255_decoder_tb/UUT/SyndromeEnableOut
add wave -noupdate -divider KES(0)
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/KES_UiBM3t(0)/KES/SyndromeEnIn
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/KES_UiBM3t(0)/KES/SyndromeIn
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/KES_UiBM3t(0)/KES/Lambda
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/KES_UiBM3t(0)/KES/Omega
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/KES_UiBM3t(0)/KES/LambdaEnOut
add wave -noupdate -divider KES(1)
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/KES_UiBM3t(1)/KES/SyndromeEnIn
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/KES_UiBM3t(1)/KES/SyndromeIn
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/KES_UiBM3t(1)/KES/Lambda
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/KES_UiBM3t(1)/KES/Omega
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/KES_UiBM3t(1)/KES/LambdaEnOut
add wave -noupdate -divider CSEE
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/CSEE/LambdaEnIn
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/CSEE/LambdaIn
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/CSEE/OmegaIn
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/CSEE/Alpha
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/CSEE/LambdaReg
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/CSEE/LambdaReg_2
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/CSEE/OmegaReg
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/CSEE/OmegaReg_2
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/CSEE/Alpha16
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/CSEE/Alpha16_2
add wave -noupdate /rs_255_decoder_tb/UUT/DECODER(0)/CSEE/ErrorValue
add wave -noupdate -divider DATA_OUT
add wave -noupdate /rs_255_decoder_tb/UUT/DataInDelayed(0)
add wave -noupdate /rs_255_decoder_tb/UUT/line__29/ErrorOutRvrsd
add wave -noupdate /rs_255_decoder_tb/UUT/DataOut
add wave -noupdate /rs_255_decoder_tb/UUT/StartOut
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5976 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 415
configure wave -valuecolwidth 211
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {9123 ns} {9440 ns}
