#include "nenosms4.h"

static const uint8_t S_BOX[] = {
	214, 144, 233, 254, 204, 225, 61, 183, 22, 182, 20, 194, 40, 251, 44, 5,
	43, 103, 154, 118, 42, 190, 4, 195, 170, 68, 19, 38, 73, 134, 6, 153,
	156, 66, 80, 244, 145, 239, 152, 122, 51, 84, 11, 67, 237, 207, 172, 98,
	228, 179, 28, 169, 201, 8, 232, 149, 128, 223, 148, 250, 117, 143, 63, 166,
	71, 7, 167, 252, 243, 115, 23, 186, 131, 89, 60, 25, 230, 133, 79, 168,
	104, 107, 129, 178, 113, 100, 218, 139, 248, 235, 15, 75, 112, 86, 157,
	53, 30, 36, 14, 94, 99, 88, 209, 162, 37, 34, 124, 59, 1, 33, 120,
	135, 212, 0, 70, 87, 159, 211, 39, 82, 76, 54, 2, 231, 160, 196, 200,
	158, 234, 191, 138, 210, 64, 199, 56, 181, 163, 247, 242, 206, 249, 97, 21,
	161, 224, 174, 93, 164, 155, 52, 26, 85, 173, 147, 50, 48, 245, 140, 177,
	227, 29, 246, 226, 46, 130, 102, 202, 96, 192, 41, 35, 171, 13, 83, 78,
	111, 213, 219, 55, 69, 222, 253, 142, 47, 3, 255, 106, 114, 109, 108, 91,
	81, 141, 27, 175, 146, 187, 221, 188, 127, 17, 217, 92, 65, 31, 16, 90,
	216, 10, 193, 49, 136, 165, 205, 123, 189, 45, 116, 208, 18, 184, 229, 180,
	176, 137, 105, 151, 74, 12, 150, 119, 126, 101, 185, 241, 9, 197, 110, 198,
	132, 24, 240, 125, 236, 58, 220, 77, 32, 121, 238, 95, 62, 215, 203, 57, 72
};

static const uint32_t FK[] = { 0XA3B1BAC6, 0X56AA3350, 0X677D9197, 0XB27022DC };

static const uint32_t CK[] = {
	0X00070E15, 0X1C232A31, 0X383F464D, 0X545B6269,
	0X70777E85, 0X8C939AA1, 0XA8AFB6BD, 0XC4CBD2D9,
	0XE0E7EEF5, 0XFC030A11, 0X181F262D, 0X343B4249,
	0X50575E65, 0X6C737A81, 0X888F969D, 0XA4ABB2B9,
	0XC0C7CED5, 0XDCE3EAF1, 0XF8FF060D, 0X141B2229,
	0X30373E45, 0X4C535A61, 0X686F767D, 0X848B9299,
	0XA0A7AEB5, 0XBCC3CAD1, 0XD8DFE6ED, 0XF4FB0209,
	0X10171E25, 0X2C333A41, 0X484F565D, 0X646B7279
};

void sm4_setkey_enc(uint32_t* rk, uint32_t* key)
{
	sm4_setkey(rk, key);
}

void sm4_setkey_dec(uint32_t* rk, uint32_t* key)
{

	sm4_setkey(rk, key);
	int i;
	for (i = 0; i < 16; i++)
	{
		SWAP(rk[i], rk[31 - i]);
	}
}

uint8_t sm4Sbox(uint8_t ch)
{
	return S_BOX[ch];
}

uint32_t
sm4Rk(uint32_t ka)
{
	uint8_t* C = (uint8_t*)(&ka);
	int i;
	for (i = 0; i < 4; i++) {
		C[i] = sm4Sbox(C[i]); //t
	}

	uint32_t* B = (uint32_t*)C;
	return (*B) ^ ROT(*B, 13) ^ ROT(*B, 23);
}

void
sm4_setkey(uint32_t* rk, uint32_t* key)
{
	uint32_t K[36];


	for (int i = 0; i < 4;i++) {
		K[i] = key[i] ^ FK[i];
	}
	for (int i = 0;i < 32; i++) {
		K[i + 4] = K[i] ^ sm4Rk(K[i + 1] ^ K[i + 2] ^ K[i + 3] ^ CK[i]);
		rk[i] = K[i + 4];
	}
}

// 对秘钥进行转置
void
trans32(unsigned int rk, uint32x4_t* dst)
{
	int cnt = 31;
	while (rk != 0) {
		if (rk & 1) dst[cnt--] = vdupq_n_u32(0xffffffff);
		else dst[cnt--] = vdupq_n_u32(0);
		rk = rk >> 1;
	}
	while (cnt >= 0) {
		dst[cnt--] = vdupq_n_u32(0);
	}
}

// 并行加解密128组
void
sm4_crypt_ecb(sm4_context* ctx, uint32x4_t* plain)
{
    word0 = plain + 0;
    word1 = plain + 32;
    word2 = plain + 32;
    word3 = plain + 32;
    // 数据准备
    trans256(plain);
    for (int i = 0; i < 8; i++) {
        trans32(ctx->sk[i * 4], key);
    	s0(word1, word2, word3, key, word0);
    	s1(word1, word2, word3, key, word0);
    	s2(word1, word2, word3, key, word0);
    	s3(word1, word2, word3, key, word0);

    	trans32(ctx->sk[i * 4 + 1], key);
    	s0(word0, word2, word3, key, word1);
    	s1(word0, word2, word3, key, word1);
    	s2(word0, word2, word3, key, word1);
    	s3(word0, word2, word3, key, word1);

    	trans32(ctx->sk[i * 4 + 2], key);
    	s0(word1, word0, word3, key, word2);
    	s1(word1, word0, word3, key, word2);
    	s2(word1, word0, word3, key, word2);
    	s3(word1, word0, word3, key, word2);

    	trans32(ctx->sk[i * 4 + 3], key);
    	s0(word1, word2, word0, key, word3);
    	s1(word1, word2, word0, key, word3);
    	s2(word1, word2, word0, key, word3);
    	s3(word1, word2, word0, key, word3);

    }
    trans256(plain);
}