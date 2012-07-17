########################################
# USER VARIABLES

EXE = sample.exe
PACKNAME =
SRC =
MAINSRC = main.opa
PCKDIR = ./packages/
PCK = jQueryUI.opx
PLUGIN =
PLUGINDIR =
OTHER_DEPENDS =

#Compiler variables
OPACOMPILER = opa
MINIMAL_VERSION = 0
FLAG = --minimal-version $(MINIMAL_VERSION) -v
PORT = 8080

RUNOPT ?= #-d --debug-js

# Build exe
default: exe

# Run Server
run: exe
	./$(EXE) $(RUNOPT) || exit 0 ## prevent ugly make error 130 :) ##

include Makefile.common
