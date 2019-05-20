#ifndef NENO_SMS4_H
#define NENO_SMS4_H

#include <arm_neno.h>
#include <malloc.h>

#define SWAP(a, b) { unsigned long t=a; a=b; b=t; t=0;}

typedef unsigned char uint8_t;
typedef unsigned int uint32_t;

typedef struct
{
	int mode;                   /*!<  encrypt/decrypt   */
	uint32_t sk[32];       /*!<  SM4 subkeys       */
}sm4_context;


// 引入汇编文件
// 比特矩阵转置
extern "C" void trans256(uint32x4_t *plain);

//计算轮函数
extern "C" void s0(uint32x4_t *worda, uint32x4_t *wordb, uint32x4_t *wordc, uint32x4_t *wordkey, uint32x4_t *wordp);
extern "C" void s1(uint32x4_t *worda, uint32x4_t *wordb, uint32x4_t *wordc, uint32x4_t *wordkey, uint32x4_t *wordp);
extern "C" void s2(uint32x4_t *worda, uint32x4_t *wordb, uint32x4_t *wordc, uint32x4_t *wordkey, uint32x4_t *wordp);
extern "C" void s3(uint32x4_t *worda, uint32x4_t *wordb, uint32x4_t *wordc, uint32x4_t *wordkey, uint32x4_t *wordp);

// 并行加密128组
void sm4_crypt_ecb(sm4_context* ctx, uint32x4_t* plain);


// 对轮秘钥转置
void trans32(unsigned int, uint32x4_t *key);
uint8_t sm4Sbox(uint8_t ch);
uint32_t sm4Rk(uint32_t ka);
void sm4_setkey(uint32_t *rk, uint32_t *key);

// 从文件中加载指定长度的字节
void load(uint32_t *Mem, FILE *fin, uint32_t len);
// 向文件写入
void store(uint32_t *Mem, FILE *fout, uint32_t len);

// 分配128组内存
uint32x4_t plain[128];
uint32x4_t *word0, *word1, *word2, *word3;

uint32x4_t key[32];

//uint32x4_t *plain, *word0, *word1, *word2, *word3;

// 注意内存泄露
//uint32x4_t *key = (uint32x4_t*)malloc(32*16);

//plain = (uint32x4_t*)malloc(128*16);

#endif // NENO_SMS4_H