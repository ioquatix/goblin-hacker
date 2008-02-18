/*
 *  Endian.h
 *  Goblin Hacker
 *
 *  Created by Administrator on 19/12/07.
 *  Copyright 2007 Orion Transfer Ltd. All rights reserved.
 *
 *	Thanks to Hermann Gundel for pointing out that orderCopy doesn't work
 *  when srcType and dstType are the same. (What was I thinking!?)
 */
 
#ifndef _ENDIAN_H
#define _ENDIAN_H

enum Endian {
	BIG,
	LITTLE
};

// Borrowed from Dream framework
// Thanks to Gianni Mariani for the basis of this class.
inline bool isBigEndian () { 
	 unsigned x = 1; 
	 return ! ( * ( char * )( & x ) ); 
}

inline Endian hostEndian () {
	if (isBigEndian())
		return BIG;
	else
		return LITTLE;
}

template <typename base_t>
inline void orderCopy(const base_t & _src, base_t & _dst, Endian srcType, Endian dstType) { 
	 const unsigned char * src = (const unsigned char *) &_src; 
	 unsigned char * dst = (unsigned char *) &_dst; 
	 if (srcType != dstType) {
		if (sizeof(base_t) == 2) {
			dst[1] = src[0]; 
			dst[0] = src[1]; 
		} else if (sizeof(base_t) == 4) {
			dst[3] = src[0]; 
			dst[2] = src[1]; 
			dst[1] = src[2]; 
			dst[0] = src[3]; 
		} else { 
			dst += sizeof(base_t) - 1;
			for (int i = sizeof(base_t); i > 0; i--)
				*(dst--) = *(src++); 
		}
	} else {
		for (int i = sizeof(base_t); i > 0; i--)
			*(dst++) = *(src++); 
	}
}

template <typename base_t>
inline base_t orderRead(const base_t & _src, Endian srcType, Endian dstType) { 
	base_t r;
	orderCopy(_src, r, srcType, dstType);
	return r;
}


#endif