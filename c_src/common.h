/*
 * Copyright (c) 2012 Basho Technologies, Inc. All Rights Reserved.
 * Author: Gregory Burd <greg@basho.com> <greg@burd.me>
 *
 * This file is part of euv released under the MIT license.
 * See the LICENSE file for more information.
 */

#ifndef __COMMON_H__
#define __COMMON_H__

#if defined(__cplusplus)
extern "C" {
#endif

#if !(__STDC_VERSION__ >= 199901L || defined(__GNUC__))
# undef  DEBUG
# define DEBUG		0
# define DPRINTF	(void)	/* Vararg macros may be unsupported */
#elif DEBUG
#include <stdio.h>
#include <stdarg.h>
#define DPRINTF(fmt, ...)							\
    do {									\
	fprintf(stderr, "%s:%d " fmt "\n", __FILE__, __LINE__, __VA_ARGS__);    \
	fflush(stderr);								\
    } while(0)
#define DPUTS(arg)		DPRINTF("%s", arg)
#else
#define DPRINTF(fmt, ...)	((void) 0)
#define DPUTS(arg)		((void) 0)
#endif

#ifndef UNUSED
#define UNUSED(v) ((void)(v))
#endif

#ifndef COMPQUIET
#define COMPQUIET(n, v) do {                                            \
        (n) = (v);                                                      \
        (n) = (n);                                                      \
} while (0)
#endif

#ifdef __APPLE__
#define PRIuint64(x) (x)
#else
#define PRIuint64(x) (unsigned long long)(x)
#endif

#if defined(__cplusplus)
}
#endif

#endif // __COMMON_H__
