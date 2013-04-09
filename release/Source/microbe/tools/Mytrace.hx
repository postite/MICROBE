package microbe.tools;
class Mytrace {

    public static function setRedirection() {
        haxe.Log.trace = mytrace;
    }

    private static function mytrace( v : Dynamic, ?inf : haxe.PosInfos ) {
        #if js
        		untyped console.log(v +" ::> \n " +inf.fileName +" "+inf.lineNumber+" "+inf.methodName);
        #end

        #if php
        		microbe.controllers.GenericController.appDebug.log(v +" ::> " +inf.fileName +" "+inf.lineNumber+" "+inf.methodName);
        #end
    }

}