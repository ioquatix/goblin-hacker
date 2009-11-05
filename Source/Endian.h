/*
 *  Endian.h
 *  Dream
 *
 *  Created by Samuel Williams on 29/09/06.
 *  Copyright 2006 Samuel G. D. Williams. All rights reserved.
 *
 */

 
//
//  This software was originally produced by Orion Transfer Ltd.
//    Please see http://www.oriontransfer.org for more details.
//

/*
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

 
#ifndef _DREAM_ENDIAN_H
#define _DREAM_ENDIAN_H

enum Endian {
	BIG,
	LITTLE
};

#ifdef __LITTLE_ENDIAN__ || i386
inline Endian hostEndian () {
	return LITTLE;
}
#elif __BIG_ENDIAN__ || ppc
inline Endian hostEndian () {
	return BIG;
}
#else
inline bool _isBigEndian () { 
	 unsigned x = 1; 
	 return ! ( * ( char * )( & x ) ); 
}

inline Endian hostEndian () {
	if (_isBigEndian())
		return BIG;
	else
		return LITTLE;
}
#endif

// Network order is big endian
// Use this if you need to write something that deals specifically with network order.
inline Endian networkEndian () {
	return BIG;
}

// X86 (Intel/AMD) is little endian
// Platforms using this library will generally be little endian (X86)
// Therefore, we standardize on little-endian.. 
// This will need little or no encoding/decoding for the majority of platforms.
inline Endian libraryEndian () {
	return LITTLE;
}

// This is a very efficient interface for decoding endian values.
// uint32_t val = readInt(...);
// endianDecode(val, libraryEndian(), hostEndian());
template <typename base_t>
inline void endianDecode (base_t & value, Endian srcType, Endian dstType) {
	if (srcType != dstType) {
		base_t copy = value;
		orderCopy(value, copy);
		value = copy;
	}
}

// This interface can be used when reading data directly from memory.
inline void orderCopy(const unsigned char * src, unsigned char * dst, size_t len, Endian srcType, Endian dstType) {
	if (srcType != dstType) {
		dst += len - 1;
		for (int i = 0; i < len; i++)
			*(dst--) = *(src++);
	} else {
		for (int i = 0; i < len; i++)
			*(dst++) = *(src++); 
	}
}

template <typename base_t>
void orderCopy(const base_t & _src, base_t & _dst, Endian srcType, Endian dstType) { 
	 const unsigned char * src = (const unsigned char *) &_src; 
	 unsigned char * dst = (unsigned char *) &_dst;
	 
	 orderCopy(src, dst, sizeof(base_t), srcType, dstType);
}

template <typename base_t>
inline base_t orderRead(const base_t & _src, Endian srcType, Endian dstType) { 
	base_t r;
	orderCopy(_src, r, srcType, dstType);
	return r;
}

template <typename base_t>
inline void orderWrite(const base_t & val, base_t & dst, Endian srcType, Endian dstType) {
	 // for the time being this is the same as OrderRead 
	 orderCopy(val, dst, srcType, dstType); 
}


#endif