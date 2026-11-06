/*
 * SDCC dialect shim for clangd only.
 *
 * Based on the compatibility-header approach used by vscode_sdcc.h:
 * https://gist.github.com/hexeguitar/1ffa147b0c358cb3455879c2baa64c63
 *
 * Deliberately supports only SDCC's __-prefixed spellings.  Do not add the
 * legacy bit/data/code aliases here: they collide with ordinary C names.
 */
#ifndef NVIM_SDCC_CLANGD_H
#define NVIM_SDCC_CLANGD_H

#if !defined(__SDCC) && !defined(SDCC)
#define __data
#define __near
#define __idata
#define __xdata
#define __far
#define __pdata
#define __code

#define __bit _Bool
#define __sfr volatile unsigned char
#define __sfr16 volatile unsigned short
#define __sfr32 volatile unsigned int
#define __sbit volatile _Bool

#define __at(address)
#define __using(bank)
#define __interrupt(vector)
#define __critical
#define __reentrant
#define __banked
#define __nonbanked
#define __naked
#endif

#endif
