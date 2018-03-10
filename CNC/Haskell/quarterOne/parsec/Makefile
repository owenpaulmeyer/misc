# -----------------------------------------------------------------------------
# $Id: Makefile,v 1.2 2003/08/05 17:14:31 ross Exp $

TOP=..
include $(TOP)/mk/boilerplate.mk

# -----------------------------------------------------------------------------

SUBDIRS = 

ALL_DIRS = \
	Text/ParserCombinators \
	Text/ParserCombinators/Parsec

PACKAGE = parsec
PACKAGE_DEPS = base

SRC_HC_OPTS += -fglasgow-exts

# -----------------------------------------------------------------------------
# Doc building with Haddock

SRC_HADDOCK_OPTS += -t "Haskell Core Libraries (parsec package)" \
	-p prologue.txt

# -----------------------------------------------------------------------------

include $(TOP)/mk/target.mk
