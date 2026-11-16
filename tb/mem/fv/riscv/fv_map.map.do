
//input ports
add mapped point clk clk -type PI PI
add mapped point rst_n rst_n -type PI PI

//output ports
add mapped point trace_pc[31] trace_pc[31] -type PO PO
add mapped point trace_pc[30] trace_pc[30] -type PO PO
add mapped point trace_pc[29] trace_pc[29] -type PO PO
add mapped point trace_pc[28] trace_pc[28] -type PO PO
add mapped point trace_pc[27] trace_pc[27] -type PO PO
add mapped point trace_pc[26] trace_pc[26] -type PO PO
add mapped point trace_pc[25] trace_pc[25] -type PO PO
add mapped point trace_pc[24] trace_pc[24] -type PO PO
add mapped point trace_pc[23] trace_pc[23] -type PO PO
add mapped point trace_pc[22] trace_pc[22] -type PO PO
add mapped point trace_pc[21] trace_pc[21] -type PO PO
add mapped point trace_pc[20] trace_pc[20] -type PO PO
add mapped point trace_pc[19] trace_pc[19] -type PO PO
add mapped point trace_pc[18] trace_pc[18] -type PO PO
add mapped point trace_pc[17] trace_pc[17] -type PO PO
add mapped point trace_pc[16] trace_pc[16] -type PO PO
add mapped point trace_pc[15] trace_pc[15] -type PO PO
add mapped point trace_pc[14] trace_pc[14] -type PO PO
add mapped point trace_pc[13] trace_pc[13] -type PO PO
add mapped point trace_pc[12] trace_pc[12] -type PO PO
add mapped point trace_pc[11] trace_pc[11] -type PO PO
add mapped point trace_pc[10] trace_pc[10] -type PO PO
add mapped point trace_pc[9] trace_pc[9] -type PO PO
add mapped point trace_pc[8] trace_pc[8] -type PO PO
add mapped point trace_pc[7] trace_pc[7] -type PO PO
add mapped point trace_pc[6] trace_pc[6] -type PO PO
add mapped point trace_pc[5] trace_pc[5] -type PO PO
add mapped point trace_pc[4] trace_pc[4] -type PO PO
add mapped point trace_pc[3] trace_pc[3] -type PO PO
add mapped point trace_pc[2] trace_pc[2] -type PO PO
add mapped point trace_pc[1] trace_pc[1] -type PO PO
add mapped point trace_pc[0] trace_pc[0] -type PO PO
add mapped point trace_inst[31] trace_inst[31] -type PO PO
add mapped point trace_inst[30] trace_inst[30] -type PO PO
add mapped point trace_inst[29] trace_inst[29] -type PO PO
add mapped point trace_inst[28] trace_inst[28] -type PO PO
add mapped point trace_inst[27] trace_inst[27] -type PO PO
add mapped point trace_inst[26] trace_inst[26] -type PO PO
add mapped point trace_inst[25] trace_inst[25] -type PO PO
add mapped point trace_inst[24] trace_inst[24] -type PO PO
add mapped point trace_inst[23] trace_inst[23] -type PO PO
add mapped point trace_inst[22] trace_inst[22] -type PO PO
add mapped point trace_inst[21] trace_inst[21] -type PO PO
add mapped point trace_inst[20] trace_inst[20] -type PO PO
add mapped point trace_inst[19] trace_inst[19] -type PO PO
add mapped point trace_inst[18] trace_inst[18] -type PO PO
add mapped point trace_inst[17] trace_inst[17] -type PO PO
add mapped point trace_inst[16] trace_inst[16] -type PO PO
add mapped point trace_inst[15] trace_inst[15] -type PO PO
add mapped point trace_inst[14] trace_inst[14] -type PO PO
add mapped point trace_inst[13] trace_inst[13] -type PO PO
add mapped point trace_inst[12] trace_inst[12] -type PO PO
add mapped point trace_inst[11] trace_inst[11] -type PO PO
add mapped point trace_inst[10] trace_inst[10] -type PO PO
add mapped point trace_inst[9] trace_inst[9] -type PO PO
add mapped point trace_inst[8] trace_inst[8] -type PO PO
add mapped point trace_inst[7] trace_inst[7] -type PO PO
add mapped point trace_inst[6] trace_inst[6] -type PO PO
add mapped point trace_inst[5] trace_inst[5] -type PO PO
add mapped point trace_inst[4] trace_inst[4] -type PO PO
add mapped point trace_inst[3] trace_inst[3] -type PO PO
add mapped point trace_inst[2] trace_inst[2] -type PO PO
add mapped point trace_inst[1] trace_inst[1] -type PO PO
add mapped point trace_inst[0] trace_inst[0] -type PO PO

//inout ports




//Sequential Pins
add mapped point u_datapath/u_mem/c_pc_w[31]/q u_datapath_u_mem_c_pc_w_reg[31]/Q -type DFF DFF
add mapped point u_datapath/u_mem/c_pc_w[30]/q u_datapath_u_mem_c_pc_w_reg[30]/Q -type DFF DFF
add mapped point u_datapath/u_mem/c_pc_w[28]/q u_datapath_u_mem_c_pc_w_reg[28]/Q -type DFF DFF
add mapped point u_datapath/u_mem/c_pc_w[24]/q u_datapath_u_mem_c_pc_w_reg[24]/Q -type DFF DFF
add mapped point u_datapath/u_mem/c_pc_w[16]/q u_datapath_u_mem_c_pc_w_reg[16]/Q -type DFF DFF
add mapped point u_datapath/u_mem/c_pc_w[15]/q u_datapath_u_mem_c_pc_w_reg[15]/Q -type DFF DFF
add mapped point u_datapath/u_mem/c_pc_w[23]/q u_datapath_u_mem_c_pc_w_reg[23]/Q -type DFF DFF
add mapped point u_datapath/u_mem/c_pc_w[14]/q u_datapath_u_mem_c_pc_w_reg[14]/Q -type DFF DFF
add mapped point u_datapath/u_mem/c_pc_w[13]/q u_datapath_u_mem_c_pc_w_reg[13]/Q -type DFF DFF
add mapped point u_datapath/u_mem/c_pc_w[27]/q u_datapath_u_mem_c_pc_w_reg[27]/Q -type DFF DFF
add mapped point u_datapath/u_mem/c_pc_w[26]/q u_datapath_u_mem_c_pc_w_reg[26]/Q -type DFF DFF
add mapped point u_datapath/u_mem/c_pc_w[12]/q u_datapath_u_mem_c_pc_w_reg[12]/Q -type DFF DFF
add mapped point u_datapath/u_mem/c_pc_w[11]/q u_datapath_u_mem_c_pc_w_reg[11]/Q -type DFF DFF
add mapped point u_datapath/u_mem/c_pc_w[21]/q u_datapath_u_mem_c_pc_w_reg[21]/Q -type DFF DFF
add mapped point u_datapath/u_mem/c_pc_w[29]/q u_datapath_u_mem_c_pc_w_reg[29]/Q -type DFF DFF
add mapped point u_datapath/u_mem/c_pc_w[22]/q u_datapath_u_mem_c_pc_w_reg[22]/Q -type DFF DFF
add mapped point u_datapath/u_mem/c_pc_w[20]/q u_datapath_u_mem_c_pc_w_reg[20]/Q -type DFF DFF
add mapped point u_datapath/u_mem/c_pc_w[19]/q u_datapath_u_mem_c_pc_w_reg[19]/Q -type DFF DFF
add mapped point u_datapath/u_mem/c_pc_w[25]/q u_datapath_u_mem_c_pc_w_reg[25]/Q -type DFF DFF
add mapped point u_datapath/u_mem/c_pc_w[18]/q u_datapath_u_mem_c_pc_w_reg[18]/Q -type DFF DFF
add mapped point u_datapath/u_mem/c_pc_w[17]/q u_datapath_u_mem_c_pc_w_reg[17]/Q -type DFF DFF
add mapped point u_datapath/u_ex/c_pc_m[24]/q u_datapath_u_ex_c_pc_m_reg[24]/Q -type DFF DFF
add mapped point u_datapath/u_ex/c_pc_m[20]/q u_datapath_u_ex_c_pc_m_reg[20]/Q -type DFF DFF
add mapped point u_datapath/u_ex/c_pc_m[21]/q u_datapath_u_ex_c_pc_m_reg[21]/Q -type DFF DFF
add mapped point u_datapath/u_ex/c_pc_m[22]/q u_datapath_u_ex_c_pc_m_reg[22]/Q -type DFF DFF
add mapped point u_datapath/u_ex/c_pc_m[23]/q u_datapath_u_ex_c_pc_m_reg[23]/Q -type DFF DFF
add mapped point u_datapath/u_ex/c_pc_m[19]/q u_datapath_u_ex_c_pc_m_reg[19]/Q -type DFF DFF
add mapped point u_datapath/u_ex/c_pc_m[25]/q u_datapath_u_ex_c_pc_m_reg[25]/Q -type DFF DFF
add mapped point u_datapath/u_ex/c_pc_m[26]/q u_datapath_u_ex_c_pc_m_reg[26]/Q -type DFF DFF
add mapped point u_datapath/u_ex/c_pc_m[27]/q u_datapath_u_ex_c_pc_m_reg[27]/Q -type DFF DFF
add mapped point u_datapath/u_ex/c_pc_m[28]/q u_datapath_u_ex_c_pc_m_reg[28]/Q -type DFF DFF
add mapped point u_datapath/u_ex/c_pc_m[29]/q u_datapath_u_ex_c_pc_m_reg[29]/Q -type DFF DFF
add mapped point u_datapath/u_ex/c_pc_m[13]/q u_datapath_u_ex_c_pc_m_reg[13]/Q -type DFF DFF
add mapped point u_datapath/u_mem/inst_w[0]/q u_datapath_u_mem_inst_w_reg[0]/Q -type DFF DFF
add mapped point u_datapath/u_ex/c_pc_m[31]/q u_datapath_u_ex_c_pc_m_reg[31]/Q -type DFF DFF
add mapped point u_datapath/u_ex/c_pc_m[11]/q u_datapath_u_ex_c_pc_m_reg[11]/Q -type DFF DFF
add mapped point u_datapath/u_ex/c_pc_m[12]/q u_datapath_u_ex_c_pc_m_reg[12]/Q -type DFF DFF
add mapped point u_datapath/u_ex/c_pc_m[30]/q u_datapath_u_ex_c_pc_m_reg[30]/Q -type DFF DFF
add mapped point u_datapath/u_ex/c_pc_m[14]/q u_datapath_u_ex_c_pc_m_reg[14]/Q -type DFF DFF
add mapped point u_datapath/u_ex/c_pc_m[15]/q u_datapath_u_ex_c_pc_m_reg[15]/Q -type DFF DFF
add mapped point u_datapath/u_ex/c_pc_m[16]/q u_datapath_u_ex_c_pc_m_reg[16]/Q -type DFF DFF
add mapped point u_datapath/u_ex/c_pc_m[17]/q u_datapath_u_ex_c_pc_m_reg[17]/Q -type DFF DFF
add mapped point u_datapath/u_ex/c_pc_m[18]/q u_datapath_u_ex_c_pc_m_reg[18]/Q -type DFF DFF
add mapped point u_datapath/u_id/c_pc_e[23]/q u_datapath_u_id_c_pc_e_reg[23]/Q -type DFF DFF
add mapped point u_datapath/u_id/c_pc_e[20]/q u_datapath_u_id_c_pc_e_reg[20]/Q -type DFF DFF
add mapped point u_datapath/u_id/c_pc_e[21]/q u_datapath_u_id_c_pc_e_reg[21]/Q -type DFF DFF
add mapped point u_datapath/u_id/c_pc_e[22]/q u_datapath_u_id_c_pc_e_reg[22]/Q -type DFF DFF
add mapped point u_datapath/u_id/c_pc_e[30]/q u_datapath_u_id_c_pc_e_reg[30]/Q -type DFF DFF
add mapped point u_datapath/u_id/c_pc_e[19]/q u_datapath_u_id_c_pc_e_reg[19]/Q -type DFF DFF
add mapped point u_datapath/u_id/c_pc_e[24]/q u_datapath_u_id_c_pc_e_reg[24]/Q -type DFF DFF
add mapped point u_datapath/u_id/c_pc_e[25]/q u_datapath_u_id_c_pc_e_reg[25]/Q -type DFF DFF
add mapped point u_datapath/u_id/c_pc_e[26]/q u_datapath_u_id_c_pc_e_reg[26]/Q -type DFF DFF
add mapped point u_datapath/u_id/c_pc_e[27]/q u_datapath_u_id_c_pc_e_reg[27]/Q -type DFF DFF
add mapped point u_datapath/u_id/c_pc_e[28]/q u_datapath_u_id_c_pc_e_reg[28]/Q -type DFF DFF
add mapped point u_datapath/u_id/c_pc_e[14]/q u_datapath_u_id_c_pc_e_reg[14]/Q -type DFF DFF
add mapped point u_datapath/u_id/c_pc_e[31]/q u_datapath_u_id_c_pc_e_reg[31]/Q -type DFF DFF
add mapped point u_datapath/u_id/c_pc_e[11]/q u_datapath_u_id_c_pc_e_reg[11]/Q -type DFF DFF
add mapped point u_datapath/u_id/c_pc_e[12]/q u_datapath_u_id_c_pc_e_reg[12]/Q -type DFF DFF
add mapped point u_datapath/u_id/c_pc_e[13]/q u_datapath_u_id_c_pc_e_reg[13]/Q -type DFF DFF
add mapped point u_datapath/u_id/c_pc_e[29]/q u_datapath_u_id_c_pc_e_reg[29]/Q -type DFF DFF
add mapped point u_datapath/u_id/c_pc_e[15]/q u_datapath_u_id_c_pc_e_reg[15]/Q -type DFF DFF
add mapped point u_datapath/u_id/c_pc_e[16]/q u_datapath_u_id_c_pc_e_reg[16]/Q -type DFF DFF
add mapped point u_datapath/u_id/c_pc_e[17]/q u_datapath_u_id_c_pc_e_reg[17]/Q -type DFF DFF
add mapped point u_datapath/u_id/c_pc_e[18]/q u_datapath_u_id_c_pc_e_reg[18]/Q -type DFF DFF
add mapped point u_datapath/u_ex/inst_m[0]/q u_datapath_u_ex_inst_m_reg[0]/Q -type DFF DFF
add mapped point u_datapath/u_id/inst_e[0]/q u_datapath_u_id_inst_e_reg[0]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[7]/q u_datapath_u_if_c_pc_reg[7]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[3]/q u_datapath_u_if_c_pc_reg[3]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[30]/q u_datapath_u_if_c_pc_reg[30]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[4]/q u_datapath_u_if_c_pc_reg[4]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[5]/q u_datapath_u_if_c_pc_reg[5]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[6]/q u_datapath_u_if_c_pc_reg[6]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[26]/q u_datapath_u_if_c_pc_reg[26]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[14]/q u_datapath_u_if_c_pc_reg[14]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[8]/q u_datapath_u_if_c_pc_reg[8]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[9]/q u_datapath_u_if_c_pc_reg[9]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[10]/q u_datapath_u_if_c_pc_reg[10]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[11]/q u_datapath_u_if_c_pc_reg[11]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[12]/q u_datapath_u_if_c_pc_reg[12]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[13]/q u_datapath_u_if_c_pc_reg[13]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[2]/q u_datapath_u_if_c_pc_reg[2]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[22]/q u_datapath_u_if_c_pc_reg[22]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[16]/q u_datapath_u_if_c_pc_reg[16]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[17]/q u_datapath_u_if_c_pc_reg[17]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[18]/q u_datapath_u_if_c_pc_reg[18]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[19]/q u_datapath_u_if_c_pc_reg[19]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[20]/q u_datapath_u_if_c_pc_reg[20]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[21]/q u_datapath_u_if_c_pc_reg[21]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[15]/q u_datapath_u_if_c_pc_reg[15]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[23]/q u_datapath_u_if_c_pc_reg[23]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[24]/q u_datapath_u_if_c_pc_reg[24]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[25]/q u_datapath_u_if_c_pc_reg[25]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[27]/q u_datapath_u_if_c_pc_reg[27]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[28]/q u_datapath_u_if_c_pc_reg[28]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[29]/q u_datapath_u_if_c_pc_reg[29]/Q -type DFF DFF
add mapped point u_datapath/u_if/c_pc[31]/q u_datapath_u_if_c_pc_reg[31]/Q -type DFF DFF



//Black Boxes



//Empty Modules as Blackboxes
