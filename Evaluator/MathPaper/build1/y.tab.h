/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     NUMBER = 258,
     SIN = 259,
     COS = 260,
     TAN = 261,
     ASIN = 262,
     ACOS = 263,
     ATAN = 264,
     SINH = 265,
     COSH = 266,
     TANH = 267,
     ASINH = 268,
     ACOSH = 269,
     ATANH = 270,
     SQRT = 271,
     MOD = 272,
     LN = 273,
     LOG = 274,
     PI = 275,
     UMINUS = 276
   };
#endif
/* Tokens.  */
#define NUMBER 258
#define SIN 259
#define COS 260
#define TAN 261
#define ASIN 262
#define ACOS 263
#define ATAN 264
#define SINH 265
#define COSH 266
#define TANH 267
#define ASINH 268
#define ACOSH 269
#define ATANH 270
#define SQRT 271
#define MOD 272
#define LN 273
#define LOG 274
#define PI 275
#define UMINUS 276




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 11 "grammar.y"
{
	int    ival;
	double dval;
}
/* Line 1529 of yacc.c.  */
#line 96 "y.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

