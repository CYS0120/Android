/*
 *  u-des.h
 *  iUbipay
 *
 *  Created by Dong Hyun Shin on 11. 2. 10..
 *  Copyright 2011 Neoclip. All rights reserved.
 *
 */

#ifdef __cplusplus
extern "C" {
#endif
	
void des_enc(const char *pCVC, const char *pCpw, const char *pYYMM, int isShinhan, unsigned char *output/* 8byte */);

#ifdef __cplusplus
}
#endif