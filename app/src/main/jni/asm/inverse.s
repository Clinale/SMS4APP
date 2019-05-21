	area inverse, code, readonly 
	export inverse
	code32
    con dcd 0xffffffff,0xffffffff,0xffffffff,0xffffffff
	entry

start
	
;bit0   
	vldm con,q0
        veor q0,q8
        veor q0,q10
        veor q0,q13
        veor q0,q14
        veor q0,q15

;bit1   
	vldm con,q1
        veor q1,q9
        veor q1,q12
        veor q1,q13
        veor q1,q14
        veor q1,q15

;bit2   
	veor q2,q11,q8
        veor q2,q12
        veor q2,q13
        veor q2,q14

;bit3   
	vldm con,q3
        veor q3,q10
        veor q3,q11
        veor q3,q12
        veor q3,q13
        veor q3,q15

;bit4   
	veor q4,q10,q9
        veor q4,q11
        veor q4,q12
        veor q4,q14

;bit5   
	veor q5,q9,q8
        veor q5,q10
        veor q5,q11
        veor q5,q13

;bit6   
	vldm con,q6
        veor q6,q8
        veor q6,q9
        veor q6,q10
        veor q6,q12
        veor q6,q15

;bit7   
	vldm con,q7
        veor q7,q8
        veor q7,q9
        veor q7,q11
        veor q7,q14
        veor q7,q15

	;you would code there
;transform
;(q7 q6 q5 q4 q3 q2 q1 q0) * T
;-->(q15 q14 q13 q12 q11 q10 q9 q8)
;matrix
;[1. 0. 0. 1. 1. 1. 0. 1.]
;[1. 1. 1. 1. 0. 1. 0. 1.]
;[1. 0. 1. 1. 1. 1. 0. 1.]
;[1. 1. 1. 1. 0. 1. 1. 1.]
;[1. 0. 1. 0. 0. 1. 1. 1.]
;[1. 0. 1. 0. 0. 0. 1. 0.]
;[0. 0. 0. 1. 0. 0. 0. 0.]
;[0. 0. 0. 0. 0. 0. 0. 1.]
;bit0
        vmov q8,q0
        veor q8,q3
        veor q8,q4
        veor q8,q5
        veor q8,q6
        veor q8,q7
        
;bit1
        vmov q9,q2
        veor q9,q3
        veor q9,q4

;bit2
        vmov q10,q3
        veor q10,q4
        veor q10,q5
        veor q10,q6
        veor q10,q7

;bit3
        vmov q11,q5
        veor q11,q7
;bit4
        vmov q12,q1
        veor q12,q4
        veor q12,q5
        veor q12,q6
        veor q12,q7

;bit5
        vmov q13,q2
        veor q13,q3
        veor q13,q4
        veor q13,q5
        veor q13,q6

;bit6
        vmov q14,q4
        veor q14,q6
        
;bit7
        vmov q15,q2
        veor q15,q3
        veor q15,q4
        veor q15,q5
        veor q15,q6
        veor q15,q7

;end transform

;begin inv
;high (q8-q11) low (q12-q15)

;calculate g1g1v + g1g0 + g0g0
;cal g1g1v + g0g0   v=(1001)_2
;bit0
        veor q0,q9,q11
        veor q0,q0,q12

;bit1
        veor q1,q8,q12
        veor q1,q1,q14

;bit2
        veor q2,q8,q10
        veor q2,q2,q13

;bit3
        veor q3,q11,q13
        veor q3,q3,q15
;end cal g1g1v + g0g0

;cal g1g1v + g0g0 + g1g0
;bit0
        vand q4,q12,q11
        vand q5,q13,q10
        veor q4,q4,q5
        vand q5,q14,q9
        veor q4,q4,q5
        veor q5,q12,q15
        vand q5,q5,q8
        veor q4,q4,q5
        veor q0,q0,q4

;bit1
        vand q4,q13,q11
        vand q5,q10,q14
        veor q4,q4,q5
        veor q5,q12,q15
        vand q5,q5,q9
        veor q4,q4,q5
        veor q5,q12,q13
        vand q5,q5,q8
        veor q4,q4,q5
        veor q1,q1,q4

;bit2
        vand q4,q14,q15
        veor q5,q12,q15
        vand q5,q5,q10
        veor q4,q4,q5
        veor q5,q12,q13
        vand q5,q5,q9
        veor q4,q4,q5
        veor q5,q13,q14
        vand q5,q5,q8
        veor q4,q4,q5
        veor q2,q2,q4

;bit3
        vand q4,q8,q15
        vand q5,q12,q10
        veor q4,q4,q5
        vand q5,q9,q13
        veor q4,q4,q5
        vand q5,q14,q8
        veor q4,q4,q5
        veor q3,q3,q4

;end cal g1g1v + g1g0 + g0g0 --> (q0, q1, q2, q3)
;cal inverse
;refer to inverse.asm
;bit3
        veor q6,q2,q3
        vmvn q0,q0
	vand q7,q0,q6
        vmvn q0,q0
        vmvn q6,q6
	vand q5, q6, q0
        vmvn q6,q6
        vmvn q1,q1
	vand q5, q1, q5
        vmvn q1,q1
	vorr q7, q7, q5
        vmvn q0,q0
	vand q6, q0, q1
        vmvn q0,q0
        vmvn q2,q2
	vand q6, q2, q6
        vmvn q2,q2
	vorr q7, q7, q6
	vand q6, q1, q2
        vmvn q3,q3
	vand q6, q3, q6
        vmvn q3,q3
	vorr q7, q7, q6   

;bit2
        veor q6, q0, q15
	vand q6, q6, q1
	vand q5, q14, q15
	vmvn q0,q0
        vand q5, q0, q5
	;vpandn q5, q0, q5
	vorr q6, q6, q5
	vand q4, q1, q14
	vand q4, q0, q4
	vmvn q0,q0
        vorr q6, q6, q4
        vorr q4, q1, q14 
        vmvn q4,q4
        vand q4, q4, q0 
        vmvn q4,q4
        vorr q6, q6, q4  

;bit1
        veor q4, q0,q1
	vmvn q3,q3
        vand q4, q3, q4
        vmvn q3,q3
        vorr q5, q5, q4 
	vand q4, q0, q2
	vmvn q1,q1
        vand q4, q1, q4
	vmvn q1,q1
        vorr q5, q5, q4
	vand q4, q0, q1
        vand q4, q4, q3 
	vmvn q2,q2
        vand q4, q2, q4
        vmvn q2,q2
	vorr q5, q5, q4

;bit0
        veor q4,q1,q2
        vmvn q0,q0
	vand q4,q0,q4
        vmvn q0,q0
	vand q1,q1,q2
        vmvn q1,q1
	vand q2,q1,q0
        vmvn q1,q1
        vmvn q3,q3
	vand q2,q3,q2
        vmvn q3,q3
	vorr q4,q4,q2
	vand q2,q1,q0
	vand q2,q2,q3
	vorr q4,q4,q2

;end inverse --> (q4, q5, q6, q7)
;cal g1 ^ g0 --> (q12, q13, q14, q15)
        veor q12,q12,q8
        veor q13,q13,q9
        veor q14,q14,q10
        veor q15,q15,q11
;end cal g1 ^ g0

;cal inv * (g1 ^ g0) --> (q0, q1, q2, q3)
;c0 = (q12 & q7) ^ (q13 & q6) ^ (q14 & q5) ^ ((q15 ^ q12) & q4)
;c1 = (q13 & q7) ^ (q14 & q6) ^ ((q15 ^ q12) & q5) ^ ((q12 ^ q13) & q4)
;c2 = (q14 & q7) ^ ((q15 ^ q12) & q6) ^ ((q12 ^ q13) & q5) ^ ((q13 ^ q14) & q4)
;c3 = (q15 & q7) ^ (q12 & q6) ^ (q13 & q5) ^ (q14 & q4)
;bit2
        vand q2,q14,q7
        veor q3,q15,q12
        vand q3,q3,q6
        veor q2,q2,q3
        veor q3,q12,q13
        vand q3,q3,q5
        veor q2,q2,q3
        veor q3,q13,q14
        vand q3,q3,q4
        veor q2,q2,q3

;bit1
        vand q1,q13,q7
        vand q3,q14,q6
        veor q1,q1,q3
        veor q3,q15,q12
        vand q3,q3,q5
        veor q1,q1,q3
        veor q3,q12,q13
        vand q3,q3,q4
        veor q1,q1,q3

;bit0
        vand q0,q12,q7
        vand q3,q13,q6
        veor q0,q0,q3
        vand q3,q14,q5
        veor q0,q0,q3
        veor q3,q15,q12
        vand q3,q3,q4
        veor q0,q0,q3

;bit3
        vand q3,q15,q7
        vand q15,q12,q6
        veor q3,q3,q15
        vand q15,q13,q5
        veor q3,q3,q15
        vand q15,q14,q4
        veor q3,q3,q15
;end cal inv * (g1 ^ g0) --> (q0, q1, q2, q3)

;cal inv * g1 --> (q12, q13, q14, q15)
;c0 = (q8 & q7) ^ (q9 & q6) ^ (q10 & q5) ^ ((q11 ^ q8) & q4)
;c1 = (q9 & q7) ^ (q10 & q6) ^ ((q11 ^ q8) & q5) ^ ((q8 ^ q9) & q4)
;c2 = (q10 & q7) ^ ((q11 ^ q8) & q6) ^ ((q8 ^ q9) & q5) ^ ((q9 ^ q10) & q4)
;c3 = (q11 & q7) ^ (q8 & q6) ^ (q9 & q5) ^ (q10 & q4)
;bit2
        vand q14,q10,q7
        veor q15,q11,q8
        vand q15,q15,q6
        veor q14,q14,q15
        veor q15,q8,q9
        vand q15,q15,q5
        veor q14,q14,q15
        veor q15,q9,q10
        vand q15,q15,q4
        veor q14,q14,q15

;bit1
        vand q13,q10,q7
        vand q15,q10,q6
        veor q13,q13,q15
        veor q15,q11,q8
        vand q15,q15,q5
        veor q13,q13,q15
        veor q15,q8,q9
        vand q15,q15,q4
        veor q13,q13,q15

;bit0
        vand q12,q8,q7
        vand q15,q9,q6
        veor q12,q12,q15
        vand q15,q10,q5
        veor q12,q12,q15
        veor q15,q11,q8
        vand q15,q15,q4
        veor q12,q12,q15

;bit3
        vand q15,q11,q7
        vand q11,q8,q6
        veor q15,q15,q11
        vand q11,q9,q5
        veor q15,q15,q11
        vand q11,q10,q4
        veor q15,q15,q11
;end cal inv * g1 --> (q12, q13, q14, q15)
;high --> (q12-15) low --> (q0-3)

;transform
;result --> (high,low) --> (q4-q11)
;bit0
        vmov q4,q12
        veor q4,q4,q14

;bit1
        vmov q5,q12
        veor q5,q5,q0
        veor q5,q5,q2

;bit2
        vmov q6,q12
        veor q6,q6,q14
        veor q6,q6,q0

;bit3
        vmov q7,q12
        veor q7,q7,q13
        veor q7,q7,q0
        veor q7,q7,q2

;bit4
        vmov q8,q13
        veor q8,q8,q0
        veor q8,q8,q1

;bit5
        vmov q9,q12
        veor q9,q9,q1

;bit6
        vmov q10,q13
        veor q10,q10,q15
        veor q10,q10,q0

;bit7
        vmov q11,q1
        veor q11,q11,q3
;end transform  

;bit0   
	vldm con,q0
        veor q0,q8
        veor q0,q10
        veor q0,q13
        veor q0,q14
        veor q0,q15

;bit1   
	vldm con,q1
        veor q1,q9
        veor q1,q12
        veor q1,q13
        veor q1,q14
        veor q1,q15

;bit2   
	veor q2,q11,q8
        veor q2,q12
        veor q2,q13
        veor q2,q14

;bit3   
	vldm con,q3
        veor q3,q10
        veor q3,q11
        veor q3,q12
        veor q3,q13
        veor q3,q15

;bit4   
	veor q4,q10,q9
        veor q4,q11
        veor q4,q12
        veor q4,q14

;bit5   
	veor q5,q9,q8
        veor q5,q10
        veor q5,q11
        veor q5,q13

;bit6   
	vldm con,q6
        veor q6,q8
        veor q6,q9
        veor q6,q10
        veor q6,q12
        veor q6,q15

;bit7   
	vldm con,q7
        veor q7,q8
        veor q7,q9
        veor q7,q11
        veor q7,q14
        veor q7,q15
stop
	bx lr
	end
