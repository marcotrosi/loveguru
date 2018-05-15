.PHONY: dir cln tst all tag doc rel bld
.SILENT:

OUT_DIR=./out
SRC_DIR=./src
TST_DIR=./tst
DOC_DIR=./doc
LOVE=/Applications/love.app/Contents/MacOS/love

DIRS=${OUT_DIR} 


dir:
	mkdir -p ${DIRS}

cln:
	rm -rf ${OUT_DIR}

bld: dir
	luac -o ${OUT_DIR}/guru.lua ${SRC_DIR}/guru.lua

tst:
	cp ${SRC_DIR}/guru.lua ${TST_DIR}/guru.lua
	# rm -f test.love
	# cd ${TST_DIR}; zip -r ../tst.love *
	# open tst.love
	${LOVE} ${TST_DIR}

all: cln rel tst

#tag:
#	ctags -f .tags ${SRC_DIR}/* ${TST_DIR}/*

#doc:
#	cp ./doc/aRTlua.txt ~/.vim/doc/

rel: bld
	cp ${SRC_DIR}/guru.lua ~/Code/lib

