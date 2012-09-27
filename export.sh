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
version=$2
targetd=$TM_PROJECT_DIRECTORY"/release"
echo $1
echo $2
echo "→ Assembling the 'release.zip' package"
	rm -rf $targetd $targetd.zip
	mkdir -p $targetd
	#generate_documentation
	#mkdir -p $targetd/ndll/
	mkdir -p $targetd/Source
	# cp -r tmp/$system $targetd/ndll/
	# 	cp -r ndll/Source $targetd/
	# 	cp -r curl $targetd/
	
	cp -r src/haxigniter $targetd/Source
	cp -r src/javascriptOutils $targetd/Source
	#cp -r src/jquery $targetd/Source
	#cp -r src/js $targetd/Source
	cp -r src/microbe $targetd/Source
	cp -r src/microbe $targetd/Source
	#cp -r src/test $targetd/Source #peut creer des conflits 
	#cp -r src/monjs $targetd/Source
	cp -r src/poko $targetd/Source
	
	
	cp -r www squelette
	cp -r src/config squelette
	cp -r src/controllers squelette
	cp -r src/Nav.hx squelette
	cp -r src/vo squelette
	cp -r squelette $targetd/Source
	cp haxelib.xml $targetd/Source/haxelib.xml
	cp run.n $targetd/Source/run.n
	cd $targetd
		if command -v 7z &>/dev/null; then
		7z a -tzip release.zip release > 7z.log
		
		else
			zip -r release.zip Source
			haxelib remove $lib/$version
			haxelib test release.zip
			#echo "	Did not find 7z - release packacke won't be assembled"
			#echo "	You can try to do it manually or install p7zip-full"
		fi
	cd ..