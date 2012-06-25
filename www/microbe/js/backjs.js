var $_, $hxClasses = $hxClasses || {}, $estr = function() { return js.Boot.__string_rec(this,''); }
function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	return proto;
}
var Hash = $hxClasses["Hash"] = function() {
	this.h = { };
};
Hash.__name__ = ["Hash"];
Hash.prototype = {
	h: null
	,set: function(key,value) {
		this.h["$" + key] = value;
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,remove: function(key) {
		key = "$" + key;
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key.substr(1));
		}
		return a.iterator();
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref["$" + i];
		}};
	}
	,toString: function() {
		var s = new StringBuf();
		s.b[s.b.length] = "{";
		var it = this.keys();
		while( it.hasNext() ) {
			var i = it.next();
			s.b[s.b.length] = i == null?"null":i;
			s.b[s.b.length] = " => ";
			s.add(Std.string(this.get(i)));
			if(it.hasNext()) s.b[s.b.length] = ", ";
		}
		s.b[s.b.length] = "}";
		return s.b.join("");
	}
	,__class__: Hash
}
var IntHash = $hxClasses["IntHash"] = function() {
	this.h = { };
};
IntHash.__name__ = ["IntHash"];
IntHash.prototype = {
	h: null
	,set: function(key,value) {
		this.h[key] = value;
	}
	,get: function(key) {
		return this.h[key];
	}
	,exists: function(key) {
		return this.h.hasOwnProperty(key);
	}
	,remove: function(key) {
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key | 0);
		}
		return a.iterator();
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref[i];
		}};
	}
	,toString: function() {
		var s = new StringBuf();
		s.b[s.b.length] = "{";
		var it = this.keys();
		while( it.hasNext() ) {
			var i = it.next();
			s.b[s.b.length] = i == null?"null":i;
			s.b[s.b.length] = " => ";
			s.add(Std.string(this.get(i)));
			if(it.hasNext()) s.b[s.b.length] = ", ";
		}
		s.b[s.b.length] = "}";
		return s.b.join("");
	}
	,__class__: IntHash
}
var IntIter = $hxClasses["IntIter"] = function(min,max) {
	this.min = min;
	this.max = max;
};
IntIter.__name__ = ["IntIter"];
IntIter.prototype = {
	min: null
	,max: null
	,hasNext: function() {
		return this.min < this.max;
	}
	,next: function() {
		return this.min++;
	}
	,__class__: IntIter
}
var Lambda = $hxClasses["Lambda"] = function() { }
Lambda.__name__ = ["Lambda"];
Lambda.array = function(it) {
	var a = new Array();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		a.push(i);
	}
	return a;
}
Lambda.list = function(it) {
	var l = new List();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		l.add(i);
	}
	return l;
}
Lambda.map = function(it,f) {
	var l = new List();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(f(x));
	}
	return l;
}
Lambda.mapi = function(it,f) {
	var l = new List();
	var i = 0;
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(f(i++,x));
	}
	return l;
}
Lambda.has = function(it,elt,cmp) {
	if(cmp == null) {
		var $it0 = it.iterator();
		while( $it0.hasNext() ) {
			var x = $it0.next();
			if(x == elt) return true;
		}
	} else {
		var $it1 = it.iterator();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			if(cmp(x,elt)) return true;
		}
	}
	return false;
}
Lambda.exists = function(it,f) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) return true;
	}
	return false;
}
Lambda.foreach = function(it,f) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(!f(x)) return false;
	}
	return true;
}
Lambda.iter = function(it,f) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		f(x);
	}
}
Lambda.filter = function(it,f) {
	var l = new List();
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) l.add(x);
	}
	return l;
}
Lambda.fold = function(it,f,first) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		first = f(x,first);
	}
	return first;
}
Lambda.count = function(it,pred) {
	var n = 0;
	if(pred == null) {
		var $it0 = it.iterator();
		while( $it0.hasNext() ) {
			var _ = $it0.next();
			n++;
		}
	} else {
		var $it1 = it.iterator();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			if(pred(x)) n++;
		}
	}
	return n;
}
Lambda.empty = function(it) {
	return !it.iterator().hasNext();
}
Lambda.indexOf = function(it,v) {
	var i = 0;
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var v2 = $it0.next();
		if(v == v2) return i;
		i++;
	}
	return -1;
}
Lambda.concat = function(a,b) {
	var l = new List();
	var $it0 = a.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(x);
	}
	var $it1 = b.iterator();
	while( $it1.hasNext() ) {
		var x = $it1.next();
		l.add(x);
	}
	return l;
}
Lambda.prototype = {
	__class__: Lambda
}
var List = $hxClasses["List"] = function() {
	this.length = 0;
};
List.__name__ = ["List"];
List.prototype = {
	h: null
	,q: null
	,length: null
	,add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,push: function(item) {
		var x = [item,this.h];
		this.h = x;
		if(this.q == null) this.q = x;
		this.length++;
	}
	,first: function() {
		return this.h == null?null:this.h[0];
	}
	,last: function() {
		return this.q == null?null:this.q[0];
	}
	,pop: function() {
		if(this.h == null) return null;
		var x = this.h[0];
		this.h = this.h[1];
		if(this.h == null) this.q = null;
		this.length--;
		return x;
	}
	,isEmpty: function() {
		return this.h == null;
	}
	,clear: function() {
		this.h = null;
		this.q = null;
		this.length = 0;
	}
	,remove: function(v) {
		var prev = null;
		var l = this.h;
		while(l != null) {
			if(l[0] == v) {
				if(prev == null) this.h = l[1]; else prev[1] = l[1];
				if(this.q == l) this.q = prev;
				this.length--;
				return true;
			}
			prev = l;
			l = l[1];
		}
		return false;
	}
	,iterator: function() {
		return { h : this.h, hasNext : function() {
			return this.h != null;
		}, next : function() {
			if(this.h == null) return null;
			var x = this.h[0];
			this.h = this.h[1];
			return x;
		}};
	}
	,toString: function() {
		var s = new StringBuf();
		var first = true;
		var l = this.h;
		s.b[s.b.length] = "{";
		while(l != null) {
			if(first) first = false; else s.b[s.b.length] = ", ";
			s.add(Std.string(l[0]));
			l = l[1];
		}
		s.b[s.b.length] = "}";
		return s.b.join("");
	}
	,join: function(sep) {
		var s = new StringBuf();
		var first = true;
		var l = this.h;
		while(l != null) {
			if(first) first = false; else s.b[s.b.length] = sep == null?"null":sep;
			s.add(l[0]);
			l = l[1];
		}
		return s.b.join("");
	}
	,filter: function(f) {
		var l2 = new List();
		var l = this.h;
		while(l != null) {
			var v = l[0];
			l = l[1];
			if(f(v)) l2.add(v);
		}
		return l2;
	}
	,map: function(f) {
		var b = new List();
		var l = this.h;
		while(l != null) {
			var v = l[0];
			l = l[1];
			b.add(f(v));
		}
		return b;
	}
	,__class__: List
}
var Reflect = $hxClasses["Reflect"] = function() { }
Reflect.__name__ = ["Reflect"];
Reflect.hasField = function(o,field) {
	return Object.prototype.hasOwnProperty.call(o,field);
}
Reflect.field = function(o,field) {
	var v = null;
	try {
		v = o[field];
	} catch( e ) {
	}
	return v;
}
Reflect.setField = function(o,field,value) {
	o[field] = value;
}
Reflect.getProperty = function(o,field) {
	var tmp;
	return o == null?null:o.__properties__ && (tmp = o.__properties__["get_" + field])?o[tmp]():o[field];
}
Reflect.setProperty = function(o,field,value) {
	var tmp;
	if(o.__properties__ && (tmp = o.__properties__["set_" + field])) o[tmp](value); else o[field] = value;
}
Reflect.callMethod = function(o,func,args) {
	return func.apply(o,args);
}
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
}
Reflect.isFunction = function(f) {
	return typeof(f) == "function" && f.__name__ == null;
}
Reflect.compare = function(a,b) {
	return a == b?0:a > b?1:-1;
}
Reflect.compareMethods = function(f1,f2) {
	if(f1 == f2) return true;
	if(!Reflect.isFunction(f1) || !Reflect.isFunction(f2)) return false;
	return f1.scope == f2.scope && f1.method == f2.method && f1.method != null;
}
Reflect.isObject = function(v) {
	if(v == null) return false;
	var t = typeof(v);
	return t == "string" || t == "object" && !v.__enum__ || t == "function" && v.__name__ != null;
}
Reflect.deleteField = function(o,f) {
	if(!Reflect.hasField(o,f)) return false;
	delete(o[f]);
	return true;
}
Reflect.copy = function(o) {
	var o2 = { };
	var _g = 0, _g1 = Reflect.fields(o);
	while(_g < _g1.length) {
		var f = _g1[_g];
		++_g;
		o2[f] = Reflect.field(o,f);
	}
	return o2;
}
Reflect.makeVarArgs = function(f) {
	return function() {
		var a = Array.prototype.slice.call(arguments);
		return f(a);
	};
}
Reflect.prototype = {
	__class__: Reflect
}
var Std = $hxClasses["Std"] = function() { }
Std.__name__ = ["Std"];
Std["is"] = function(v,t) {
	return js.Boot.__instanceof(v,t);
}
Std.string = function(s) {
	return js.Boot.__string_rec(s,"");
}
Std["int"] = function(x) {
	return x | 0;
}
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && x.charCodeAt(1) == 120) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
Std.parseFloat = function(x) {
	return parseFloat(x);
}
Std.random = function(x) {
	return Math.floor(Math.random() * x);
}
Std.prototype = {
	__class__: Std
}
var StringBuf = $hxClasses["StringBuf"] = function() {
	this.b = new Array();
};
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	add: function(x) {
		this.b[this.b.length] = x == null?"null":x;
	}
	,addSub: function(s,pos,len) {
		this.b[this.b.length] = s.substr(pos,len);
	}
	,addChar: function(c) {
		this.b[this.b.length] = String.fromCharCode(c);
	}
	,toString: function() {
		return this.b.join("");
	}
	,b: null
	,__class__: StringBuf
}
var StringTools = $hxClasses["StringTools"] = function() { }
StringTools.__name__ = ["StringTools"];
StringTools.urlEncode = function(s) {
	return encodeURIComponent(s);
}
StringTools.urlDecode = function(s) {
	return decodeURIComponent(s.split("+").join(" "));
}
StringTools.htmlEscape = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
StringTools.htmlUnescape = function(s) {
	return s.split("&gt;").join(">").split("&lt;").join("<").split("&amp;").join("&");
}
StringTools.startsWith = function(s,start) {
	return s.length >= start.length && s.substr(0,start.length) == start;
}
StringTools.endsWith = function(s,end) {
	var elen = end.length;
	var slen = s.length;
	return slen >= elen && s.substr(slen - elen,elen) == end;
}
StringTools.isSpace = function(s,pos) {
	var c = s.charCodeAt(pos);
	return c >= 9 && c <= 13 || c == 32;
}
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return s.substr(r,l - r); else return s;
}
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
	if(r > 0) return s.substr(0,l - r); else return s;
}
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
}
StringTools.rpad = function(s,c,l) {
	var sl = s.length;
	var cl = c.length;
	while(sl < l) if(l - sl < cl) {
		s += c.substr(0,l - sl);
		sl = l;
	} else {
		s += c;
		sl += cl;
	}
	return s;
}
StringTools.lpad = function(s,c,l) {
	var ns = "";
	var sl = s.length;
	if(sl >= l) return s;
	var cl = c.length;
	while(sl < l) if(l - sl < cl) {
		ns += c.substr(0,l - sl);
		sl = l;
	} else {
		ns += c;
		sl += cl;
	}
	return ns + s;
}
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
}
StringTools.hex = function(n,digits) {
	var s = "";
	var hexChars = "0123456789ABCDEF";
	do {
		s = hexChars.charAt(n & 15) + s;
		n >>>= 4;
	} while(n > 0);
	if(digits != null) while(s.length < digits) s = "0" + s;
	return s;
}
StringTools.fastCodeAt = function(s,index) {
	return s.cca(index);
}
StringTools.isEOF = function(c) {
	return c != c;
}
StringTools.prototype = {
	__class__: StringTools
}
var ValueType = $hxClasses["ValueType"] = { __ename__ : ["ValueType"], __constructs__ : ["TNull","TInt","TFloat","TBool","TObject","TFunction","TClass","TEnum","TUnknown"] }
ValueType.TNull = ["TNull",0];
ValueType.TNull.toString = $estr;
ValueType.TNull.__enum__ = ValueType;
ValueType.TInt = ["TInt",1];
ValueType.TInt.toString = $estr;
ValueType.TInt.__enum__ = ValueType;
ValueType.TFloat = ["TFloat",2];
ValueType.TFloat.toString = $estr;
ValueType.TFloat.__enum__ = ValueType;
ValueType.TBool = ["TBool",3];
ValueType.TBool.toString = $estr;
ValueType.TBool.__enum__ = ValueType;
ValueType.TObject = ["TObject",4];
ValueType.TObject.toString = $estr;
ValueType.TObject.__enum__ = ValueType;
ValueType.TFunction = ["TFunction",5];
ValueType.TFunction.toString = $estr;
ValueType.TFunction.__enum__ = ValueType;
ValueType.TClass = function(c) { var $x = ["TClass",6,c]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TEnum = function(e) { var $x = ["TEnum",7,e]; $x.__enum__ = ValueType; $x.toString = $estr; return $x; }
ValueType.TUnknown = ["TUnknown",8];
ValueType.TUnknown.toString = $estr;
ValueType.TUnknown.__enum__ = ValueType;
var Type = $hxClasses["Type"] = function() { }
Type.__name__ = ["Type"];
Type.getClass = function(o) {
	if(o == null) return null;
	if(o.__enum__ != null) return null;
	return o.__class__;
}
Type.getEnum = function(o) {
	if(o == null) return null;
	return o.__enum__;
}
Type.getSuperClass = function(c) {
	return c.__super__;
}
Type.getClassName = function(c) {
	var a = c.__name__;
	return a.join(".");
}
Type.getEnumName = function(e) {
	var a = e.__ename__;
	return a.join(".");
}
Type.resolveClass = function(name) {
	var cl = $hxClasses[name];
	if(cl == null || cl.__name__ == null) return null;
	return cl;
}
Type.resolveEnum = function(name) {
	var e = $hxClasses[name];
	if(e == null || e.__ename__ == null) return null;
	return e;
}
Type.createInstance = function(cl,args) {
	switch(args.length) {
	case 0:
		return new cl();
	case 1:
		return new cl(args[0]);
	case 2:
		return new cl(args[0],args[1]);
	case 3:
		return new cl(args[0],args[1],args[2]);
	case 4:
		return new cl(args[0],args[1],args[2],args[3]);
	case 5:
		return new cl(args[0],args[1],args[2],args[3],args[4]);
	case 6:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5]);
	case 7:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
	case 8:
		return new cl(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
	default:
		throw "Too many arguments";
	}
	return null;
}
Type.createEmptyInstance = function(cl) {
	function empty() {}; empty.prototype = cl.prototype;
	return new empty();
}
Type.createEnum = function(e,constr,params) {
	var f = Reflect.field(e,constr);
	if(f == null) throw "No such constructor " + constr;
	if(Reflect.isFunction(f)) {
		if(params == null) throw "Constructor " + constr + " need parameters";
		return f.apply(e,params);
	}
	if(params != null && params.length != 0) throw "Constructor " + constr + " does not need parameters";
	return f;
}
Type.createEnumIndex = function(e,index,params) {
	var c = e.__constructs__[index];
	if(c == null) throw index + " is not a valid enum constructor index";
	return Type.createEnum(e,c,params);
}
Type.getInstanceFields = function(c) {
	var a = [];
	for(var i in c.prototype) a.push(i);
	a.remove("__class__");
	a.remove("__properties__");
	return a;
}
Type.getClassFields = function(c) {
	var a = Reflect.fields(c);
	a.remove("__name__");
	a.remove("__interfaces__");
	a.remove("__properties__");
	a.remove("__super__");
	a.remove("prototype");
	return a;
}
Type.getEnumConstructs = function(e) {
	var a = e.__constructs__;
	return a.copy();
}
Type["typeof"] = function(v) {
	switch(typeof(v)) {
	case "boolean":
		return ValueType.TBool;
	case "string":
		return ValueType.TClass(String);
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) return ValueType.TInt;
		return ValueType.TFloat;
	case "object":
		if(v == null) return ValueType.TNull;
		var e = v.__enum__;
		if(e != null) return ValueType.TEnum(e);
		var c = v.__class__;
		if(c != null) return ValueType.TClass(c);
		return ValueType.TObject;
	case "function":
		if(v.__name__ != null) return ValueType.TObject;
		return ValueType.TFunction;
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
}
Type.enumEq = function(a,b) {
	if(a == b) return true;
	try {
		if(a[0] != b[0]) return false;
		var _g1 = 2, _g = a.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(!Type.enumEq(a[i],b[i])) return false;
		}
		var e = a.__enum__;
		if(e != b.__enum__ || e == null) return false;
	} catch( e ) {
		return false;
	}
	return true;
}
Type.enumConstructor = function(e) {
	return e[0];
}
Type.enumParameters = function(e) {
	return e.slice(2);
}
Type.enumIndex = function(e) {
	return e[1];
}
Type.allEnums = function(e) {
	var all = [];
	var cst = e.__constructs__;
	var _g = 0;
	while(_g < cst.length) {
		var c = cst[_g];
		++_g;
		var v = Reflect.field(e,c);
		if(!Reflect.isFunction(v)) all.push(v);
	}
	return all;
}
Type.prototype = {
	__class__: Type
}
var haxe = haxe || {}
haxe.FastList = $hxClasses["haxe.FastList"] = function() {
};
haxe.FastList.__name__ = ["haxe","FastList"];
haxe.FastList.prototype = {
	head: null
	,add: function(item) {
		this.head = new haxe.FastCell(item,this.head);
	}
	,first: function() {
		return this.head == null?null:this.head.elt;
	}
	,pop: function() {
		var k = this.head;
		if(k == null) return null; else {
			this.head = k.next;
			return k.elt;
		}
	}
	,isEmpty: function() {
		return this.head == null;
	}
	,remove: function(v) {
		var prev = null;
		var l = this.head;
		while(l != null) {
			if(l.elt == v) {
				if(prev == null) this.head = l.next; else prev.next = l.next;
				break;
			}
			prev = l;
			l = l.next;
		}
		return l != null;
	}
	,iterator: function() {
		var l = this.head;
		return { hasNext : function() {
			return l != null;
		}, next : function() {
			var k = l;
			l = k.next;
			return k.elt;
		}};
	}
	,toString: function() {
		var a = new Array();
		var l = this.head;
		while(l != null) {
			a.push(l.elt);
			l = l.next;
		}
		return "{" + a.join(",") + "}";
	}
	,__class__: haxe.FastList
}
var feffects = feffects || {}
feffects.Tween = $hxClasses["feffects.Tween"] = function(init,end,dur,obj,prop,easing) {
	this.initVal = init;
	this.endVal = end;
	this.duration = dur;
	this.offsetTime = 0;
	this.obj = obj;
	this.prop = prop;
	if(easing != null) this.easingF = easing; else if(Reflect.isFunction(obj)) this.easingF = obj; else this.easingF = this.easingEquation.$bind(this);
	this.isPlaying = false;
};
feffects.Tween.__name__ = ["feffects","Tween"];
feffects.Tween.timer = null;
feffects.Tween.AddTween = function(tween) {
	feffects.Tween.aTweens.add(tween);
	feffects.Tween.timer.run = feffects.Tween.DispatchTweens;
}
feffects.Tween.RemoveTween = function(tween) {
	if(tween == null || feffects.Tween.timer == null) return;
	feffects.Tween.aTweens.remove(tween);
	if(feffects.Tween.aTweens.head == null && feffects.Tween.aPaused.head == null) {
		feffects.Tween.timer.stop();
		feffects.Tween.timer = null;
	}
}
feffects.Tween.getActiveTweens = function() {
	return feffects.Tween.aTweens;
}
feffects.Tween.getPausedTweens = function() {
	return feffects.Tween.aPaused;
}
feffects.Tween.setTweenPaused = function(tween) {
	if(tween == null || feffects.Tween.timer == null) return;
	feffects.Tween.aPaused.add(tween);
	feffects.Tween.aTweens.remove(tween);
}
feffects.Tween.setTweenActive = function(tween) {
	if(tween == null || feffects.Tween.timer == null) return;
	feffects.Tween.aTweens.add(tween);
	feffects.Tween.aPaused.remove(tween);
}
feffects.Tween.DispatchTweens = function() {
	var $it0 = feffects.Tween.aTweens.iterator();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		i.doInterval();
	}
}
feffects.Tween.prototype = {
	duration: null
	,position: null
	,reversed: null
	,isPlaying: null
	,initVal: null
	,endVal: null
	,startTime: null
	,pauseTime: null
	,offsetTime: null
	,reverseTime: null
	,updateFunc: null
	,endFunc: null
	,easingF: null
	,obj: null
	,prop: null
	,start: function() {
		if(feffects.Tween.timer != null) feffects.Tween.timer.stop();
		feffects.Tween.timer = new haxe.Timer(feffects.Tween.interval);
		this.startTime = Date.now().getTime() - feffects.Tween.jsDate;
		if(this.duration == 0) this.endTween(); else feffects.Tween.AddTween(this);
		this.isPlaying = true;
		this.position = 0;
		this.reverseTime = this.startTime;
		this.reversed = false;
	}
	,pause: function() {
		this.pauseTime = Date.now().getTime() - feffects.Tween.jsDate;
		feffects.Tween.setTweenPaused(this);
		this.isPlaying = false;
	}
	,resume: function() {
		this.startTime += Date.now().getTime() - feffects.Tween.jsDate - this.pauseTime;
		this.reverseTime += Date.now().getTime() - feffects.Tween.jsDate - this.pauseTime;
		feffects.Tween.setTweenActive(this);
		this.isPlaying = true;
	}
	,seek: function(ms) {
		this.offsetTime = ms;
	}
	,reverse: function() {
		this.reversed = !this.reversed;
		if(!this.reversed) this.startTime += Date.now().getTime() - feffects.Tween.jsDate - this.reverseTime << 1;
		this.reverseTime = Date.now().getTime() - feffects.Tween.jsDate;
	}
	,stop: function() {
		feffects.Tween.RemoveTween(this);
		this.isPlaying = false;
	}
	,doInterval: function() {
		var stamp = Date.now().getTime() - feffects.Tween.jsDate;
		var curTime = 0;
		if(this.reversed) curTime = (this.reverseTime << 1) - stamp - this.startTime + this.offsetTime; else curTime = stamp - this.startTime + this.offsetTime;
		var curVal = this.easingF(curTime,this.initVal,this.endVal - this.initVal,this.duration);
		if(curTime >= this.duration || curTime <= 0) this.endTween(); else {
			if(this.updateFunc != null) this.updateFunc(curVal);
			if(this.prop != null) this.obj[this.prop] = curVal;
		}
		this.position = curTime;
	}
	,getCurVal: function(curTime) {
		return this.easingF(curTime,this.initVal,this.endVal - this.initVal,this.duration);
	}
	,endTween: function() {
		feffects.Tween.RemoveTween(this);
		var val = 0.0;
		if(this.reversed) val = this.initVal; else val = this.endVal;
		if(this.updateFunc != null) this.updateFunc(val);
		if(this.endFunc != null) this.endFunc(val);
		if(this.prop != null) this.obj[this.prop] = val;
	}
	,setTweenHandlers: function(update,end) {
		this.updateFunc = update;
		this.endFunc = end;
	}
	,setEasing: function(easingFunc) {
		if(easingFunc != null) this.easingF = easingFunc;
	}
	,easingEquation: function(t,b,c,d) {
		return c / 2 * (Math.sin(Math.PI * (t / d - 0.5)) + 1) + b;
	}
	,__class__: feffects.Tween
}
haxe.Public = $hxClasses["haxe.Public"] = function() { }
haxe.Public.__name__ = ["haxe","Public"];
haxe.Public.prototype = {
	__class__: haxe.Public
}
if(!feffects.easing) feffects.easing = {}
feffects.easing.Bounce = $hxClasses["feffects.easing.Bounce"] = function() { }
feffects.easing.Bounce.__name__ = ["feffects","easing","Bounce"];
feffects.easing.Bounce.__interfaces__ = [haxe.Public];
feffects.easing.Bounce.easeOut = function(t,b,c,d) {
	if((t /= d) < 1 / 2.75) return c * (7.5625 * t * t) + b; else if(t < 2 / 2.75) return c * (7.5625 * (t -= 1.5 / 2.75) * t + .75) + b; else if(t < 2.5 / 2.75) return c * (7.5625 * (t -= 2.25 / 2.75) * t + .9375) + b; else return c * (7.5625 * (t -= 2.625 / 2.75) * t + .984375) + b;
}
feffects.easing.Bounce.easeIn = function(t,b,c,d) {
	return c - feffects.easing.Bounce.easeOut(d - t,0,c,d) + b;
}
feffects.easing.Bounce.easeInOut = function(t,b,c,d) {
	if(t < d / 2) return (c - feffects.easing.Bounce.easeOut(d - t * 2,0,c,d)) * .5 + b; else return feffects.easing.Bounce.easeOut(t * 2 - d,0,c,d) * .5 + c * .5 + b;
}
feffects.easing.Bounce.prototype = {
	__class__: feffects.easing.Bounce
}
haxe.FastCell = $hxClasses["haxe.FastCell"] = function(elt,next) {
	this.elt = elt;
	this.next = next;
};
haxe.FastCell.__name__ = ["haxe","FastCell"];
haxe.FastCell.prototype = {
	elt: null
	,next: null
	,__class__: haxe.FastCell
}
haxe.Http = $hxClasses["haxe.Http"] = function(url) {
	this.url = url;
	this.headers = new Hash();
	this.params = new Hash();
	this.async = true;
};
haxe.Http.__name__ = ["haxe","Http"];
haxe.Http.requestUrl = function(url) {
	var h = new haxe.Http(url);
	h.async = false;
	var r = null;
	h.onData = function(d) {
		r = d;
	};
	h.onError = function(e) {
		throw e;
	};
	h.request(false);
	return r;
}
haxe.Http.prototype = {
	url: null
	,async: null
	,postData: null
	,headers: null
	,params: null
	,setHeader: function(header,value) {
		this.headers.set(header,value);
	}
	,setParameter: function(param,value) {
		this.params.set(param,value);
	}
	,setPostData: function(data) {
		this.postData = data;
	}
	,request: function(post) {
		var me = this;
		var r = new js.XMLHttpRequest();
		var onreadystatechange = function() {
			if(r.readyState != 4) return;
			var s = (function($this) {
				var $r;
				try {
					$r = r.status;
				} catch( e ) {
					$r = null;
				}
				return $r;
			}(this));
			if(s == undefined) s = null;
			if(s != null) me.onStatus(s);
			if(s != null && s >= 200 && s < 400) me.onData(r.responseText); else switch(s) {
			case null: case undefined:
				me.onError("Failed to connect or resolve host");
				break;
			case 12029:
				me.onError("Failed to connect to host");
				break;
			case 12007:
				me.onError("Unknown host");
				break;
			default:
				me.onError("Http Error #" + r.status);
			}
		};
		if(this.async) r.onreadystatechange = onreadystatechange;
		var uri = this.postData;
		if(uri != null) post = true; else {
			var $it0 = this.params.keys();
			while( $it0.hasNext() ) {
				var p = $it0.next();
				if(uri == null) uri = ""; else uri += "&";
				uri += StringTools.urlEncode(p) + "=" + StringTools.urlEncode(this.params.get(p));
			}
		}
		try {
			if(post) r.open("POST",this.url,this.async); else if(uri != null) {
				var question = this.url.split("?").length <= 1;
				r.open("GET",this.url + (question?"?":"&") + uri,this.async);
				uri = null;
			} else r.open("GET",this.url,this.async);
		} catch( e ) {
			this.onError(e.toString());
			return;
		}
		if(this.headers.get("Content-Type") == null && post && this.postData == null) r.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		var $it1 = this.headers.keys();
		while( $it1.hasNext() ) {
			var h = $it1.next();
			r.setRequestHeader(h,this.headers.get(h));
		}
		r.send(uri);
		if(!this.async) onreadystatechange();
	}
	,onData: function(data) {
	}
	,onError: function(msg) {
	}
	,onStatus: function(status) {
	}
	,__class__: haxe.Http
}
haxe.Log = $hxClasses["haxe.Log"] = function() { }
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
}
haxe.Log.clear = function() {
	js.Boot.__clear_trace();
}
haxe.Log.prototype = {
	__class__: haxe.Log
}
haxe.Serializer = $hxClasses["haxe.Serializer"] = function() {
	this.buf = new StringBuf();
	this.cache = new Array();
	this.useCache = haxe.Serializer.USE_CACHE;
	this.useEnumIndex = haxe.Serializer.USE_ENUM_INDEX;
	this.shash = new Hash();
	this.scount = 0;
};
haxe.Serializer.__name__ = ["haxe","Serializer"];
haxe.Serializer.run = function(v) {
	var s = new haxe.Serializer();
	s.serialize(v);
	return s.toString();
}
haxe.Serializer.prototype = {
	buf: null
	,cache: null
	,shash: null
	,scount: null
	,useCache: null
	,useEnumIndex: null
	,toString: function() {
		return this.buf.b.join("");
	}
	,serializeString: function(s) {
		var x = this.shash.get(s);
		if(x != null) {
			this.buf.add("R");
			this.buf.add(x);
			return;
		}
		this.shash.set(s,this.scount++);
		this.buf.add("y");
		s = StringTools.urlEncode(s);
		this.buf.add(s.length);
		this.buf.add(":");
		this.buf.add(s);
	}
	,serializeRef: function(v) {
		var vt = typeof(v);
		var _g1 = 0, _g = this.cache.length;
		while(_g1 < _g) {
			var i = _g1++;
			var ci = this.cache[i];
			if(typeof(ci) == vt && ci == v) {
				this.buf.add("r");
				this.buf.add(i);
				return true;
			}
		}
		this.cache.push(v);
		return false;
	}
	,serializeFields: function(v) {
		var _g = 0, _g1 = Reflect.fields(v);
		while(_g < _g1.length) {
			var f = _g1[_g];
			++_g;
			this.serializeString(f);
			this.serialize(Reflect.field(v,f));
		}
		this.buf.add("g");
	}
	,serialize: function(v) {
		var $e = (Type["typeof"](v));
		switch( $e[1] ) {
		case 0:
			this.buf.add("n");
			break;
		case 1:
			if(v == 0) {
				this.buf.add("z");
				return;
			}
			this.buf.add("i");
			this.buf.add(v);
			break;
		case 2:
			if(Math.isNaN(v)) this.buf.add("k"); else if(!Math.isFinite(v)) this.buf.add(v < 0?"m":"p"); else {
				this.buf.add("d");
				this.buf.add(v);
			}
			break;
		case 3:
			this.buf.add(v?"t":"f");
			break;
		case 6:
			var c = $e[2];
			if(c == String) {
				this.serializeString(v);
				return;
			}
			if(this.useCache && this.serializeRef(v)) return;
			switch(c) {
			case Array:
				var ucount = 0;
				this.buf.add("a");
				var l = v["length"];
				var _g = 0;
				while(_g < l) {
					var i = _g++;
					if(v[i] == null) ucount++; else {
						if(ucount > 0) {
							if(ucount == 1) this.buf.add("n"); else {
								this.buf.add("u");
								this.buf.add(ucount);
							}
							ucount = 0;
						}
						this.serialize(v[i]);
					}
				}
				if(ucount > 0) {
					if(ucount == 1) this.buf.add("n"); else {
						this.buf.add("u");
						this.buf.add(ucount);
					}
				}
				this.buf.add("h");
				break;
			case List:
				this.buf.add("l");
				var v1 = v;
				var $it0 = v1.iterator();
				while( $it0.hasNext() ) {
					var i = $it0.next();
					this.serialize(i);
				}
				this.buf.add("h");
				break;
			case Date:
				var d = v;
				this.buf.add("v");
				this.buf.add(d.toString());
				break;
			case Hash:
				this.buf.add("b");
				var v1 = v;
				var $it1 = v1.keys();
				while( $it1.hasNext() ) {
					var k = $it1.next();
					this.serializeString(k);
					this.serialize(v1.get(k));
				}
				this.buf.add("h");
				break;
			case IntHash:
				this.buf.add("q");
				var v1 = v;
				var $it2 = v1.keys();
				while( $it2.hasNext() ) {
					var k = $it2.next();
					this.buf.add(":");
					this.buf.add(k);
					this.serialize(v1.get(k));
				}
				this.buf.add("h");
				break;
			case haxe.io.Bytes:
				var v1 = v;
				var i = 0;
				var max = v1.length - 2;
				var chars = "";
				var b64 = haxe.Serializer.BASE64;
				while(i < max) {
					var b1 = v1.b[i++];
					var b2 = v1.b[i++];
					var b3 = v1.b[i++];
					chars += b64.charAt(b1 >> 2) + b64.charAt((b1 << 4 | b2 >> 4) & 63) + b64.charAt((b2 << 2 | b3 >> 6) & 63) + b64.charAt(b3 & 63);
				}
				if(i == max) {
					var b1 = v1.b[i++];
					var b2 = v1.b[i++];
					chars += b64.charAt(b1 >> 2) + b64.charAt((b1 << 4 | b2 >> 4) & 63) + b64.charAt(b2 << 2 & 63);
				} else if(i == max + 1) {
					var b1 = v1.b[i++];
					chars += b64.charAt(b1 >> 2) + b64.charAt(b1 << 4 & 63);
				}
				this.buf.add("s");
				this.buf.add(chars.length);
				this.buf.add(":");
				this.buf.add(chars);
				break;
			default:
				this.cache.pop();
				if(v.hxSerialize != null) {
					this.buf.add("C");
					this.serializeString(Type.getClassName(c));
					this.cache.push(v);
					v.hxSerialize(this);
					this.buf.add("g");
				} else {
					this.buf.add("c");
					this.serializeString(Type.getClassName(c));
					this.cache.push(v);
					this.serializeFields(v);
				}
			}
			break;
		case 4:
			if(this.useCache && this.serializeRef(v)) return;
			this.buf.add("o");
			this.serializeFields(v);
			break;
		case 7:
			var e = $e[2];
			if(this.useCache && this.serializeRef(v)) return;
			this.cache.pop();
			this.buf.add(this.useEnumIndex?"j":"w");
			this.serializeString(Type.getEnumName(e));
			if(this.useEnumIndex) {
				this.buf.add(":");
				this.buf.add(v[1]);
			} else this.serializeString(v[0]);
			this.buf.add(":");
			var l = v["length"];
			this.buf.add(l - 2);
			var _g = 2;
			while(_g < l) {
				var i = _g++;
				this.serialize(v[i]);
			}
			this.cache.push(v);
			break;
		case 5:
			throw "Cannot serialize function";
			break;
		default:
			throw "Cannot serialize " + Std.string(v);
		}
	}
	,serializeException: function(e) {
		this.buf.add("x");
		this.serialize(e);
	}
	,__class__: haxe.Serializer
}
haxe.Timer = $hxClasses["haxe.Timer"] = function(time_ms) {
	var me = this;
	this.id = window.setInterval(function() {
		me.run();
	},time_ms);
};
haxe.Timer.__name__ = ["haxe","Timer"];
haxe.Timer.delay = function(f,time_ms) {
	var t = new haxe.Timer(time_ms);
	t.run = function() {
		t.stop();
		f();
	};
	return t;
}
haxe.Timer.measure = function(f,pos) {
	var t0 = haxe.Timer.stamp();
	var r = f();
	haxe.Log.trace(haxe.Timer.stamp() - t0 + "s",pos);
	return r;
}
haxe.Timer.stamp = function() {
	return Date.now().getTime() / 1000;
}
haxe.Timer.prototype = {
	id: null
	,stop: function() {
		if(this.id == null) return;
		window.clearInterval(this.id);
		this.id = null;
	}
	,run: function() {
	}
	,__class__: haxe.Timer
}
haxe.Unserializer = $hxClasses["haxe.Unserializer"] = function(buf) {
	this.buf = buf;
	this.length = buf.length;
	this.pos = 0;
	this.scache = new Array();
	this.cache = new Array();
	var r = haxe.Unserializer.DEFAULT_RESOLVER;
	if(r == null) {
		r = Type;
		haxe.Unserializer.DEFAULT_RESOLVER = r;
	}
	this.setResolver(r);
};
haxe.Unserializer.__name__ = ["haxe","Unserializer"];
haxe.Unserializer.initCodes = function() {
	var codes = new Array();
	var _g1 = 0, _g = haxe.Unserializer.BASE64.length;
	while(_g1 < _g) {
		var i = _g1++;
		codes[haxe.Unserializer.BASE64.cca(i)] = i;
	}
	return codes;
}
haxe.Unserializer.run = function(v) {
	return new haxe.Unserializer(v).unserialize();
}
haxe.Unserializer.prototype = {
	buf: null
	,pos: null
	,length: null
	,cache: null
	,scache: null
	,resolver: null
	,setResolver: function(r) {
		if(r == null) this.resolver = { resolveClass : function(_) {
			return null;
		}, resolveEnum : function(_) {
			return null;
		}}; else this.resolver = r;
	}
	,getResolver: function() {
		return this.resolver;
	}
	,get: function(p) {
		return this.buf.cca(p);
	}
	,readDigits: function() {
		var k = 0;
		var s = false;
		var fpos = this.pos;
		while(true) {
			var c = this.buf.cca(this.pos);
			if(c != c) break;
			if(c == 45) {
				if(this.pos != fpos) break;
				s = true;
				this.pos++;
				continue;
			}
			if(c < 48 || c > 57) break;
			k = k * 10 + (c - 48);
			this.pos++;
		}
		if(s) k *= -1;
		return k;
	}
	,unserializeObject: function(o) {
		while(true) {
			if(this.pos >= this.length) throw "Invalid object";
			if(this.buf.cca(this.pos) == 103) break;
			var k = this.unserialize();
			if(!Std["is"](k,String)) throw "Invalid object key";
			var v = this.unserialize();
			o[k] = v;
		}
		this.pos++;
	}
	,unserializeEnum: function(edecl,tag) {
		if(this.buf.cca(this.pos++) != 58) throw "Invalid enum format";
		var nargs = this.readDigits();
		if(nargs == 0) return Type.createEnum(edecl,tag);
		var args = new Array();
		while(nargs-- > 0) args.push(this.unserialize());
		return Type.createEnum(edecl,tag,args);
	}
	,unserialize: function() {
		switch(this.buf.cca(this.pos++)) {
		case 110:
			return null;
		case 116:
			return true;
		case 102:
			return false;
		case 122:
			return 0;
		case 105:
			return this.readDigits();
		case 100:
			var p1 = this.pos;
			while(true) {
				var c = this.buf.cca(this.pos);
				if(c >= 43 && c < 58 || c == 101 || c == 69) this.pos++; else break;
			}
			return Std.parseFloat(this.buf.substr(p1,this.pos - p1));
		case 121:
			var len = this.readDigits();
			if(this.buf.cca(this.pos++) != 58 || this.length - this.pos < len) throw "Invalid string length";
			var s = this.buf.substr(this.pos,len);
			this.pos += len;
			s = StringTools.urlDecode(s);
			this.scache.push(s);
			return s;
		case 107:
			return Math.NaN;
		case 109:
			return Math.NEGATIVE_INFINITY;
		case 112:
			return Math.POSITIVE_INFINITY;
		case 97:
			var buf = this.buf;
			var a = new Array();
			this.cache.push(a);
			while(true) {
				var c = this.buf.cca(this.pos);
				if(c == 104) {
					this.pos++;
					break;
				}
				if(c == 117) {
					this.pos++;
					var n = this.readDigits();
					a[a.length + n - 1] = null;
				} else a.push(this.unserialize());
			}
			return a;
		case 111:
			var o = { };
			this.cache.push(o);
			this.unserializeObject(o);
			return o;
		case 114:
			var n = this.readDigits();
			if(n < 0 || n >= this.cache.length) throw "Invalid reference";
			return this.cache[n];
		case 82:
			var n = this.readDigits();
			if(n < 0 || n >= this.scache.length) throw "Invalid string reference";
			return this.scache[n];
		case 120:
			throw this.unserialize();
			break;
		case 99:
			var name = this.unserialize();
			var cl = this.resolver.resolveClass(name);
			if(cl == null) throw "Class not found " + name;
			var o = Type.createEmptyInstance(cl);
			this.cache.push(o);
			this.unserializeObject(o);
			return o;
		case 119:
			var name = this.unserialize();
			var edecl = this.resolver.resolveEnum(name);
			if(edecl == null) throw "Enum not found " + name;
			var e = this.unserializeEnum(edecl,this.unserialize());
			this.cache.push(e);
			return e;
		case 106:
			var name = this.unserialize();
			var edecl = this.resolver.resolveEnum(name);
			if(edecl == null) throw "Enum not found " + name;
			this.pos++;
			var index = this.readDigits();
			var tag = Type.getEnumConstructs(edecl)[index];
			if(tag == null) throw "Unknown enum index " + name + "@" + index;
			var e = this.unserializeEnum(edecl,tag);
			this.cache.push(e);
			return e;
		case 108:
			var l = new List();
			this.cache.push(l);
			var buf = this.buf;
			while(this.buf.cca(this.pos) != 104) l.add(this.unserialize());
			this.pos++;
			return l;
		case 98:
			var h = new Hash();
			this.cache.push(h);
			var buf = this.buf;
			while(this.buf.cca(this.pos) != 104) {
				var s = this.unserialize();
				h.set(s,this.unserialize());
			}
			this.pos++;
			return h;
		case 113:
			var h = new IntHash();
			this.cache.push(h);
			var buf = this.buf;
			var c = this.buf.cca(this.pos++);
			while(c == 58) {
				var i = this.readDigits();
				h.set(i,this.unserialize());
				c = this.buf.cca(this.pos++);
			}
			if(c != 104) throw "Invalid IntHash format";
			return h;
		case 118:
			var d = Date.fromString(this.buf.substr(this.pos,19));
			this.cache.push(d);
			this.pos += 19;
			return d;
		case 115:
			var len = this.readDigits();
			var buf = this.buf;
			if(this.buf.cca(this.pos++) != 58 || this.length - this.pos < len) throw "Invalid bytes length";
			var codes = haxe.Unserializer.CODES;
			if(codes == null) {
				codes = haxe.Unserializer.initCodes();
				haxe.Unserializer.CODES = codes;
			}
			var i = this.pos;
			var rest = len & 3;
			var size = (len >> 2) * 3 + (rest >= 2?rest - 1:0);
			var max = i + (len - rest);
			var bytes = haxe.io.Bytes.alloc(size);
			var bpos = 0;
			while(i < max) {
				var c1 = codes[buf.cca(i++)];
				var c2 = codes[buf.cca(i++)];
				bytes.b[bpos++] = (c1 << 2 | c2 >> 4) & 255;
				var c3 = codes[buf.cca(i++)];
				bytes.b[bpos++] = (c2 << 4 | c3 >> 2) & 255;
				var c4 = codes[buf.cca(i++)];
				bytes.b[bpos++] = (c3 << 6 | c4) & 255;
			}
			if(rest >= 2) {
				var c1 = codes[buf.cca(i++)];
				var c2 = codes[buf.cca(i++)];
				bytes.b[bpos++] = (c1 << 2 | c2 >> 4) & 255;
				if(rest == 3) {
					var c3 = codes[buf.cca(i++)];
					bytes.b[bpos++] = (c2 << 4 | c3 >> 2) & 255;
				}
			}
			this.pos += len;
			this.cache.push(bytes);
			return bytes;
		case 67:
			var name = this.unserialize();
			var cl = this.resolver.resolveClass(name);
			if(cl == null) throw "Class not found " + name;
			var o = Type.createEmptyInstance(cl);
			this.cache.push(o);
			o.hxUnserialize(this);
			if(this.buf.cca(this.pos++) != 103) throw "Invalid custom data";
			return o;
		default:
		}
		this.pos--;
		throw "Invalid char " + this.buf.charAt(this.pos) + " at position " + this.pos;
	}
	,__class__: haxe.Unserializer
}
if(!haxe.io) haxe.io = {}
haxe.io.Bytes = $hxClasses["haxe.io.Bytes"] = function(length,b) {
	this.length = length;
	this.b = b;
};
haxe.io.Bytes.__name__ = ["haxe","io","Bytes"];
haxe.io.Bytes.alloc = function(length) {
	var a = new Array();
	var _g = 0;
	while(_g < length) {
		var i = _g++;
		a.push(0);
	}
	return new haxe.io.Bytes(length,a);
}
haxe.io.Bytes.ofString = function(s) {
	var a = new Array();
	var _g1 = 0, _g = s.length;
	while(_g1 < _g) {
		var i = _g1++;
		var c = s.cca(i);
		if(c <= 127) a.push(c); else if(c <= 2047) {
			a.push(192 | c >> 6);
			a.push(128 | c & 63);
		} else if(c <= 65535) {
			a.push(224 | c >> 12);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		} else {
			a.push(240 | c >> 18);
			a.push(128 | c >> 12 & 63);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		}
	}
	return new haxe.io.Bytes(a.length,a);
}
haxe.io.Bytes.ofData = function(b) {
	return new haxe.io.Bytes(b.length,b);
}
haxe.io.Bytes.prototype = {
	length: null
	,b: null
	,get: function(pos) {
		return this.b[pos];
	}
	,set: function(pos,v) {
		this.b[pos] = v & 255;
	}
	,blit: function(pos,src,srcpos,len) {
		if(pos < 0 || srcpos < 0 || len < 0 || pos + len > this.length || srcpos + len > src.length) throw haxe.io.Error.OutsideBounds;
		var b1 = this.b;
		var b2 = src.b;
		if(b1 == b2 && pos > srcpos) {
			var i = len;
			while(i > 0) {
				i--;
				b1[i + pos] = b2[i + srcpos];
			}
			return;
		}
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			b1[i + pos] = b2[i + srcpos];
		}
	}
	,sub: function(pos,len) {
		if(pos < 0 || len < 0 || pos + len > this.length) throw haxe.io.Error.OutsideBounds;
		return new haxe.io.Bytes(len,this.b.slice(pos,pos + len));
	}
	,compare: function(other) {
		var b1 = this.b;
		var b2 = other.b;
		var len = this.length < other.length?this.length:other.length;
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			if(b1[i] != b2[i]) return b1[i] - b2[i];
		}
		return this.length - other.length;
	}
	,readString: function(pos,len) {
		if(pos < 0 || len < 0 || pos + len > this.length) throw haxe.io.Error.OutsideBounds;
		var s = "";
		var b = this.b;
		var fcc = String.fromCharCode;
		var i = pos;
		var max = pos + len;
		while(i < max) {
			var c = b[i++];
			if(c < 128) {
				if(c == 0) break;
				s += fcc(c);
			} else if(c < 224) s += fcc((c & 63) << 6 | b[i++] & 127); else if(c < 240) {
				var c2 = b[i++];
				s += fcc((c & 31) << 12 | (c2 & 127) << 6 | b[i++] & 127);
			} else {
				var c2 = b[i++];
				var c3 = b[i++];
				s += fcc((c & 15) << 18 | (c2 & 127) << 12 | c3 << 6 & 127 | b[i++] & 127);
			}
		}
		return s;
	}
	,toString: function() {
		return this.readString(0,this.length);
	}
	,toHex: function() {
		var s = new StringBuf();
		var chars = [];
		var str = "0123456789abcdef";
		var _g1 = 0, _g = str.length;
		while(_g1 < _g) {
			var i = _g1++;
			chars.push(str.charCodeAt(i));
		}
		var _g1 = 0, _g = this.length;
		while(_g1 < _g) {
			var i = _g1++;
			var c = this.b[i];
			s.b[s.b.length] = String.fromCharCode(chars[c >> 4]);
			s.b[s.b.length] = String.fromCharCode(chars[c & 15]);
		}
		return s.b.join("");
	}
	,getData: function() {
		return this.b;
	}
	,__class__: haxe.io.Bytes
}
haxe.io.Error = $hxClasses["haxe.io.Error"] = { __ename__ : ["haxe","io","Error"], __constructs__ : ["Blocked","Overflow","OutsideBounds","Custom"] }
haxe.io.Error.Blocked = ["Blocked",0];
haxe.io.Error.Blocked.toString = $estr;
haxe.io.Error.Blocked.__enum__ = haxe.io.Error;
haxe.io.Error.Overflow = ["Overflow",1];
haxe.io.Error.Overflow.toString = $estr;
haxe.io.Error.Overflow.__enum__ = haxe.io.Error;
haxe.io.Error.OutsideBounds = ["OutsideBounds",2];
haxe.io.Error.OutsideBounds.toString = $estr;
haxe.io.Error.OutsideBounds.__enum__ = haxe.io.Error;
haxe.io.Error.Custom = function(e) { var $x = ["Custom",3,e]; $x.__enum__ = haxe.io.Error; $x.toString = $estr; return $x; }
if(!haxe.macro) haxe.macro = {}
haxe.macro.Context = $hxClasses["haxe.macro.Context"] = function() { }
haxe.macro.Context.__name__ = ["haxe","macro","Context"];
haxe.macro.Context.prototype = {
	__class__: haxe.macro.Context
}
haxe.macro.Constant = $hxClasses["haxe.macro.Constant"] = { __ename__ : ["haxe","macro","Constant"], __constructs__ : ["CInt","CFloat","CString","CIdent","CType","CRegexp"] }
haxe.macro.Constant.CInt = function(v) { var $x = ["CInt",0,v]; $x.__enum__ = haxe.macro.Constant; $x.toString = $estr; return $x; }
haxe.macro.Constant.CFloat = function(f) { var $x = ["CFloat",1,f]; $x.__enum__ = haxe.macro.Constant; $x.toString = $estr; return $x; }
haxe.macro.Constant.CString = function(s) { var $x = ["CString",2,s]; $x.__enum__ = haxe.macro.Constant; $x.toString = $estr; return $x; }
haxe.macro.Constant.CIdent = function(s) { var $x = ["CIdent",3,s]; $x.__enum__ = haxe.macro.Constant; $x.toString = $estr; return $x; }
haxe.macro.Constant.CType = function(s) { var $x = ["CType",4,s]; $x.__enum__ = haxe.macro.Constant; $x.toString = $estr; return $x; }
haxe.macro.Constant.CRegexp = function(r,opt) { var $x = ["CRegexp",5,r,opt]; $x.__enum__ = haxe.macro.Constant; $x.toString = $estr; return $x; }
haxe.macro.Binop = $hxClasses["haxe.macro.Binop"] = { __ename__ : ["haxe","macro","Binop"], __constructs__ : ["OpAdd","OpMult","OpDiv","OpSub","OpAssign","OpEq","OpNotEq","OpGt","OpGte","OpLt","OpLte","OpAnd","OpOr","OpXor","OpBoolAnd","OpBoolOr","OpShl","OpShr","OpUShr","OpMod","OpAssignOp","OpInterval"] }
haxe.macro.Binop.OpAdd = ["OpAdd",0];
haxe.macro.Binop.OpAdd.toString = $estr;
haxe.macro.Binop.OpAdd.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpMult = ["OpMult",1];
haxe.macro.Binop.OpMult.toString = $estr;
haxe.macro.Binop.OpMult.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpDiv = ["OpDiv",2];
haxe.macro.Binop.OpDiv.toString = $estr;
haxe.macro.Binop.OpDiv.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpSub = ["OpSub",3];
haxe.macro.Binop.OpSub.toString = $estr;
haxe.macro.Binop.OpSub.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpAssign = ["OpAssign",4];
haxe.macro.Binop.OpAssign.toString = $estr;
haxe.macro.Binop.OpAssign.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpEq = ["OpEq",5];
haxe.macro.Binop.OpEq.toString = $estr;
haxe.macro.Binop.OpEq.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpNotEq = ["OpNotEq",6];
haxe.macro.Binop.OpNotEq.toString = $estr;
haxe.macro.Binop.OpNotEq.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpGt = ["OpGt",7];
haxe.macro.Binop.OpGt.toString = $estr;
haxe.macro.Binop.OpGt.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpGte = ["OpGte",8];
haxe.macro.Binop.OpGte.toString = $estr;
haxe.macro.Binop.OpGte.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpLt = ["OpLt",9];
haxe.macro.Binop.OpLt.toString = $estr;
haxe.macro.Binop.OpLt.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpLte = ["OpLte",10];
haxe.macro.Binop.OpLte.toString = $estr;
haxe.macro.Binop.OpLte.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpAnd = ["OpAnd",11];
haxe.macro.Binop.OpAnd.toString = $estr;
haxe.macro.Binop.OpAnd.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpOr = ["OpOr",12];
haxe.macro.Binop.OpOr.toString = $estr;
haxe.macro.Binop.OpOr.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpXor = ["OpXor",13];
haxe.macro.Binop.OpXor.toString = $estr;
haxe.macro.Binop.OpXor.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpBoolAnd = ["OpBoolAnd",14];
haxe.macro.Binop.OpBoolAnd.toString = $estr;
haxe.macro.Binop.OpBoolAnd.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpBoolOr = ["OpBoolOr",15];
haxe.macro.Binop.OpBoolOr.toString = $estr;
haxe.macro.Binop.OpBoolOr.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpShl = ["OpShl",16];
haxe.macro.Binop.OpShl.toString = $estr;
haxe.macro.Binop.OpShl.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpShr = ["OpShr",17];
haxe.macro.Binop.OpShr.toString = $estr;
haxe.macro.Binop.OpShr.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpUShr = ["OpUShr",18];
haxe.macro.Binop.OpUShr.toString = $estr;
haxe.macro.Binop.OpUShr.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpMod = ["OpMod",19];
haxe.macro.Binop.OpMod.toString = $estr;
haxe.macro.Binop.OpMod.__enum__ = haxe.macro.Binop;
haxe.macro.Binop.OpAssignOp = function(op) { var $x = ["OpAssignOp",20,op]; $x.__enum__ = haxe.macro.Binop; $x.toString = $estr; return $x; }
haxe.macro.Binop.OpInterval = ["OpInterval",21];
haxe.macro.Binop.OpInterval.toString = $estr;
haxe.macro.Binop.OpInterval.__enum__ = haxe.macro.Binop;
haxe.macro.Unop = $hxClasses["haxe.macro.Unop"] = { __ename__ : ["haxe","macro","Unop"], __constructs__ : ["OpIncrement","OpDecrement","OpNot","OpNeg","OpNegBits"] }
haxe.macro.Unop.OpIncrement = ["OpIncrement",0];
haxe.macro.Unop.OpIncrement.toString = $estr;
haxe.macro.Unop.OpIncrement.__enum__ = haxe.macro.Unop;
haxe.macro.Unop.OpDecrement = ["OpDecrement",1];
haxe.macro.Unop.OpDecrement.toString = $estr;
haxe.macro.Unop.OpDecrement.__enum__ = haxe.macro.Unop;
haxe.macro.Unop.OpNot = ["OpNot",2];
haxe.macro.Unop.OpNot.toString = $estr;
haxe.macro.Unop.OpNot.__enum__ = haxe.macro.Unop;
haxe.macro.Unop.OpNeg = ["OpNeg",3];
haxe.macro.Unop.OpNeg.toString = $estr;
haxe.macro.Unop.OpNeg.__enum__ = haxe.macro.Unop;
haxe.macro.Unop.OpNegBits = ["OpNegBits",4];
haxe.macro.Unop.OpNegBits.toString = $estr;
haxe.macro.Unop.OpNegBits.__enum__ = haxe.macro.Unop;
haxe.macro.ExprDef = $hxClasses["haxe.macro.ExprDef"] = { __ename__ : ["haxe","macro","ExprDef"], __constructs__ : ["EConst","EArray","EBinop","EField","EType","EParenthesis","EObjectDecl","EArrayDecl","ECall","ENew","EUnop","EVars","EFunction","EBlock","EFor","EIn","EIf","EWhile","ESwitch","ETry","EReturn","EBreak","EContinue","EUntyped","EThrow","ECast","EDisplay","EDisplayNew","ETernary","ECheckType"] }
haxe.macro.ExprDef.EConst = function(c) { var $x = ["EConst",0,c]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EArray = function(e1,e2) { var $x = ["EArray",1,e1,e2]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EBinop = function(op,e1,e2) { var $x = ["EBinop",2,op,e1,e2]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EField = function(e,field) { var $x = ["EField",3,e,field]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EType = function(e,field) { var $x = ["EType",4,e,field]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EParenthesis = function(e) { var $x = ["EParenthesis",5,e]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EObjectDecl = function(fields) { var $x = ["EObjectDecl",6,fields]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EArrayDecl = function(values) { var $x = ["EArrayDecl",7,values]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.ECall = function(e,params) { var $x = ["ECall",8,e,params]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.ENew = function(t,params) { var $x = ["ENew",9,t,params]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EUnop = function(op,postFix,e) { var $x = ["EUnop",10,op,postFix,e]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EVars = function(vars) { var $x = ["EVars",11,vars]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EFunction = function(name,f) { var $x = ["EFunction",12,name,f]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EBlock = function(exprs) { var $x = ["EBlock",13,exprs]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EFor = function(it,expr) { var $x = ["EFor",14,it,expr]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EIn = function(e1,e2) { var $x = ["EIn",15,e1,e2]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EIf = function(econd,eif,eelse) { var $x = ["EIf",16,econd,eif,eelse]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EWhile = function(econd,e,normalWhile) { var $x = ["EWhile",17,econd,e,normalWhile]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.ESwitch = function(e,cases,edef) { var $x = ["ESwitch",18,e,cases,edef]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.ETry = function(e,catches) { var $x = ["ETry",19,e,catches]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EReturn = function(e) { var $x = ["EReturn",20,e]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EBreak = ["EBreak",21];
haxe.macro.ExprDef.EBreak.toString = $estr;
haxe.macro.ExprDef.EBreak.__enum__ = haxe.macro.ExprDef;
haxe.macro.ExprDef.EContinue = ["EContinue",22];
haxe.macro.ExprDef.EContinue.toString = $estr;
haxe.macro.ExprDef.EContinue.__enum__ = haxe.macro.ExprDef;
haxe.macro.ExprDef.EUntyped = function(e) { var $x = ["EUntyped",23,e]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EThrow = function(e) { var $x = ["EThrow",24,e]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.ECast = function(e,t) { var $x = ["ECast",25,e,t]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EDisplay = function(e,isCall) { var $x = ["EDisplay",26,e,isCall]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EDisplayNew = function(t) { var $x = ["EDisplayNew",27,t]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.ETernary = function(econd,eif,eelse) { var $x = ["ETernary",28,econd,eif,eelse]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.ECheckType = function(e,t) { var $x = ["ECheckType",29,e,t]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ComplexType = $hxClasses["haxe.macro.ComplexType"] = { __ename__ : ["haxe","macro","ComplexType"], __constructs__ : ["TPath","TFunction","TAnonymous","TParent","TExtend","TOptional"] }
haxe.macro.ComplexType.TPath = function(p) { var $x = ["TPath",0,p]; $x.__enum__ = haxe.macro.ComplexType; $x.toString = $estr; return $x; }
haxe.macro.ComplexType.TFunction = function(args,ret) { var $x = ["TFunction",1,args,ret]; $x.__enum__ = haxe.macro.ComplexType; $x.toString = $estr; return $x; }
haxe.macro.ComplexType.TAnonymous = function(fields) { var $x = ["TAnonymous",2,fields]; $x.__enum__ = haxe.macro.ComplexType; $x.toString = $estr; return $x; }
haxe.macro.ComplexType.TParent = function(t) { var $x = ["TParent",3,t]; $x.__enum__ = haxe.macro.ComplexType; $x.toString = $estr; return $x; }
haxe.macro.ComplexType.TExtend = function(p,fields) { var $x = ["TExtend",4,p,fields]; $x.__enum__ = haxe.macro.ComplexType; $x.toString = $estr; return $x; }
haxe.macro.ComplexType.TOptional = function(t) { var $x = ["TOptional",5,t]; $x.__enum__ = haxe.macro.ComplexType; $x.toString = $estr; return $x; }
haxe.macro.TypeParam = $hxClasses["haxe.macro.TypeParam"] = { __ename__ : ["haxe","macro","TypeParam"], __constructs__ : ["TPType","TPExpr"] }
haxe.macro.TypeParam.TPType = function(t) { var $x = ["TPType",0,t]; $x.__enum__ = haxe.macro.TypeParam; $x.toString = $estr; return $x; }
haxe.macro.TypeParam.TPExpr = function(e) { var $x = ["TPExpr",1,e]; $x.__enum__ = haxe.macro.TypeParam; $x.toString = $estr; return $x; }
haxe.macro.Access = $hxClasses["haxe.macro.Access"] = { __ename__ : ["haxe","macro","Access"], __constructs__ : ["APublic","APrivate","AStatic","AOverride","ADynamic","AInline"] }
haxe.macro.Access.APublic = ["APublic",0];
haxe.macro.Access.APublic.toString = $estr;
haxe.macro.Access.APublic.__enum__ = haxe.macro.Access;
haxe.macro.Access.APrivate = ["APrivate",1];
haxe.macro.Access.APrivate.toString = $estr;
haxe.macro.Access.APrivate.__enum__ = haxe.macro.Access;
haxe.macro.Access.AStatic = ["AStatic",2];
haxe.macro.Access.AStatic.toString = $estr;
haxe.macro.Access.AStatic.__enum__ = haxe.macro.Access;
haxe.macro.Access.AOverride = ["AOverride",3];
haxe.macro.Access.AOverride.toString = $estr;
haxe.macro.Access.AOverride.__enum__ = haxe.macro.Access;
haxe.macro.Access.ADynamic = ["ADynamic",4];
haxe.macro.Access.ADynamic.toString = $estr;
haxe.macro.Access.ADynamic.__enum__ = haxe.macro.Access;
haxe.macro.Access.AInline = ["AInline",5];
haxe.macro.Access.AInline.toString = $estr;
haxe.macro.Access.AInline.__enum__ = haxe.macro.Access;
haxe.macro.FieldType = $hxClasses["haxe.macro.FieldType"] = { __ename__ : ["haxe","macro","FieldType"], __constructs__ : ["FVar","FFun","FProp"] }
haxe.macro.FieldType.FVar = function(t,e) { var $x = ["FVar",0,t,e]; $x.__enum__ = haxe.macro.FieldType; $x.toString = $estr; return $x; }
haxe.macro.FieldType.FFun = function(f) { var $x = ["FFun",1,f]; $x.__enum__ = haxe.macro.FieldType; $x.toString = $estr; return $x; }
haxe.macro.FieldType.FProp = function(get,set,t,e) { var $x = ["FProp",2,get,set,t,e]; $x.__enum__ = haxe.macro.FieldType; $x.toString = $estr; return $x; }
haxe.macro.TypeDefKind = $hxClasses["haxe.macro.TypeDefKind"] = { __ename__ : ["haxe","macro","TypeDefKind"], __constructs__ : ["TDEnum","TDStructure","TDClass"] }
haxe.macro.TypeDefKind.TDEnum = ["TDEnum",0];
haxe.macro.TypeDefKind.TDEnum.toString = $estr;
haxe.macro.TypeDefKind.TDEnum.__enum__ = haxe.macro.TypeDefKind;
haxe.macro.TypeDefKind.TDStructure = ["TDStructure",1];
haxe.macro.TypeDefKind.TDStructure.toString = $estr;
haxe.macro.TypeDefKind.TDStructure.__enum__ = haxe.macro.TypeDefKind;
haxe.macro.TypeDefKind.TDClass = function(extend,implement,isInterface) { var $x = ["TDClass",2,extend,implement,isInterface]; $x.__enum__ = haxe.macro.TypeDefKind; $x.toString = $estr; return $x; }
haxe.macro.Error = $hxClasses["haxe.macro.Error"] = function(m,p) {
	this.message = m;
	this.pos = p;
};
haxe.macro.Error.__name__ = ["haxe","macro","Error"];
haxe.macro.Error.prototype = {
	message: null
	,pos: null
	,__class__: haxe.macro.Error
}
var hxs = hxs || {}
if(!hxs.core) hxs.core = {}
hxs.core.SignalBase = $hxClasses["hxs.core.SignalBase"] = function(caller) {
	this.slots = new hxs.core.PriorityQueue();
	this.target = caller;
	this.isMuted = false;
	if(!Std["is"](caller,hxs.core.SignalBase)) this.onChanged = new hxs.Signal(this);
};
hxs.core.SignalBase.__name__ = ["hxs","core","SignalBase"];
hxs.core.SignalBase.prototype = {
	slots: null
	,target: null
	,isMuted: null
	,onChanged: null
	,add: function(listener,priority,runCount) {
		if(runCount == null) runCount = -1;
		if(priority == null) priority = 0;
		this.remove(listener);
		this.slots.add(new hxs.core.Slot(listener,hxs.core.SignalType.NORMAL,runCount),priority);
		this.onChanged.dispatch();
	}
	,addOnce: function(listener,priority) {
		if(priority == null) priority = 0;
		this.add(listener,priority,1);
	}
	,addAdvanced: function(listener,priority,runCount) {
		if(runCount == null) runCount = -1;
		if(priority == null) priority = 0;
		this.remove(listener);
		this.slots.add(new hxs.core.Slot(listener,hxs.core.SignalType.ADVANCED,runCount),priority);
	}
	,addVoid: function(listener,priority,runCount) {
		if(runCount == null) runCount = -1;
		if(priority == null) priority = 0;
		this.remove(listener);
		this.slots.add(new hxs.core.Slot(listener,hxs.core.SignalType.VOID,runCount),priority);
	}
	,remove: function(listener) {
		var $it0 = this.slots.iterator();
		while( $it0.hasNext() ) {
			var i = $it0.next();
			if(i.listener == listener) this.slots.remove(i);
		}
	}
	,removeAll: function() {
		this.slots = new hxs.core.PriorityQueue();
	}
	,mute: function() {
		this.isMuted = true;
	}
	,unmute: function() {
		this.isMuted = false;
	}
	,muteSlot: function(listener) {
		var _g = 0, _g1 = this.slots.items;
		while(_g < _g1.length) {
			var i = _g1[_g];
			++_g;
			if(i.item.listener == listener) i.item.mute();
		}
	}
	,unmuteSlot: function(listener) {
		var _g = 0, _g1 = this.slots.items;
		while(_g < _g1.length) {
			var i = _g1[_g];
			++_g;
			if(i.item.listener == listener) i.item.unmute();
		}
	}
	,onFireSlot: function(slot) {
		if(slot.remainingCalls != -1) {
			if(--slot.remainingCalls <= 0) this.remove(slot.listener);
		}
	}
	,__class__: hxs.core.SignalBase
}
hxs.Signal = $hxClasses["hxs.Signal"] = function(caller) {
	hxs.core.SignalBase.call(this,caller);
};
hxs.Signal.__name__ = ["hxs","Signal"];
hxs.Signal.__super__ = hxs.core.SignalBase;
hxs.Signal.prototype = $extend(hxs.core.SignalBase.prototype,{
	dispatch: function() {
		var $it0 = this.slots.iterator();
		while( $it0.hasNext() ) {
			var slot = $it0.next();
			if(this.isMuted) return;
			if(slot.isMuted) continue;
			switch( (slot.type)[1] ) {
			case 0:
				slot.listener();
				break;
			case 1:
				slot.listener(new hxs.core.Info(this,slot));
				break;
			case 2:
				slot.listener();
				break;
			}
			this.onFireSlot(slot);
		}
	}
	,getTrigger: function() {
		var _this = this;
		return new hxs.extras.Trigger(function() {
			_this.dispatch();
		});
	}
	,__class__: hxs.Signal
});
hxs.Signal1 = $hxClasses["hxs.Signal1"] = function(caller) {
	hxs.core.SignalBase.call(this,caller);
};
hxs.Signal1.__name__ = ["hxs","Signal1"];
hxs.Signal1.__super__ = hxs.core.SignalBase;
hxs.Signal1.prototype = $extend(hxs.core.SignalBase.prototype,{
	dispatch: function(a) {
		var $it0 = this.slots.iterator();
		while( $it0.hasNext() ) {
			var slot = $it0.next();
			if(this.isMuted) return;
			if(slot.isMuted) continue;
			switch( (slot.type)[1] ) {
			case 0:
				slot.listener(a);
				break;
			case 1:
				slot.listener(a,new hxs.core.Info(this,slot));
				break;
			case 2:
				slot.listener();
				break;
			}
			this.onFireSlot(slot);
		}
	}
	,getTrigger: function(a) {
		var _this = this;
		return new hxs.extras.Trigger(function() {
			_this.dispatch(a);
		});
	}
	,__class__: hxs.Signal1
});
hxs.Signal4 = $hxClasses["hxs.Signal4"] = function(caller) {
	hxs.core.SignalBase.call(this,caller);
};
hxs.Signal4.__name__ = ["hxs","Signal4"];
hxs.Signal4.__super__ = hxs.core.SignalBase;
hxs.Signal4.prototype = $extend(hxs.core.SignalBase.prototype,{
	dispatch: function(a,b,c,d) {
		var $it0 = this.slots.iterator();
		while( $it0.hasNext() ) {
			var slot = $it0.next();
			if(this.isMuted) return;
			if(slot.isMuted) continue;
			switch( (slot.type)[1] ) {
			case 0:
				slot.listener(a,b,c,d);
				break;
			case 1:
				slot.listener(a,b,c,d,new hxs.core.Info(this,slot));
				break;
			case 2:
				slot.listener();
				break;
			}
			this.onFireSlot(slot);
		}
	}
	,getTrigger: function(a,b,c,d) {
		var _this = this;
		return new hxs.extras.Trigger(function() {
			_this.dispatch(a,b,c,d);
		});
	}
	,__class__: hxs.Signal4
});
hxs.core.Info = $hxClasses["hxs.core.Info"] = function(signal,slot) {
	this.target = signal.target;
	this.signal = signal;
	this.slot = slot;
};
hxs.core.Info.__name__ = ["hxs","core","Info"];
hxs.core.Info.prototype = {
	target: null
	,signal: null
	,slot: null
	,__class__: hxs.core.Info
}
hxs.core.PriorityQueue = $hxClasses["hxs.core.PriorityQueue"] = function() {
	this.items = [];
};
hxs.core.PriorityQueue.__name__ = ["hxs","core","PriorityQueue"];
hxs.core.PriorityQueue.prototype = {
	currentIterator: null
	,items: null
	,length: null
	,iterator: function() {
		return this.currentIterator = new hxs.core.PriorityQueueIterator(this.items);
	}
	,peek: function() {
		return this.items[0].item;
	}
	,front: function() {
		return this.items.shift().item;
	}
	,back: function() {
		return this.items.pop().item;
	}
	,add: function(item,priority) {
		if(priority == null) priority = 0;
		var data = { item : item, priority : priority};
		if(data.priority < 0) data.priority = 0;
		var c = this.items.length;
		while(c-- > 0) if(this.items[c].priority >= priority) break;
		this.items.insert(c + 1,data);
		return data;
	}
	,remove: function(item) {
		var _g = 0, _g1 = this.items;
		while(_g < _g1.length) {
			var i = _g1[_g];
			++_g;
			if(i.item == item) this.items.remove(i);
		}
	}
	,getPriority: function(item) {
		var _g = 0, _g1 = this.items;
		while(_g < _g1.length) {
			var i = _g1[_g];
			++_g;
			if(i.item == item) return i.priority;
		}
		return -1;
	}
	,setPriority: function(item,priority) {
		var _g = 0, _g1 = this.items;
		while(_g < _g1.length) {
			var i = _g1[_g];
			++_g;
			if(i.item == item) i.priority = priority;
		}
		this.resort();
	}
	,getLength: function() {
		return this.items.length;
	}
	,resort: function() {
		var a = this.items.copy();
		this.items = [];
		var _g = 0;
		while(_g < a.length) {
			var i = a[_g];
			++_g;
			this.add(i.item,i.priority);
		}
	}
	,__class__: hxs.core.PriorityQueue
	,__properties__: {get_length:"getLength"}
}
hxs.core.PriorityQueueIterator = $hxClasses["hxs.core.PriorityQueueIterator"] = function(q) {
	this.q = q.copy();
	this.reset();
};
hxs.core.PriorityQueueIterator.__name__ = ["hxs","core","PriorityQueueIterator"];
hxs.core.PriorityQueueIterator.prototype = {
	q: null
	,i: null
	,reset: function() {
		this.i = 0;
	}
	,hasNext: function() {
		return this.i < this.q.length;
	}
	,next: function() {
		return this.q[this.i++].item;
	}
	,__class__: hxs.core.PriorityQueueIterator
}
hxs.core.SignalType = $hxClasses["hxs.core.SignalType"] = { __ename__ : ["hxs","core","SignalType"], __constructs__ : ["NORMAL","ADVANCED","VOID"] }
hxs.core.SignalType.NORMAL = ["NORMAL",0];
hxs.core.SignalType.NORMAL.toString = $estr;
hxs.core.SignalType.NORMAL.__enum__ = hxs.core.SignalType;
hxs.core.SignalType.ADVANCED = ["ADVANCED",1];
hxs.core.SignalType.ADVANCED.toString = $estr;
hxs.core.SignalType.ADVANCED.__enum__ = hxs.core.SignalType;
hxs.core.SignalType.VOID = ["VOID",2];
hxs.core.SignalType.VOID.toString = $estr;
hxs.core.SignalType.VOID.__enum__ = hxs.core.SignalType;
hxs.core.Slot = $hxClasses["hxs.core.Slot"] = function(listener,type,remainingCalls) {
	this.listener = listener;
	this.type = type;
	this.remainingCalls = remainingCalls;
	this.isMuted = false;
};
hxs.core.Slot.__name__ = ["hxs","core","Slot"];
hxs.core.Slot.prototype = {
	listener: null
	,type: null
	,remainingCalls: null
	,isMuted: null
	,mute: function() {
		this.isMuted = true;
	}
	,unmute: function() {
		this.isMuted = false;
	}
	,__class__: hxs.core.Slot
}
if(!hxs.extras) hxs.extras = {}
hxs.extras.Trigger = $hxClasses["hxs.extras.Trigger"] = function(closure) {
	this.closure = closure;
};
hxs.extras.Trigger.__name__ = ["hxs","extras","Trigger"];
hxs.extras.Trigger.prototype = {
	closure: null
	,dispatch: function() {
		this.closure();
	}
	,__class__: hxs.extras.Trigger
}
var javascriptOutils = javascriptOutils || {}
javascriptOutils.Layout = $hxClasses["javascriptOutils.Layout"] = function() {
};
javascriptOutils.Layout.__name__ = ["javascriptOutils","Layout"];
javascriptOutils.Layout.getWindow = function() {
	return $(window);
}
javascriptOutils.Layout.getDoc = function() {
	return $(document);
}
javascriptOutils.Layout.scrollPercentage = function(viewableAreaHeight) {
	var viewable_area = javascriptOutils.Layout.getWindow().height();
	var total_height;
	var scroll_top = javascriptOutils.Layout.getWindow().scrollTop();
	if(viewableAreaHeight != null) total_height = viewableAreaHeight; else total_height = javascriptOutils.Layout.getDoc().height();
	var scroll_percent = scroll_top / (total_height - viewable_area);
	return scroll_percent;
}
javascriptOutils.Layout.prototype = {
	__class__: javascriptOutils.Layout
}
var js = js || {}
js.Boot = $hxClasses["js.Boot"] = function() { }
js.Boot.__name__ = ["js","Boot"];
js.Boot.__unhtml = function(s) {
	return s.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
}
js.Boot.__trace = function(v,i) {
	var msg = i != null?i.fileName + ":" + i.lineNumber + ": ":"";
	msg += js.Boot.__string_rec(v,"");
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML += js.Boot.__unhtml(msg) + "<br/>"; else if(typeof(console) != "undefined" && console.log != null) console.log(msg);
}
js.Boot.__clear_trace = function() {
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML = "";
}
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ != null || o.__ename__ != null)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__ != null) {
				if(o.length == 2) return o[0];
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2, _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) str += "," + js.Boot.__string_rec(o[i],s); else str += js.Boot.__string_rec(o[i],s);
				}
				return str + ")";
			}
			var l = o.length;
			var i;
			var str = "[";
			s += "\t";
			var _g = 0;
			while(_g < l) {
				var i1 = _g++;
				str += (i1 > 0?",":"") + js.Boot.__string_rec(o[i1],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString) {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) { ;
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js.Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
}
js.Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0, _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js.Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js.Boot.__interfLoop(cc.__super__,cl);
}
js.Boot.__instanceof = function(o,cl) {
	try {
		if(o instanceof cl) {
			if(cl == Array) return o.__enum__ == null;
			return true;
		}
		if(js.Boot.__interfLoop(o.__class__,cl)) return true;
	} catch( e ) {
		if(cl == null) return false;
	}
	switch(cl) {
	case Int:
		return Math.ceil(o%2147483648.0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return o === true || o === false;
	case String:
		return typeof(o) == "string";
	case Dynamic:
		return true;
	default:
		if(o == null) return false;
		return o.__enum__ == cl || cl == Class && o.__name__ != null || cl == Enum && o.__ename__ != null;
	}
}
js.Boot.__init = function() {
	js.Lib.isIE = typeof document!='undefined' && document.all != null && typeof window!='undefined' && window.opera == null;
	js.Lib.isOpera = typeof window!='undefined' && window.opera != null;
	Array.prototype.copy = Array.prototype.slice;
	Array.prototype.insert = function(i,x) {
		this.splice(i,0,x);
	};
	Array.prototype.remove = Array.prototype.indexOf?function(obj) {
		var idx = this.indexOf(obj);
		if(idx == -1) return false;
		this.splice(idx,1);
		return true;
	}:function(obj) {
		var i = 0;
		var l = this.length;
		while(i < l) {
			if(this[i] == obj) {
				this.splice(i,1);
				return true;
			}
			i++;
		}
		return false;
	};
	Array.prototype.iterator = function() {
		return { cur : 0, arr : this, hasNext : function() {
			return this.cur < this.arr.length;
		}, next : function() {
			return this.arr[this.cur++];
		}};
	};
	if(String.prototype.cca == null) String.prototype.cca = String.prototype.charCodeAt;
	String.prototype.charCodeAt = function(i) {
		var x = this.cca(i);
		if(x != x) return undefined;
		return x;
	};
	var oldsub = String.prototype.substr;
	String.prototype.substr = function(pos,len) {
		if(pos != null && pos != 0 && len != null && len < 0) return "";
		if(len == null) len = this.length;
		if(pos < 0) {
			pos = this.length + pos;
			if(pos < 0) pos = 0;
		} else if(len < 0) len = this.length + len - pos;
		return oldsub.apply(this,[pos,len]);
	};
	Function.prototype["$bind"] = function(o) {
		var f = function() {
			return f.method.apply(f.scope,arguments);
		};
		f.scope = o;
		f.method = this;
		return f;
	};
}
js.Boot.prototype = {
	__class__: js.Boot
}
js.Lib = $hxClasses["js.Lib"] = function() { }
js.Lib.__name__ = ["js","Lib"];
js.Lib.isIE = null;
js.Lib.isOpera = null;
js.Lib.document = null;
js.Lib.window = null;
js.Lib.alert = function(v) {
	alert(js.Boot.__string_rec(v,""));
}
js.Lib.eval = function(code) {
	return eval(code);
}
js.Lib.setErrorHandler = function(f) {
	js.Lib.onerror = f;
}
js.Lib.prototype = {
	__class__: js.Lib
}
var microbe = microbe || {}
microbe.ClassMap = $hxClasses["microbe.ClassMap"] = function() {
};
microbe.ClassMap.__name__ = ["microbe","ClassMap"];
microbe.ClassMap.prototype = {
	id: null
	,voClass: null
	,fields: null
	,submit: null
	,action: null
	,toString: function() {
		return this.fields.toString();
	}
	,__class__: microbe.ClassMap
}
microbe.ClassMapUtils = $hxClasses["microbe.ClassMapUtils"] = function(_map) {
	this.map = _map;
	this.mapFields = new microbe.form.MicroFieldList();
	this.mapFields = this.map.fields;
};
microbe.ClassMapUtils.__name__ = ["microbe","ClassMapUtils"];
microbe.ClassMapUtils.prototype = {
	currentCollec: null
	,map: null
	,mapFields: null
	,currentVoName: null
	,temp: null
	,removeInCurrent: function(list) {
		this.currentCollec.remove(list);
	}
	,searchinCollecByPos: function(pos) {
		return this.currentCollec.filter(function(item) {
			js.Lib.alert("item=" + item);
			if(item.pos == pos) {
				js.Lib.alert("Trouvé" + pos);
				return true;
			}
			return false;
		}).first();
	}
	,searchinCollecById: function(collectItemid) {
		return this.currentCollec.filter(function(item) {
			js.Lib.alert("item=" + item);
			if(item.id == collectItemid) {
				js.Lib.alert("Trouvé" + item.id);
				return true;
			}
			return false;
		}).first();
	}
	,addInCollec: function(item) {
		this.currentCollec.add(item);
	}
	,addinCollecAt: function(item,pos) {
		var tab = Lambda.array(this.currentCollec.fields);
		tab.insert(pos,item);
		this.currentCollec.fields = Lambda.list(tab);
	}
	,searchCollec: function(voName) {
		this.temp = new List();
		this.currentVoName = voName;
		var result = this.mapFields.filter(this.searchCollecAlgo.$bind(this));
		this.currentCollec = result.first();
		return this.currentCollec;
	}
	,parseCollec: function(collec) {
		haxe.Log.trace("<br/>collec=" + collec.getLength(),{ fileName : "ClassMapUtils.hx", lineNumber : 75, className : "microbe.ClassMapUtils", methodName : "parseCollec"});
		haxe.Log.trace("<br/>new Collec=" + collec,{ fileName : "ClassMapUtils.hx", lineNumber : 77, className : "microbe.ClassMapUtils", methodName : "parseCollec"});
	}
	,searchCollecAlgo: function(item) {
		if(item.type == microbe.form.InstanceType.collection && item.voName == this.currentVoName) {
			this.temp.add(item);
			return true;
		} else {
			if(Std["is"](item,microbe.form.MicroFieldList)) item.filter(this.searchCollecAlgo.$bind(this));
			return false;
		}
	}
	,__class__: microbe.ClassMapUtils
}
microbe.TagManager = $hxClasses["microbe.TagManager"] = function() {
};
microbe.TagManager.__name__ = ["microbe","TagManager"];
microbe.TagManager.getTags = function(spod,spodId) {
	microbe.tools.Debug.Alerte(Std.string(spodId),{ fileName : "TagManager.hx", lineNumber : 79, className : "microbe.TagManager", methodName : "getTags"});
	microbe.tools.Debug.Alerte(microbe.jsTools.BackJS.base_url,{ fileName : "TagManager.hx", lineNumber : 80, className : "microbe.TagManager", methodName : "getTags"});
	var Xreponse = null;
	Xreponse = haxe.Http.requestUrl(microbe.jsTools.BackJS.base_url + "/index.php/gap/tags/spod/" + spod + "/id/" + spodId);
	var reponse = haxe.Unserializer.run(Xreponse);
	microbe.tools.Debug.Alerte(Std.string(reponse),{ fileName : "TagManager.hx", lineNumber : 86, className : "microbe.TagManager", methodName : "getTags"});
	return reponse;
}
microbe.TagManager.addTag = function(spod,spodID,tag) {
	var reponse = haxe.Http.requestUrl(microbe.jsTools.BackJS.base_url + "/index.php/gap/recTag/" + StringTools.urlEncode(tag) + "/" + spod + "/" + spodID);
	return "reponse=" + reponse;
}
microbe.TagManager.getTagsById = function(spod,spodId) {
	return new List();
}
microbe.TagManager.removeTagFromSpod = function(spod,spodID,tag) {
	var reponse = haxe.Http.requestUrl(microbe.jsTools.BackJS.base_url + "/index.php/gap/dissociateTag/" + StringTools.urlEncode(tag) + "/" + spod + "/" + spodID);
	return "reponse=" + reponse;
}
microbe.TagManager.recTag = function(s) {
	return s;
}
microbe.TagManager.recTags = function(listTag) {
}
microbe.TagManager.getSpodName = function(spod) {
	return Type.getClassName(spod).split(".").slice(-1).toString();
}
microbe.TagManager.prototype = {
	__class__: microbe.TagManager
}
microbe.Tag = $hxClasses["microbe.Tag"] = function() {
};
microbe.Tag.__name__ = ["microbe","Tag"];
microbe.Tag.prototype = {
	tag: null
	,id: null
	,__class__: microbe.Tag
}
if(!microbe.form) microbe.form = {}
microbe.form.AjaxElement = $hxClasses["microbe.form.AjaxElement"] = function(_microfield,_iter) {
	microbe.tools.Debug.Alerte("new",{ fileName : "AjaxElement.hx", lineNumber : 23, className : "microbe.form.AjaxElement", methodName : "new"});
	if(Std["is"](_microfield,microbe.form.Microfield)) {
		this.microfield = _microfield;
		this.id = _microfield.elementId;
		this.field = _microfield.field;
		this.element = _microfield.element;
		this.value = _microfield.value;
	}
	if(Std["is"](_microfield,microbe.form.MicroFieldList)) {
		this.microfieldliste = _microfield;
		this.id = _microfield.elementId;
		this.field = _microfield.field;
		this.element = _microfield.element;
		this.value = _microfield.value;
		this.voName = _microfield.voName;
		this.spodId = _microfield.id;
	}
	if(_iter != null) this.pos = _iter;
	this.setValue(this.value);
};
microbe.form.AjaxElement.__name__ = ["microbe","form","AjaxElement"];
microbe.form.AjaxElement.prototype = {
	id: null
	,microfield: null
	,microfieldliste: null
	,field: null
	,element: null
	,value: null
	,pos: null
	,voName: null
	,spodId: null
	,focus: function() {
		new js.JQuery("#" + this.id).addClass("borded");
	}
	,getForm: function() {
		var p = new js.JQuery("#" + this.id).parents("form");
		return p.attr("id");
	}
	,output: function() {
		return "yop";
	}
	,getValue: function() {
		return "null";
	}
	,setValue: function(val) {
	}
	,__class__: microbe.form.AjaxElement
}
microbe.form.Form = $hxClasses["microbe.form.Form"] = function(name,action,method) {
	this.requiredClass = "formRequired";
	this.requiredErrorClass = "formRequiredError";
	this.invalidErrorClass = "formInvalidError";
	this.labelRequiredIndicator = " *";
	this.forcePopulate = false;
	this.id = this.name = name;
	this.action = action;
	this.method = method == null?microbe.form.FormMethod.POST:method;
	this.elements = new List();
	this.extraErrors = new List();
	this.fieldsets = new Hash();
	this.addFieldset("__default",new microbe.form.FieldSet("__default","Default",false));
	this.wymEditorCount = 0;
	this.submittedButtonName = null;
};
microbe.form.Form.__name__ = ["microbe","form","Form"];
microbe.form.Form.prototype = {
	id: null
	,name: null
	,action: null
	,method: null
	,elements: null
	,fieldsets: null
	,forcePopulate: null
	,submitButton: null
	,deleteButton: null
	,extraErrors: null
	,requiredClass: null
	,requiredErrorClass: null
	,invalidErrorClass: null
	,labelRequiredIndicator: null
	,defaultClass: null
	,submittedButtonName: null
	,wymEditorCount: null
	,addElement: function(element,fieldSetKey) {
		if(fieldSetKey == null) fieldSetKey = "__default";
		element.form = this;
		this.elements.add(element);
		if(fieldSetKey != null && this.fieldsets.exists(fieldSetKey)) this.fieldsets.get(fieldSetKey).elements.add(element);
		if(Std["is"](element,microbe.form.elements.RichtextWym)) this.wymEditorCount++;
		return element;
	}
	,removeElement: function(element) {
		if(this.elements.remove(element)) {
			element.form = null;
			var $it0 = this.fieldsets.iterator();
			while( $it0.hasNext() ) {
				var fs = $it0.next();
				fs.elements.remove(element);
			}
			return true;
		}
		return false;
	}
	,setSubmitButton: function(el) {
		return this.submitButton = el;
	}
	,setDeleteButton: function(el) {
		return this.deleteButton = el;
	}
	,addFieldset: function(fieldSetKey,fieldSet) {
		fieldSet.form = this;
		this.fieldsets.set(fieldSetKey,fieldSet);
	}
	,getFieldsets: function() {
		return this.fieldsets;
	}
	,getLabel: function(elementName) {
		return this.getElement(elementName).getLabel();
	}
	,getElement: function(name) {
		var $it0 = this.elements.iterator();
		while( $it0.hasNext() ) {
			var element = $it0.next();
			if(element.name == name) return element;
		}
		throw "Cannot access Form Element: '" + name + "'";
		return null;
	}
	,getValueOf: function(elementName) {
		return this.getElement(elementName).value;
	}
	,getElementTyped: function(name,type) {
		var o = this.getElement(name);
		return o;
	}
	,getData: function() {
		var data = { };
		var $it0 = this.getElements().iterator();
		while( $it0.hasNext() ) {
			var element = $it0.next();
			data[element.name] = element.value;
		}
		return data;
	}
	,populateElements: function() {
		var element;
		var $it0 = this.getElements().iterator();
		while( $it0.hasNext() ) {
			var element1 = $it0.next();
			element1.populate();
		}
	}
	,clearData: function() {
		var element;
		var $it0 = this.getElements().iterator();
		while( $it0.hasNext() ) {
			var element1 = $it0.next();
			element1.value = null;
		}
	}
	,getOpenTag: function() {
		return "<form id=\"" + this.id + "\" name=\"" + this.name + "\" method=\"" + this.method + "\" action=\"" + this.action + "\" enctype=\"multipart/form-data\" >";
	}
	,getCloseTag: function() {
		var s = new StringBuf();
		s.add("<input type=\"hidden\" name=\"" + this.name + "_formSubmitted\" value=\"true\" /></form>");
		return s.b.join("");
	}
	,isValid: function() {
		var valid = true;
		var $it0 = this.getElements().iterator();
		while( $it0.hasNext() ) {
			var element = $it0.next();
			if(!element.isValid()) valid = false;
		}
		if(this.extraErrors.length > 0) valid = false;
		return valid;
	}
	,addError: function(error) {
		this.extraErrors.add(error);
	}
	,getErrorsList: function() {
		this.isValid();
		var errors = new List();
		var $it0 = this.extraErrors.iterator();
		while( $it0.hasNext() ) {
			var e = $it0.next();
			errors.add(e);
		}
		var $it1 = this.getElements().iterator();
		while( $it1.hasNext() ) {
			var element = $it1.next();
			var $it2 = element.getErrors().iterator();
			while( $it2.hasNext() ) {
				var error = $it2.next();
				errors.add(error);
			}
		}
		return errors;
	}
	,getElements: function() {
		return this.elements;
	}
	,isSubmitted: function() {
		return false;
	}
	,getSubmittedValue: function() {
		return "";
	}
	,getErrors: function() {
		if(!this.isSubmitted()) return "";
		var s = new StringBuf();
		var errors = this.getErrorsList();
		if(errors.length > 0) {
			s.b[s.b.length] = "<ul class=\"formErrors\" >";
			var $it0 = errors.iterator();
			while( $it0.hasNext() ) {
				var error = $it0.next();
				s.add("<li>" + error + "</li>");
			}
			s.b[s.b.length] = "</ul>";
		}
		return s.b.join("");
	}
	,getPreview: function() {
		var s = new StringBuf();
		s.add(this.getOpenTag());
		if(this.isSubmitted()) s.add(this.getErrors());
		s.b[s.b.length] = "<ul>\n";
		var $it0 = this.getElements().iterator();
		while( $it0.hasNext() ) {
			var element = $it0.next();
			if(element != this.submitButton || element != this.deleteButton) s.add("\t" + element.getPreview() + "\n");
		}
		if(this.submitButton != null) {
			this.submitButton.form = this;
			s.add(this.submitButton.getPreview());
		}
		if(this.deleteButton != null) {
			this.deleteButton.form = this;
			s.add(this.deleteButton.render());
		}
		s.b[s.b.length] = "</ul>\n";
		s.add(this.getCloseTag());
		return s.b.join("");
	}
	,toString: function() {
		return this.getPreview();
	}
	,__class__: microbe.form.Form
}
microbe.form.FieldSet = $hxClasses["microbe.form.FieldSet"] = function(name,label,visible) {
	if(visible == null) visible = true;
	if(label == null) label = "";
	if(name == null) name = "";
	this.name = name;
	this.label = label;
	this.visible = visible;
	this.elements = new List();
};
microbe.form.FieldSet.__name__ = ["microbe","form","FieldSet"];
microbe.form.FieldSet.prototype = {
	name: null
	,form: null
	,label: null
	,visible: null
	,elements: null
	,getOpenTag: function() {
		return "<fieldset id=\"" + this.form.name + "_" + this.name + "\" name=\"" + this.form.name + "_" + this.name + "\" class=\"" + (this.visible?"":"fieldsetNoDisplay") + "\" ><legend>" + this.label + "</legend>";
	}
	,getCloseTag: function() {
		return "</fieldset>";
	}
	,__class__: microbe.form.FieldSet
}
microbe.form.FormMethod = $hxClasses["microbe.form.FormMethod"] = { __ename__ : ["microbe","form","FormMethod"], __constructs__ : ["GET","POST"] }
microbe.form.FormMethod.GET = ["GET",0];
microbe.form.FormMethod.GET.toString = $estr;
microbe.form.FormMethod.GET.__enum__ = microbe.form.FormMethod;
microbe.form.FormMethod.POST = ["POST",1];
microbe.form.FormMethod.POST.toString = $estr;
microbe.form.FormMethod.POST.__enum__ = microbe.form.FormMethod;
microbe.form.FormElement = $hxClasses["microbe.form.FormElement"] = function() {
	this.active = true;
	this.errors = new List();
	this.validators = new List();
	this.inited = false;
};
microbe.form.FormElement.__name__ = ["microbe","form","FormElement"];
microbe.form.FormElement.prototype = {
	form: null
	,name: null
	,label: null
	,description: null
	,value: null
	,required: null
	,errors: null
	,attributes: null
	,active: null
	,validators: null
	,cssClass: null
	,inited: null
	,isValid: function() {
		this.errors.clear();
		if(this.active == false) return true;
		if(this.value == "" && this.required) {
			this.errors.add("<span class=\"formErrorsField\">" + (this.label != null && this.label != ""?this.label:this.name) + "</span> required.");
			return false;
		} else if(this.value != "") {
			if(!this.validators.isEmpty()) {
				var pass = true;
				var $it0 = this.validators.iterator();
				while( $it0.hasNext() ) {
					var validator = $it0.next();
					if(!validator.isValid(this.value)) pass = false;
				}
				if(!pass) return false;
			}
			return true;
		}
		return true;
	}
	,checkValid: function() {
		this.value == "";
	}
	,init: function() {
		this.inited = true;
	}
	,addValidator: function(validator) {
		this.validators.add(validator);
	}
	,bindEvent: function(event,method,params,isMethodGlobal) {
		if(isMethodGlobal == null) isMethodGlobal = false;
	}
	,populate: function() {
	}
	,getErrors: function() {
		this.isValid();
		var $it0 = this.validators.iterator();
		while( $it0.hasNext() ) {
			var val = $it0.next();
			var $it1 = val.errors.iterator();
			while( $it1.hasNext() ) {
				var err = $it1.next();
				this.errors.add("<span class=\"formErrorsField\">" + this.label + "</span> : " + err);
			}
		}
		return this.errors;
	}
	,render: function(iter) {
		if(!this.inited) this.init();
		return this.value;
	}
	,remove: function() {
		if(this.form != null) return this.form.removeElement(this);
		return false;
	}
	,getPreview: function() {
		return "<li><span>" + this.getLabel() + "</span><div>" + this.render() + "</div></li>";
	}
	,getType: function() {
		return Std.string(Type.getClass(this));
	}
	,getLabelClasses: function() {
		var css = "";
		var requiredSet = false;
		if(this.required) {
			css = this.form.requiredClass;
			if(this.form.isSubmitted() && this.required && this.value == "") {
				css = this.form.requiredErrorClass;
				requiredSet = true;
			}
		}
		if(!requiredSet && this.form.isSubmitted() && !this.isValid()) css = this.form.invalidErrorClass;
		if(this.cssClass != null) css += css == ""?this.cssClass:" " + this.cssClass;
		return css;
	}
	,getLabel: function() {
		var n = this.form.name + "_" + this.name;
		return "<label for=\"" + n + "\" class=\"" + this.getLabelClasses() + "\" id=\"" + n + "Label\">" + this.label + (this.required?this.form.labelRequiredIndicator:null) + "</label>";
	}
	,getClasses: function() {
		var css = this.cssClass != null?this.cssClass:this.form.defaultClass;
		if(this.required && this.form.isSubmitted()) {
			if(this.value == "") css += " " + this.form.requiredErrorClass;
			if(!this.isValid()) css += " " + this.form.invalidErrorClass;
		}
		return StringTools.trim(css);
	}
	,test: function() {
		this.init();
		return "popoop" + this.form.name;
	}
	,safeString: function(s) {
		return s == null?"":StringTools.htmlEscape(Std.string(s)).split("\"").join("&quot;");
	}
	,__class__: microbe.form.FormElement
}
microbe.form.Formatter = $hxClasses["microbe.form.Formatter"] = function() { }
microbe.form.Formatter.__name__ = ["microbe","form","Formatter"];
microbe.form.Formatter.prototype = {
	format: null
	,__class__: microbe.form.Formatter
}
microbe.form.InstanceType = $hxClasses["microbe.form.InstanceType"] = { __ename__ : ["microbe","form","InstanceType"], __constructs__ : ["formElement","collection","spodable"] }
microbe.form.InstanceType.formElement = ["formElement",0];
microbe.form.InstanceType.formElement.toString = $estr;
microbe.form.InstanceType.formElement.__enum__ = microbe.form.InstanceType;
microbe.form.InstanceType.collection = ["collection",1];
microbe.form.InstanceType.collection.toString = $estr;
microbe.form.InstanceType.collection.__enum__ = microbe.form.InstanceType;
microbe.form.InstanceType.spodable = ["spodable",2];
microbe.form.InstanceType.spodable.toString = $estr;
microbe.form.InstanceType.spodable.__enum__ = microbe.form.InstanceType;
microbe.form.IMicrotype = $hxClasses["microbe.form.IMicrotype"] = function() { }
microbe.form.IMicrotype.__name__ = ["microbe","form","IMicrotype"];
microbe.form.IMicrotype.prototype = {
	voName: null
	,field: null
	,value: null
	,type: null
	,toString: null
	,__class__: microbe.form.IMicrotype
}
microbe.form.MicroFieldList = $hxClasses["microbe.form.MicroFieldList"] = function() {
	this.fields = new List();
};
microbe.form.MicroFieldList.__name__ = ["microbe","form","MicroFieldList"];
microbe.form.MicroFieldList.__interfaces__ = [microbe.form.IMicrotype];
microbe.form.MicroFieldList.prototype = {
	field: null
	,voName: null
	,value: null
	,id: null
	,elementId: null
	,type: null
	,fields: null
	,indent: null
	,length: null
	,pos: null
	,taggable: null
	,getLength: function() {
		return this.fields.length;
	}
	,add: function(item) {
		this.fields.add(item);
		return item;
	}
	,iterator: function() {
		return this.fields.iterator();
	}
	,first: function() {
		return this.fields.first();
	}
	,last: function() {
		return this.fields.last();
	}
	,next: function() {
		return this.fields.iterator().next();
	}
	,remove: function(v) {
		return this.fields.remove(v);
	}
	,filter: function(f) {
		return this.fields.filter(f);
	}
	,map: function(f) {
		return this.fields.map(f);
	}
	,toString: function() {
		this.indent++;
		return "MICROFIELDLIST: " + this.voName + ", TYPE:" + this.type + ", FIELD:" + this.field + "  ID:" + this.id + ",ElementId:" + this.elementId + " pos=" + this.pos + " VALUE:" + this.value + "\n" + this.fields.toString() + "\n";
		return "";
	}
	,__class__: microbe.form.MicroFieldList
	,__properties__: {get_length:"getLength"}
}
microbe.form.Microfield = $hxClasses["microbe.form.Microfield"] = function() {
};
microbe.form.Microfield.__name__ = ["microbe","form","Microfield"];
microbe.form.Microfield.__interfaces__ = [microbe.form.IMicrotype];
microbe.form.Microfield.prototype = {
	voName: null
	,field: null
	,element: null
	,elementId: null
	,value: null
	,type: null
	,toString: function() {
		return "\nMICROFIELD :type:" + this.type + "\nfield:" + this.field + ",\nvoName:" + this.voName + ",\nelement:" + this.element + ", \nelementId:" + this.elementId + "\nvalue:" + this.value + "\n";
		return "";
	}
	,__class__: microbe.form.Microfield
}
microbe.form.Validator = $hxClasses["microbe.form.Validator"] = function() {
	this.errors = new List();
};
microbe.form.Validator.__name__ = ["microbe","form","Validator"];
microbe.form.Validator.prototype = {
	errors: null
	,isValid: function(value) {
		this.errors.clear();
		return true;
	}
	,reset: function() {
		this.errors.clear();
	}
	,__class__: microbe.form.Validator
}
if(!microbe.form.elements) microbe.form.elements = {}
microbe.form.elements.AjaxArea = $hxClasses["microbe.form.elements.AjaxArea"] = function(_microfield) {
	microbe.form.AjaxElement.call(this,_microfield);
};
microbe.form.elements.AjaxArea.__name__ = ["microbe","form","elements","AjaxArea"];
microbe.form.elements.AjaxArea.__super__ = microbe.form.AjaxElement;
microbe.form.elements.AjaxArea.prototype = $extend(microbe.form.AjaxElement.prototype,{
	moduleid: null
	,getValue: function() {
		var val = new js.JQuery("#" + this.id).val();
		microbe.tools.Debug.Alerte(val,{ fileName : "AjaxArea.hx", lineNumber : 75, className : "microbe.form.elements.AjaxArea", methodName : "getValue"});
		return val;
	}
	,setValue: function(val) {
		microbe.tools.Debug.Alerte(val,{ fileName : "AjaxArea.hx", lineNumber : 79, className : "microbe.form.elements.AjaxArea", methodName : "setValue"});
		new js.JQuery("#" + this.id).val(val);
	}
	,__class__: microbe.form.elements.AjaxArea
});
microbe.form.elements.AjaxDate = $hxClasses["microbe.form.elements.AjaxDate"] = function(_microfield,_iter) {
	this.id = _microfield.elementId;
	this.pos = Std.parseInt(this.getCollectionContainer());
	microbe.form.AjaxElement.call(this,_microfield,_iter);
};
microbe.form.elements.AjaxDate.__name__ = ["microbe","form","elements","AjaxDate"];
microbe.form.elements.AjaxDate.__super__ = microbe.form.AjaxElement;
microbe.form.elements.AjaxDate.prototype = $extend(microbe.form.AjaxElement.prototype,{
	getCollectionContainer: function() {
		var p = new js.JQuery("#" + this.id).parents(".collection");
		if(p.attr("pos") != null) return p.attr("pos");
		return "0";
	}
	,getValue: function() {
		var valeur = new js.JQuery("#madate_" + this.pos).val();
		return valeur;
	}
	,setValue: function(val) {
		if(val == null) val = Date.now().toString();
		var valeur = new js.JQuery("#madate_" + this.pos).val(val);
	}
	,__class__: microbe.form.elements.AjaxDate
});
microbe.form.elements.AjaxEditor = $hxClasses["microbe.form.elements.AjaxEditor"] = function(_microfield,iter) {
	microbe.form.AjaxElement.call(this,_microfield);
	this.pos = iter;
	microbe.form.elements.AjaxEditor.self = this;
	this.ed = "editor";
	this.value = "carrotte";
	this.base_url = js.Lib.window.location.protocol + "//" + js.Lib.window.location.host;
	var wymOptions = { };
	wymOptions.skin = "compact";
	wymOptions.html = "hello la compagnie";
	this.wym = new $(".editor:visible");
	this.wym.wymeditor(wymOptions);
};
microbe.form.elements.AjaxEditor.__name__ = ["microbe","form","elements","AjaxEditor"];
microbe.form.elements.AjaxEditor.self = null;
microbe.form.elements.AjaxEditor.__super__ = microbe.form.AjaxElement;
microbe.form.elements.AjaxEditor.prototype = $extend(microbe.form.AjaxElement.prototype,{
	formDefaultAction: null
	,base_url: null
	,ed: null
	,wym: null
	,transformed: null
	,getValue: function() {
		js.JQuery.wymeditors(0).update();
		return new js.JQuery("#" + this.id).attr("value");
	}
	,output: function() {
		return "yeah from js";
	}
	,setValue: function(val) {
		new js.JQuery("#" + this.id).attr("value",this.value);
	}
	,__class__: microbe.form.elements.AjaxEditor
});
microbe.form.elements.AjaxInput = $hxClasses["microbe.form.elements.AjaxInput"] = function(_microfield) {
	microbe.form.AjaxElement.call(this,_microfield);
};
microbe.form.elements.AjaxInput.__name__ = ["microbe","form","elements","AjaxInput"];
microbe.form.elements.AjaxInput.__super__ = microbe.form.AjaxElement;
microbe.form.elements.AjaxInput.prototype = $extend(microbe.form.AjaxElement.prototype,{
	moduleid: null
	,getValue: function() {
		return new js.JQuery("#" + this.id).attr("value");
	}
	,setValue: function(val) {
		new js.JQuery("#" + this.id).attr("value",val);
	}
	,__class__: microbe.form.elements.AjaxInput
});
microbe.form.elements.AjaxUploader = $hxClasses["microbe.form.elements.AjaxUploader"] = function(_microfield,_iter) {
	this.setComposant("AjaxUploader");
	microbe.form.AjaxElement.call(this,_microfield,_iter);
	this.self = this;
	this.base_url = js.Lib.window.location.protocol + "//" + js.Lib.window.location.host;
	this.makeIframeUniq();
	this.getBouton().click(this.testUpload.$bind(this));
};
microbe.form.elements.AjaxUploader.__name__ = ["microbe","form","elements","AjaxUploader"];
microbe.form.elements.AjaxUploader.__super__ = microbe.form.AjaxElement;
microbe.form.elements.AjaxUploader.prototype = $extend(microbe.form.AjaxElement.prototype,{
	self: null
	,formDefaultAction: null
	,base_url: null
	,uploadtarget: null
	,_composantName: null
	,uniqIframe: null
	,composantName: null
	,init: function(e) {
		this.getCollectionContainer();
	}
	,getComposant: function() {
		return this._composantName;
	}
	,setComposant: function(val) {
		this._composantName = val;
		return this._composantName;
	}
	,testUpload: function(e) {
		this.DisableForm();
		this.formDefaultAction = new js.JQuery("#" + this.getForm()).attr("target");
		new js.JQuery("#" + this.getForm()).attr("target",this.getIframe());
		js.Lib.alert(new js.JQuery("#" + this.getForm()).attr("target"));
		new js.JQuery("#" + this.id + " #" + this.getIframe()).load(this.onLoad.$bind(this));
		new js.JQuery("#" + this.getForm()).attr("action","/index.php/upload");
		new js.JQuery("#" + this.getForm()).submit();
	}
	,onLoad: function(e) {
		var p = new js.JQuery("#" + this.id + " #" + this.getIframe()).contents().text();
		this.setValue(p);
		this.getpreview().fadeTo(0,0);
		this.getpreview().fadeTo(600,1);
		new js.JQuery("#" + this.getForm()).attr("target",this.formDefaultAction);
		this.enableForm();
	}
	,getBouton: function() {
		return new js.JQuery("#" + this.id + " #uploadButton");
	}
	,getRetour: function() {
		var retour = new js.JQuery("#" + this.id + " #" + this.getComposant() + "retour" + this.getCollectionContainer());
		return retour;
	}
	,getInputName: function() {
		var inputName = new js.JQuery("#" + this.id + " #" + this.getComposant() + "fileinput").attr("name");
		return inputName;
	}
	,getpreview: function() {
		return new js.JQuery("#" + this.id + " #" + this.getComposant() + "preview" + this.getCollectionContainer());
	}
	,getCollectionContainer: function() {
		var p = new js.JQuery("#" + this.id).parents(".collection");
		if(p.attr("pos") != null) return p.attr("pos");
		return "";
	}
	,makeIframeUniq: function() {
		var ifr = new js.JQuery("#" + this.id + " #" + this.getComposant() + "upload_target" + this.getCollectionContainer());
		var oldid = ifr.attr("id");
		ifr.attr("id",oldid + (Math.random() * 2000 | 0));
		this.uniqIframe = ifr.attr("id");
		ifr[0].contentWindow.name = this.uniqIframe;
		js.Lib.alert("uniq=" + this.uniqIframe);
	}
	,getIframe: function() {
		return this.uniqIframe;
	}
	,DisableForm: function() {
		new js.JQuery("#" + this.getForm() + " input[name!='" + this.getInputName() + "']").attr("disabled","disabled");
	}
	,enableForm: function() {
		new js.JQuery("input").attr("disabled","");
	}
	,getValue: function() {
		var retour = this.getRetour().attr("value");
		return retour;
	}
	,setValue: function(val) {
		if(val != null) this.getpreview().attr("src",js.Lib.window.location.protocol + "//" + js.Lib.window.location.host + "/index.php/imageBase/resize/thumb/" + val); else this.getpreview().attr("src","/microbe/css/assets/blankframe.png");
		this.getRetour().attr("value",val);
	}
	,__class__: microbe.form.elements.AjaxUploader
	,__properties__: {set_composantName:"setComposant",get_composantName:"getComposant"}
});
microbe.form.elements.Button = $hxClasses["microbe.form.elements.Button"] = function(name,label,value,type,link) {
	microbe.form.FormElement.call(this);
	this.name = name;
	this.label = label;
	this.value = value;
	this.link = link;
	this.type = type == null?microbe.form.elements.ButtonType.SUBMIT:type;
};
microbe.form.elements.Button.__name__ = ["microbe","form","elements","Button"];
microbe.form.elements.Button.__super__ = microbe.form.FormElement;
microbe.form.elements.Button.prototype = $extend(microbe.form.FormElement.prototype,{
	type: null
	,link: null
	,isValid: function() {
		return true;
	}
	,render: function(iter) {
		var _onClick = "";
		if(this.link != null) _onClick = " onclick=" + this.link;
		return "<button type=\"" + this.type + "\" class=\"" + this.getClasses() + "\" name=\"" + this.form.name + "_" + this.name + "\" id=\"" + this.form.name + "_" + this.name + "\" value=\"" + this.value + "\" " + _onClick + " >" + this.label + "</button>";
	}
	,toString: function() {
		return this.render();
	}
	,getLabel: function() {
		var n = this.form.name + "_" + this.name;
		return "<label for=\"" + n + "\" ></label>";
	}
	,getPreview: function() {
		return "<tr><td></td><td>" + this.render() + "<td></tr>";
	}
	,populate: function() {
		microbe.form.FormElement.prototype.populate.call(this);
		var n = this.form.name + "_" + this.name;
	}
	,__class__: microbe.form.elements.Button
});
microbe.form.elements.ButtonType = $hxClasses["microbe.form.elements.ButtonType"] = { __ename__ : ["microbe","form","elements","ButtonType"], __constructs__ : ["SUBMIT","BUTTON","RESET"] }
microbe.form.elements.ButtonType.SUBMIT = ["SUBMIT",0];
microbe.form.elements.ButtonType.SUBMIT.toString = $estr;
microbe.form.elements.ButtonType.SUBMIT.__enum__ = microbe.form.elements.ButtonType;
microbe.form.elements.ButtonType.BUTTON = ["BUTTON",1];
microbe.form.elements.ButtonType.BUTTON.toString = $estr;
microbe.form.elements.ButtonType.BUTTON.__enum__ = microbe.form.elements.ButtonType;
microbe.form.elements.ButtonType.RESET = ["RESET",2];
microbe.form.elements.ButtonType.RESET.toString = $estr;
microbe.form.elements.ButtonType.RESET.__enum__ = microbe.form.elements.ButtonType;
microbe.form.elements.CheckBox = $hxClasses["microbe.form.elements.CheckBox"] = function(_microfield,_iter) {
	microbe.form.AjaxElement.call(this,_microfield,_iter);
	microbe.tools.Debug.Alerte(this.id,{ fileName : "CheckBox.hx", lineNumber : 17, className : "microbe.form.elements.CheckBox", methodName : "new"});
};
microbe.form.elements.CheckBox.__name__ = ["microbe","form","elements","CheckBox"];
microbe.form.elements.CheckBox.__super__ = microbe.form.AjaxElement;
microbe.form.elements.CheckBox.prototype = $extend(microbe.form.AjaxElement.prototype,{
	getValue: function() {
		var valeur = new js.JQuery("#" + this.id).attr("checked");
		var val;
		if(valeur == true) val = "true"; else val = "false";
		return val;
	}
	,setValue: function(val) {
		"set_" + microbe.tools.Debug.Alerte(val,{ fileName : "CheckBox.hx", lineNumber : 42, className : "microbe.form.elements.CheckBox", methodName : "setValue"});
		var etat;
		if(val == "true") etat = "checked"; else etat = "";
		new js.JQuery("#" + this.id).attr("checked",etat);
	}
	,__class__: microbe.form.elements.CheckBox
});
microbe.form.elements.CollectionElement = $hxClasses["microbe.form.elements.CollectionElement"] = function(_liste,_pos) {
	microbe.form.AjaxElement.call(this,_liste,_pos);
	this.elementid = this.id + _pos;
	this.pos = _pos;
	this.collItemId = this.getCollecItemId(new js.JQuery("#" + this.elementid).attr("tri"));
	microbe.tools.Debug.Alerte(Std.string("collecItemId=" + this.collItemId),{ fileName : "CollectionElement.hx", lineNumber : 100, className : "microbe.form.elements.CollectionElement", methodName : "new"});
	new js.JQuery("#" + this.elementid + " .deletecollection").bind("click",this.beforedelete.$bind(this));
};
microbe.form.elements.CollectionElement.__name__ = ["microbe","form","elements","CollectionElement"];
microbe.form.elements.CollectionElement.__super__ = microbe.form.AjaxElement;
microbe.form.elements.CollectionElement.prototype = $extend(microbe.form.AjaxElement.prototype,{
	elementid: null
	,collItemId: null
	,getCollecItemId: function(tri) {
		var splited = Lambda.list(tri.split("_")).last();
		return Std.parseInt(splited);
	}
	,beforedelete: function(e) {
		var target = new js.JQuery(e.target);
		microbe.tools.Debug.Alerte(target.attr("id"),{ fileName : "CollectionElement.hx", lineNumber : 114, className : "microbe.form.elements.CollectionElement", methodName : "beforedelete"});
		target.text("sure?");
		target.unbind("click",this.beforedelete.$bind(this));
		target.click(this.delete.$bind(this));
	}
	,'delete': function(e) {
		microbe.tools.Debug.Alerte("delete",{ fileName : "CollectionElement.hx", lineNumber : 120, className : "microbe.form.elements.CollectionElement", methodName : "delete"});
		Std.string("id=" + this.collItemId);
		microbe.form.elements.CollectionElement.deleteSignal.dispatch(this.elementid,this.voName,this.pos,this.collItemId);
	}
	,active: function() {
		new js.JQuery("#uploadButton");
	}
	,getValue: function() {
		return new js.JQuery("#" + this.id).attr("value");
	}
	,setValue: function(val) {
		new js.JQuery("#" + this.id).attr("value",val);
	}
	,__class__: microbe.form.elements.CollectionElement
});
microbe.form.elements.CollectionWrapper = $hxClasses["microbe.form.elements.CollectionWrapper"] = function() {
	this.me = new js.JQuery(".collectionWrapper");
	this.spod = this.me.attr("spod");
	this.createPlusBouton();
	microbe.form.elements.CollectionWrapper.plusInfos = new hxs.Signal1();
	var sortoptions = { };
	sortoptions.update = this.onSortChanged.$bind(this);
	sortoptions.start = this.onSortStart.$bind(this);
	sortoptions.placeholder = "placeHolder";
	sortoptions.opacity = .2;
	this.sort = new $(".collectionWrapper").sortable(sortoptions);
};
microbe.form.elements.CollectionWrapper.__name__ = ["microbe","form","elements","CollectionWrapper"];
microbe.form.elements.CollectionWrapper.plusInfos = null;
microbe.form.elements.CollectionWrapper.prototype = {
	me: null
	,plus: null
	,clone: null
	,sort: null
	,spod: null
	,createPlusBouton: function() {
		var plusString = microbe.form.elements.PlusCollectionButton.create("plusbutton");
		this.me.append(plusString);
		var plus = new microbe.form.elements.PlusCollectionButton(this.me.find(".plusbutton"));
		microbe.form.elements.PlusCollectionButton.sign.add(this.onPLUS.$bind(this));
		plus.init();
	}
	,onPLUS: function(s) {
		microbe.tools.Debug.Alerte("onPlus",{ fileName : "CollectionWrapper.hx", lineNumber : 97, className : "microbe.form.elements.CollectionWrapper", methodName : "onPLUS"});
		this.clone = this.me.children(".collection").last().clone();
		var collength = this.me.children(".collection").length;
		this.clone.attr("id",this.clone.attr("name"));
		microbe.form.elements.CollectionWrapper.plusInfos.dispatch({ collectionName : this.clone.attr("name"), graine : collength, target : this});
	}
	,notify: function(newColl) {
		microbe.tools.Debug.Alerte("notify",{ fileName : "CollectionWrapper.hx", lineNumber : 106, className : "microbe.form.elements.CollectionWrapper", methodName : "notify"});
		this.me.append(newColl);
	}
	,onSortStart: function(e,ui) {
		var childs = this.me.children(".collection");
		var $it0 = childs.iterator();
		while( $it0.hasNext() ) {
			var a = $it0.next();
			var value = Lambda.list(a.attr("tri").split("_")).last().length;
			if(value == 0) return this.dispatchError();
		}
		return;
	}
	,dispatchError: function() {
		this.sort.sortable("disable");
		js.Lib.alert("Veuilez enregistrer avant de réarranger l'ordre !");
	}
	,onSortChanged: function(e,ui) {
		var pop = this.sort.sortable("serialize",{ attribute : "tri", key : "id"});
		haxe.Log.trace(pop,{ fileName : "CollectionWrapper.hx", lineNumber : 124, className : "microbe.form.elements.CollectionWrapper", methodName : "onSortChanged"});
		var liste = pop.split("&id=");
		liste[0] = liste[0].split("id=")[1];
		var req = new haxe.Http(microbe.jsTools.BackJS.back_url + "reorder/" + this.spod);
		req.setParameter("orderedList",haxe.Serializer.run(liste));
		req.onData = function(d) {
			haxe.Log.trace(d,{ fileName : "CollectionWrapper.hx", lineNumber : 133, className : "microbe.form.elements.CollectionWrapper", methodName : "onSortChanged"});
		};
		req.request(true);
		haxe.Log.trace("afterreorder",{ fileName : "CollectionWrapper.hx", lineNumber : 135, className : "microbe.form.elements.CollectionWrapper", methodName : "onSortChanged"});
	}
	,__class__: microbe.form.elements.CollectionWrapper
}
microbe.form.elements.DeleteButton = $hxClasses["microbe.form.elements.DeleteButton"] = function(id) {
	microbe.form.AjaxElement.call(this,null);
	microbe.form.elements.DeleteButton.sign = new hxs.Signal();
	this.elementid = id;
	new js.JQuery("#" + this.elementid).bind("click",this.onClick.$bind(this));
};
microbe.form.elements.DeleteButton.__name__ = ["microbe","form","elements","DeleteButton"];
microbe.form.elements.DeleteButton.sign = null;
microbe.form.elements.DeleteButton.__super__ = microbe.form.AjaxElement;
microbe.form.elements.DeleteButton.prototype = $extend(microbe.form.AjaxElement.prototype,{
	elementid: null
	,tooltip: null
	,start: null
	,buttonwidth: null
	,onClick: function(event) {
		new js.JQuery("#" + this.elementid).append("<div class='tooltip'><span>sure ?</span></div>");
		var tooltip = new js.JQuery(".tooltip");
		tooltip.css("top","0");
		this.buttonwidth = new js.JQuery("#" + this.elementid).outerWidth();
		var maTween = new feffects.Tween(this.start,this.start + this.buttonwidth / 2,500,feffects.easing.Bounce.easeOut);
		maTween.setTweenHandlers(this.anime.$bind(this),this.fini.$bind(this));
		maTween.start();
	}
	,anime: function(e) {
		new js.JQuery(".tooltip").css("left",e + "px");
	}
	,fini: function(e) {
		new js.JQuery("#" + this.elementid + " span").first().text("oui");
		new js.JQuery("#" + this.elementid).css("width","120px").css("text-align","left");
		new js.JQuery("#" + this.elementid).bind("click",this.onTool.$bind(this));
	}
	,onTool: function(e) {
		microbe.form.elements.DeleteButton.sign.dispatch();
	}
	,__class__: microbe.form.elements.DeleteButton
});
microbe.form.elements.FakeElement = $hxClasses["microbe.form.elements.FakeElement"] = function(name,value,required,display,attributes) {
	if(attributes == null) attributes = "";
	if(display == null) display = false;
	if(required == null) required = false;
	microbe.form.FormElement.call(this);
	this.name = name;
	this.value = value;
	this.required = required;
	this.display = display;
	this.attributes = attributes;
};
microbe.form.elements.FakeElement.__name__ = ["microbe","form","elements","FakeElement"];
microbe.form.elements.FakeElement.__super__ = microbe.form.FormElement;
microbe.form.elements.FakeElement.prototype = $extend(microbe.form.FormElement.prototype,{
	display: null
	,render: function(iter) {
		var n = this.name;
		return n;
	}
	,getPreview: function() {
		return this.render();
	}
	,toString: function() {
		return this.render();
	}
	,__class__: microbe.form.elements.FakeElement
});
microbe.form.elements.Hidden = $hxClasses["microbe.form.elements.Hidden"] = function(_microfield) {
	microbe.form.AjaxElement.call(this,_microfield);
};
microbe.form.elements.Hidden.__name__ = ["microbe","form","elements","Hidden"];
microbe.form.elements.Hidden.__super__ = microbe.form.AjaxElement;
microbe.form.elements.Hidden.prototype = $extend(microbe.form.AjaxElement.prototype,{
	moduleid: null
	,getValue: function() {
		return new js.JQuery("#" + this.id).attr("value");
	}
	,setValue: function(val) {
		js.Lib.alert("val=" + val);
		new js.JQuery("#" + this.id).attr("value",val);
	}
	,__class__: microbe.form.elements.Hidden
});
microbe.form.elements.IframeUploader = $hxClasses["microbe.form.elements.IframeUploader"] = function(_microfield,_iter) {
	microbe.form.AjaxElement.call(this,_microfield,_iter);
	this.base_url = js.Lib.window.location.protocol + "//" + js.Lib.window.location.host;
	this.getBouton().click(this.testUpload.$bind(this));
};
microbe.form.elements.IframeUploader.__name__ = ["microbe","form","elements","IframeUploader"];
microbe.form.elements.IframeUploader.__super__ = microbe.form.AjaxElement;
microbe.form.elements.IframeUploader.prototype = $extend(microbe.form.AjaxElement.prototype,{
	self: null
	,formDefaultAction: null
	,base_url: null
	,uploadtarget: null
	,init: function(e) {
	}
	,testUpload: function(e) {
		this.DisableForm();
		this.disableStatus();
		this.formDefaultAction = new js.JQuery("#" + this.getForm()).attr("target");
		var iframe = "<iframe id='uploadtarget' name='uploadtarget' style='width:0;height:0;border:0px solid #fff;'></iframe>";
		new js.JQuery("#" + this.id).append(iframe);
		new js.JQuery("#" + this.getForm()).attr("target","uploadtarget");
		new js.JQuery("#" + this.id + " #" + this.getIframe()).load(this.onLoad.$bind(this));
		new js.JQuery("#" + this.getForm()).attr("action","/index.php/upload");
		new js.JQuery("#" + this.getForm()).submit();
	}
	,disableStatus: function() {
		new js.JQuery("#" + this.id + " p.status").remove();
	}
	,onLoad: function(e) {
		var p = new js.JQuery("#" + this.id + " #" + this.getIframe()).contents().text();
		if(p == "tooBig") {
			var status = new js.JQuery("<p class='status'>");
			status.text("le fichier est trop lourd");
			var res = new js.JQuery("#" + this.id).append(status);
		}
		new js.JQuery("#" + this.id + " #" + this.getIframe()).remove();
		this.setValue(p);
		this.getpreview().fadeTo(0,0);
		this.getpreview().fadeTo(600,1);
		new js.JQuery("#" + this.getForm()).attr("target",this.formDefaultAction);
		this.enableForm();
	}
	,getBouton: function() {
		return new js.JQuery("#" + this.id + " #uploadButton");
	}
	,getRetour: function() {
		var retour = new js.JQuery("#" + this.id + " #retour");
		return retour;
	}
	,getInputName: function() {
		var inputName = new js.JQuery("#" + this.id + " #fileinput").attr("name");
		return inputName;
	}
	,getpreview: function() {
		return new js.JQuery("#" + this.id + " #preview");
	}
	,getIframe: function() {
		return "uploadtarget";
	}
	,DisableForm: function() {
		new js.JQuery("#" + this.getForm() + " input[name!='" + this.getInputName() + "']").attr("disabled","disabled");
	}
	,enableForm: function() {
		new js.JQuery("input").attr("disabled","");
	}
	,getValue: function() {
		var retour = this.getRetour().attr("value");
		return retour;
	}
	,setValue: function(val) {
		if(val != null) this.getpreview().attr("src",js.Lib.window.location.protocol + "//" + js.Lib.window.location.host + "/index.php/imageBase/resize/thumb/" + val); else this.getpreview().attr("src","/microbe/css/assets/blankframe.png");
		this.getRetour().attr("value",val);
	}
	,__class__: microbe.form.elements.IframeUploader
});
microbe.form.elements.ImageUploader = $hxClasses["microbe.form.elements.ImageUploader"] = function(_microfield,_iter) {
	microbe.form.elements.IframeUploader.call(this,_microfield,_iter);
	new js.JQuery("#" + this.id + " .file_input_button").click(this.onFake.$bind(this));
	new js.JQuery("#" + this.id + " #cancel").click(this.onVide.$bind(this));
};
microbe.form.elements.ImageUploader.__name__ = ["microbe","form","elements","ImageUploader"];
microbe.form.elements.ImageUploader.__super__ = microbe.form.elements.IframeUploader;
microbe.form.elements.ImageUploader.prototype = $extend(microbe.form.elements.IframeUploader.prototype,{
	onVide: function(e) {
		this.setValue(null);
	}
	,onFake: function(e) {
		e.preventDefault();
		new js.JQuery("#" + this.id + " .hiddenfileinput").trigger("click");
	}
	,setValue: function(val) {
		if(val != null) this.getpreview().attr("src",js.Lib.window.location.protocol + "//" + js.Lib.window.location.host + "/index.php/imageBase/resize/modele/" + val); else this.getpreview().attr("src","/microbe/css/assets/blankframe.png");
		this.getRetour().attr("value",val);
	}
	,__class__: microbe.form.elements.ImageUploader
});
microbe.form.elements.Input = $hxClasses["microbe.form.elements.Input"] = function(name,label,value,required,validators,attributes) {
	if(attributes == null) attributes = "";
	if(required == null) required = false;
	microbe.form.FormElement.call(this);
	this.name = name;
	this.label = label;
	this.value = value;
	this.required = required;
	this.attributes = attributes;
	this.password = false;
	this.showLabelAsDefaultValue = false;
	this.useSizeValues = false;
	this.printRequired = false;
	this.width = 180;
};
microbe.form.elements.Input.__name__ = ["microbe","form","elements","Input"];
microbe.form.elements.Input.__super__ = microbe.form.FormElement;
microbe.form.elements.Input.prototype = $extend(microbe.form.FormElement.prototype,{
	password: null
	,width: null
	,showLabelAsDefaultValue: null
	,useSizeValues: null
	,printRequired: null
	,formatter: null
	,render: function(iter) {
		var n = this.form.name + "_" + this.name;
		var tType = this.password?"password":"text";
		if(this.showLabelAsDefaultValue && this.value == this.label) this.addValidator(new microbe.form.validators.BoolValidator(false,"Not valid"));
		if((this.value == null || this.value == "") && this.showLabelAsDefaultValue) this.value = this.label;
		var style = this.useSizeValues?"style=\"width:" + this.width + "px\"":"";
		return "<input " + style + " class=\"" + this.getClasses() + "\" type=\"" + tType + "\" name=\"" + n + "\" id=\"" + n + "\" value=\"" + this.safeString(this.value) + "\"  " + this.attributes + " />" + (this.required && this.form.isSubmitted() && this.printRequired?" required":null);
	}
	,toString: function() {
		return this.render();
	}
	,__class__: microbe.form.elements.Input
});
microbe.form.elements.Mock = $hxClasses["microbe.form.elements.Mock"] = function(_microfield) {
	microbe.form.AjaxElement.call(this,_microfield);
	microbe.tools.Debug.Alerte(this.id,{ fileName : "Mock.hx", lineNumber : 48, className : "microbe.form.elements.Mock", methodName : "new"});
	var pop = new js.JQuery("#" + this.id + "test").click(this.onFake.$bind(this));
};
microbe.form.elements.Mock.__name__ = ["microbe","form","elements","Mock"];
microbe.form.elements.Mock.__super__ = microbe.form.AjaxElement;
microbe.form.elements.Mock.prototype = $extend(microbe.form.AjaxElement.prototype,{
	onFake: function(e) {
		microbe.tools.Debug.Alerte("onFake",{ fileName : "Mock.hx", lineNumber : 55, className : "microbe.form.elements.Mock", methodName : "onFake"});
	}
	,getValue: function() {
		microbe.tools.Debug.Alerte("",{ fileName : "Mock.hx", lineNumber : 59, className : "microbe.form.elements.Mock", methodName : "getValue"});
		return new js.JQuery("#" + this.id).attr("value");
	}
	,setValue: function(val) {
		microbe.tools.Debug.Alerte("",{ fileName : "Mock.hx", lineNumber : 64, className : "microbe.form.elements.Mock", methodName : "setValue"});
		new js.JQuery("#" + this.id).attr("value",val);
	}
	,__class__: microbe.form.elements.Mock
});
microbe.form.elements.PlusCollectionButton = $hxClasses["microbe.form.elements.PlusCollectionButton"] = function(_me) {
	this.me = _me;
	microbe.form.elements.PlusCollectionButton.sign = new hxs.Signal1();
};
microbe.form.elements.PlusCollectionButton.__name__ = ["microbe","form","elements","PlusCollectionButton"];
microbe.form.elements.PlusCollectionButton.sign = null;
microbe.form.elements.PlusCollectionButton.create = function(classe) {
	return "<button type=\"BUTTON\" class=\"" + classe + "\">plus</button>";
}
microbe.form.elements.PlusCollectionButton.prototype = {
	transport: null
	,elementid: null
	,me: null
	,onClick: function(e) {
		e.stopImmediatePropagation();
		microbe.form.elements.PlusCollectionButton.sign.dispatch("transport");
		microbe.tools.Debug.Alerte(Std.string(microbe.form.elements.PlusCollectionButton.cont),{ fileName : "PlusCollectionButton.hx", lineNumber : 74, className : "microbe.form.elements.PlusCollectionButton", methodName : "onClick"});
		microbe.form.elements.PlusCollectionButton.cont++;
	}
	,init: function() {
		this.me.click(this.onClick.$bind(this));
	}
	,__class__: microbe.form.elements.PlusCollectionButton
}
microbe.form.elements.RichtextWym = $hxClasses["microbe.form.elements.RichtextWym"] = function(_microfield) {
	microbe.form.AjaxElement.call(this,_microfield);
	microbe.form.elements.RichtextWym.self = this;
	this.base_url = js.Lib.window.location.protocol + "//" + js.Lib.window.location.host;
};
microbe.form.elements.RichtextWym.__name__ = ["microbe","form","elements","RichtextWym"];
microbe.form.elements.RichtextWym.self = null;
microbe.form.elements.RichtextWym.__super__ = microbe.form.AjaxElement;
microbe.form.elements.RichtextWym.prototype = $extend(microbe.form.AjaxElement.prototype,{
	formDefaultAction: null
	,base_url: null
	,getValue: function() {
		return wym.html;
	}
	,output: function() {
		return "yeah from js";
	}
	,setValue: function(val) {
		__js__("wym.html(" + val + ")");
	}
	,__class__: microbe.form.elements.RichtextWym
});
microbe.form.elements.TagView = $hxClasses["microbe.form.elements.TagView"] = function(_microfield,_iter) {
	microbe.form.AjaxElement.call(this,_microfield,_iter);
	new js.JQuery("#addTag").click(this.onAdd.$bind(this));
	new js.JQuery("#tagSelector select").change(this.onSelect.$bind(this));
	microbe.tools.Debug.Alerte("new",{ fileName : "TagView.hx", lineNumber : 25, className : "microbe.form.elements.TagView", methodName : "new"});
	this.init();
};
microbe.form.elements.TagView.__name__ = ["microbe","form","elements","TagView"];
microbe.form.elements.TagView.__super__ = microbe.form.AjaxElement;
microbe.form.elements.TagView.prototype = $extend(microbe.form.AjaxElement.prototype,{
	spodTags: null
	,contextTags: null
	,fullTags: null
	,filtre: null
	,init: function() {
		this.getTags(this.voName,this.spodId);
		microbe.tools.Debug.Alerte(Std.string(this.spodTags),{ fileName : "TagView.hx", lineNumber : 32, className : "microbe.form.elements.TagView", methodName : "init"});
		this.afficheTags();
		microbe.tools.Debug.Alerte(Std.string(this.contextTags),{ fileName : "TagView.hx", lineNumber : 34, className : "microbe.form.elements.TagView", methodName : "init"});
		this.populateTags();
		microbe.tools.Debug.Alerte(Std.string(this.fullTags),{ fileName : "TagView.hx", lineNumber : 36, className : "microbe.form.elements.TagView", methodName : "init"});
		new js.JQuery("#tagSelector #pute").keyup(this.onType.$bind(this));
		new js.JQuery("#tagSelector #results").blur(this.onBlur.$bind(this));
	}
	,onBlur: function(e) {
		new js.JQuery("#tagSelector #results").hide();
	}
	,onType: function(e) {
		var filtered = this.findinSpodTags();
		this.showResults(filtered);
	}
	,findinSpodTags: function() {
		return Lambda.filter(this.fullTags,this.subFind.$bind(this));
	}
	,subFind: function(item) {
		var filtre = new js.JQuery("#tagSelector #pute").val();
		if(Std.string(item).substr(0,filtre.length) == filtre) return true;
		return false;
	}
	,showResults: function(data) {
		if(data.length > 0) {
			var resultHtml = "";
			var $it0 = data.iterator();
			while( $it0.hasNext() ) {
				var tag = $it0.next();
				resultHtml += "<option class=\"result\">";
				resultHtml += tag;
				resultHtml += "</option>";
			}
			new js.JQuery("#tagSelector #results").html(resultHtml);
			new js.JQuery("#tagSelector #results").css("display","block");
			new js.JQuery("#tagSelector #results .result").click(this.onSelect.$bind(this));
		} else new js.JQuery("#tagSelector #results").css("display","none");
	}
	,onSelect: function(e) {
		js.Lib.alert("pop");
		var selected = new js.JQuery("#tagSelector select option:selected");
		new js.JQuery("#tagSelector #pute").val(selected.text());
	}
	,reload: function() {
	}
	,createResultsDiv: function() {
		var str = "<div id='results'></div>";
		var div = new js.JQuery("#tagSelector").append(str);
	}
	,getTags: function(spod,spodId) {
		microbe.tools.Debug.Alerte("",{ fileName : "TagView.hx", lineNumber : 109, className : "microbe.form.elements.TagView", methodName : "getTags"});
		if(spodId != null) {
			microbe.tools.Debug.Alerte(spod,{ fileName : "TagView.hx", lineNumber : 112, className : "microbe.form.elements.TagView", methodName : "getTags"});
			var context = microbe.TagManager.getTags(spod,spodId);
			microbe.tools.Debug.Alerte("",{ fileName : "TagView.hx", lineNumber : 114, className : "microbe.form.elements.TagView", methodName : "getTags"});
			var tags = microbe.TagManager.getTags(spod);
			microbe.tools.Debug.Alerte("",{ fileName : "TagView.hx", lineNumber : 116, className : "microbe.form.elements.TagView", methodName : "getTags"});
			this.contextTags = context;
			microbe.tools.Debug.Alerte("",{ fileName : "TagView.hx", lineNumber : 118, className : "microbe.form.elements.TagView", methodName : "getTags"});
			this.spodTags = tags;
		} else {
			microbe.tools.Debug.Alerte("",{ fileName : "TagView.hx", lineNumber : 121, className : "microbe.form.elements.TagView", methodName : "getTags"});
			this.contextTags = new List();
			this.spodTags = new List();
		}
	}
	,afficheTags: function() {
		new js.JQuery("#tagSelector .tagitem").remove();
		var str = "";
		str += "<ul class='tags'>";
		var $it0 = this.contextTags.iterator();
		while( $it0.hasNext() ) {
			var tag = $it0.next();
			str += "<li class='tagitem'><div class='tag'>" + tag.tag + "</div><div class='minus'></div></li>";
		}
		str += "</ul>";
		new js.JQuery("#tagSelector").append(str);
		new js.JQuery("#tagSelector .tagitem .minus").click(this.remove.$bind(this));
	}
	,remove: function(e) {
		var tag = new js.JQuery(e.currentTarget).parent(".tagitem").children(".tag").text();
		microbe.TagManager.removeTagFromSpod(this.voName,this.spodId,tag);
		this.init();
	}
	,compareTags: function() {
		var $it0 = this.spodTags.iterator();
		while( $it0.hasNext() ) {
			var dispo = $it0.next();
			if(Lambda.has(this.contextTags,dispo)) this.spodTags.remove(dispo);
		}
	}
	,populateTags: function() {
		new js.JQuery("#tagSelector select").empty();
		this.fullTags = new List();
		var str = "";
		var $it0 = this.spodTags.iterator();
		while( $it0.hasNext() ) {
			var tag = $it0.next();
			this.fullTags.add(tag.tag);
		}
		new js.JQuery("#tagSelector select").append(str);
	}
	,onAdd: function(e) {
		var newTag = new js.JQuery("#tagSelector #pute").val();
		js.Lib.alert("add" + newTag);
		js.Lib.alert(microbe.TagManager.addTag(this.voName,this.spodId,newTag));
		js.Lib.alert("afetr");
		this.init();
	}
	,__class__: microbe.form.elements.TagView
});
microbe.form.elements.TestCrossAjax = $hxClasses["microbe.form.elements.TestCrossAjax"] = function(_microfield,_iter) {
	microbe.tools.Debug.Alerte("",{ fileName : "TestCrossAjax.hx", lineNumber : 48, className : "microbe.form.elements.TestCrossAjax", methodName : "new"});
	microbe.form.AjaxElement.call(this,_microfield,_iter);
	this.self = this;
	this.base_url = js.Lib.window.location.protocol + "//" + js.Lib.window.location.host;
	this.getBouton().click(this.testUpload.$bind(this));
};
microbe.form.elements.TestCrossAjax.__name__ = ["microbe","form","elements","TestCrossAjax"];
microbe.form.elements.TestCrossAjax.__super__ = microbe.form.AjaxElement;
microbe.form.elements.TestCrossAjax.prototype = $extend(microbe.form.AjaxElement.prototype,{
	self: null
	,formDefaultAction: null
	,base_url: null
	,uploadtarget: null
	,init: function(e) {
		this.getCollectionContainer();
	}
	,testUpload: function(e) {
		this.DisableEnableForm();
		new js.JQuery("#" + this.getForm()).attr("target",this.getIframe());
		new js.JQuery("#" + this.getIframe()).load(this.onLoad.$bind(this));
		this.formDefaultAction = new js.JQuery("#" + this.getForm()).attr("action");
		new js.JQuery("#" + this.getForm()).attr("action","http://localhost:8888/index.php/upload");
		new js.JQuery("#" + this.getForm()).submit();
	}
	,onLoad: function(e) {
		var p = new js.JQuery("#" + this.getIframe()).contents().text();
		this.setValue(p);
		this.getpreview().fadeTo(0,0);
		this.getpreview().fadeTo(600,1);
		this.enableForm();
	}
	,DisableEnableForm: function() {
		new js.JQuery("#" + this.getForm() + " input[name!='" + this.getInputName() + "']").attr("disabled","disabled");
	}
	,enableForm: function() {
		new js.JQuery("input").attr("disabled","");
	}
	,creeIframe: function() {
		new js.JQuery("#" + "myFrame").remove();
		new js.JQuery("<iframe id=\"myFrame\" />").appendTo("body");
	}
	,getIframe: function() {
		var ifr = new js.JQuery("#" + "upload_target" + this.getCollectionContainer()).attr("id");
		return ifr;
	}
	,active: function() {
		new js.JQuery("#uploadButton");
	}
	,getBouton: function() {
		return new js.JQuery("#" + this.id + " #uploadButton");
	}
	,getRetour: function() {
		return new js.JQuery("#" + this.id + " #retour" + this.getCollectionContainer());
	}
	,getInputName: function() {
		return new js.JQuery("#" + this.id + " #fileinput").attr("name");
	}
	,getpreview: function() {
		return new js.JQuery("#" + this.id + " #preview" + this.getCollectionContainer());
	}
	,getCollectionContainer: function() {
		var p = new js.JQuery("#" + this.id).parents(".collection");
		if(p.attr("pos") != null) return p.attr("pos");
		return "";
	}
	,setpreview: function(source) {
		this.getpreview().css("width","300px");
		this.getpreview().attr("src",source);
		this.getpreview().fadeTo(0,0);
		this.getpreview().fadeTo(600,1);
	}
	,getValue: function() {
		return new js.JQuery("#retour" + this.getCollectionContainer()).attr("value");
	}
	,setValue: function(val) {
		this.getpreview().attr("src",js.Lib.window.location.protocol + "//" + js.Lib.window.location.host + "/index.php/imageBase/resize/thumb/" + val);
		this.getRetour().attr("value",val);
	}
	,output: function() {
		return "yeah from js";
	}
	,__class__: microbe.form.elements.TestCrossAjax
});
if(!microbe.form.validators) microbe.form.validators = {}
microbe.form.validators.BoolValidator = $hxClasses["microbe.form.validators.BoolValidator"] = function(valid,error) {
	microbe.form.Validator.call(this);
	this.valid = valid;
	if(error != null) this.errorNotValid = error; else this.errorNotValid = "Not valid.";
};
microbe.form.validators.BoolValidator.__name__ = ["microbe","form","validators","BoolValidator"];
microbe.form.validators.BoolValidator.__super__ = microbe.form.Validator;
microbe.form.validators.BoolValidator.prototype = $extend(microbe.form.Validator.prototype,{
	errorNotValid: null
	,valid: null
	,isValid: function(value) {
		if(!this.valid) this.errors.push(this.errorNotValid);
		return this.valid;
	}
	,__class__: microbe.form.validators.BoolValidator
});
if(!microbe.jsTools) microbe.jsTools = {}
microbe.jsTools.BackJS = $hxClasses["microbe.jsTools.BackJS"] = function() {
	microbe.tools.Debug.Alerte("new",{ fileName : "BackJS.hx", lineNumber : 59, className : "microbe.jsTools.BackJS", methodName : "new"});
	new js.JQuery("document").ready(function(e) {
		microbe.jsTools.BackJS.getInstance().init();
	});
};
$hxExpose(microbe.jsTools.BackJS, "microbe.jsTools.BackJS");
microbe.jsTools.BackJS.__name__ = ["microbe","jsTools","BackJS"];
microbe.jsTools.BackJS.__properties__ = {get_instance:"getInstance"}
microbe.jsTools.BackJS.instance = null;
microbe.jsTools.BackJS.main = function() {
	microbe.jsTools.BackJS.instance = new microbe.jsTools.BackJS();
}
microbe.jsTools.BackJS.getInstance = function() {
	if(microbe.jsTools.BackJS.instance == null) microbe.jsTools.BackJS.instance = new microbe.jsTools.BackJS();
	return microbe.jsTools.BackJS.instance;
}
microbe.jsTools.BackJS.prototype = {
	currentVo: null
	,classMap: null
	,microbeElements: null
	,sort: null
	,init: function() {
		this.start();
	}
	,start: function() {
		if(this.classMap != null) {
			new js.JQuery("#" + this.classMap.submit).click(function(e) {
				microbe.jsTools.BackJS.getInstance().record();
			});
			this.currentVo = this.classMap.voClass;
			if(this.classMap.fields.taggable == true) new microbe.form.elements.TagView(this.classMap.fields);
			this.microbeElements = new microbe.jsTools.ElementBinder();
			var deleteBouton = new microbe.form.elements.DeleteButton(this.classMap.voClass + "_form_effacer");
			var parser = new microbe.jsTools.MapParser(this.microbeElements);
			parser.parse(this.classMap);
			var wrapper = new microbe.form.elements.CollectionWrapper();
			microbe.form.elements.CollectionWrapper.plusInfos.add(this.PlusCollection.$bind(this));
			var sortoptions = { };
			sortoptions.placeholder = "placeHolder";
			sortoptions.opacity = .2;
			sortoptions.update = this.onSortChanged.$bind(this);
			this.sort = new $("#leftCol .itemslist").sortable(sortoptions);
			this.listen();
		}
	}
	,onSortChanged: function(e,ui) {
		var pop = this.sort.sortable("serialize",{ attribute : "tri", key : "id"});
		haxe.Log.trace(pop,{ fileName : "BackJS.hx", lineNumber : 118, className : "microbe.jsTools.BackJS", methodName : "onSortChanged"});
		var liste = pop.split("&id=");
		liste[0] = liste[0].split("id=")[1];
		var req = new haxe.Http(microbe.jsTools.BackJS.back_url + "reorder/" + this.currentVo);
		req.setParameter("orderedList",haxe.Serializer.run(liste));
		req.onData = function(d) {
			haxe.Log.trace(d,{ fileName : "BackJS.hx", lineNumber : 127, className : "microbe.jsTools.BackJS", methodName : "onSortChanged"});
		};
		req.request(true);
		haxe.Log.trace("afterreorder",{ fileName : "BackJS.hx", lineNumber : 129, className : "microbe.jsTools.BackJS", methodName : "onSortChanged"});
	}
	,setClassMap: function(compressedMap) {
		this.classMap = haxe.Unserializer.run(compressedMap);
	}
	,listen: function() {
		microbe.tools.Debug.Alerte("listen",{ fileName : "BackJS.hx", lineNumber : 142, className : "microbe.jsTools.BackJS", methodName : "listen"});
		microbe.form.elements.CollectionElement.deleteSignal.add(this.deleteCollection.$bind(this));
		microbe.form.elements.DeleteButton.sign.add(this.deleteSpod.$bind(this));
		new js.JQuery(".ajout").click(this.onAjoute.$bind(this));
	}
	,onAjoute: function(e) {
		microbe.tools.Debug.Alerte("ajoute",{ fileName : "BackJS.hx", lineNumber : 152, className : "microbe.jsTools.BackJS", methodName : "onAjoute"});
		js.Lib.window.location.href = microbe.jsTools.BackJS.back_url + "ajoute/" + this.currentVo;
	}
	,deleteSpod: function() {
		microbe.tools.Debug.Alerte("sur?",{ fileName : "BackJS.hx", lineNumber : 159, className : "microbe.jsTools.BackJS", methodName : "deleteSpod"});
		js.Lib.window.location.href = microbe.jsTools.BackJS.back_url + "delete/" + this.classMap.voClass + "/" + this.classMap.id;
	}
	,spodDelete: function(voName,id) {
		microbe.tools.Debug.Alerte("",{ fileName : "BackJS.hx", lineNumber : 166, className : "microbe.jsTools.BackJS", methodName : "spodDelete"});
		var reponse = haxe.Http.requestUrl(microbe.jsTools.BackJS.back_url + "delete/" + voName + "/" + id);
	}
	,record: function() {
		haxe.Log.trace("clika" + this.microbeElements,{ fileName : "BackJS.hx", lineNumber : 174, className : "microbe.jsTools.BackJS", methodName : "record"});
		microbe.tools.Debug.Alerte("record",{ fileName : "BackJS.hx", lineNumber : 175, className : "microbe.jsTools.BackJS", methodName : "record"});
		var $it0 = this.microbeElements.iterator();
		while( $it0.hasNext() ) {
			var mic = $it0.next();
			haxe.Log.trace("micVAlue=" + mic.getValue(),{ fileName : "BackJS.hx", lineNumber : 178, className : "microbe.jsTools.BackJS", methodName : "record"});
			mic.microfield.value = mic.getValue();
		}
		this.AjaxFormTraitement();
		haxe.Log.trace("finrecord",{ fileName : "BackJS.hx", lineNumber : 182, className : "microbe.jsTools.BackJS", methodName : "record"});
	}
	,AjaxFormTraitement: function() {
		var me = this;
		microbe.tools.Debug.Alerte(Std.string(this.classMap),{ fileName : "BackJS.hx", lineNumber : 187, className : "microbe.jsTools.BackJS", methodName : "AjaxFormTraitement"});
		var compressedValues = haxe.Serializer.run(this.classMap);
		haxe.Log.trace("classMAp=" + this.classMap + "back_url=" + microbe.jsTools.BackJS.back_url,{ fileName : "BackJS.hx", lineNumber : 190, className : "microbe.jsTools.BackJS", methodName : "AjaxFormTraitement"});
		var req = new haxe.Http(microbe.jsTools.BackJS.back_url + "rec/");
		req.setParameter("map",compressedValues);
		req.onData = function(d) {
			me.afterRecord(d);
		};
		req.request(true);
	}
	,afterRecord: function(d) {
		haxe.Log.trace("Fter Record",{ fileName : "BackJS.hx", lineNumber : 198, className : "microbe.jsTools.BackJS", methodName : "afterRecord"});
		js.Lib.window.location.href = microbe.jsTools.BackJS.back_url + "nav/" + this.classMap.voClass + "/" + this.classMap.id;
	}
	,deleteCollection: function(id,voName,pos,collecItemId) {
		var maputil = new microbe.ClassMapUtils(this.classMap);
		maputil.searchCollec(voName);
		var microListe = maputil.searchinCollecById(collecItemId);
		var spodid = microListe.id;
		maputil.removeInCurrent(microListe);
		new js.JQuery("#" + id).fadeOut(1000,function() {
			new js.JQuery("#" + id).remove();
		});
		this.spodDelete(voName,spodid);
	}
	,_plusInfos: null
	,PlusCollection: function(plusInfos) {
		var me = this;
		this._plusInfos = plusInfos;
		microbe.tools.Debug.Alerte(Std.string("name" + plusInfos.collectionName + "graine=" + plusInfos.graine),{ fileName : "BackJS.hx", lineNumber : 233, className : "microbe.jsTools.BackJS", methodName : "PlusCollection"});
		var req = new haxe.Http(microbe.jsTools.BackJS.back_url + "addCollectServerItem/");
		microbe.tools.Debug.Alerte(microbe.jsTools.BackJS.back_url,{ fileName : "BackJS.hx", lineNumber : 236, className : "microbe.jsTools.BackJS", methodName : "PlusCollection"});
		req.setParameter("name",plusInfos.collectionName);
		req.setParameter("voParent",this.classMap.voClass);
		req.setParameter("voParentId",Std.string(this.classMap.id));
		req.setParameter("graine",Std.string(plusInfos.graine));
		req.onError = js.Lib.alert;
		req.onData = function(x) {
			me.onAddItemPlus(x,me._plusInfos);
		};
		req.request(true);
		microbe.tools.Debug.Alerte("end",{ fileName : "BackJS.hx", lineNumber : 244, className : "microbe.jsTools.BackJS", methodName : "PlusCollection"});
	}
	,onAddItemPlus: function(x,PI) {
		var raw = null;
		try {
			raw = haxe.Unserializer.run(x);
		} catch( err ) {
			if( js.Boot.__instanceof(err,String) ) {
				microbe.tools.Debug.Alerte(err,{ fileName : "BackJS.hx", lineNumber : 257, className : "microbe.jsTools.BackJS", methodName : "onAddItemPlus"});
			} else throw(err);
		}
		PI.target.notify(raw.element);
		this.parseplusCollec(raw.microliste,PI.graine);
	}
	,parseplusCollec: function(liste,pos) {
		var microfield = liste.fields.first();
		var $it0 = microfield.iterator();
		while( $it0.hasNext() ) {
			var elements = $it0.next();
			this.microbeElements.createElement(elements);
		}
		this.microbeElements.createCollectionElement(microfield,pos);
		var maputil = new microbe.ClassMapUtils(this.classMap);
		maputil.searchCollec(microfield.voName);
		maputil.addInCollec(microfield);
		this.classMap.fields = maputil.mapFields;
		microbe.tools.Debug.Alerte(Std.string(microfield),{ fileName : "BackJS.hx", lineNumber : 278, className : "microbe.jsTools.BackJS", methodName : "parseplusCollec"});
	}
	,__class__: microbe.jsTools.BackJS
}
microbe.jsTools.ElementBinder = $hxClasses["microbe.jsTools.ElementBinder"] = function() {
	this.elements = new List();
};
microbe.jsTools.ElementBinder.__name__ = ["microbe","jsTools","ElementBinder"];
microbe.jsTools.ElementBinder.prototype = {
	elements: null
	,createCollectionElement: function(microChamps,position) {
		var d = Type.createInstance(Type.resolveClass("microbe.form.elements.CollectionElement"),[microChamps,position]);
		microbe.tools.Debug.Alerte(Std.string(position + "-pos"),{ fileName : "ElementBinder.hx", lineNumber : 32, className : "microbe.jsTools.ElementBinder", methodName : "createCollectionElement"});
	}
	,createElement: function(microChamps) {
		microbe.tools.Debug.Alerte(Std.string(microChamps.element),{ fileName : "ElementBinder.hx", lineNumber : 38, className : "microbe.jsTools.ElementBinder", methodName : "createElement"});
		var classe = Type.resolveClass(microChamps.element);
		microbe.tools.Debug.Alerte(Std.string(classe),{ fileName : "ElementBinder.hx", lineNumber : 40, className : "microbe.jsTools.ElementBinder", methodName : "createElement"});
		var d = Type.createInstance(Type.resolveClass(microChamps.element),[microChamps]);
		this.add(d);
	}
	,add: function(element) {
		this.elements.add(element);
	}
	,iterator: function() {
		return this.elements.iterator();
	}
	,__class__: microbe.jsTools.ElementBinder
}
microbe.jsTools.MapParser = $hxClasses["microbe.jsTools.MapParser"] = function(_microbeElements) {
	this.microbeElements = _microbeElements;
};
microbe.jsTools.MapParser.__name__ = ["microbe","jsTools","MapParser"];
microbe.jsTools.MapParser.prototype = {
	map: null
	,microbeElements: null
	,parse: function(_map) {
		microbe.tools.Debug.Alerte("",{ fileName : "MapParser.hx", lineNumber : 30, className : "microbe.jsTools.MapParser", methodName : "parse"});
		this.map = _map;
		var liste = this.map.fields;
		this.recurMap(liste);
		microbe.tools.Debug.Alerte("afterparse",{ fileName : "MapParser.hx", lineNumber : 41, className : "microbe.jsTools.MapParser", methodName : "parse"});
	}
	,recurMap: function(liste) {
		microbe.tools.Debug.Alerte("recurMap",{ fileName : "MapParser.hx", lineNumber : 48, className : "microbe.jsTools.MapParser", methodName : "recurMap"});
		var pos = 0;
		var $it0 = liste.iterator();
		while( $it0.hasNext() ) {
			var chps = $it0.next();
			if(Std["is"](chps,microbe.form.MicroFieldList)) {
				if(chps.type == microbe.form.InstanceType.collection) {
					var $it1 = ((function($this) {
						var $r;
						var $t = chps;
						if(Std["is"]($t,microbe.form.MicroFieldList)) $t; else throw "Class cast error";
						$r = $t;
						return $r;
					}(this))).fields.iterator();
					while( $it1.hasNext() ) {
						var item = $it1.next();
						this.microbeElements.createCollectionElement(chps,pos);
						pos++;
					}
				}
				this.recurMap((function($this) {
					var $r;
					var $t = chps;
					if(Std["is"]($t,microbe.form.MicroFieldList)) $t; else throw "Class cast error";
					$r = $t;
					return $r;
				}(this)));
			} else {
				var microChamps = chps;
				this.microbeElements.createElement(microChamps);
			}
		}
	}
	,__class__: microbe.jsTools.MapParser
}
if(!microbe.macroUtils) microbe.macroUtils = {}
microbe.macroUtils.Imports = $hxClasses["microbe.macroUtils.Imports"] = function() { }
microbe.macroUtils.Imports.__name__ = ["microbe","macroUtils","Imports"];
microbe.macroUtils.Imports.prototype = {
	__class__: microbe.macroUtils.Imports
}
if(!microbe.notification) microbe.notification = {}
microbe.notification.NoteType = $hxClasses["microbe.notification.NoteType"] = { __ename__ : ["microbe","notification","NoteType"], __constructs__ : ["alerte","message","erreur"] }
microbe.notification.NoteType.alerte = ["alerte",0];
microbe.notification.NoteType.alerte.toString = $estr;
microbe.notification.NoteType.alerte.__enum__ = microbe.notification.NoteType;
microbe.notification.NoteType.message = ["message",1];
microbe.notification.NoteType.message.toString = $estr;
microbe.notification.NoteType.message.__enum__ = microbe.notification.NoteType;
microbe.notification.NoteType.erreur = ["erreur",2];
microbe.notification.NoteType.erreur.toString = $estr;
microbe.notification.NoteType.erreur.__enum__ = microbe.notification.NoteType;
microbe.notification.Note = $hxClasses["microbe.notification.Note"] = function(texte,type) {
	this.noteType = type;
	if(texte != null) this.text(texte);
};
microbe.notification.Note.__name__ = ["microbe","notification","Note"];
microbe.notification.Note.prototype = {
	_text: null
	,box: null
	,jBox: null
	,noteType: null
	,color: null
	,getType: function() {
		switch( (this.noteType)[1] ) {
		case 0:
			this.color = "#0af";
			break;
		case 1:
			this.color = "#33cc33";
			break;
		case 2:
			this.color = "#cc3300";
			break;
		}
		return this.color;
	}
	,createBox: function() {
		var _box = "<div class='note'>" + this._text + "</div>";
		this.box = _box;
		this.jBox = new js.JQuery(this.box);
		this.jBox.css("position","absolute");
		this.jBox.css("background-color",this.getType());
		this.jBox.css("width","400px");
		this.jBox.css("right","-400px");
		this.jBox.css("top","400px");
		this.jBox.css("font-size","33px");
		this.jBox.css("display","block");
		return this.jBox;
	}
	,text: function(val) {
		this._text = val;
		this.createBox();
	}
	,execute: function() {
		new js.JQuery("body").append(this.jBox);
		this.jBox.animate({ right : 0},300,this.onNote.$bind(this));
	}
	,onNote: function() {
		new js.JQuery("body").animate({ top : 0},3000,this.onDone.$bind(this));
	}
	,onDone: function() {
		this.jBox.animate({ right : -400},300);
	}
	,__class__: microbe.notification.Note
}
if(!microbe.tools) microbe.tools = {}
microbe.tools.Debug = $hxClasses["microbe.tools.Debug"] = function() { }
microbe.tools.Debug.__name__ = ["microbe","tools","Debug"];
microbe.tools.Debug.Alerte = function(str,pos) {
}
microbe.tools.Debug.prototype = {
	__class__: microbe.tools.Debug
}
if(!microbe.vo) microbe.vo = {}
microbe.vo.Spodable = $hxClasses["microbe.vo.Spodable"] = function() { }
microbe.vo.Spodable.__name__ = ["microbe","vo","Spodable"];
microbe.vo.Spodable.prototype = {
	poz: null
	,getFormule: null
	,getDefaultField: null
	,id: null
	,__class__: microbe.vo.Spodable
}
microbe.vo.Taggable = $hxClasses["microbe.vo.Taggable"] = function() { }
microbe.vo.Taggable.__name__ = ["microbe","vo","Taggable"];
microbe.vo.Taggable.prototype = {
	getTags: null
	,__class__: microbe.vo.Taggable
}
js.Boot.__res = {}
js.Boot.__init();
{
	var d = Date;
	d.now = function() {
		return new Date();
	};
	d.fromTime = function(t) {
		var d1 = new Date();
		d1["setTime"](t);
		return d1;
	};
	d.fromString = function(s) {
		switch(s.length) {
		case 8:
			var k = s.split(":");
			var d1 = new Date();
			d1["setTime"](0);
			d1["setUTCHours"](k[0]);
			d1["setUTCMinutes"](k[1]);
			d1["setUTCSeconds"](k[2]);
			return d1;
		case 10:
			var k = s.split("-");
			return new Date(k[0],k[1] - 1,k[2],0,0,0);
		case 19:
			var k = s.split(" ");
			var y = k[0].split("-");
			var t = k[1].split(":");
			return new Date(y[0],y[1] - 1,y[2],t[0],t[1],t[2]);
		default:
			throw "Invalid date format : " + s;
		}
	};
	d.prototype["toString"] = function() {
		var date = this;
		var m = date.getMonth() + 1;
		var d1 = date.getDate();
		var h = date.getHours();
		var mi = date.getMinutes();
		var s = date.getSeconds();
		return date.getFullYear() + "-" + (m < 10?"0" + m:"" + m) + "-" + (d1 < 10?"0" + d1:"" + d1) + " " + (h < 10?"0" + h:"" + h) + ":" + (mi < 10?"0" + mi:"" + mi) + ":" + (s < 10?"0" + s:"" + s);
	};
	d.prototype.__class__ = $hxClasses["Date"] = d;
	d.__name__ = ["Date"];
}
{
	Math.__name__ = ["Math"];
	Math.NaN = Number["NaN"];
	Math.NEGATIVE_INFINITY = Number["NEGATIVE_INFINITY"];
	Math.POSITIVE_INFINITY = Number["POSITIVE_INFINITY"];
	$hxClasses["Math"] = Math;
	Math.isFinite = function(i) {
		return isFinite(i);
	};
	Math.isNaN = function(i) {
		return isNaN(i);
	};
}
{
	String.prototype.__class__ = $hxClasses["String"] = String;
	String.__name__ = ["String"];
	Array.prototype.__class__ = $hxClasses["Array"] = Array;
	Array.__name__ = ["Array"];
	var Int = $hxClasses["Int"] = { __name__ : ["Int"]};
	var Dynamic = $hxClasses["Dynamic"] = { __name__ : ["Dynamic"]};
	var Float = $hxClasses["Float"] = Number;
	Float.__name__ = ["Float"];
	var Bool = $hxClasses["Bool"] = Boolean;
	Bool.__ename__ = ["Bool"];
	var Class = $hxClasses["Class"] = { __name__ : ["Class"]};
	var Enum = { };
	var Void = $hxClasses["Void"] = { __ename__ : ["Void"]};
}
{
	var q = window.jQuery;
	js.JQuery = q;
	q.fn.iterator = function() {
		return { pos : 0, j : this, hasNext : function() {
			return this.pos < this.j.length;
		}, next : function() {
			return $(this.j[this.pos++]);
		}};
	};
}
{
	if(typeof document != "undefined") js.Lib.document = document;
	if(typeof window != "undefined") {
		js.Lib.window = window;
		js.Lib.window.onerror = function(msg,url,line) {
			var f = js.Lib.onerror;
			if(f == null) return false;
			return f(msg,[url + ":" + line]);
		};
	}
}
js["XMLHttpRequest"] = window.XMLHttpRequest?XMLHttpRequest:window.ActiveXObject?function() {
	try {
		return new ActiveXObject("Msxml2.XMLHTTP");
	} catch( e ) {
		try {
			return new ActiveXObject("Microsoft.XMLHTTP");
		} catch( e1 ) {
			throw "Unable to create XMLHttpRequest object.";
		}
	}
}:(function($this) {
	var $r;
	throw "Unable to create XMLHttpRequest object.";
	return $r;
}(this));
var Editor = WYMeditor.editor;
var Wymeditor=window.jQuery;
{
	var Sortable = window.jQuery;
	var SortableEvent={create:"sortcreate",sortstart:"start",sort:"sort",change:"sortchange",sortbeforeStop:"beforeStop",stop:"sortstop",update:"sortupdate",receive:"sortreceive",remove:"sortremove",over:"sortover",out:"sortout",activate:"sortactivate",deactivate:"sortdeactivate"}
}
feffects.Tween.aTweens = new haxe.FastList();
feffects.Tween.aPaused = new haxe.FastList();
feffects.Tween.jsDate = Date.now().getTime();
feffects.Tween.interval = 10;
haxe.Serializer.USE_CACHE = false;
haxe.Serializer.USE_ENUM_INDEX = false;
haxe.Serializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:";
haxe.Unserializer.DEFAULT_RESOLVER = Type;
haxe.Unserializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:";
haxe.Unserializer.CODES = null;
js.Lib.onerror = null;
microbe.TagManager.debug = 1;
microbe.form.AjaxElement.debug = false;
microbe.form.elements.AjaxArea.debug = 0;
microbe.form.elements.CheckBox.debug = false;
microbe.form.elements.CollectionElement.debug = 0;
microbe.form.elements.CollectionElement.deleteSignal = new hxs.Signal4();
microbe.form.elements.CollectionWrapper.debug = 1;
microbe.form.elements.ImageUploader.debug = true;
microbe.form.elements.Mock.debug = 1;
microbe.form.elements.PlusCollectionButton.debug = 0;
microbe.form.elements.PlusCollectionButton.cont = 0;
microbe.form.elements.TagView.debug = 1;
microbe.form.elements.TestCrossAjax.debug = false;
microbe.jsTools.BackJS.debug = 1;
microbe.jsTools.BackJS.base_url = js.Lib.window.location.protocol + "//" + js.Lib.window.location.host;
microbe.jsTools.BackJS.back_url = microbe.jsTools.BackJS.base_url + "/index.php/pipo/";
microbe.jsTools.ElementBinder.debug = 0;
microbe.jsTools.MapParser.debug = 0;
microbe.tools.Debug.debug = false;
microbe.jsTools.BackJS.main();
function $hxExpose(src, path) {
	var o = window;
	var parts = path.split(".");
	for(var ii = 0; ii < parts.length-1; ++ii) {
		var p = parts[ii];
		if(typeof o[p] == "undefined") o[p] = {};
		o = o[p];
	}
	o[parts[parts.length-1]] = src;
}
//@ sourceMappingURL=backjs.js.map