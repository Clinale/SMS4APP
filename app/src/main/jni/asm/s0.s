	import inverse
	area s0, code, readonly 
	export s0
	code32
	entry

start
	ldr r10,[sp]


;bit0
        vldm r0+0,q8
        vldm r1+0,q9
        veor q8,q9
        vldm r2+0,q9
        veor q8,q9
        vldm r3+0,q9
        veor q8,q9

;bit1
		vldm r0+16,q9
        vldm r1+16,q10
        veor q9,q10
        vldm r2+16,q10
        veor q9,q10
        vldm r3+16,q10
        veor q9,q10

;bit2
        vldm r0+32,q10
        vldm r1+32,q11
        veor q10,q11
        vldm r2+32,q11
        veor q10,q11
        vldm r3+32,q11
        veor q10,q11

;bit3
        vldm r0+48,q11
        vldm r1+48,q12
        veor q11,q12
        vldm r2+48,q12
        veor q11,q12
        vldm r3+48,q12
        veor q11,q12

;bit4
        vldm r0+64,q12
        vldm r1+64,q13
        veor q12,q13
        vldm r2+64,q13
        veor q12,q13
        vldm r3+64,q13
        veor q12,q13

;bit5
        vldm r0+80,q13
        vldm r1+80,q14
        veor q13,q14
        vldm r2+80,q14
        veor q13,q14
        vldm r3+80,q14
        veor q13,q14

;bit6
        vldm r0+96,q14
        vldm r1+96,q15
        veor q14,q15
        vldm r2+96,q15
        veor q14,q15
        vldm r3+96,q15
        veor q14,q15

;bit7
        vldm r0+112,q15
        vldm r1+112,q0
        veor q15,q0
        vldm r2+112,q0
        veor q15,q0
        vldm r3+112,q0
        veor q15,q0

		bl inverse

;bit0
        vldm r10+0,q12
        veor q12,q0
        vstm r10+0,q12

        vldm r10+480,q12
        veor q12,q0
        vstm r10+480,q12

        vldm r10+352,q12
        veor q12,q0
        vstm r10+352,q12

        vldm r10+224,q12
        veor q12,q0
        vstm r10+224,q12

        vldm r10+128,q12
        veor q12,q0
        vstm r10+128,q12

;bit1
        vldm r10+16,q12
        veor q12,q1
        vstm r10+16,q12

        vldm r10+496,q12
        veor q12,q1
        vstm r10+496,q12

        vldm r10+368,q12
        veor q12,q1
        vstm r10+368,q12

        vldm r10+240,q12
        veor q12,q1
        vstm r10+240,q12

        vldm r10+144,q12
        veor q12,q1
        vstm r10+144,q12

;bit2
        vldm r10+32,q12
        veor q12,q2
        vstm r10+32,q12

        vldm r10+0,q12
        veor q12,q2
        vstm r10+0,q12

        vldm r10+384,q12
        veor q12,q2
        vstm r10+384,q12

        vldm r10+256,q12
        veor q12,q2
        vstm r10+256,q12

        vldm r10+160,q12
        veor q12,q2
        vstm r10+160,q12

;bit3
        vldm r10+48,q12
        veor q12,q3
        vstm r10+48,q12

        vldm r10+16,q12
        veor q12,q3
        vstm r10+16,q12

        vldm r10+400,q12
        veor q12,q3
        vstm r10+400,q12

        vldm r10+272,q12
        veor q12,q3
        vstm r10+272,q12

        vldm r10+176,q12
        veor q12,q3
        vstm r10+176,q12

;bit4
        vldm r10+64,q12
        veor q12,q4
        vstm r10+64,q12

        vldm r10+32,q12
        veor q12,q4
        vstm r10+32,q12

        vldm r10+416,q12
        veor q12,q4
        vstm r10+416,q12

        vldm r10+288,q12
        veor q12,q4
        vstm r10+288,q12

        vldm r10+192,q12
        veor q12,q4
        vstm r10+192,q12

;bit5
        vldm r10+80,q12
        veor q12,q5
        vstm r10+80,q12

        vldm r10+48,q12
        veor q12,q5
        vstm r10+48,q12

        vldm r10+432,q12
        veor q12,q5
        vstm r10+432,q12

        vldm r10+304,q12
        veor q12,q5
        vstm r10+304,q12

        vldm r10+208,q12
        veor q12,q5
        vstm r10+208,q12

;bit6
        vldm r10+96,q12
        veor q12,q6
        vstm r10+96,q12

        vldm r10+64,q12
        veor q12,q6
        vstm r10+64,q12

        vldm r10+448,q12
        veor q12,q6
        vstm r10+448,q12

        vldm r10+320,q12
        veor q12,q6
        vstm r10+320,q12

        vldm r10+224,q12
        veor q12,q6
        vstm r10+224,q12

;bit7
        vldm r10+112,q12
        veor q12,q7
        vstm r10+112,q12

        vldm r10+80,q12
        veor q12,q7
        vstm r10+80,q12

        vldm r10+464,q12
        veor q12,q7
        vstm r10+464,q12

        vldm r10+336,q12
        veor q12,q7
        vstm r10+336,q12

        vldm r10+240,q12
        veor q12,q7
        vstm r10+240,q12


stop
	bx lr
	end
