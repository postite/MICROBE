#!/bin/bash
# SRCPATH=$TM_PROJECT_DIRECTORY"/src"
# LIBNAME=mylib
# OLDLIBVERSION=`cat $SRCPATH/$LIBNAME.version`
# NEWLIBVERSION=`calc OLDLIBVERSION + 1`
# echo "Input version comment:"
# read LIBCOMMENT
# cat "$SRCPATH/haxelib.xml.tpl" | sed "s/#VERSION#/$NEWLIBVERSION/" | sed "s/#COMMENT#/$LIBCOMMENT/" > "$SRCPATH/$LIBNAME/haxelib.xml"
# zip -r "$SRCPATH/$LIBNAME.zip" "$SRCPATH/$LIBNAME"
# echo "$NEWLIBVERSION" > "$SRCPATH/$LIBNAME.version"

lib=$1
targetd=$TM_PROJECT_DIRECTORY"/release"
echo $1
echo "→ Assembling the 'release.zip' package"
	rm -rf $targetd $targetd.zip
	mkdir -p $targetd
	#generate_documentation
	#mkdir -p $targetd/ndll/
	mkdir -p $targetd/Source
	# cp -r tmp/$system $targetd/ndll/
	# 	cp -r ndll/Source $targetd/
	# 	cp -r curl $targetd/
	cp -r src/* $targetd/Source
	cp haxelib.xml $targetd/Source/haxelib.xml
	cd $targetd
		if command -v 7z &>/dev/null; then
			7z a -tzip release.zip release > 7z.log
		
			
		else
			zip -r release.zip Source
			haxelib remove $lib
			haxelib test release.zip
			#echo "	Did not find 7z - release packacke won't be assembled"
			#echo "	You can try to do it manually or install p7zip-full"
		fi
	cd ..