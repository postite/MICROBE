var $hxClasses = $hxClasses || {},$estr = function() { return js.Boot.__string_rec(this,''); };
function $extend(from, fields) {
	function inherit() {}; inherit.prototype = from; var proto = new inherit();
	for (var name in fields) proto[name] = fields[name];
	return proto;
}
var DateTools = $hxClasses["DateTools"] = function() { }
DateTools.__name__ = ["DateTools"];
DateTools.__format_get = function(d,e) {
	return (function($this) {
		var $r;
		switch(e) {
		case "%":
			$r = "%";
			break;
		case "C":
			$r = StringTools.lpad(Std.string(d.getFullYear() / 100 | 0),"0",2);
			break;
		case "d":
			$r = StringTools.lpad(Std.string(d.getDate()),"0",2);
			break;
		case "D":
			$r = DateTools.__format(d,"%m/%d/%y");
			break;
		case "e":
			$r = Std.string(d.getDate());
			break;
		case "H":case "k":
			$r = StringTools.lpad(Std.string(d.getHours()),e == "H"?"0":" ",2);
			break;
		case "I":case "l":
			$r = (function($this) {
				var $r;
				var hour = d.getHours() % 12;
				$r = StringTools.lpad(Std.string(hour == 0?12:hour),e == "I"?"0":" ",2);
				return $r;
			}($this));
			break;
		case "m":
			$r = StringTools.lpad(Std.string(d.getMonth() + 1),"0",2);
			break;
		case "M":
			$r = StringTools.lpad(Std.string(d.getMinutes()),"0",2);
			break;
		case "n":
			$r = "\n";
			break;
		case "p":
			$r = d.getHours() > 11?"PM":"AM";
			break;
		case "r":
			$r = DateTools.__format(d,"%I:%M:%S %p");
			break;
		case "R":
			$r = DateTools.__format(d,"%H:%M");
			break;
		case "s":
			$r = Std.string(d.getTime() / 1000 | 0);
			break;
		case "S":
			$r = StringTools.lpad(Std.string(d.getSeconds()),"0",2);
			break;
		case "t":
			$r = "\t";
			break;
		case "T":
			$r = DateTools.__format(d,"%H:%M:%S");
			break;
		case "u":
			$r = (function($this) {
				var $r;
				var t = d.getDay();
				$r = t == 0?"7":Std.string(t);
				return $r;
			}($this));
			break;
		case "w":
			$r = Std.string(d.getDay());
			break;
		case "y":
			$r = StringTools.lpad(Std.string(d.getFullYear() % 100),"0",2);
			break;
		case "Y":
			$r = Std.string(d.getFullYear());
			break;
		default:
			$r = (function($this) {
				var $r;
				throw "Date.format %" + e + "- not implemented yet.";
				return $r;
			}($this));
		}
		return $r;
	}(this));
}
DateTools.__format = function(d,f) {
	var r = new StringBuf();
	var p = 0;
	while(true) {
		var np = f.indexOf("%",p);
		if(np < 0) break;
		r.b += HxOverrides.substr(f,p,np - p);
		r.b += Std.string(DateTools.__format_get(d,HxOverrides.substr(f,np + 1,1)));
		p = np + 2;
	}
	r.b += HxOverrides.substr(f,p,f.length - p);
	return r.b;
}
DateTools.format = function(d,f) {
	return DateTools.__format(d,f);
}
DateTools.delta = function(d,t) {
	return (function($this) {
		var $r;
		var d1 = new Date();
		d1.setTime(d.getTime() + t);
		$r = d1;
		return $r;
	}(this));
}
DateTools.getMonthDays = function(d) {
	var month = d.getMonth();
	var year = d.getFullYear();
	if(month != 1) return DateTools.DAYS_OF_MONTH[month];
	var isB = year % 4 == 0 && year % 100 != 0 || year % 400 == 0;
	return isB?29:28;
}
DateTools.seconds = function(n) {
	return n * 1000.0;
}
DateTools.minutes = function(n) {
	return n * 60.0 * 1000.0;
}
DateTools.hours = function(n) {
	return n * 60.0 * 60.0 * 1000.0;
}
DateTools.days = function(n) {
	return n * 24.0 * 60.0 * 60.0 * 1000.0;
}
DateTools.parse = function(t) {
	var s = t / 1000;
	var m = s / 60;
	var h = m / 60;
	return { ms : t % 1000, seconds : s % 60 | 0, minutes : m % 60 | 0, hours : h % 24 | 0, days : h / 24 | 0};
}
DateTools.make = function(o) {
	return o.ms + 1000.0 * (o.seconds + 60.0 * (o.minutes + 60.0 * (o.hours + 24.0 * o.days)));
}
var EReg = $hxClasses["EReg"] = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.__name__ = ["EReg"];
EReg.prototype = {
	customReplace: function(s,f) {
		var buf = new StringBuf();
		while(true) {
			if(!this.match(s)) break;
			buf.b += Std.string(this.matchedLeft());
			buf.b += Std.string(f(this));
			s = this.matchedRight();
		}
		buf.b += Std.string(s);
		return buf.b;
	}
	,replace: function(s,by) {
		return s.replace(this.r,by);
	}
	,split: function(s) {
		var d = "#__delim__#";
		return s.replace(this.r,d).split(d);
	}
	,matchedPos: function() {
		if(this.r.m == null) throw "No string matched";
		return { pos : this.r.m.index, len : this.r.m[0].length};
	}
	,matchedRight: function() {
		if(this.r.m == null) throw "No string matched";
		var sz = this.r.m.index + this.r.m[0].length;
		return this.r.s.substr(sz,this.r.s.length - sz);
	}
	,matchedLeft: function() {
		if(this.r.m == null) throw "No string matched";
		return this.r.s.substr(0,this.r.m.index);
	}
	,matched: function(n) {
		return this.r.m != null && n >= 0 && n < this.r.m.length?this.r.m[n]:(function($this) {
			var $r;
			throw "EReg::matched";
			return $r;
		}(this));
	}
	,match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,r: null
	,__class__: EReg
}
var Hash = $hxClasses["Hash"] = function() {
	this.h = { };
};
Hash.__name__ = ["Hash"];
Hash.prototype = {
	toString: function() {
		var s = new StringBuf();
		s.b += Std.string("{");
		var it = this.keys();
		while( it.hasNext() ) {
			var i = it.next();
			s.b += Std.string(i);
			s.b += Std.string(" => ");
			s.b += Std.string(Std.string(this.get(i)));
			if(it.hasNext()) s.b += Std.string(", ");
		}
		s.b += Std.string("}");
		return s.b;
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref["$" + i];
		}};
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key.substr(1));
		}
		return HxOverrides.iter(a);
	}
	,remove: function(key) {
		key = "$" + key;
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,exists: function(key) {
		return this.h.hasOwnProperty("$" + key);
	}
	,get: function(key) {
		return this.h["$" + key];
	}
	,set: function(key,value) {
		this.h["$" + key] = value;
	}
	,h: null
	,__class__: Hash
}
var HxOverrides = $hxClasses["HxOverrides"] = function() { }
HxOverrides.__name__ = ["HxOverrides"];
HxOverrides.dateStr = function(date) {
	var m = date.getMonth() + 1;
	var d = date.getDate();
	var h = date.getHours();
	var mi = date.getMinutes();
	var s = date.getSeconds();
	return date.getFullYear() + "-" + (m < 10?"0" + m:"" + m) + "-" + (d < 10?"0" + d:"" + d) + " " + (h < 10?"0" + h:"" + h) + ":" + (mi < 10?"0" + mi:"" + mi) + ":" + (s < 10?"0" + s:"" + s);
}
HxOverrides.strDate = function(s) {
	switch(s.length) {
	case 8:
		var k = s.split(":");
		var d = new Date();
		d.setTime(0);
		d.setUTCHours(k[0]);
		d.setUTCMinutes(k[1]);
		d.setUTCSeconds(k[2]);
		return d;
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
}
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
}
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
}
HxOverrides.remove = function(a,obj) {
	var i = 0;
	var l = a.length;
	while(i < l) {
		if(a[i] == obj) {
			a.splice(i,1);
			return true;
		}
		i++;
	}
	return false;
}
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
}
var IntHash = $hxClasses["IntHash"] = function() {
	this.h = { };
};
IntHash.__name__ = ["IntHash"];
IntHash.prototype = {
	toString: function() {
		var s = new StringBuf();
		s.b += Std.string("{");
		var it = this.keys();
		while( it.hasNext() ) {
			var i = it.next();
			s.b += Std.string(i);
			s.b += Std.string(" => ");
			s.b += Std.string(Std.string(this.get(i)));
			if(it.hasNext()) s.b += Std.string(", ");
		}
		s.b += Std.string("}");
		return s.b;
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref[i];
		}};
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) a.push(key | 0);
		}
		return HxOverrides.iter(a);
	}
	,remove: function(key) {
		if(!this.h.hasOwnProperty(key)) return false;
		delete(this.h[key]);
		return true;
	}
	,exists: function(key) {
		return this.h.hasOwnProperty(key);
	}
	,get: function(key) {
		return this.h[key];
	}
	,set: function(key,value) {
		this.h[key] = value;
	}
	,h: null
	,__class__: IntHash
}
var IntIter = $hxClasses["IntIter"] = function(min,max) {
	this.min = min;
	this.max = max;
};
IntIter.__name__ = ["IntIter"];
IntIter.prototype = {
	next: function() {
		return this.min++;
	}
	,hasNext: function() {
		return this.min < this.max;
	}
	,max: null
	,min: null
	,__class__: IntIter
}
var Lambda = $hxClasses["Lambda"] = function() { }
Lambda.__name__ = ["Lambda"];
Lambda.array = function(it) {
	var a = new Array();
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		a.push(i);
	}
	return a;
}
Lambda.list = function(it) {
	var l = new List();
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var i = $it0.next();
		l.add(i);
	}
	return l;
}
Lambda.map = function(it,f) {
	var l = new List();
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(f(x));
	}
	return l;
}
Lambda.mapi = function(it,f) {
	var l = new List();
	var i = 0;
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(f(i++,x));
	}
	return l;
}
Lambda.has = function(it,elt,cmp) {
	if(cmp == null) {
		var $it0 = $iterator(it)();
		while( $it0.hasNext() ) {
			var x = $it0.next();
			if(x == elt) return true;
		}
	} else {
		var $it1 = $iterator(it)();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			if(cmp(x,elt)) return true;
		}
	}
	return false;
}
Lambda.exists = function(it,f) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) return true;
	}
	return false;
}
Lambda.foreach = function(it,f) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(!f(x)) return false;
	}
	return true;
}
Lambda.iter = function(it,f) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		f(x);
	}
}
Lambda.filter = function(it,f) {
	var l = new List();
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) l.add(x);
	}
	return l;
}
Lambda.fold = function(it,f,first) {
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		first = f(x,first);
	}
	return first;
}
Lambda.count = function(it,pred) {
	var n = 0;
	if(pred == null) {
		var $it0 = $iterator(it)();
		while( $it0.hasNext() ) {
			var _ = $it0.next();
			n++;
		}
	} else {
		var $it1 = $iterator(it)();
		while( $it1.hasNext() ) {
			var x = $it1.next();
			if(pred(x)) n++;
		}
	}
	return n;
}
Lambda.empty = function(it) {
	return !$iterator(it)().hasNext();
}
Lambda.indexOf = function(it,v) {
	var i = 0;
	var $it0 = $iterator(it)();
	while( $it0.hasNext() ) {
		var v2 = $it0.next();
		if(v == v2) return i;
		i++;
	}
	return -1;
}
Lambda.concat = function(a,b) {
	var l = new List();
	var $it0 = $iterator(a)();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		l.add(x);
	}
	var $it1 = $iterator(b)();
	while( $it1.hasNext() ) {
		var x = $it1.next();
		l.add(x);
	}
	return l;
}
var List = $hxClasses["List"] = function() {
	this.length = 0;
};
List.__name__ = ["List"];
List.prototype = {
	map: function(f) {
		var b = new List();
		var l = this.h;
		while(l != null) {
			var v = l[0];
			l = l[1];
			b.add(f(v));
		}
		return b;
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
	,join: function(sep) {
		var s = new StringBuf();
		var first = true;
		var l = this.h;
		while(l != null) {
			if(first) first = false; else s.b += Std.string(sep);
			s.b += Std.string(l[0]);
			l = l[1];
		}
		return s.b;
	}
	,toString: function() {
		var s = new StringBuf();
		var first = true;
		var l = this.h;
		s.b += Std.string("{");
		while(l != null) {
			if(first) first = false; else s.b += Std.string(", ");
			s.b += Std.string(Std.string(l[0]));
			l = l[1];
		}
		s.b += Std.string("}");
		return s.b;
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
	,clear: function() {
		this.h = null;
		this.q = null;
		this.length = 0;
	}
	,isEmpty: function() {
		return this.h == null;
	}
	,pop: function() {
		if(this.h == null) return null;
		var x = this.h[0];
		this.h = this.h[1];
		if(this.h == null) this.q = null;
		this.length--;
		return x;
	}
	,last: function() {
		return this.q == null?null:this.q[0];
	}
	,first: function() {
		return this.h == null?null:this.h[0];
	}
	,push: function(item) {
		var x = [item,this.h];
		this.h = x;
		if(this.q == null) this.q = x;
		this.length++;
	}
	,add: function(item) {
		var x = [item];
		if(this.h == null) this.h = x; else this.q[1] = x;
		this.q = x;
		this.length++;
	}
	,length: null
	,q: null
	,h: null
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
	return typeof(f) == "function" && !(f.__name__ || f.__ename__);
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
	return t == "string" || t == "object" && !v.__enum__ || t == "function" && (v.__name__ || v.__ename__);
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
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
}
Std.parseFloat = function(x) {
	return parseFloat(x);
}
Std.random = function(x) {
	return Math.floor(Math.random() * x);
}
var StringBuf = $hxClasses["StringBuf"] = function() {
	this.b = "";
};
StringBuf.__name__ = ["StringBuf"];
StringBuf.prototype = {
	toString: function() {
		return this.b;
	}
	,addSub: function(s,pos,len) {
		this.b += HxOverrides.substr(s,pos,len);
	}
	,addChar: function(c) {
		this.b += String.fromCharCode(c);
	}
	,add: function(x) {
		this.b += Std.string(x);
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
	return s.length >= start.length && HxOverrides.substr(s,0,start.length) == start;
}
StringTools.endsWith = function(s,end) {
	var elen = end.length;
	var slen = s.length;
	return slen >= elen && HxOverrides.substr(s,slen - elen,elen) == end;
}
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	return c >= 9 && c <= 13 || c == 32;
}
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return HxOverrides.substr(s,r,l - r); else return s;
}
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
	if(r > 0) return HxOverrides.substr(s,0,l - r); else return s;
}
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
}
StringTools.rpad = function(s,c,l) {
	var sl = s.length;
	var cl = c.length;
	while(sl < l) if(l - sl < cl) {
		s += HxOverrides.substr(c,0,l - sl);
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
		ns += HxOverrides.substr(c,0,l - sl);
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
	return s.charCodeAt(index);
}
StringTools.isEOF = function(c) {
	return c != c;
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
	if(cl == null || !cl.__name__) return null;
	return cl;
}
Type.resolveEnum = function(name) {
	var e = $hxClasses[name];
	if(e == null || !e.__ename__) return null;
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
	HxOverrides.remove(a,"__class__");
	HxOverrides.remove(a,"__properties__");
	return a;
}
Type.getClassFields = function(c) {
	var a = Reflect.fields(c);
	HxOverrides.remove(a,"__name__");
	HxOverrides.remove(a,"__interfaces__");
	HxOverrides.remove(a,"__properties__");
	HxOverrides.remove(a,"__super__");
	HxOverrides.remove(a,"prototype");
	return a;
}
Type.getEnumConstructs = function(e) {
	var a = e.__constructs__;
	return a.slice();
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
		if(v.__name__ || v.__ename__) return ValueType.TObject;
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
var haxe = haxe || {}
haxe.FastList = $hxClasses["haxe.FastList"] = function() {
};
haxe.FastList.__name__ = ["haxe","FastList"];
haxe.FastList.prototype = {
	toString: function() {
		var a = new Array();
		var l = this.head;
		while(l != null) {
			a.push(l.elt);
			l = l.next;
		}
		return "{" + a.join(",") + "}";
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
	,isEmpty: function() {
		return this.head == null;
	}
	,pop: function() {
		var k = this.head;
		if(k == null) return null; else {
			this.head = k.next;
			return k.elt;
		}
	}
	,first: function() {
		return this.head == null?null:this.head.elt;
	}
	,add: function(item) {
		this.head = new haxe.FastCell(item,this.head);
	}
	,head: null
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
	if(easing != null) this.easingF = easing; else if(Reflect.isFunction(obj)) this.easingF = obj; else this.easingF = $bind(this,this.easingEquation);
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
	easingEquation: function(t,b,c,d) {
		return c / 2 * (Math.sin(Math.PI * (t / d - 0.5)) + 1) + b;
	}
	,setEasing: function(easingFunc) {
		if(easingFunc != null) this.easingF = easingFunc;
	}
	,setTweenHandlers: function(update,end) {
		this.updateFunc = update;
		this.endFunc = end;
	}
	,endTween: function() {
		feffects.Tween.RemoveTween(this);
		var val = 0.0;
		if(this.reversed) val = this.initVal; else val = this.endVal;
		if(this.updateFunc != null) this.updateFunc(val);
		if(this.endFunc != null) this.endFunc(val);
		if(this.prop != null) this.obj[this.prop] = val;
	}
	,getCurVal: function(curTime) {
		return this.easingF(curTime,this.initVal,this.endVal - this.initVal,this.duration);
	}
	,doInterval: function() {
		var stamp = new Date().getTime() - feffects.Tween.jsDate;
		var curTime = 0;
		if(this.reversed) curTime = (this.reverseTime << 1) - stamp - this.startTime + this.offsetTime; else curTime = stamp - this.startTime + this.offsetTime;
		var curVal = this.easingF(curTime,this.initVal,this.endVal - this.initVal,this.duration);
		if(curTime >= this.duration || curTime <= 0) this.endTween(); else {
			if(this.updateFunc != null) this.updateFunc(curVal);
			if(this.prop != null) this.obj[this.prop] = curVal;
		}
		this.position = curTime;
	}
	,stop: function() {
		feffects.Tween.RemoveTween(this);
		this.isPlaying = false;
	}
	,reverse: function() {
		this.reversed = !this.reversed;
		if(!this.reversed) this.startTime += new Date().getTime() - feffects.Tween.jsDate - this.reverseTime << 1;
		this.reverseTime = new Date().getTime() - feffects.Tween.jsDate;
	}
	,seek: function(ms) {
		this.offsetTime = ms;
	}
	,resume: function() {
		this.startTime += new Date().getTime() - feffects.Tween.jsDate - this.pauseTime;
		this.reverseTime += new Date().getTime() - feffects.Tween.jsDate - this.pauseTime;
		feffects.Tween.setTweenActive(this);
		this.isPlaying = true;
	}
	,pause: function() {
		this.pauseTime = new Date().getTime() - feffects.Tween.jsDate;
		feffects.Tween.setTweenPaused(this);
		this.isPlaying = false;
	}
	,start: function() {
		if(feffects.Tween.timer != null) feffects.Tween.timer.stop();
		feffects.Tween.timer = new haxe.Timer(feffects.Tween.interval);
		this.startTime = new Date().getTime() - feffects.Tween.jsDate;
		if(this.duration == 0) this.endTween(); else feffects.Tween.AddTween(this);
		this.isPlaying = true;
		this.position = 0;
		this.reverseTime = this.startTime;
		this.reversed = false;
	}
	,prop: null
	,obj: null
	,easingF: null
	,endFunc: null
	,updateFunc: null
	,reverseTime: null
	,offsetTime: null
	,pauseTime: null
	,startTime: null
	,endVal: null
	,initVal: null
	,isPlaying: null
	,reversed: null
	,position: null
	,duration: null
	,__class__: feffects.Tween
}
haxe.Public = $hxClasses["haxe.Public"] = function() { }
haxe.Public.__name__ = ["haxe","Public"];
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
haxe.FastCell = $hxClasses["haxe.FastCell"] = function(elt,next) {
	this.elt = elt;
	this.next = next;
};
haxe.FastCell.__name__ = ["haxe","FastCell"];
haxe.FastCell.prototype = {
	next: null
	,elt: null
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
	onStatus: function(status) {
	}
	,onError: function(msg) {
	}
	,onData: function(data) {
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
	,setPostData: function(data) {
		this.postData = data;
	}
	,setParameter: function(param,value) {
		this.params.set(param,value);
	}
	,setHeader: function(header,value) {
		this.headers.set(header,value);
	}
	,params: null
	,headers: null
	,postData: null
	,async: null
	,url: null
	,__class__: haxe.Http
}
haxe.Json = $hxClasses["haxe.Json"] = function() {
};
haxe.Json.__name__ = ["haxe","Json"];
haxe.Json.parse = function(text) {
	return new haxe.Json().doParse(text);
}
haxe.Json.stringify = function(value) {
	return new haxe.Json().toString(value);
}
haxe.Json.prototype = {
	parseString: function() {
		var start = this.pos;
		var buf = new StringBuf();
		while(true) {
			var c = this.str.charCodeAt(this.pos++);
			if(c == 34) break;
			if(c == 92) {
				buf.b += HxOverrides.substr(this.str,start,this.pos - start - 1);
				c = this.str.charCodeAt(this.pos++);
				switch(c) {
				case 114:
					buf.b += String.fromCharCode(13);
					break;
				case 110:
					buf.b += String.fromCharCode(10);
					break;
				case 116:
					buf.b += String.fromCharCode(9);
					break;
				case 98:
					buf.b += String.fromCharCode(8);
					break;
				case 102:
					buf.b += String.fromCharCode(12);
					break;
				case 47:case 92:case 34:
					buf.b += String.fromCharCode(c);
					break;
				case 117:
					var uc = Std.parseInt("0x" + HxOverrides.substr(this.str,this.pos,4));
					this.pos += 4;
					buf.b += String.fromCharCode(uc);
					break;
				default:
					throw "Invalid escape sequence \\" + String.fromCharCode(c) + " at position " + (this.pos - 1);
				}
				start = this.pos;
			} else if(c != c) throw "Unclosed string";
		}
		buf.b += HxOverrides.substr(this.str,start,this.pos - start - 1);
		return buf.b;
	}
	,parseRec: function() {
		while(true) {
			var c = this.str.charCodeAt(this.pos++);
			switch(c) {
			case 32:case 13:case 10:case 9:
				break;
			case 123:
				var obj = { }, field = null, comma = null;
				while(true) {
					var c1 = this.str.charCodeAt(this.pos++);
					switch(c1) {
					case 32:case 13:case 10:case 9:
						break;
					case 125:
						if(field != null || comma == false) this.invalidChar();
						return obj;
					case 58:
						if(field == null) this.invalidChar();
						obj[field] = this.parseRec();
						field = null;
						comma = true;
						break;
					case 44:
						if(comma) comma = false; else this.invalidChar();
						break;
					case 34:
						if(comma) this.invalidChar();
						field = this.parseString();
						break;
					default:
						this.invalidChar();
					}
				}
				break;
			case 91:
				var arr = [], comma = null;
				while(true) {
					var c1 = this.str.charCodeAt(this.pos++);
					switch(c1) {
					case 32:case 13:case 10:case 9:
						break;
					case 93:
						if(comma == false) this.invalidChar();
						return arr;
					case 44:
						if(comma) comma = false; else this.invalidChar();
						break;
					default:
						if(comma) this.invalidChar();
						this.pos--;
						arr.push(this.parseRec());
						comma = true;
					}
				}
				break;
			case 116:
				var save = this.pos;
				if(this.str.charCodeAt(this.pos++) != 114 || this.str.charCodeAt(this.pos++) != 117 || this.str.charCodeAt(this.pos++) != 101) {
					this.pos = save;
					this.invalidChar();
				}
				return true;
			case 102:
				var save = this.pos;
				if(this.str.charCodeAt(this.pos++) != 97 || this.str.charCodeAt(this.pos++) != 108 || this.str.charCodeAt(this.pos++) != 115 || this.str.charCodeAt(this.pos++) != 101) {
					this.pos = save;
					this.invalidChar();
				}
				return false;
			case 110:
				var save = this.pos;
				if(this.str.charCodeAt(this.pos++) != 117 || this.str.charCodeAt(this.pos++) != 108 || this.str.charCodeAt(this.pos++) != 108) {
					this.pos = save;
					this.invalidChar();
				}
				return null;
			case 34:
				return this.parseString();
			case 48:case 49:case 50:case 51:case 52:case 53:case 54:case 55:case 56:case 57:case 45:
				this.pos--;
				if(!this.reg_float.match(HxOverrides.substr(this.str,this.pos,null))) throw "Invalid float at position " + this.pos;
				var v = this.reg_float.matched(0);
				this.pos += v.length;
				var f = Std.parseFloat(v);
				var i = f | 0;
				return i == f?i:f;
			default:
				this.invalidChar();
			}
		}
	}
	,nextChar: function() {
		return this.str.charCodeAt(this.pos++);
	}
	,invalidChar: function() {
		this.pos--;
		throw "Invalid char " + this.str.charCodeAt(this.pos) + " at position " + this.pos;
	}
	,doParse: function(str) {
		this.reg_float = new EReg("^-?(0|[1-9][0-9]*)(\\.[0-9]+)?([eE][+-]?[0-9]+)?","");
		this.str = str;
		this.pos = 0;
		return this.parseRec();
	}
	,quote: function(s) {
		this.buf.b += Std.string("\"");
		var i = 0;
		while(true) {
			var c = s.charCodeAt(i++);
			if(c != c) break;
			switch(c) {
			case 34:
				this.buf.b += Std.string("\\\"");
				break;
			case 92:
				this.buf.b += Std.string("\\\\");
				break;
			case 10:
				this.buf.b += Std.string("\\n");
				break;
			case 13:
				this.buf.b += Std.string("\\r");
				break;
			case 9:
				this.buf.b += Std.string("\\t");
				break;
			case 8:
				this.buf.b += Std.string("\\b");
				break;
			case 12:
				this.buf.b += Std.string("\\f");
				break;
			default:
				this.buf.b += String.fromCharCode(c);
			}
		}
		this.buf.b += Std.string("\"");
	}
	,toStringRec: function(v) {
		var $e = (Type["typeof"](v));
		switch( $e[1] ) {
		case 8:
			this.buf.b += Std.string("\"???\"");
			break;
		case 4:
			this.objString(v);
			break;
		case 1:
		case 2:
			this.buf.b += Std.string(v);
			break;
		case 5:
			this.buf.b += Std.string("\"<fun>\"");
			break;
		case 6:
			var c = $e[2];
			if(c == String) this.quote(v); else if(c == Array) {
				var v1 = v;
				this.buf.b += Std.string("[");
				var len = v1.length;
				if(len > 0) {
					this.toStringRec(v1[0]);
					var i = 1;
					while(i < len) {
						this.buf.b += Std.string(",");
						this.toStringRec(v1[i++]);
					}
				}
				this.buf.b += Std.string("]");
			} else if(c == Hash) {
				var v1 = v;
				var o = { };
				var $it0 = v1.keys();
				while( $it0.hasNext() ) {
					var k = $it0.next();
					o[k] = v1.get(k);
				}
				this.objString(o);
			} else this.objString(v);
			break;
		case 7:
			var e = $e[2];
			this.buf.b += Std.string(v[1]);
			break;
		case 3:
			this.buf.b += Std.string(v?"true":"false");
			break;
		case 0:
			this.buf.b += Std.string("null");
			break;
		}
	}
	,objString: function(v) {
		this.fieldsString(v,Reflect.fields(v));
	}
	,fieldsString: function(v,fields) {
		var first = true;
		this.buf.b += Std.string("{");
		var _g = 0;
		while(_g < fields.length) {
			var f = fields[_g];
			++_g;
			var value = Reflect.field(v,f);
			if(Reflect.isFunction(value)) continue;
			if(first) first = false; else this.buf.b += Std.string(",");
			this.quote(f);
			this.buf.b += Std.string(":");
			this.toStringRec(value);
		}
		this.buf.b += Std.string("}");
	}
	,toString: function(v) {
		this.buf = new StringBuf();
		this.toStringRec(v);
		return this.buf.b;
	}
	,reg_float: null
	,pos: null
	,str: null
	,buf: null
	,__class__: haxe.Json
}
haxe.Log = $hxClasses["haxe.Log"] = function() { }
haxe.Log.__name__ = ["haxe","Log"];
haxe.Log.trace = function(v,infos) {
	js.Boot.__trace(v,infos);
}
haxe.Log.clear = function() {
	js.Boot.__clear_trace();
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
	serializeException: function(e) {
		this.buf.b += Std.string("x");
		this.serialize(e);
	}
	,serialize: function(v) {
		var $e = (Type["typeof"](v));
		switch( $e[1] ) {
		case 0:
			this.buf.b += Std.string("n");
			break;
		case 1:
			if(v == 0) {
				this.buf.b += Std.string("z");
				return;
			}
			this.buf.b += Std.string("i");
			this.buf.b += Std.string(v);
			break;
		case 2:
			if(Math.isNaN(v)) this.buf.b += Std.string("k"); else if(!Math.isFinite(v)) this.buf.b += Std.string(v < 0?"m":"p"); else {
				this.buf.b += Std.string("d");
				this.buf.b += Std.string(v);
			}
			break;
		case 3:
			this.buf.b += Std.string(v?"t":"f");
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
				this.buf.b += Std.string("a");
				var l = v.length;
				var _g = 0;
				while(_g < l) {
					var i = _g++;
					if(v[i] == null) ucount++; else {
						if(ucount > 0) {
							if(ucount == 1) this.buf.b += Std.string("n"); else {
								this.buf.b += Std.string("u");
								this.buf.b += Std.string(ucount);
							}
							ucount = 0;
						}
						this.serialize(v[i]);
					}
				}
				if(ucount > 0) {
					if(ucount == 1) this.buf.b += Std.string("n"); else {
						this.buf.b += Std.string("u");
						this.buf.b += Std.string(ucount);
					}
				}
				this.buf.b += Std.string("h");
				break;
			case List:
				this.buf.b += Std.string("l");
				var v1 = v;
				var $it0 = v1.iterator();
				while( $it0.hasNext() ) {
					var i = $it0.next();
					this.serialize(i);
				}
				this.buf.b += Std.string("h");
				break;
			case Date:
				var d = v;
				this.buf.b += Std.string("v");
				this.buf.b += Std.string(HxOverrides.dateStr(d));
				break;
			case Hash:
				this.buf.b += Std.string("b");
				var v1 = v;
				var $it1 = v1.keys();
				while( $it1.hasNext() ) {
					var k = $it1.next();
					this.serializeString(k);
					this.serialize(v1.get(k));
				}
				this.buf.b += Std.string("h");
				break;
			case IntHash:
				this.buf.b += Std.string("q");
				var v1 = v;
				var $it2 = v1.keys();
				while( $it2.hasNext() ) {
					var k = $it2.next();
					this.buf.b += Std.string(":");
					this.buf.b += Std.string(k);
					this.serialize(v1.get(k));
				}
				this.buf.b += Std.string("h");
				break;
			case haxe.io.Bytes:
				var v1 = v;
				var i = 0;
				var max = v1.length - 2;
				var charsBuf = new StringBuf();
				var b64 = haxe.Serializer.BASE64;
				while(i < max) {
					var b1 = v1.b[i++];
					var b2 = v1.b[i++];
					var b3 = v1.b[i++];
					charsBuf.b += Std.string(b64.charAt(b1 >> 2));
					charsBuf.b += Std.string(b64.charAt((b1 << 4 | b2 >> 4) & 63));
					charsBuf.b += Std.string(b64.charAt((b2 << 2 | b3 >> 6) & 63));
					charsBuf.b += Std.string(b64.charAt(b3 & 63));
				}
				if(i == max) {
					var b1 = v1.b[i++];
					var b2 = v1.b[i++];
					charsBuf.b += Std.string(b64.charAt(b1 >> 2));
					charsBuf.b += Std.string(b64.charAt((b1 << 4 | b2 >> 4) & 63));
					charsBuf.b += Std.string(b64.charAt(b2 << 2 & 63));
				} else if(i == max + 1) {
					var b1 = v1.b[i++];
					charsBuf.b += Std.string(b64.charAt(b1 >> 2));
					charsBuf.b += Std.string(b64.charAt(b1 << 4 & 63));
				}
				var chars = charsBuf.b;
				this.buf.b += Std.string("s");
				this.buf.b += Std.string(chars.length);
				this.buf.b += Std.string(":");
				this.buf.b += Std.string(chars);
				break;
			default:
				this.cache.pop();
				if(v.hxSerialize != null) {
					this.buf.b += Std.string("C");
					this.serializeString(Type.getClassName(c));
					this.cache.push(v);
					v.hxSerialize(this);
					this.buf.b += Std.string("g");
				} else {
					this.buf.b += Std.string("c");
					this.serializeString(Type.getClassName(c));
					this.cache.push(v);
					this.serializeFields(v);
				}
			}
			break;
		case 4:
			if(this.useCache && this.serializeRef(v)) return;
			this.buf.b += Std.string("o");
			this.serializeFields(v);
			break;
		case 7:
			var e = $e[2];
			if(this.useCache && this.serializeRef(v)) return;
			this.cache.pop();
			this.buf.b += Std.string(this.useEnumIndex?"j":"w");
			this.serializeString(Type.getEnumName(e));
			if(this.useEnumIndex) {
				this.buf.b += Std.string(":");
				this.buf.b += Std.string(v[1]);
			} else this.serializeString(v[0]);
			this.buf.b += Std.string(":");
			var l = v.length;
			this.buf.b += Std.string(l - 2);
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
	,serializeFields: function(v) {
		var _g = 0, _g1 = Reflect.fields(v);
		while(_g < _g1.length) {
			var f = _g1[_g];
			++_g;
			this.serializeString(f);
			this.serialize(Reflect.field(v,f));
		}
		this.buf.b += Std.string("g");
	}
	,serializeRef: function(v) {
		var vt = typeof(v);
		var _g1 = 0, _g = this.cache.length;
		while(_g1 < _g) {
			var i = _g1++;
			var ci = this.cache[i];
			if(typeof(ci) == vt && ci == v) {
				this.buf.b += Std.string("r");
				this.buf.b += Std.string(i);
				return true;
			}
		}
		this.cache.push(v);
		return false;
	}
	,serializeString: function(s) {
		var x = this.shash.get(s);
		if(x != null) {
			this.buf.b += Std.string("R");
			this.buf.b += Std.string(x);
			return;
		}
		this.shash.set(s,this.scount++);
		this.buf.b += Std.string("y");
		s = StringTools.urlEncode(s);
		this.buf.b += Std.string(s.length);
		this.buf.b += Std.string(":");
		this.buf.b += Std.string(s);
	}
	,toString: function() {
		return this.buf.b;
	}
	,useEnumIndex: null
	,useCache: null
	,scount: null
	,shash: null
	,cache: null
	,buf: null
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
	return new Date().getTime() / 1000;
}
haxe.Timer.prototype = {
	run: function() {
	}
	,stop: function() {
		if(this.id == null) return;
		window.clearInterval(this.id);
		this.id = null;
	}
	,id: null
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
		codes[haxe.Unserializer.BASE64.charCodeAt(i)] = i;
	}
	return codes;
}
haxe.Unserializer.run = function(v) {
	return new haxe.Unserializer(v).unserialize();
}
haxe.Unserializer.prototype = {
	unserialize: function() {
		switch(this.buf.charCodeAt(this.pos++)) {
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
				var c = this.buf.charCodeAt(this.pos);
				if(c >= 43 && c < 58 || c == 101 || c == 69) this.pos++; else break;
			}
			return Std.parseFloat(HxOverrides.substr(this.buf,p1,this.pos - p1));
		case 121:
			var len = this.readDigits();
			if(this.buf.charCodeAt(this.pos++) != 58 || this.length - this.pos < len) throw "Invalid string length";
			var s = HxOverrides.substr(this.buf,this.pos,len);
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
				var c = this.buf.charCodeAt(this.pos);
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
			while(this.buf.charCodeAt(this.pos) != 104) l.add(this.unserialize());
			this.pos++;
			return l;
		case 98:
			var h = new Hash();
			this.cache.push(h);
			var buf = this.buf;
			while(this.buf.charCodeAt(this.pos) != 104) {
				var s = this.unserialize();
				h.set(s,this.unserialize());
			}
			this.pos++;
			return h;
		case 113:
			var h = new IntHash();
			this.cache.push(h);
			var buf = this.buf;
			var c = this.buf.charCodeAt(this.pos++);
			while(c == 58) {
				var i = this.readDigits();
				h.set(i,this.unserialize());
				c = this.buf.charCodeAt(this.pos++);
			}
			if(c != 104) throw "Invalid IntHash format";
			return h;
		case 118:
			var d = HxOverrides.strDate(HxOverrides.substr(this.buf,this.pos,19));
			this.cache.push(d);
			this.pos += 19;
			return d;
		case 115:
			var len = this.readDigits();
			var buf = this.buf;
			if(this.buf.charCodeAt(this.pos++) != 58 || this.length - this.pos < len) throw "Invalid bytes length";
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
				var c1 = codes[buf.charCodeAt(i++)];
				var c2 = codes[buf.charCodeAt(i++)];
				bytes.b[bpos++] = (c1 << 2 | c2 >> 4) & 255;
				var c3 = codes[buf.charCodeAt(i++)];
				bytes.b[bpos++] = (c2 << 4 | c3 >> 2) & 255;
				var c4 = codes[buf.charCodeAt(i++)];
				bytes.b[bpos++] = (c3 << 6 | c4) & 255;
			}
			if(rest >= 2) {
				var c1 = codes[buf.charCodeAt(i++)];
				var c2 = codes[buf.charCodeAt(i++)];
				bytes.b[bpos++] = (c1 << 2 | c2 >> 4) & 255;
				if(rest == 3) {
					var c3 = codes[buf.charCodeAt(i++)];
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
			if(this.buf.charCodeAt(this.pos++) != 103) throw "Invalid custom data";
			return o;
		default:
		}
		this.pos--;
		throw "Invalid char " + this.buf.charAt(this.pos) + " at position " + this.pos;
	}
	,unserializeEnum: function(edecl,tag) {
		if(this.buf.charCodeAt(this.pos++) != 58) throw "Invalid enum format";
		var nargs = this.readDigits();
		if(nargs == 0) return Type.createEnum(edecl,tag);
		var args = new Array();
		while(nargs-- > 0) args.push(this.unserialize());
		return Type.createEnum(edecl,tag,args);
	}
	,unserializeObject: function(o) {
		while(true) {
			if(this.pos >= this.length) throw "Invalid object";
			if(this.buf.charCodeAt(this.pos) == 103) break;
			var k = this.unserialize();
			if(!js.Boot.__instanceof(k,String)) throw "Invalid object key";
			var v = this.unserialize();
			o[k] = v;
		}
		this.pos++;
	}
	,readDigits: function() {
		var k = 0;
		var s = false;
		var fpos = this.pos;
		while(true) {
			var c = this.buf.charCodeAt(this.pos);
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
	,get: function(p) {
		return this.buf.charCodeAt(p);
	}
	,getResolver: function() {
		return this.resolver;
	}
	,setResolver: function(r) {
		if(r == null) this.resolver = { resolveClass : function(_) {
			return null;
		}, resolveEnum : function(_) {
			return null;
		}}; else this.resolver = r;
	}
	,resolver: null
	,scache: null
	,cache: null
	,length: null
	,pos: null
	,buf: null
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
		var c = s.charCodeAt(i);
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
	getData: function() {
		return this.b;
	}
	,toHex: function() {
		var s = new StringBuf();
		var chars = [];
		var str = "0123456789abcdef";
		var _g1 = 0, _g = str.length;
		while(_g1 < _g) {
			var i = _g1++;
			chars.push(HxOverrides.cca(str,i));
		}
		var _g1 = 0, _g = this.length;
		while(_g1 < _g) {
			var i = _g1++;
			var c = this.b[i];
			s.b += String.fromCharCode(chars[c >> 4]);
			s.b += String.fromCharCode(chars[c & 15]);
		}
		return s.b;
	}
	,toString: function() {
		return this.readString(0,this.length);
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
	,sub: function(pos,len) {
		if(pos < 0 || len < 0 || pos + len > this.length) throw haxe.io.Error.OutsideBounds;
		return new haxe.io.Bytes(len,this.b.slice(pos,pos + len));
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
	,set: function(pos,v) {
		this.b[pos] = v & 255;
	}
	,get: function(pos) {
		return this.b[pos];
	}
	,b: null
	,length: null
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
haxe.macro.Constant = $hxClasses["haxe.macro.Constant"] = { __ename__ : ["haxe","macro","Constant"], __constructs__ : ["CInt","CFloat","CString","CIdent","CRegexp","CType"] }
haxe.macro.Constant.CInt = function(v) { var $x = ["CInt",0,v]; $x.__enum__ = haxe.macro.Constant; $x.toString = $estr; return $x; }
haxe.macro.Constant.CFloat = function(f) { var $x = ["CFloat",1,f]; $x.__enum__ = haxe.macro.Constant; $x.toString = $estr; return $x; }
haxe.macro.Constant.CString = function(s) { var $x = ["CString",2,s]; $x.__enum__ = haxe.macro.Constant; $x.toString = $estr; return $x; }
haxe.macro.Constant.CIdent = function(s) { var $x = ["CIdent",3,s]; $x.__enum__ = haxe.macro.Constant; $x.toString = $estr; return $x; }
haxe.macro.Constant.CRegexp = function(r,opt) { var $x = ["CRegexp",4,r,opt]; $x.__enum__ = haxe.macro.Constant; $x.toString = $estr; return $x; }
haxe.macro.Constant.CType = function(s) { var $x = ["CType",5,s]; $x.__enum__ = haxe.macro.Constant; $x.toString = $estr; return $x; }
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
haxe.macro.ExprDef = $hxClasses["haxe.macro.ExprDef"] = { __ename__ : ["haxe","macro","ExprDef"], __constructs__ : ["EConst","EArray","EBinop","EField","EParenthesis","EObjectDecl","EArrayDecl","ECall","ENew","EUnop","EVars","EFunction","EBlock","EFor","EIn","EIf","EWhile","ESwitch","ETry","EReturn","EBreak","EContinue","EUntyped","EThrow","ECast","EDisplay","EDisplayNew","ETernary","ECheckType","EType"] }
haxe.macro.ExprDef.EConst = function(c) { var $x = ["EConst",0,c]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EArray = function(e1,e2) { var $x = ["EArray",1,e1,e2]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EBinop = function(op,e1,e2) { var $x = ["EBinop",2,op,e1,e2]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EField = function(e,field) { var $x = ["EField",3,e,field]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EParenthesis = function(e) { var $x = ["EParenthesis",4,e]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EObjectDecl = function(fields) { var $x = ["EObjectDecl",5,fields]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EArrayDecl = function(values) { var $x = ["EArrayDecl",6,values]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.ECall = function(e,params) { var $x = ["ECall",7,e,params]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.ENew = function(t,params) { var $x = ["ENew",8,t,params]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EUnop = function(op,postFix,e) { var $x = ["EUnop",9,op,postFix,e]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EVars = function(vars) { var $x = ["EVars",10,vars]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EFunction = function(name,f) { var $x = ["EFunction",11,name,f]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EBlock = function(exprs) { var $x = ["EBlock",12,exprs]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EFor = function(it,expr) { var $x = ["EFor",13,it,expr]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EIn = function(e1,e2) { var $x = ["EIn",14,e1,e2]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EIf = function(econd,eif,eelse) { var $x = ["EIf",15,econd,eif,eelse]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EWhile = function(econd,e,normalWhile) { var $x = ["EWhile",16,econd,e,normalWhile]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.ESwitch = function(e,cases,edef) { var $x = ["ESwitch",17,e,cases,edef]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.ETry = function(e,catches) { var $x = ["ETry",18,e,catches]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EReturn = function(e) { var $x = ["EReturn",19,e]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EBreak = ["EBreak",20];
haxe.macro.ExprDef.EBreak.toString = $estr;
haxe.macro.ExprDef.EBreak.__enum__ = haxe.macro.ExprDef;
haxe.macro.ExprDef.EContinue = ["EContinue",21];
haxe.macro.ExprDef.EContinue.toString = $estr;
haxe.macro.ExprDef.EContinue.__enum__ = haxe.macro.ExprDef;
haxe.macro.ExprDef.EUntyped = function(e) { var $x = ["EUntyped",22,e]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EThrow = function(e) { var $x = ["EThrow",23,e]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.ECast = function(e,t) { var $x = ["ECast",24,e,t]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EDisplay = function(e,isCall) { var $x = ["EDisplay",25,e,isCall]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EDisplayNew = function(t) { var $x = ["EDisplayNew",26,t]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.ETernary = function(econd,eif,eelse) { var $x = ["ETernary",27,econd,eif,eelse]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.ECheckType = function(e,t) { var $x = ["ECheckType",28,e,t]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
haxe.macro.ExprDef.EType = function(e,field) { var $x = ["EType",29,e,field]; $x.__enum__ = haxe.macro.ExprDef; $x.toString = $estr; return $x; }
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
	pos: null
	,message: null
	,__class__: haxe.macro.Error
}
var hxs = hxs || {}
if(!hxs.core) hxs.core = {}
hxs.core.SignalBase = $hxClasses["hxs.core.SignalBase"] = function(caller) {
	this.slots = new hxs.core.PriorityQueue();
	this.target = caller;
	this.isMuted = false;
	if(!js.Boot.__instanceof(caller,hxs.core.SignalBase)) this.onChanged = new hxs.Signal(this);
};
hxs.core.SignalBase.__name__ = ["hxs","core","SignalBase"];
hxs.core.SignalBase.prototype = {
	onFireSlot: function(slot) {
		if(slot.remainingCalls != -1) {
			if(--slot.remainingCalls <= 0) this.remove(slot.listener);
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
	,muteSlot: function(listener) {
		var _g = 0, _g1 = this.slots.items;
		while(_g < _g1.length) {
			var i = _g1[_g];
			++_g;
			if(i.item.listener == listener) i.item.mute();
		}
	}
	,unmute: function() {
		this.isMuted = false;
	}
	,mute: function() {
		this.isMuted = true;
	}
	,removeAll: function() {
		this.slots = new hxs.core.PriorityQueue();
	}
	,remove: function(listener) {
		var $it0 = this.slots.iterator();
		while( $it0.hasNext() ) {
			var i = $it0.next();
			if(i.listener == listener) this.slots.remove(i);
		}
	}
	,addVoid: function(listener,priority,runCount) {
		if(runCount == null) runCount = -1;
		if(priority == null) priority = 0;
		this.remove(listener);
		this.slots.add(new hxs.core.Slot(listener,hxs.core.SignalType.VOID,runCount),priority);
	}
	,addAdvanced: function(listener,priority,runCount) {
		if(runCount == null) runCount = -1;
		if(priority == null) priority = 0;
		this.remove(listener);
		this.slots.add(new hxs.core.Slot(listener,hxs.core.SignalType.ADVANCED,runCount),priority);
	}
	,addOnce: function(listener,priority) {
		if(priority == null) priority = 0;
		this.add(listener,priority,1);
	}
	,add: function(listener,priority,runCount) {
		if(runCount == null) runCount = -1;
		if(priority == null) priority = 0;
		this.remove(listener);
		this.slots.add(new hxs.core.Slot(listener,hxs.core.SignalType.NORMAL,runCount),priority);
		this.onChanged.dispatch();
	}
	,onChanged: null
	,isMuted: null
	,target: null
	,slots: null
	,__class__: hxs.core.SignalBase
}
hxs.Signal = $hxClasses["hxs.Signal"] = function(caller) {
	hxs.core.SignalBase.call(this,caller);
};
hxs.Signal.__name__ = ["hxs","Signal"];
hxs.Signal.__super__ = hxs.core.SignalBase;
hxs.Signal.prototype = $extend(hxs.core.SignalBase.prototype,{
	getTrigger: function() {
		var _this = this;
		return new hxs.extras.Trigger(function() {
			_this.dispatch();
		});
	}
	,dispatch: function() {
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
	,__class__: hxs.Signal
});
hxs.Signal1 = $hxClasses["hxs.Signal1"] = function(caller) {
	hxs.core.SignalBase.call(this,caller);
};
hxs.Signal1.__name__ = ["hxs","Signal1"];
hxs.Signal1.__super__ = hxs.core.SignalBase;
hxs.Signal1.prototype = $extend(hxs.core.SignalBase.prototype,{
	getTrigger: function(a) {
		var _this = this;
		return new hxs.extras.Trigger(function() {
			_this.dispatch(a);
		});
	}
	,dispatch: function(a) {
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
	,__class__: hxs.Signal1
});
hxs.Signal4 = $hxClasses["hxs.Signal4"] = function(caller) {
	hxs.core.SignalBase.call(this,caller);
};
hxs.Signal4.__name__ = ["hxs","Signal4"];
hxs.Signal4.__super__ = hxs.core.SignalBase;
hxs.Signal4.prototype = $extend(hxs.core.SignalBase.prototype,{
	getTrigger: function(a,b,c,d) {
		var _this = this;
		return new hxs.extras.Trigger(function() {
			_this.dispatch(a,b,c,d);
		});
	}
	,dispatch: function(a,b,c,d) {
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
	,__class__: hxs.Signal4
});
hxs.core.Info = $hxClasses["hxs.core.Info"] = function(signal,slot) {
	this.target = signal.target;
	this.signal = signal;
	this.slot = slot;
};
hxs.core.Info.__name__ = ["hxs","core","Info"];
hxs.core.Info.prototype = {
	slot: null
	,signal: null
	,target: null
	,__class__: hxs.core.Info
}
hxs.core.PriorityQueue = $hxClasses["hxs.core.PriorityQueue"] = function() {
	this.items = [];
};
hxs.core.PriorityQueue.__name__ = ["hxs","core","PriorityQueue"];
hxs.core.PriorityQueue.prototype = {
	resort: function() {
		var a = this.items.slice();
		this.items = [];
		var _g = 0;
		while(_g < a.length) {
			var i = a[_g];
			++_g;
			this.add(i.item,i.priority);
		}
	}
	,getLength: function() {
		return this.items.length;
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
	,getPriority: function(item) {
		var _g = 0, _g1 = this.items;
		while(_g < _g1.length) {
			var i = _g1[_g];
			++_g;
			if(i.item == item) return i.priority;
		}
		return -1;
	}
	,remove: function(item) {
		var _g = 0, _g1 = this.items;
		while(_g < _g1.length) {
			var i = _g1[_g];
			++_g;
			if(i.item == item) HxOverrides.remove(this.items,i);
		}
	}
	,add: function(item,priority) {
		if(priority == null) priority = 0;
		var data = { item : item, priority : priority};
		if(data.priority < 0) data.priority = 0;
		var c = this.items.length;
		while(c-- > 0) if(this.items[c].priority >= priority) break;
		this.items.splice(c + 1,0,data);
		return data;
	}
	,back: function() {
		return this.items.pop().item;
	}
	,front: function() {
		return this.items.shift().item;
	}
	,peek: function() {
		return this.items[0].item;
	}
	,iterator: function() {
		return this.currentIterator = new hxs.core.PriorityQueueIterator(this.items);
	}
	,length: null
	,items: null
	,currentIterator: null
	,__class__: hxs.core.PriorityQueue
	,__properties__: {get_length:"getLength"}
}
hxs.core.PriorityQueueIterator = $hxClasses["hxs.core.PriorityQueueIterator"] = function(q) {
	this.q = q.slice();
	this.reset();
};
hxs.core.PriorityQueueIterator.__name__ = ["hxs","core","PriorityQueueIterator"];
hxs.core.PriorityQueueIterator.prototype = {
	next: function() {
		return this.q[this.i++].item;
	}
	,hasNext: function() {
		return this.i < this.q.length;
	}
	,reset: function() {
		this.i = 0;
	}
	,i: null
	,q: null
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
	unmute: function() {
		this.isMuted = false;
	}
	,mute: function() {
		this.isMuted = true;
	}
	,isMuted: null
	,remainingCalls: null
	,type: null
	,listener: null
	,__class__: hxs.core.Slot
}
if(!hxs.extras) hxs.extras = {}
hxs.extras.Trigger = $hxClasses["hxs.extras.Trigger"] = function(closure) {
	this.closure = closure;
};
hxs.extras.Trigger.__name__ = ["hxs","extras","Trigger"];
hxs.extras.Trigger.prototype = {
	dispatch: function() {
		this.closure();
	}
	,closure: null
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
	var d;
	if(typeof(document) != "undefined" && (d = document.getElementById("haxe:trace")) != null) d.innerHTML += js.Boot.__unhtml(msg) + "<br/>"; else if(typeof(console) != "undefined" && console.log != null) console.log(msg);
}
js.Boot.__clear_trace = function() {
	var d = document.getElementById("haxe:trace");
	if(d != null) d.innerHTML = "";
}
js.Boot.isClass = function(o) {
	return o.__name__;
}
js.Boot.isEnum = function(e) {
	return e.__ename__;
}
js.Boot.getClass = function(o) {
	return o.__class__;
}
js.Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
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
		if(cl == Class && o.__name__ != null) return true; else null;
		if(cl == Enum && o.__ename__ != null) return true; else null;
		return o.__enum__ == cl;
	}
}
js.Boot.__cast = function(o,t) {
	if(js.Boot.__instanceof(o,t)) return o; else throw "Cannot cast " + Std.string(o) + " to " + Std.string(t);
}
js.Lib = $hxClasses["js.Lib"] = function() { }
js.Lib.__name__ = ["js","Lib"];
js.Lib.document = null;
js.Lib.window = null;
js.Lib.debug = function() {
	debugger;
}
js.Lib.alert = function(v) {
	alert(js.Boot.__string_rec(v,""));
}
js.Lib.eval = function(code) {
	return eval(code);
}
js.Lib.setErrorHandler = function(f) {
	js.Lib.onerror = f;
}
var microbe = microbe || {}
microbe.ClassMap = $hxClasses["microbe.ClassMap"] = function() {
};
microbe.ClassMap.__name__ = ["microbe","ClassMap"];
microbe.ClassMap.prototype = {
	toString: function() {
		return this.fields.toString();
	}
	,action: null
	,submit: null
	,fields: null
	,voClass: null
	,id: null
	,__class__: microbe.ClassMap
}
microbe.ClassMapUtils = $hxClasses["microbe.ClassMapUtils"] = function(_map) {
	this.map = _map;
	this.mapFields = new microbe.form.MicroFieldList();
	this.mapFields = this.map.fields;
};
microbe.ClassMapUtils.__name__ = ["microbe","ClassMapUtils"];
microbe.ClassMapUtils.prototype = {
	searchCollecAlgo: function(item) {
		if(item.type == microbe.form.InstanceType.collection && item.voName == this.currentVoName) {
			this.temp.add(item);
			return true;
		} else {
			if(js.Boot.__instanceof(item,microbe.form.MicroFieldList)) item.filter($bind(this,this.searchCollecAlgo));
			return false;
		}
	}
	,parseCollec: function(collec) {
		haxe.Log.trace("<br/>collec=" + collec.getLength(),{ fileName : "ClassMapUtils.hx", lineNumber : 75, className : "microbe.ClassMapUtils", methodName : "parseCollec"});
		haxe.Log.trace("<br/>new Collec=" + Std.string(collec),{ fileName : "ClassMapUtils.hx", lineNumber : 77, className : "microbe.ClassMapUtils", methodName : "parseCollec"});
	}
	,searchCollec: function(voName) {
		this.temp = new List();
		this.currentVoName = voName;
		var result = this.mapFields.filter($bind(this,this.searchCollecAlgo));
		this.currentCollec = result.first();
		return this.currentCollec;
	}
	,addinCollecAt: function(item,pos) {
		var tab = Lambda.array(this.currentCollec.fields);
		tab.splice(pos,0,item);
		this.currentCollec.fields = Lambda.list(tab);
	}
	,addInCollec: function(item) {
		this.currentCollec.add(item);
	}
	,searchinCollecById: function(collectItemid) {
		return this.currentCollec.filter(function(item) {
			js.Lib.alert("item=" + Std.string(item));
			if(item.id == collectItemid) {
				js.Lib.alert("Trouvé" + Std.string(item.id));
				return true;
			}
			return false;
		}).first();
	}
	,searchinCollecByPos: function(pos) {
		return this.currentCollec.filter(function(item) {
			js.Lib.alert("item=" + Std.string(item));
			if(item.pos == pos) {
				js.Lib.alert("Trouvé" + pos);
				return true;
			}
			return false;
		}).first();
	}
	,removeInCurrent: function(list) {
		this.currentCollec.remove(list);
	}
	,temp: null
	,currentVoName: null
	,mapFields: null
	,map: null
	,currentCollec: null
	,__class__: microbe.ClassMapUtils
}
microbe.ERROR_TYPE = $hxClasses["microbe.ERROR_TYPE"] = { __ename__ : ["microbe","ERROR_TYPE"], __constructs__ : ["DOUBLON","FATAL"] }
microbe.ERROR_TYPE.DOUBLON = ["DOUBLON",0];
microbe.ERROR_TYPE.DOUBLON.toString = $estr;
microbe.ERROR_TYPE.DOUBLON.__enum__ = microbe.ERROR_TYPE;
microbe.ERROR_TYPE.FATAL = ["FATAL",1];
microbe.ERROR_TYPE.FATAL.toString = $estr;
microbe.ERROR_TYPE.FATAL.__enum__ = microbe.ERROR_TYPE;
microbe.ERROR = $hxClasses["microbe.ERROR"] = function(type,message,forfield) {
	this.message = message;
	this.type = type;
	this.forfield = forfield;
};
microbe.ERROR.__name__ = ["microbe","ERROR"];
microbe.ERROR.prototype = {
	forfield: null
	,type: null
	,message: null
	,__class__: microbe.ERROR
}
microbe.TagManager = $hxClasses["microbe.TagManager"] = function() {
};
microbe.TagManager.__name__ = ["microbe","TagManager"];
microbe.TagManager.currentspod = null;
microbe.TagManager.getTags = function(spod,spodId) {
	microbe.tools.Debug.Alerte(Std.string(spodId),{ fileName : "TagManager.hx", lineNumber : 353, className : "microbe.TagManager", methodName : "getTags"});
	microbe.tools.Debug.Alerte(microbe.jsTools.BackJS.base_url,{ fileName : "TagManager.hx", lineNumber : 354, className : "microbe.TagManager", methodName : "getTags"});
	var Xreponse = null;
	Xreponse = haxe.Http.requestUrl(microbe.jsTools.BackJS.base_url + "/index.php/gap/tags/spod/" + spod + "/id/" + spodId);
	var reponse = haxe.Unserializer.run(Xreponse);
	microbe.tools.Debug.Alerte(Std.string(reponse),{ fileName : "TagManager.hx", lineNumber : 360, className : "microbe.TagManager", methodName : "getTags"});
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
	id: null
	,tag: null
	,__class__: microbe.Tag
}
if(!microbe.form) microbe.form = {}
microbe.form.AjaxElement = $hxClasses["microbe.form.AjaxElement"] = function(_microfield,_iter) {
	microbe.tools.Debug.Alerte("new",{ fileName : "AjaxElement.hx", lineNumber : 25, className : "microbe.form.AjaxElement", methodName : "new"});
	if(js.Boot.__instanceof(_microfield,microbe.form.Microfield)) {
		this.microfield = _microfield;
		this.id = _microfield.elementId;
		this.field = _microfield.field;
		this.element = _microfield.element;
		this.value = _microfield.value;
	}
	if(js.Boot.__instanceof(_microfield,microbe.form.MicroFieldList)) {
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
	microbe.jsTools.BackSignal.erreur.add($bind(this,this.onError));
};
microbe.form.AjaxElement.__name__ = ["microbe","form","AjaxElement"];
microbe.form.AjaxElement.prototype = {
	setValue: function(val) {
	}
	,getValue: function() {
		return "null";
	}
	,output: function() {
		return "yop";
	}
	,getForm: function() {
		var p = new js.JQuery("#" + this.id).parents("form");
		return p.attr("id");
	}
	,focus: function() {
		new js.JQuery("#" + this.id).addClass("borded");
	}
	,tryAgain: function() {
		var _g = this;
		new js.JQuery(" #" + this.id).focus(function(e) {
			new js.JQuery(" #" + _g.id).css("background","");
		});
	}
	,onError: function(er) {
		haxe.Log.trace("onERROR" + er.forfield + "/" + this.field,{ fileName : "AjaxElement.hx", lineNumber : 50, className : "microbe.form.AjaxElement", methodName : "onError"});
		if(er.forfield != null) {
			if(this.field == er.forfield) {
				haxe.Log.trace("ERROR" + er.forfield + "==?" + this.field + "id=" + this.id,{ fileName : "AjaxElement.hx", lineNumber : 53, className : "microbe.form.AjaxElement", methodName : "onError"});
				new js.JQuery("#" + this.id).css("background","red");
				microbe.jsTools.BackSignal.tryAgain.addOnce($bind(this,this.tryAgain));
			}
		}
	}
	,spodId: null
	,voName: null
	,pos: null
	,value: null
	,element: null
	,field: null
	,microfieldliste: null
	,microfield: null
	,id: null
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
	toString: function() {
		return this.getPreview();
	}
	,getPreview: function() {
		var s = new StringBuf();
		s.b += Std.string(this.getOpenTag());
		if(this.isSubmitted()) s.b += Std.string(this.getErrors());
		s.b += Std.string("<ul>\n");
		var $it0 = this.getElements().iterator();
		while( $it0.hasNext() ) {
			var element = $it0.next();
			if(element != this.submitButton || element != this.deleteButton) s.b += Std.string("\t" + element.getPreview() + "\n");
		}
		if(this.submitButton != null) {
			this.submitButton.form = this;
			s.b += Std.string(this.submitButton.getPreview());
		}
		if(this.deleteButton != null) {
			this.deleteButton.form = this;
			s.b += Std.string(this.deleteButton.render());
		}
		s.b += Std.string("</ul>\n");
		s.b += Std.string(this.getCloseTag());
		return s.b;
	}
	,getErrors: function() {
		if(!this.isSubmitted()) return "";
		var s = new StringBuf();
		var errors = this.getErrorsList();
		if(errors.length > 0) {
			s.b += Std.string("<ul class=\"formErrors\" >");
			var $it0 = errors.iterator();
			while( $it0.hasNext() ) {
				var error = $it0.next();
				s.b += Std.string("<li>" + error + "</li>");
			}
			s.b += Std.string("</ul>");
		}
		return s.b;
	}
	,getSubmittedValue: function() {
		return "";
	}
	,isSubmitted: function() {
		return false;
	}
	,getElements: function() {
		return this.elements;
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
	,addError: function(error) {
		this.extraErrors.add(error);
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
	,getCloseTag: function() {
		var s = new StringBuf();
		s.b += Std.string("<input type=\"hidden\" name=\"" + this.name + "_formSubmitted\" value=\"true\" /></form>");
		return s.b;
	}
	,getOpenTag: function() {
		return "<form id=\"" + this.id + "\" name=\"" + this.name + "\" method=\"" + Std.string(this.method) + "\" action=\"" + this.action + "\" enctype=\"multipart/form-data\" >";
	}
	,clearData: function() {
		var element;
		var $it0 = this.getElements().iterator();
		while( $it0.hasNext() ) {
			var element1 = $it0.next();
			element1.value = null;
		}
	}
	,populateElements: function() {
		var element;
		var $it0 = this.getElements().iterator();
		while( $it0.hasNext() ) {
			var element1 = $it0.next();
			element1.populate();
		}
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
	,getElementTyped: function(name,type) {
		var o = this.getElement(name);
		return o;
	}
	,getValueOf: function(elementName) {
		return this.getElement(elementName).value;
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
	,getLabel: function(elementName) {
		return this.getElement(elementName).getLabel();
	}
	,getFieldsets: function() {
		return this.fieldsets;
	}
	,addFieldset: function(fieldSetKey,fieldSet) {
		fieldSet.form = this;
		this.fieldsets.set(fieldSetKey,fieldSet);
	}
	,setDeleteButton: function(el) {
		return this.deleteButton = el;
	}
	,setSubmitButton: function(el) {
		return this.submitButton = el;
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
	,addElement: function(element,fieldSetKey) {
		if(fieldSetKey == null) fieldSetKey = "__default";
		element.form = this;
		this.elements.add(element);
		if(fieldSetKey != null && this.fieldsets.exists(fieldSetKey)) this.fieldsets.get(fieldSetKey).elements.add(element);
		if(js.Boot.__instanceof(element,microbe.form.elements.RichtextWym)) this.wymEditorCount++;
		return element;
	}
	,wymEditorCount: null
	,submittedButtonName: null
	,defaultClass: null
	,labelRequiredIndicator: null
	,invalidErrorClass: null
	,requiredErrorClass: null
	,requiredClass: null
	,extraErrors: null
	,deleteButton: null
	,submitButton: null
	,forcePopulate: null
	,fieldsets: null
	,elements: null
	,method: null
	,action: null
	,name: null
	,id: null
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
	getCloseTag: function() {
		return "</fieldset>";
	}
	,getOpenTag: function() {
		return "<fieldset id=\"" + this.form.name + "_" + this.name + "\" name=\"" + this.form.name + "_" + this.name + "\" class=\"" + (this.visible?"":"fieldsetNoDisplay") + "\" ><legend>" + this.label + "</legend>";
	}
	,elements: null
	,visible: null
	,label: null
	,form: null
	,name: null
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
	safeString: function(s) {
		return s == null?"":StringTools.htmlEscape(Std.string(s)).split("\"").join("&quot;");
	}
	,test: function() {
		this.init();
		return "popoop" + this.form.name;
	}
	,getClasses: function() {
		var css = this.cssClass != null?this.cssClass:this.form.defaultClass;
		if(this.required && this.form.isSubmitted()) {
			if(this.value == "") css += " " + this.form.requiredErrorClass;
			if(!this.isValid()) css += " " + this.form.invalidErrorClass;
		}
		return StringTools.trim(css);
	}
	,getLabel: function() {
		var n = this.form.name + "_" + this.name;
		if(this.label != null) return "<label for=\"" + n + "\" class=\"" + this.getLabelClasses() + "\" id=\"" + n + "Label\">" + this.label + (this.required?this.form.labelRequiredIndicator:null) + "</label>";
		return null;
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
	,getType: function() {
		return Std.string(Type.getClass(this));
	}
	,getPreview: function() {
		return "<li><span class='labelsp'>" + this.getLabel() + "</span><div>" + this.render() + "</div></li>";
	}
	,remove: function() {
		if(this.form != null) return this.form.removeElement(this);
		return false;
	}
	,render: function(iter) {
		if(!this.inited) this.init();
		return this.value;
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
	,populate: function() {
	}
	,bindEvent: function(event,method,params,isMethodGlobal) {
		if(isMethodGlobal == null) isMethodGlobal = false;
	}
	,addValidator: function(validator) {
		this.validators.add(validator);
	}
	,init: function() {
		this.inited = true;
	}
	,checkValid: function() {
		this.value == "";
	}
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
	,inited: null
	,cssClass: null
	,validators: null
	,active: null
	,attributes: null
	,errors: null
	,required: null
	,value: null
	,description: null
	,label: null
	,name: null
	,form: null
	,__class__: microbe.form.FormElement
}
microbe.form.Formatter = $hxClasses["microbe.form.Formatter"] = function() { }
microbe.form.Formatter.__name__ = ["microbe","form","Formatter"];
microbe.form.Formatter.prototype = {
	format: null
	,__class__: microbe.form.Formatter
}
microbe.form.InstanceType = $hxClasses["microbe.form.InstanceType"] = { __ename__ : ["microbe","form","InstanceType"], __constructs__ : ["formElement","collection","spodable","dataElement"] }
microbe.form.InstanceType.formElement = ["formElement",0];
microbe.form.InstanceType.formElement.toString = $estr;
microbe.form.InstanceType.formElement.__enum__ = microbe.form.InstanceType;
microbe.form.InstanceType.collection = ["collection",1];
microbe.form.InstanceType.collection.toString = $estr;
microbe.form.InstanceType.collection.__enum__ = microbe.form.InstanceType;
microbe.form.InstanceType.spodable = ["spodable",2];
microbe.form.InstanceType.spodable.toString = $estr;
microbe.form.InstanceType.spodable.__enum__ = microbe.form.InstanceType;
microbe.form.InstanceType.dataElement = ["dataElement",3];
microbe.form.InstanceType.dataElement.toString = $estr;
microbe.form.InstanceType.dataElement.__enum__ = microbe.form.InstanceType;
microbe.form.IMicrotype = $hxClasses["microbe.form.IMicrotype"] = function() { }
microbe.form.IMicrotype.__name__ = ["microbe","form","IMicrotype"];
microbe.form.IMicrotype.prototype = {
	toString: null
	,type: null
	,value: null
	,field: null
	,voName: null
	,__class__: microbe.form.IMicrotype
}
microbe.form.MicroFieldList = $hxClasses["microbe.form.MicroFieldList"] = function() {
	this.fields = new List();
};
microbe.form.MicroFieldList.__name__ = ["microbe","form","MicroFieldList"];
microbe.form.MicroFieldList.__interfaces__ = [microbe.form.IMicrotype];
microbe.form.MicroFieldList.prototype = {
	toString: function() {
		this.indent++;
		return "MICROFIELDLIST: " + this.voName + ", TYPE:" + Std.string(this.type) + ", FIELD:" + this.field + "  ID:" + this.id + ",ElementId:" + this.elementId + " pos=" + this.pos + " VALUE:" + this.value + "\n" + this.fields.toString() + "\n";
		return "";
	}
	,map: function(f) {
		return this.fields.map(f);
	}
	,filter: function(f) {
		return this.fields.filter(f);
	}
	,remove: function(v) {
		return this.fields.remove(v);
	}
	,next: function() {
		return this.fields.iterator().next();
	}
	,last: function() {
		return this.fields.last();
	}
	,first: function() {
		return this.fields.first();
	}
	,iterator: function() {
		return this.fields.iterator();
	}
	,add: function(item) {
		this.fields.add(item);
		return item;
	}
	,getLength: function() {
		return this.fields.length;
	}
	,traductable: null
	,taggable: null
	,pos: null
	,length: null
	,indent: null
	,fields: null
	,type: null
	,elementId: null
	,id: null
	,value: null
	,voName: null
	,field: null
	,__class__: microbe.form.MicroFieldList
	,__properties__: {get_length:"getLength"}
}
microbe.form.Microfield = $hxClasses["microbe.form.Microfield"] = function() {
};
microbe.form.Microfield.__name__ = ["microbe","form","Microfield"];
microbe.form.Microfield.__interfaces__ = [microbe.form.IMicrotype];
microbe.form.Microfield.prototype = {
	toString: function() {
		return "\nMICROFIELD :type:" + Std.string(this.type) + "\nfield:" + this.field + ",\nvoName:" + this.voName + ",\nelement:" + this.element + ", \nelementId:" + this.elementId + "\nvalue:" + this.value + "\n";
		return "";
	}
	,type: null
	,value: null
	,elementId: null
	,element: null
	,field: null
	,voName: null
	,voId: null
	,__class__: microbe.form.Microfield
}
microbe.form.Validator = $hxClasses["microbe.form.Validator"] = function() {
	this.errors = new List();
};
microbe.form.Validator.__name__ = ["microbe","form","Validator"];
microbe.form.Validator.prototype = {
	reset: function() {
		this.errors.clear();
	}
	,isValid: function(value) {
		this.errors.clear();
		return true;
	}
	,errors: null
	,__class__: microbe.form.Validator
}
if(!microbe.form.elements) microbe.form.elements = {}
microbe.form.elements.AjaxArea = $hxClasses["microbe.form.elements.AjaxArea"] = function(_microfield) {
	microbe.form.AjaxElement.call(this,_microfield);
};
microbe.form.elements.AjaxArea.__name__ = ["microbe","form","elements","AjaxArea"];
microbe.form.elements.AjaxArea.__super__ = microbe.form.AjaxElement;
microbe.form.elements.AjaxArea.prototype = $extend(microbe.form.AjaxElement.prototype,{
	setValue: function(val) {
		microbe.tools.Debug.Alerte(val,{ fileName : "AjaxArea.hx", lineNumber : 79, className : "microbe.form.elements.AjaxArea", methodName : "setValue"});
		new js.JQuery("#" + this.id).val(val);
	}
	,getValue: function() {
		var val = new js.JQuery("#" + this.id).val();
		microbe.tools.Debug.Alerte(val,{ fileName : "AjaxArea.hx", lineNumber : 75, className : "microbe.form.elements.AjaxArea", methodName : "getValue"});
		return val;
	}
	,moduleid: null
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
	setValue: function(valeur) {
		haxe.Log.trace("date=" + valeur,{ fileName : "AjaxDate.hx", lineNumber : 43, className : "microbe.form.elements.AjaxDate", methodName : "setValue"});
		var _date = null;
		if(valeur == null) {
			haxe.Log.trace("date nulle -> date.now()",{ fileName : "AjaxDate.hx", lineNumber : 46, className : "microbe.form.elements.AjaxDate", methodName : "setValue"});
			valeur = DateTools.format(new Date(),"%Y-%m-%d").toString();
		}
		try {
			_date = HxOverrides.strDate(valeur);
			haxe.Log.trace("parsage de date" + Std.string(_date),{ fileName : "AjaxDate.hx", lineNumber : 52, className : "microbe.form.elements.AjaxDate", methodName : "setValue"});
		} catch( e ) {
			if( js.Boot.__instanceof(e,String) ) {
				js.Lib.alert("erreur de parsage de Date " + e);
				var fake = DateTools.format(new Date(),"%Y-%m-%d").toString();
				_date = HxOverrides.strDate(fake);
			} else throw(e);
		}
		var format = DateTools.format(_date,"%Y-%m-%d");
		new js.JQuery("#madate_" + this.pos).val(format);
	}
	,getValue: function() {
		var valeur = new js.JQuery("#madate_" + this.pos).val();
		haxe.Log.trace("get value valeur=" + valeur,{ fileName : "AjaxDate.hx", lineNumber : 30, className : "microbe.form.elements.AjaxDate", methodName : "getValue"});
		var _date = HxOverrides.strDate(valeur);
		var format = DateTools.format(_date,"%Y-%m-%d");
		haxe.Log.trace("getValue after format" + format,{ fileName : "AjaxDate.hx", lineNumber : 34, className : "microbe.form.elements.AjaxDate", methodName : "getValue"});
		haxe.Log.trace("format=" + format.toString(),{ fileName : "AjaxDate.hx", lineNumber : 36, className : "microbe.form.elements.AjaxDate", methodName : "getValue"});
		return format.toString();
	}
	,getCollectionContainer: function() {
		var p = new js.JQuery("#" + this.id).parents(".collection");
		if(p.attr("pos") != null) return p.attr("pos");
		return "0";
	}
	,__class__: microbe.form.elements.AjaxDate
});
microbe.form.elements.AjaxEditor = $hxClasses["microbe.form.elements.AjaxEditor"] = function(_microfield,iter) {
	microbe.form.AjaxElement.call(this,_microfield);
	this.pos = iter;
	microbe.form.elements.AjaxEditor.self = this;
	this.ed = "editor";
	haxe.Log.trace("new wym",{ fileName : "AjaxEditor.hx", lineNumber : 117, className : "microbe.form.elements.AjaxEditor", methodName : "new"});
	this.base_url = js.Lib.window.location.protocol + "//" + js.Lib.window.location.host;
	this.wymOptions = { };
	this.wymOptions.skin = "compact";
	this.wymOptions.html = this.value;
	this.wym = new $(".editor:visible");
	haxe.Log.trace("after new wym",{ fileName : "AjaxEditor.hx", lineNumber : 153, className : "microbe.form.elements.AjaxEditor", methodName : "new"});
};
microbe.form.elements.AjaxEditor.__name__ = ["microbe","form","elements","AjaxEditor"];
microbe.form.elements.AjaxEditor.self = null;
microbe.form.elements.AjaxEditor.__super__ = microbe.form.AjaxElement;
microbe.form.elements.AjaxEditor.prototype = $extend(microbe.form.AjaxElement.prototype,{
	waitForIt: function(val) {
		if(val == null) val = "";
		if(this.wym != null) {
			this.wymOptions.html = val.toString();
			this.wym.wymeditor(this.wymOptions);
			this.t.stop();
		} else {
			js.Lib.alert("else");
			this.t = haxe.Timer.delay((function(f,a1) {
				return function() {
					return f(a1);
				};
			})($bind(this,this.waitForIt),val),500);
		}
	}
	,setValue: function(val) {
		haxe.Log.trace("set wym",{ fileName : "AjaxEditor.hx", lineNumber : 181, className : "microbe.form.elements.AjaxEditor", methodName : "setValue"});
		new js.JQuery("#" + this.id).attr("value",val);
		this.t = haxe.Timer.delay((function(f,a1) {
			return function() {
				return f(a1);
			};
		})($bind(this,this.waitForIt),val),500);
	}
	,output: function() {
		return "yeah from js";
	}
	,getValue: function() {
		haxe.Log.trace("wym",{ fileName : "AjaxEditor.hx", lineNumber : 172, className : "microbe.form.elements.AjaxEditor", methodName : "getValue"});
		js.JQuery.wymeditors(0).update();
		return new js.JQuery("#" + this.id).attr("value");
	}
	,transformed: null
	,wymOptions: null
	,wym: null
	,ed: null
	,t: null
	,base_url: null
	,formDefaultAction: null
	,__class__: microbe.form.elements.AjaxEditor
});
microbe.form.elements.AjaxInput = $hxClasses["microbe.form.elements.AjaxInput"] = function(_microfield) {
	microbe.form.AjaxElement.call(this,_microfield);
};
microbe.form.elements.AjaxInput.__name__ = ["microbe","form","elements","AjaxInput"];
microbe.form.elements.AjaxInput.__super__ = microbe.form.AjaxElement;
microbe.form.elements.AjaxInput.prototype = $extend(microbe.form.AjaxElement.prototype,{
	setValue: function(val) {
		new js.JQuery("#" + this.id).attr("value",val);
	}
	,getValue: function() {
		return new js.JQuery("#" + this.id).attr("value");
	}
	,moduleid: null
	,__class__: microbe.form.elements.AjaxInput
});
microbe.form.elements.AjaxUploader = $hxClasses["microbe.form.elements.AjaxUploader"] = function(_microfield,_iter) {
	this.setComposant("AjaxUploader");
	microbe.form.AjaxElement.call(this,_microfield,_iter);
	this.self = this;
	this.base_url = js.Lib.window.location.protocol + "//" + js.Lib.window.location.host;
	this.makeIframeUniq();
	this.getBouton().click($bind(this,this.testUpload));
};
microbe.form.elements.AjaxUploader.__name__ = ["microbe","form","elements","AjaxUploader"];
microbe.form.elements.AjaxUploader.__super__ = microbe.form.AjaxElement;
microbe.form.elements.AjaxUploader.prototype = $extend(microbe.form.AjaxElement.prototype,{
	setValue: function(val) {
		if(val != null) this.getpreview().attr("src",js.Lib.window.location.protocol + "//" + js.Lib.window.location.host + "/index.php/imageBase/resize/thumb/" + val); else this.getpreview().attr("src","/microbe/css/assets/blankframe.png");
		this.getRetour().attr("value",val);
	}
	,getValue: function() {
		var retour = this.getRetour().attr("value");
		return retour;
	}
	,enableForm: function() {
		new js.JQuery("input").attr("disabled","");
	}
	,DisableForm: function() {
		new js.JQuery("#" + this.getForm() + " input[name!='" + this.getInputName() + "']").attr("disabled","disabled");
	}
	,getIframe: function() {
		return this.uniqIframe;
	}
	,makeIframeUniq: function() {
		var ifr = new js.JQuery("#" + this.id + " #" + this.getComposant() + "upload_target" + this.getCollectionContainer());
		var oldid = ifr.attr("id");
		ifr.attr("id",oldid + (Math.random() * 2000 | 0));
		this.uniqIframe = ifr.attr("id");
		ifr[0].contentWindow.name = this.uniqIframe;
		js.Lib.alert("uniq=" + this.uniqIframe);
	}
	,getCollectionContainer: function() {
		var p = new js.JQuery("#" + this.id).parents(".collection");
		if(p.attr("pos") != null) return p.attr("pos");
		return "";
	}
	,getpreview: function() {
		return new js.JQuery("#" + this.id + " #" + this.getComposant() + "preview" + this.getCollectionContainer());
	}
	,getInputName: function() {
		var inputName = new js.JQuery("#" + this.id + " #" + this.getComposant() + "fileinput").attr("name");
		return inputName;
	}
	,getRetour: function() {
		var retour = new js.JQuery("#" + this.id + " #" + this.getComposant() + "retour" + this.getCollectionContainer());
		return retour;
	}
	,getBouton: function() {
		return new js.JQuery("#" + this.id + " #uploadButton");
	}
	,onLoad: function(e) {
		var p = new js.JQuery("#" + this.id + " #" + this.getIframe()).contents().text();
		this.setValue(p);
		this.getpreview().fadeTo(0,0);
		this.getpreview().fadeTo(600,1);
		new js.JQuery("#" + this.getForm()).attr("target",this.formDefaultAction);
		this.enableForm();
	}
	,testUpload: function(e) {
		this.DisableForm();
		this.formDefaultAction = new js.JQuery("#" + this.getForm()).attr("target");
		new js.JQuery("#" + this.getForm()).attr("target",this.getIframe());
		js.Lib.alert(new js.JQuery("#" + this.getForm()).attr("target"));
		new js.JQuery("#" + this.id + " #" + this.getIframe()).load($bind(this,this.onLoad));
		new js.JQuery("#" + this.getForm()).attr("action","/index.php/upload");
		new js.JQuery("#" + this.getForm()).submit();
	}
	,setComposant: function(val) {
		this._composantName = val;
		return this._composantName;
	}
	,getComposant: function() {
		return this._composantName;
	}
	,init: function(e) {
		this.getCollectionContainer();
	}
	,composantName: null
	,uniqIframe: null
	,_composantName: null
	,uploadtarget: null
	,base_url: null
	,formDefaultAction: null
	,self: null
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
	populate: function() {
		microbe.form.FormElement.prototype.populate.call(this);
		var n = this.form.name + "_" + this.name;
	}
	,getPreview: function() {
		return "<tr><td></td><td>" + this.render() + "<td></tr>";
	}
	,getLabel: function() {
		var n = this.form.name + "_" + this.name;
		return "<label for=\"" + n + "\" ></label>";
	}
	,toString: function() {
		return this.render();
	}
	,render: function(iter) {
		var _onClick = "";
		if(this.link != null) _onClick = " onclick=" + this.link;
		return "<button type=\"" + Std.string(this.type) + "\" class=\"" + this.getClasses() + "\" name=\"" + this.form.name + "_" + this.name + "\" id=\"" + this.form.name + "_" + this.name + "\" value=\"" + Std.string(this.value) + "\" " + _onClick + " >" + this.label + "</button>";
	}
	,isValid: function() {
		return true;
	}
	,link: null
	,type: null
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
	setValue: function(val) {
		"set_" + Std.string(microbe.tools.Debug.Alerte(val,{ fileName : "CheckBox.hx", lineNumber : 42, className : "microbe.form.elements.CheckBox", methodName : "setValue"}));
		var etat;
		if(val == "true") etat = "checked"; else etat = "";
		new js.JQuery("#" + this.id).attr("checked",etat);
	}
	,getValue: function() {
		var valeur = new js.JQuery("#" + this.id).attr("checked");
		var val;
		if(valeur == true) val = "true"; else val = "false";
		return val;
	}
	,__class__: microbe.form.elements.CheckBox
});
microbe.form.elements.CollectionElement = $hxClasses["microbe.form.elements.CollectionElement"] = function(_liste,_pos) {
	microbe.form.AjaxElement.call(this,_liste,_pos);
	this.elementid = this.id + _pos;
	this.pos = _pos;
	this.collItemId = this.getCollecItemId(new js.JQuery("#" + this.elementid).attr("tri"));
	microbe.tools.Debug.Alerte(Std.string("collecItemId=" + this.collItemId),{ fileName : "CollectionElement.hx", lineNumber : 101, className : "microbe.form.elements.CollectionElement", methodName : "new"});
	new js.JQuery("#" + this.elementid + " .deletecollection").bind("click",$bind(this,this.beforedelete));
};
microbe.form.elements.CollectionElement.__name__ = ["microbe","form","elements","CollectionElement"];
microbe.form.elements.CollectionElement.__super__ = microbe.form.AjaxElement;
microbe.form.elements.CollectionElement.prototype = $extend(microbe.form.AjaxElement.prototype,{
	setValue: function(val) {
		new js.JQuery("#" + this.id).attr("value",val);
	}
	,getValue: function() {
		return new js.JQuery("#" + this.id).attr("value");
	}
	,active: function() {
		new js.JQuery("#uploadButton");
	}
	,'delete': function(e) {
		microbe.tools.Debug.Alerte("delete",{ fileName : "CollectionElement.hx", lineNumber : 121, className : "microbe.form.elements.CollectionElement", methodName : "delete"});
		Std.string("id=" + this.collItemId);
		microbe.form.elements.CollectionElement.deleteSignal.dispatch(this.elementid,this.voName,this.pos,this.collItemId);
	}
	,beforedelete: function(e) {
		var target = new js.JQuery(e.target);
		microbe.tools.Debug.Alerte(target.attr("id"),{ fileName : "CollectionElement.hx", lineNumber : 115, className : "microbe.form.elements.CollectionElement", methodName : "beforedelete"});
		target.text("sure?");
		target.unbind("click",$bind(this,this.beforedelete));
		target.click($bind(this,this.delete));
	}
	,getCollecItemId: function(tri) {
		var splited = Lambda.list(tri.split("_")).last();
		return Std.parseInt(splited);
	}
	,collItemId: null
	,elementid: null
	,__class__: microbe.form.elements.CollectionElement
});
microbe.form.elements.CollectionWrapper = $hxClasses["microbe.form.elements.CollectionWrapper"] = function() {
	this.me = new js.JQuery(".collectionWrapper");
	this.spod = this.me.attr("spod");
	this.createPlusBouton();
	microbe.form.elements.CollectionWrapper.plusInfos = new hxs.Signal1();
	var sortoptions = { };
	sortoptions.update = $bind(this,this.onSortChanged);
	sortoptions.start = $bind(this,this.onSortStart);
	sortoptions.placeholder = "placeHolder";
	sortoptions.opacity = .2;
	this.sort = new $(".collectionWrapper").sortable(sortoptions);
};
microbe.form.elements.CollectionWrapper.__name__ = ["microbe","form","elements","CollectionWrapper"];
microbe.form.elements.CollectionWrapper.plusInfos = null;
microbe.form.elements.CollectionWrapper.prototype = {
	onSortChanged: function(e,ui) {
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
	,dispatchError: function() {
		this.sort.sortable("disable");
		js.Lib.alert("Veuilez enregistrer avant de réarranger l'ordre !");
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
	,notify: function(newColl) {
		microbe.tools.Debug.Alerte("notify",{ fileName : "CollectionWrapper.hx", lineNumber : 106, className : "microbe.form.elements.CollectionWrapper", methodName : "notify"});
		this.me.append(newColl);
	}
	,onPLUS: function(s) {
		microbe.tools.Debug.Alerte("onPlus",{ fileName : "CollectionWrapper.hx", lineNumber : 97, className : "microbe.form.elements.CollectionWrapper", methodName : "onPLUS"});
		this.clone = this.me.children(".collection").last().clone();
		var collength = this.me.children(".collection").length;
		this.clone.attr("id",this.clone.attr("name"));
		microbe.form.elements.CollectionWrapper.plusInfos.dispatch({ collectionName : this.clone.attr("name"), graine : collength, target : this});
	}
	,createPlusBouton: function() {
		var plusString = microbe.form.elements.PlusCollectionButton.create("plusbutton");
		this.me.append(plusString);
		var plus = new microbe.form.elements.PlusCollectionButton(this.me.find(".plusbutton"));
		microbe.form.elements.PlusCollectionButton.sign.add($bind(this,this.onPLUS));
		plus.init();
	}
	,spod: null
	,sort: null
	,clone: null
	,plus: null
	,me: null
	,__class__: microbe.form.elements.CollectionWrapper
}
microbe.form.elements.DeleteButton = $hxClasses["microbe.form.elements.DeleteButton"] = function(id) {
	microbe.form.AjaxElement.call(this,null);
	microbe.form.elements.DeleteButton.sign = new hxs.Signal();
	this.elementid = id;
	new js.JQuery("#" + this.elementid).bind("click",$bind(this,this.onClick));
};
microbe.form.elements.DeleteButton.__name__ = ["microbe","form","elements","DeleteButton"];
microbe.form.elements.DeleteButton.sign = null;
microbe.form.elements.DeleteButton.__super__ = microbe.form.AjaxElement;
microbe.form.elements.DeleteButton.prototype = $extend(microbe.form.AjaxElement.prototype,{
	onTool: function(e) {
		microbe.form.elements.DeleteButton.sign.dispatch();
	}
	,fini: function(e) {
		new js.JQuery("#" + this.elementid + " span").first().text("oui");
		new js.JQuery("#" + this.elementid).css("width","120px").css("text-align","left");
		new js.JQuery("#" + this.elementid).bind("click",$bind(this,this.onTool));
	}
	,anime: function(e) {
		new js.JQuery(".tooltip").css("left",e + "px");
	}
	,onClick: function(event) {
		new js.JQuery("#" + this.elementid).append("<div class='tooltip'><span>sure ?</span></div>");
		var tooltip = new js.JQuery(".tooltip");
		tooltip.css("top","0");
		this.buttonwidth = new js.JQuery("#" + this.elementid).outerWidth();
		var maTween = new feffects.Tween(this.start,this.start + this.buttonwidth / 2,500,feffects.easing.Bounce.easeOut);
		maTween.setTweenHandlers($bind(this,this.anime),$bind(this,this.fini));
		maTween.start();
	}
	,buttonwidth: null
	,start: null
	,tooltip: null
	,elementid: null
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
	toString: function() {
		return this.render();
	}
	,getPreview: function() {
		return this.render();
	}
	,render: function(iter) {
		var n = this.name;
		return n;
	}
	,display: null
	,__class__: microbe.form.elements.FakeElement
});
microbe.form.elements.Hidden = $hxClasses["microbe.form.elements.Hidden"] = function(_microfield) {
	microbe.form.AjaxElement.call(this,_microfield);
};
microbe.form.elements.Hidden.__name__ = ["microbe","form","elements","Hidden"];
microbe.form.elements.Hidden.__super__ = microbe.form.AjaxElement;
microbe.form.elements.Hidden.prototype = $extend(microbe.form.AjaxElement.prototype,{
	setValue: function(val) {
		js.Lib.alert("val=" + val);
		new js.JQuery("#" + this.id).attr("value",val);
	}
	,getValue: function() {
		return new js.JQuery("#" + this.id).attr("value");
	}
	,moduleid: null
	,__class__: microbe.form.elements.Hidden
});
microbe.form.elements.IframeUploader = $hxClasses["microbe.form.elements.IframeUploader"] = function(_microfield,_iter) {
	microbe.form.AjaxElement.call(this,_microfield,_iter);
	this.base_url = js.Lib.window.location.protocol + "//" + js.Lib.window.location.host;
	this.getBouton().click($bind(this,this.testUpload));
};
microbe.form.elements.IframeUploader.__name__ = ["microbe","form","elements","IframeUploader"];
microbe.form.elements.IframeUploader.__super__ = microbe.form.AjaxElement;
microbe.form.elements.IframeUploader.prototype = $extend(microbe.form.AjaxElement.prototype,{
	setValue: function(val) {
		if(val != null) this.getpreview().attr("src",js.Lib.window.location.protocol + "//" + js.Lib.window.location.host + "/index.php/imageBase/resize/thumb/" + val); else this.getpreview().attr("src","/microbe/css/assets/blankframe.png");
		this.getRetour().attr("value",val);
	}
	,getValue: function() {
		var retour = this.getRetour().attr("value");
		return retour;
	}
	,enableForm: function() {
		new js.JQuery("input").attr("disabled","");
	}
	,DisableForm: function() {
		new js.JQuery("#" + this.getForm() + " input[name!='" + this.getInputName() + "']").attr("disabled","disabled");
	}
	,getIframe: function() {
		return "uploadtarget";
	}
	,getpreview: function() {
		return new js.JQuery("#" + this.id + " #preview");
	}
	,getInputName: function() {
		var inputName = new js.JQuery("#" + this.id + " #fileinput").attr("name");
		return inputName;
	}
	,getRetour: function() {
		var retour = new js.JQuery("#" + this.id + " #retour");
		return retour;
	}
	,getBouton: function() {
		return new js.JQuery("#" + this.id + " #uploadButton");
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
	,disableStatus: function() {
		new js.JQuery("#" + this.id + " p.status").remove();
	}
	,testUpload: function(e) {
		this.DisableForm();
		this.disableStatus();
		this.formDefaultAction = new js.JQuery("#" + this.getForm()).attr("target");
		var iframe = "<iframe id='uploadtarget' name='uploadtarget' style='width:0;height:0;border:0px solid #fff;'></iframe>";
		new js.JQuery("#" + this.id).append(iframe);
		new js.JQuery("#" + this.getForm()).attr("target","uploadtarget");
		new js.JQuery("#" + this.id + " #" + this.getIframe()).load($bind(this,this.onLoad));
		new js.JQuery("#" + this.getForm()).attr("action","/index.php/upload");
		new js.JQuery("#" + this.getForm()).submit();
	}
	,init: function(e) {
	}
	,uploadtarget: null
	,base_url: null
	,formDefaultAction: null
	,self: null
	,__class__: microbe.form.elements.IframeUploader
});
microbe.form.elements.ImageUploader = $hxClasses["microbe.form.elements.ImageUploader"] = function(_microfield,_iter) {
	microbe.form.elements.IframeUploader.call(this,_microfield,_iter);
	new js.JQuery("#" + this.id + " .file_input_button").click($bind(this,this.onFake));
	new js.JQuery("#" + this.id + " #cancel").click($bind(this,this.onVide));
};
microbe.form.elements.ImageUploader.__name__ = ["microbe","form","elements","ImageUploader"];
microbe.form.elements.ImageUploader.__super__ = microbe.form.elements.IframeUploader;
microbe.form.elements.ImageUploader.prototype = $extend(microbe.form.elements.IframeUploader.prototype,{
	setValue: function(val) {
		if(val != null && val.length > 0) this.getpreview().attr("src",js.Lib.window.location.protocol + "//" + js.Lib.window.location.host + "/index.php/imageBase/resize/modele/" + val); else this.getpreview().attr("src","/microbe/css/assets/blankframe.png");
		this.getRetour().attr("value",val);
	}
	,onFake: function(e) {
		e.preventDefault();
		new js.JQuery("#" + this.id + " .hiddenfileinput").trigger("click");
	}
	,onVide: function(e) {
		this.setValue(null);
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
	toString: function() {
		return this.render();
	}
	,render: function(iter) {
		var n = this.form.name + "_" + this.name;
		var tType = this.password?"password":"text";
		if(this.showLabelAsDefaultValue && this.value == this.label) this.addValidator(new microbe.form.validators.BoolValidator(false,"Not valid"));
		if((this.value == null || this.value == "") && this.showLabelAsDefaultValue) this.value = this.label;
		var style = this.useSizeValues?"style=\"width:" + this.width + "px\"":"";
		return "<input " + style + " class=\"" + this.getClasses() + "\" type=\"" + tType + "\" name=\"" + n + "\" id=\"" + n + "\" value=\"" + this.safeString(this.value) + "\"  " + this.attributes + " />" + (this.required && this.form.isSubmitted() && this.printRequired?" required":null);
	}
	,formatter: null
	,printRequired: null
	,useSizeValues: null
	,showLabelAsDefaultValue: null
	,width: null
	,password: null
	,__class__: microbe.form.elements.Input
});
microbe.form.elements.Mock = $hxClasses["microbe.form.elements.Mock"] = function(_microfield) {
	microbe.form.AjaxElement.call(this,_microfield);
	microbe.tools.Debug.Alerte(this.id,{ fileName : "Mock.hx", lineNumber : 48, className : "microbe.form.elements.Mock", methodName : "new"});
	var pop = new js.JQuery("#" + this.id + "test").click($bind(this,this.onFake));
};
microbe.form.elements.Mock.__name__ = ["microbe","form","elements","Mock"];
microbe.form.elements.Mock.__super__ = microbe.form.AjaxElement;
microbe.form.elements.Mock.prototype = $extend(microbe.form.AjaxElement.prototype,{
	setValue: function(val) {
		microbe.tools.Debug.Alerte("",{ fileName : "Mock.hx", lineNumber : 64, className : "microbe.form.elements.Mock", methodName : "setValue"});
		new js.JQuery("#" + this.id).attr("value",val);
	}
	,getValue: function() {
		microbe.tools.Debug.Alerte("",{ fileName : "Mock.hx", lineNumber : 59, className : "microbe.form.elements.Mock", methodName : "getValue"});
		return new js.JQuery("#" + this.id).attr("value");
	}
	,onFake: function(e) {
		microbe.tools.Debug.Alerte("onFake",{ fileName : "Mock.hx", lineNumber : 55, className : "microbe.form.elements.Mock", methodName : "onFake"});
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
	init: function() {
		this.me.click($bind(this,this.onClick));
	}
	,onClick: function(e) {
		e.stopImmediatePropagation();
		microbe.form.elements.PlusCollectionButton.sign.dispatch("transport");
		microbe.tools.Debug.Alerte(Std.string(microbe.form.elements.PlusCollectionButton.cont),{ fileName : "PlusCollectionButton.hx", lineNumber : 74, className : "microbe.form.elements.PlusCollectionButton", methodName : "onClick"});
		microbe.form.elements.PlusCollectionButton.cont++;
	}
	,me: null
	,elementid: null
	,transport: null
	,__class__: microbe.form.elements.PlusCollectionButton
}
microbe.form.elements.RecButton = $hxClasses["microbe.form.elements.RecButton"] = function(id) {
	microbe.form.AjaxElement.call(this,null);
	microbe.form.elements.RecButton.sign = new hxs.Signal();
	this.elementid = id;
	new js.JQuery("#" + this.elementid).bind("click",$bind(this,this.onClick));
	microbe.jsTools.BackSignal.tryAgain.add($bind(this,this._tryAgain));
};
microbe.form.elements.RecButton.__name__ = ["microbe","form","elements","RecButton"];
microbe.form.elements.RecButton.sign = null;
microbe.form.elements.RecButton.__super__ = microbe.form.AjaxElement;
microbe.form.elements.RecButton.prototype = $extend(microbe.form.AjaxElement.prototype,{
	AfterRec: function(d) {
		new js.JQuery("#" + this.elementid).css("background","");
	}
	,_tryAgain: function() {
		new js.JQuery("#" + this.elementid).css("background","");
	}
	,onError: function(err) {
		new js.JQuery("#" + this.elementid).css("background","red");
	}
	,onClick: function(event) {
		microbe.jsTools.BackSignal.preredirect.add($bind(this,this.AfterRec));
		new js.JQuery("#" + this.elementid).css("background","green");
	}
	,buttonwidth: null
	,start: null
	,tooltip: null
	,elementid: null
	,__class__: microbe.form.elements.RecButton
});
microbe.form.elements.RichtextWym = $hxClasses["microbe.form.elements.RichtextWym"] = function(_microfield) {
	microbe.form.AjaxElement.call(this,_microfield);
	microbe.form.elements.RichtextWym.self = this;
	this.base_url = js.Lib.window.location.protocol + "//" + js.Lib.window.location.host;
};
microbe.form.elements.RichtextWym.__name__ = ["microbe","form","elements","RichtextWym"];
microbe.form.elements.RichtextWym.self = null;
microbe.form.elements.RichtextWym.__super__ = microbe.form.AjaxElement;
microbe.form.elements.RichtextWym.prototype = $extend(microbe.form.AjaxElement.prototype,{
	setValue: function(val) {
		__js__("wym.html(" + val + ")");
	}
	,output: function() {
		return "yeah from js";
	}
	,getValue: function() {
		return wym.html;
	}
	,base_url: null
	,formDefaultAction: null
	,__class__: microbe.form.elements.RichtextWym
});
microbe.form.elements.TagView = $hxClasses["microbe.form.elements.TagView"] = function(_microfield,_iter) {
	microbe.form.AjaxElement.call(this,_microfield,_iter);
	new js.JQuery("#addTag").click($bind(this,this.onAdd));
	new js.JQuery("#tagSelector select").change($bind(this,this.onSelect));
	this.init();
};
microbe.form.elements.TagView.__name__ = ["microbe","form","elements","TagView"];
microbe.form.elements.TagView.__super__ = microbe.form.AjaxElement;
microbe.form.elements.TagView.prototype = $extend(microbe.form.AjaxElement.prototype,{
	onAdd: function(e) {
		var newTag = new js.JQuery("#tagSelector #pute").val();
		haxe.Log.trace("add" + newTag,{ fileName : "TagView.hx", lineNumber : 177, className : "microbe.form.elements.TagView", methodName : "onAdd"});
		haxe.Log.trace("spodId=" + this.spodId,{ fileName : "TagView.hx", lineNumber : 178, className : "microbe.form.elements.TagView", methodName : "onAdd"});
		js.Lib.alert(microbe.TagManager.addTag(this.voName,this.spodId,newTag));
		haxe.Log.trace("after",{ fileName : "TagView.hx", lineNumber : 180, className : "microbe.form.elements.TagView", methodName : "onAdd"});
		this.init();
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
	,compareTags: function() {
		var $it0 = this.spodTags.iterator();
		while( $it0.hasNext() ) {
			var dispo = $it0.next();
			if(Lambda.has(this.contextTags,dispo)) this.spodTags.remove(dispo);
		}
	}
	,remove: function(e) {
		var tag = new js.JQuery(e.currentTarget).parent(".tagitem").children(".tag").text();
		microbe.TagManager.removeTagFromSpod(this.voName,this.spodId,tag);
		this.init();
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
		new js.JQuery("#tagSelector .tagitem .minus").click($bind(this,this.remove));
	}
	,getTags: function(spod,spodId) {
		microbe.tools.Debug.Alerte("",{ fileName : "TagView.hx", lineNumber : 111, className : "microbe.form.elements.TagView", methodName : "getTags"});
		if(spodId != null) {
			var context = microbe.TagManager.getTags(spod,spodId);
			microbe.tools.Debug.Alerte("",{ fileName : "TagView.hx", lineNumber : 116, className : "microbe.form.elements.TagView", methodName : "getTags"});
			var tags = microbe.TagManager.getTags(spod);
			microbe.tools.Debug.Alerte("",{ fileName : "TagView.hx", lineNumber : 118, className : "microbe.form.elements.TagView", methodName : "getTags"});
			this.contextTags = context;
			microbe.tools.Debug.Alerte("",{ fileName : "TagView.hx", lineNumber : 120, className : "microbe.form.elements.TagView", methodName : "getTags"});
			this.spodTags = tags;
		} else {
			microbe.tools.Debug.Alerte("",{ fileName : "TagView.hx", lineNumber : 123, className : "microbe.form.elements.TagView", methodName : "getTags"});
			this.contextTags = new List();
			this.spodTags = new List();
		}
	}
	,createResultsDiv: function() {
		var str = "<div id='results'></div>";
		var div = new js.JQuery("#tagSelector").append(str);
	}
	,reload: function() {
	}
	,onSelect: function(e) {
		js.Lib.alert("pop");
		var selected = new js.JQuery("#tagSelector select option:selected");
		new js.JQuery("#tagSelector #pute").val(selected.text());
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
			new js.JQuery("#tagSelector #results .result").click($bind(this,this.onSelect));
		} else new js.JQuery("#tagSelector #results").css("display","none");
	}
	,subFind: function(item) {
		var filtre = new js.JQuery("#tagSelector #pute").val();
		if(HxOverrides.substr(Std.string(item),0,filtre.length) == filtre) return true;
		return false;
	}
	,findinSpodTags: function() {
		return Lambda.filter(this.fullTags,$bind(this,this.subFind));
	}
	,onType: function(e) {
		var filtered = this.findinSpodTags();
		this.showResults(filtered);
	}
	,onBlur: function(e) {
		new js.JQuery("#tagSelector #results").hide();
	}
	,init: function() {
		this.getTags(this.voName,this.spodId);
		microbe.tools.Debug.Alerte(Std.string(this.spodTags),{ fileName : "TagView.hx", lineNumber : 33, className : "microbe.form.elements.TagView", methodName : "init"});
		this.afficheTags();
		microbe.tools.Debug.Alerte(Std.string(this.contextTags),{ fileName : "TagView.hx", lineNumber : 35, className : "microbe.form.elements.TagView", methodName : "init"});
		this.populateTags();
		microbe.tools.Debug.Alerte(Std.string(this.fullTags),{ fileName : "TagView.hx", lineNumber : 37, className : "microbe.form.elements.TagView", methodName : "init"});
		new js.JQuery("#tagSelector #pute").keyup($bind(this,this.onType));
		new js.JQuery("#tagSelector #results").blur($bind(this,this.onBlur));
	}
	,filtre: null
	,fullTags: null
	,contextTags: null
	,spodTags: null
	,__class__: microbe.form.elements.TagView
});
microbe.form.elements.TestCrossAjax = $hxClasses["microbe.form.elements.TestCrossAjax"] = function(_microfield,_iter) {
	microbe.tools.Debug.Alerte("",{ fileName : "TestCrossAjax.hx", lineNumber : 48, className : "microbe.form.elements.TestCrossAjax", methodName : "new"});
	microbe.form.AjaxElement.call(this,_microfield,_iter);
	this.self = this;
	this.base_url = js.Lib.window.location.protocol + "//" + js.Lib.window.location.host;
	this.getBouton().click($bind(this,this.testUpload));
};
microbe.form.elements.TestCrossAjax.__name__ = ["microbe","form","elements","TestCrossAjax"];
microbe.form.elements.TestCrossAjax.__super__ = microbe.form.AjaxElement;
microbe.form.elements.TestCrossAjax.prototype = $extend(microbe.form.AjaxElement.prototype,{
	output: function() {
		return "yeah from js";
	}
	,setValue: function(val) {
		this.getpreview().attr("src",js.Lib.window.location.protocol + "//" + js.Lib.window.location.host + "/index.php/imageBase/resize/thumb/" + val);
		this.getRetour().attr("value",val);
	}
	,getValue: function() {
		return new js.JQuery("#retour" + this.getCollectionContainer()).attr("value");
	}
	,setpreview: function(source) {
		this.getpreview().css("width","300px");
		this.getpreview().attr("src",source);
		this.getpreview().fadeTo(0,0);
		this.getpreview().fadeTo(600,1);
	}
	,getCollectionContainer: function() {
		var p = new js.JQuery("#" + this.id).parents(".collection");
		if(p.attr("pos") != null) return p.attr("pos");
		return "";
	}
	,getpreview: function() {
		return new js.JQuery("#" + this.id + " #preview" + this.getCollectionContainer());
	}
	,getInputName: function() {
		return new js.JQuery("#" + this.id + " #fileinput").attr("name");
	}
	,getRetour: function() {
		return new js.JQuery("#" + this.id + " #retour" + this.getCollectionContainer());
	}
	,getBouton: function() {
		return new js.JQuery("#" + this.id + " #uploadButton");
	}
	,active: function() {
		new js.JQuery("#uploadButton");
	}
	,getIframe: function() {
		var ifr = new js.JQuery("#" + "upload_target" + this.getCollectionContainer()).attr("id");
		return ifr;
	}
	,creeIframe: function() {
		new js.JQuery("#" + "myFrame").remove();
		new js.JQuery("<iframe id=\"myFrame\" />").appendTo("body");
	}
	,enableForm: function() {
		new js.JQuery("input").attr("disabled","");
	}
	,DisableEnableForm: function() {
		new js.JQuery("#" + this.getForm() + " input[name!='" + this.getInputName() + "']").attr("disabled","disabled");
	}
	,onLoad: function(e) {
		var p = new js.JQuery("#" + this.getIframe()).contents().text();
		this.setValue(p);
		this.getpreview().fadeTo(0,0);
		this.getpreview().fadeTo(600,1);
		this.enableForm();
	}
	,testUpload: function(e) {
		this.DisableEnableForm();
		new js.JQuery("#" + this.getForm()).attr("target",this.getIframe());
		new js.JQuery("#" + this.getIframe()).load($bind(this,this.onLoad));
		this.formDefaultAction = new js.JQuery("#" + this.getForm()).attr("action");
		new js.JQuery("#" + this.getForm()).attr("action","http://localhost:8888/index.php/upload");
		new js.JQuery("#" + this.getForm()).submit();
	}
	,init: function(e) {
		this.getCollectionContainer();
	}
	,uploadtarget: null
	,base_url: null
	,formDefaultAction: null
	,self: null
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
	isValid: function(value) {
		if(!this.valid) this.errors.push(this.errorNotValid);
		return this.valid;
	}
	,valid: null
	,errorNotValid: null
	,__class__: microbe.form.validators.BoolValidator
});
var mpartial = mpartial || {}
mpartial.Partial = $hxClasses["mpartial.Partial"] = function() { }
mpartial.Partial.__name__ = ["mpartial","Partial"];
if(!microbe.jsTools) microbe.jsTools = {}
microbe.jsTools.BackJS = $hxClasses["microbe.jsTools.BackJS"] = function() {
	this.injected();
	var backSignal = new microbe.jsTools.BackSignal();
	microbe.tools.Mytrace.setRedirection();
	new js.JQuery("document").ready(function(e) {
		microbe.jsTools.BackJS.getInstance().init();
	});
};
microbe.jsTools.BackJS.__name__ = ["microbe","jsTools","BackJS"];
microbe.jsTools.BackJS.__interfaces__ = [mpartial.Partial];
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
	parseplusCollec: function(liste,pos) {
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
		microbe.tools.Debug.Alerte(Std.string(microfield),{ fileName : "BackJS.hx", lineNumber : 354, className : "microbe.jsTools.BackJS", methodName : "parseplusCollec"});
	}
	,onAddItemPlus: function(x,PI) {
		var raw = null;
		try {
			raw = haxe.Unserializer.run(x);
		} catch( err ) {
			if( js.Boot.__instanceof(err,String) ) {
				microbe.tools.Debug.Alerte(err,{ fileName : "BackJS.hx", lineNumber : 333, className : "microbe.jsTools.BackJS", methodName : "onAddItemPlus"});
			} else throw(err);
		}
		PI.target.notify(raw.element);
		this.parseplusCollec(raw.microliste,PI.graine);
	}
	,PlusCollection: function(plusInfos) {
		var _g = this;
		this._plusInfos = plusInfos;
		microbe.tools.Debug.Alerte(Std.string("name" + plusInfos.collectionName + "graine=" + plusInfos.graine),{ fileName : "BackJS.hx", lineNumber : 309, className : "microbe.jsTools.BackJS", methodName : "PlusCollection"});
		var req = new haxe.Http(microbe.jsTools.BackJS.back_url + "addCollectServerItem/");
		microbe.tools.Debug.Alerte(microbe.jsTools.BackJS.back_url,{ fileName : "BackJS.hx", lineNumber : 312, className : "microbe.jsTools.BackJS", methodName : "PlusCollection"});
		req.setParameter("name",plusInfos.collectionName);
		req.setParameter("voParent",this.classMap.voClass);
		req.setParameter("voParentId",Std.string(this.classMap.id));
		req.setParameter("graine",Std.string(plusInfos.graine));
		req.onError = js.Lib.alert;
		req.onData = function(x) {
			_g.onAddItemPlus(x,_g._plusInfos);
		};
		req.request(true);
		microbe.tools.Debug.Alerte("end",{ fileName : "BackJS.hx", lineNumber : 320, className : "microbe.jsTools.BackJS", methodName : "PlusCollection"});
	}
	,_plusInfos: null
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
	,afterError: function(er) {
		haxe.Log.trace("afterError",{ fileName : "BackJS.hx", lineNumber : 267, className : "microbe.jsTools.BackJS", methodName : "afterError"});
		switch( (er.type)[1] ) {
		case 0:
			new microbe.notification.Note(" votre " + er.forfield + " existe dejà",microbe.notification.NoteType.erreur).execute();
			break;
		case 1:
			new microbe.notification.Note("quelque chose s'est mal passé",microbe.notification.NoteType.erreur).execute();
			break;
		}
		microbe.jsTools.BackSignal.tryAgain.dispatch();
	}
	,afterRecord: function(d) {
		haxe.Log.trace("Fter Record",{ fileName : "BackJS.hx", lineNumber : 260, className : "microbe.jsTools.BackJS", methodName : "afterRecord"});
		js.Lib.window.location.href = microbe.jsTools.BackJS.back_url + "nav/" + this.classMap.voClass + "/" + this.classMap.id;
	}
	,preRedirect: function(d) {
		var retour = null;
		try {
			retour = haxe.Unserializer.run(d);
		} catch( m ) {
			if( js.Boot.__instanceof(m,String) ) {
				retour = d;
			} else throw(m);
		}
		if(js.Boot.__instanceof(retour,microbe.ERROR)) {
			microbe.jsTools.BackSignal.erreur.dispatch(retour);
			return this.afterError(retour);
		}
		this.classMap.id = retour;
		microbe.jsTools.BackSignal.preredirectomplete.add($bind(this,this.afterRecord));
		if(microbe.jsTools.BackSignal.preredirect.get_numListeners() > 1) {
			haxe.Log.trace("numListenersfor before redirect=" + microbe.jsTools.BackSignal.preredirect.get_numListeners(),{ fileName : "BackJS.hx", lineNumber : 251, className : "microbe.jsTools.BackJS", methodName : "preRedirect"});
			microbe.jsTools.BackSignal.preredirect.dispatch(d);
		} else microbe.jsTools.BackSignal.preredirectomplete.dispatch("nib");
		return null;
	}
	,microRecord: function(m) {
		haxe.Log.trace("classMAp=" + Std.string(this.classMap) + "back_url=" + microbe.jsTools.BackJS.back_url,{ fileName : "BackJS.hx", lineNumber : 226, className : "microbe.jsTools.BackJS", methodName : "microRecord"});
		var req = new haxe.Http(microbe.jsTools.BackJS.back_url + "microRec/");
		req.setParameter("micromap",haxe.Serializer.run(m));
		req.onData = function(d) {
			microbe.jsTools.BackSignal.requestSavingComplete.dispatch(d);
		};
		req.request(true);
	}
	,AjaxFormTraitement: function() {
		var _g = this;
		microbe.tools.Debug.Alerte(Std.string(this.classMap),{ fileName : "BackJS.hx", lineNumber : 211, className : "microbe.jsTools.BackJS", methodName : "AjaxFormTraitement"});
		haxe.Log.trace("classMAp=" + Std.string(this.classMap),{ fileName : "BackJS.hx", lineNumber : 212, className : "microbe.jsTools.BackJS", methodName : "AjaxFormTraitement"});
		var compressedValues = haxe.Serializer.run(this.classMap);
		haxe.Log.trace("classMAp=" + Std.string(this.classMap) + "back_url=" + microbe.jsTools.BackJS.back_url,{ fileName : "BackJS.hx", lineNumber : 215, className : "microbe.jsTools.BackJS", methodName : "AjaxFormTraitement"});
		var req = new haxe.Http(microbe.jsTools.BackJS.back_url + "rec/");
		req.setParameter("map",compressedValues);
		req.onData = function(d) {
			_g.preRedirect(d);
		};
		req.request(true);
	}
	,record: function() {
		haxe.Log.trace("clika" + Std.string(this.microbeElements),{ fileName : "BackJS.hx", lineNumber : 194, className : "microbe.jsTools.BackJS", methodName : "record"});
		var $it0 = this.microbeElements.iterator();
		while( $it0.hasNext() ) {
			var mic = $it0.next();
			if(mic.element != null) mic.microfield.value = mic.getValue();
		}
		this.AjaxFormTraitement();
		haxe.Log.trace("finrecord",{ fileName : "BackJS.hx", lineNumber : 206, className : "microbe.jsTools.BackJS", methodName : "record"});
	}
	,spodDelete: function(voName,id) {
		microbe.tools.Debug.Alerte("",{ fileName : "BackJS.hx", lineNumber : 186, className : "microbe.jsTools.BackJS", methodName : "spodDelete"});
		var reponse = haxe.Http.requestUrl(microbe.jsTools.BackJS.back_url + "delete/" + voName + "/" + id);
	}
	,deleteSpod: function() {
		js.Lib.window.location.href = microbe.jsTools.BackJS.back_url + "delete/" + this.classMap.voClass + "/" + this.classMap.id;
	}
	,onAjoute: function(e) {
		microbe.tools.Debug.Alerte("ajoute",{ fileName : "BackJS.hx", lineNumber : 172, className : "microbe.jsTools.BackJS", methodName : "onAjoute"});
		js.Lib.window.location.href = microbe.jsTools.BackJS.back_url + "ajoute/" + this.currentVo;
	}
	,listen: function() {
		microbe.tools.Debug.Alerte("listen",{ fileName : "BackJS.hx", lineNumber : 162, className : "microbe.jsTools.BackJS", methodName : "listen"});
		microbe.form.elements.CollectionElement.deleteSignal.add($bind(this,this.deleteCollection));
		microbe.form.elements.DeleteButton.sign.add($bind(this,this.deleteSpod));
		new js.JQuery(".ajout").click($bind(this,this.onAjoute));
	}
	,setClassMap: function(compressedMap) {
		this.classMap = haxe.Unserializer.run(compressedMap);
	}
	,onSortChanged: function(e,ui) {
		var pop = this.sort.sortable("serialize",{ attribute : "tri", key : "id"});
		haxe.Log.trace(pop,{ fileName : "BackJS.hx", lineNumber : 138, className : "microbe.jsTools.BackJS", methodName : "onSortChanged"});
		var liste = pop.split("&id=");
		liste[0] = liste[0].split("id=")[1];
		var req = new haxe.Http(microbe.jsTools.BackJS.back_url + "reorder/" + this.currentVo);
		req.setParameter("orderedList",haxe.Serializer.run(liste));
		req.onData = function(d) {
			haxe.Log.trace(d,{ fileName : "BackJS.hx", lineNumber : 147, className : "microbe.jsTools.BackJS", methodName : "onSortChanged"});
		};
		req.request(true);
		haxe.Log.trace("afterreorder",{ fileName : "BackJS.hx", lineNumber : 149, className : "microbe.jsTools.BackJS", methodName : "onSortChanged"});
	}
	,start: function() {
		if(this.classMap != null) {
			new microbe.form.elements.RecButton(this.classMap.submit);
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
			microbe.form.elements.CollectionWrapper.plusInfos.add($bind(this,this.PlusCollection));
			var sortoptions = { };
			sortoptions.placeholder = "placeHolder";
			sortoptions.opacity = .2;
			sortoptions.update = $bind(this,this.onSortChanged);
			this.sort = new $("#leftCol .itemslist").sortable(sortoptions);
			this.listen();
		}
	}
	,init: function() {
		this.start();
		microbe.jsTools.BackSignal.requestSaving.add($bind(this,this.microRecord));
	}
	,injected: function() {
		haxe.Log.trace("injected natif",{ fileName : "BackJS.hx", lineNumber : 65, className : "microbe.jsTools.BackJS", methodName : "injected"});
	}
	,sort: null
	,tamereenslip: null
	,microbeElements: null
	,classMap: null
	,currentVo: null
	,__class__: microbe.jsTools.BackJS
}
var msignal = msignal || {}
msignal.Signal = $hxClasses["msignal.Signal"] = function(valueClasses) {
	if(valueClasses == null) valueClasses = [];
	this.valueClasses = valueClasses;
	this.slots = msignal.SlotList.NIL;
	this.priorityBased = false;
};
msignal.Signal.__name__ = ["msignal","Signal"];
msignal.Signal.prototype = {
	get_numListeners: function() {
		return this.slots.get_length();
	}
	,createSlot: function(listener,once,priority) {
		if(priority == null) priority = 0;
		if(once == null) once = false;
		return null;
	}
	,registrationPossible: function(listener,once) {
		if(!this.slots.nonEmpty) return true;
		var existingSlot = this.slots.find(listener);
		if(existingSlot == null) return true;
		if(existingSlot.once != once) throw "You cannot addOnce() then add() the same listener without removing the relationship first.";
		return false;
	}
	,registerListener: function(listener,once,priority) {
		if(priority == null) priority = 0;
		if(once == null) once = false;
		if(this.registrationPossible(listener,once)) {
			var newSlot = this.createSlot(listener,once,priority);
			if(!this.priorityBased && priority != 0) this.priorityBased = true;
			if(!this.priorityBased && priority == 0) this.slots = this.slots.prepend(newSlot); else this.slots = this.slots.insertWithPriority(newSlot);
			return newSlot;
		}
		return this.slots.find(listener);
	}
	,removeAll: function() {
		this.slots = msignal.SlotList.NIL;
	}
	,remove: function(listener) {
		var slot = this.slots.find(listener);
		if(slot == null) return null;
		this.slots = this.slots.filterNot(listener);
		return slot;
	}
	,addOnceWithPriority: function(listener,priority) {
		if(priority == null) priority = 0;
		return this.registerListener(listener,true,priority);
	}
	,addWithPriority: function(listener,priority) {
		if(priority == null) priority = 0;
		return this.registerListener(listener,false,priority);
	}
	,addOnce: function(listener) {
		return this.registerListener(listener,true);
	}
	,add: function(listener) {
		return this.registerListener(listener);
	}
	,priorityBased: null
	,slots: null
	,numListeners: null
	,valueClasses: null
	,__class__: msignal.Signal
	,__properties__: {get_numListeners:"get_numListeners"}
}
msignal.Signal1 = $hxClasses["msignal.Signal1"] = function(type) {
	msignal.Signal.call(this,[type]);
};
msignal.Signal1.__name__ = ["msignal","Signal1"];
msignal.Signal1.__super__ = msignal.Signal;
msignal.Signal1.prototype = $extend(msignal.Signal.prototype,{
	createSlot: function(listener,once,priority) {
		if(priority == null) priority = 0;
		if(once == null) once = false;
		return new msignal.Slot1(this,listener,once,priority);
	}
	,dispatch: function(value) {
		var slotsToProcess = this.slots;
		while(slotsToProcess.nonEmpty) {
			slotsToProcess.head.execute(value);
			slotsToProcess = slotsToProcess.tail;
		}
	}
	,__class__: msignal.Signal1
});
microbe.jsTools.BackSignal = $hxClasses["microbe.jsTools.BackSignal"] = function() {
	microbe.jsTools.BackSignal.preredirect = new msignal.Signal1();
	microbe.jsTools.BackSignal.preredirectomplete = new msignal.Signal1();
	microbe.jsTools.BackSignal.requestSaving = new msignal.Signal1();
	microbe.jsTools.BackSignal.requestSavingComplete = new msignal.Signal1();
	microbe.jsTools.BackSignal.erreur = new msignal.Signal1();
	microbe.jsTools.BackSignal.tryAgain = new msignal.Signal0();
	msignal.Signal1.call(this,String);
};
microbe.jsTools.BackSignal.__name__ = ["microbe","jsTools","BackSignal"];
microbe.jsTools.BackSignal.preredirect = null;
microbe.jsTools.BackSignal.preredirectomplete = null;
microbe.jsTools.BackSignal.requestSaving = null;
microbe.jsTools.BackSignal.requestSavingComplete = null;
microbe.jsTools.BackSignal.erreur = null;
microbe.jsTools.BackSignal.tryAgain = null;
microbe.jsTools.BackSignal.__super__ = msignal.Signal1;
microbe.jsTools.BackSignal.prototype = $extend(msignal.Signal1.prototype,{
	__class__: microbe.jsTools.BackSignal
});
microbe.jsTools.ElementBinder = $hxClasses["microbe.jsTools.ElementBinder"] = function() {
	this.elements = new List();
};
microbe.jsTools.ElementBinder.__name__ = ["microbe","jsTools","ElementBinder"];
microbe.jsTools.ElementBinder.prototype = {
	iterator: function() {
		return this.elements.iterator();
	}
	,add: function(element) {
		this.elements.add(element);
	}
	,createElement: function(microChamps) {
		if(microChamps.element != null) {
			var d = null;
			try {
				var classe = Type.resolveClass(microChamps.element);
				if(classe == null) throw "not a component";
				d = Type.createInstance(classe,[microChamps]);
			} catch( msg ) {
				if( js.Boot.__instanceof(msg,String) ) {
					js.Lib.alert("le composant : " + microChamps.element + " n'existe pas : " + msg);
				} else throw(msg);
			}
			this.add(d);
		} else {
			var fake = new microbe.form.AjaxElement(microChamps);
			this.add(fake);
		}
	}
	,createCollectionElement: function(microChamps,position) {
		var d = Type.createInstance(Type.resolveClass("microbe.form.elements.CollectionElement"),[microChamps,position]);
		microbe.tools.Debug.Alerte(Std.string(position + "-pos"),{ fileName : "ElementBinder.hx", lineNumber : 37, className : "microbe.jsTools.ElementBinder", methodName : "createCollectionElement"});
	}
	,elements: null
	,__class__: microbe.jsTools.ElementBinder
}
microbe.jsTools.MapParser = $hxClasses["microbe.jsTools.MapParser"] = function(_microbeElements) {
	this.microbeElements = _microbeElements;
};
microbe.jsTools.MapParser.__name__ = ["microbe","jsTools","MapParser"];
microbe.jsTools.MapParser.prototype = {
	recurMap: function(liste) {
		microbe.tools.Debug.Alerte("recurMap",{ fileName : "MapParser.hx", lineNumber : 48, className : "microbe.jsTools.MapParser", methodName : "recurMap"});
		var pos = 0;
		var $it0 = liste.iterator();
		while( $it0.hasNext() ) {
			var chps = $it0.next();
			if(js.Boot.__instanceof(chps,microbe.form.MicroFieldList)) {
				if(chps.type == microbe.form.InstanceType.collection) {
					var $it1 = (js.Boot.__cast(chps , microbe.form.MicroFieldList)).fields.iterator();
					while( $it1.hasNext() ) {
						var item = $it1.next();
						this.microbeElements.createCollectionElement(chps,pos);
						pos++;
					}
				}
				this.recurMap(js.Boot.__cast(chps , microbe.form.MicroFieldList));
			} else {
				var microChamps = chps;
				this.microbeElements.createElement(microChamps);
			}
		}
	}
	,parse: function(_map) {
		microbe.tools.Debug.Alerte("",{ fileName : "MapParser.hx", lineNumber : 30, className : "microbe.jsTools.MapParser", methodName : "parse"});
		this.map = _map;
		var liste = this.map.fields;
		this.recurMap(liste);
		microbe.tools.Debug.Alerte("afterparse",{ fileName : "MapParser.hx", lineNumber : 41, className : "microbe.jsTools.MapParser", methodName : "parse"});
	}
	,microbeElements: null
	,map: null
	,__class__: microbe.jsTools.MapParser
}
if(!microbe.macroUtils) microbe.macroUtils = {}
microbe.macroUtils.Imports = $hxClasses["microbe.macroUtils.Imports"] = function() { }
microbe.macroUtils.Imports.__name__ = ["microbe","macroUtils","Imports"];
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
	finsished: function() {
		this.jBox.remove();
	}
	,onDone: function() {
		this.jBox.animate({ right : -400},300,$bind(this,this.finsished));
	}
	,onNote: function() {
		new js.JQuery("body").animate({ top : 0},3000,$bind(this,this.onDone));
	}
	,execute: function() {
		new js.JQuery("body").append(this.jBox);
		this.jBox.animate({ right : 0},300,$bind(this,this.onNote));
	}
	,text: function(val) {
		this._text = val;
		this.createBox();
	}
	,createBox: function() {
		var _box = "<div class='note'>" + this._text + "</div>";
		this.box = _box;
		var winPos = new js.JQuery(js.Lib.window).scrollTop();
		this.jBox = new js.JQuery(this.box);
		this.jBox.css("position","absolute");
		this.jBox.css("background-color",this.getType());
		this.jBox.css("width","400px");
		this.jBox.css("right","-400px");
		this.jBox.css("top",winPos + 400 + "px");
		this.jBox.css("font-size","33px");
		this.jBox.css("display","block");
		return this.jBox;
	}
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
	,color: null
	,noteType: null
	,jBox: null
	,box: null
	,_text: null
	,__class__: microbe.notification.Note
}
if(!microbe.tools) microbe.tools = {}
microbe.tools.Debug = $hxClasses["microbe.tools.Debug"] = function() { }
microbe.tools.Debug.__name__ = ["microbe","tools","Debug"];
microbe.tools.Debug.Alerte = function(str,pos) {
}
microbe.tools.Mytrace = $hxClasses["microbe.tools.Mytrace"] = function() { }
microbe.tools.Mytrace.__name__ = ["microbe","tools","Mytrace"];
microbe.tools.Mytrace.setRedirection = function() {
	haxe.Log.trace = microbe.tools.Mytrace.mytrace;
}
microbe.tools.Mytrace.mytrace = function(v,inf) {
	console.log(Std.string(v) + " ::> \n " + inf.fileName + " " + inf.lineNumber + " " + inf.methodName);
}
if(!microbe.vo) microbe.vo = {}
microbe.vo.Spodable = $hxClasses["microbe.vo.Spodable"] = function() { }
microbe.vo.Spodable.__name__ = ["microbe","vo","Spodable"];
microbe.vo.Spodable.prototype = {
	id: null
	,getDefaultField: null
	,getFormule: null
	,poz: null
	,__class__: microbe.vo.Spodable
}
microbe.vo.Taggable = $hxClasses["microbe.vo.Taggable"] = function() { }
microbe.vo.Taggable.__name__ = ["microbe","vo","Taggable"];
microbe.vo.Taggable.prototype = {
	getTags: null
	,__class__: microbe.vo.Taggable
}
msignal.Signal0 = $hxClasses["msignal.Signal0"] = function() {
	msignal.Signal.call(this);
};
msignal.Signal0.__name__ = ["msignal","Signal0"];
msignal.Signal0.__super__ = msignal.Signal;
msignal.Signal0.prototype = $extend(msignal.Signal.prototype,{
	createSlot: function(listener,once,priority) {
		if(priority == null) priority = 0;
		if(once == null) once = false;
		return new msignal.Slot0(this,listener,once,priority);
	}
	,dispatch: function() {
		var slotsToProcess = this.slots;
		while(slotsToProcess.nonEmpty) {
			slotsToProcess.head.execute();
			slotsToProcess = slotsToProcess.tail;
		}
	}
	,__class__: msignal.Signal0
});
msignal.Signal2 = $hxClasses["msignal.Signal2"] = function(type1,type2) {
	msignal.Signal.call(this,[type1,type2]);
};
msignal.Signal2.__name__ = ["msignal","Signal2"];
msignal.Signal2.__super__ = msignal.Signal;
msignal.Signal2.prototype = $extend(msignal.Signal.prototype,{
	createSlot: function(listener,once,priority) {
		if(priority == null) priority = 0;
		if(once == null) once = false;
		return new msignal.Slot2(this,listener,once,priority);
	}
	,dispatch: function(value1,value2) {
		var slotsToProcess = this.slots;
		while(slotsToProcess.nonEmpty) {
			slotsToProcess.head.execute(value1,value2);
			slotsToProcess = slotsToProcess.tail;
		}
	}
	,__class__: msignal.Signal2
});
msignal.Slot = $hxClasses["msignal.Slot"] = function(signal,listener,once,priority) {
	if(priority == null) priority = 0;
	if(once == null) once = false;
	this.signal = signal;
	this.set_listener(listener);
	this.once = once;
	this.priority = priority;
	this.enabled = true;
};
msignal.Slot.__name__ = ["msignal","Slot"];
msignal.Slot.prototype = {
	set_listener: function(value) {
		if(value == null) throw "listener cannot be null";
		return this.listener = value;
	}
	,remove: function() {
		this.signal.remove(this.listener);
	}
	,signal: null
	,enabled: null
	,priority: null
	,once: null
	,listener: null
	,__class__: msignal.Slot
	,__properties__: {set_listener:"set_listener"}
}
msignal.Slot0 = $hxClasses["msignal.Slot0"] = function(signal,listener,once,priority) {
	if(priority == null) priority = 0;
	if(once == null) once = false;
	msignal.Slot.call(this,signal,listener,once,priority);
};
msignal.Slot0.__name__ = ["msignal","Slot0"];
msignal.Slot0.__super__ = msignal.Slot;
msignal.Slot0.prototype = $extend(msignal.Slot.prototype,{
	execute: function() {
		if(!this.enabled) return;
		if(this.once) this.remove();
		this.listener();
	}
	,__class__: msignal.Slot0
});
msignal.Slot1 = $hxClasses["msignal.Slot1"] = function(signal,listener,once,priority) {
	if(priority == null) priority = 0;
	if(once == null) once = false;
	msignal.Slot.call(this,signal,listener,once,priority);
};
msignal.Slot1.__name__ = ["msignal","Slot1"];
msignal.Slot1.__super__ = msignal.Slot;
msignal.Slot1.prototype = $extend(msignal.Slot.prototype,{
	execute: function(value1) {
		if(!this.enabled) return;
		if(this.once) this.remove();
		if(this.param != null) value1 = this.param;
		this.listener(value1);
	}
	,param: null
	,__class__: msignal.Slot1
});
msignal.Slot2 = $hxClasses["msignal.Slot2"] = function(signal,listener,once,priority) {
	if(priority == null) priority = 0;
	if(once == null) once = false;
	msignal.Slot.call(this,signal,listener,once,priority);
};
msignal.Slot2.__name__ = ["msignal","Slot2"];
msignal.Slot2.__super__ = msignal.Slot;
msignal.Slot2.prototype = $extend(msignal.Slot.prototype,{
	execute: function(value1,value2) {
		if(!this.enabled) return;
		if(this.once) this.remove();
		if(this.param1 != null) value1 = this.param1;
		if(this.param2 != null) value2 = this.param2;
		this.listener(value1,value2);
	}
	,param2: null
	,param1: null
	,__class__: msignal.Slot2
});
msignal.SlotList = $hxClasses["msignal.SlotList"] = function(head,tail) {
	this.nonEmpty = false;
	if(head == null && tail == null) {
		if(msignal.SlotList.NIL != null) throw "Parameters head and tail are null. Use the NIL element instead.";
		this.nonEmpty = false;
	} else if(head == null) throw "Parameter head cannot be null."; else {
		this.head = head;
		this.tail = tail == null?msignal.SlotList.NIL:tail;
		this.nonEmpty = true;
	}
};
msignal.SlotList.__name__ = ["msignal","SlotList"];
msignal.SlotList.NIL = null;
msignal.SlotList.prototype = {
	find: function(listener) {
		if(!this.nonEmpty) return null;
		var p = this;
		while(p.nonEmpty) {
			if(Reflect.compareMethods(p.head.listener,listener)) return p.head;
			p = p.tail;
		}
		return null;
	}
	,contains: function(listener) {
		if(!this.nonEmpty) return false;
		var p = this;
		while(p.nonEmpty) {
			if(Reflect.compareMethods(p.head.listener,listener)) return true;
			p = p.tail;
		}
		return false;
	}
	,filterNot: function(listener) {
		if(!this.nonEmpty || listener == null) return this;
		if(Reflect.compareMethods(this.head.listener,listener)) return this.tail;
		var wholeClone = new msignal.SlotList(this.head);
		var subClone = wholeClone;
		var current = this.tail;
		while(current.nonEmpty) {
			if(Reflect.compareMethods(current.head.listener,listener)) {
				subClone.tail = current.tail;
				return wholeClone;
			}
			subClone = subClone.tail = new msignal.SlotList(current.head);
			current = current.tail;
		}
		return this;
	}
	,insertWithPriority: function(slot) {
		if(!this.nonEmpty) return new msignal.SlotList(slot);
		var priority = slot.priority;
		if(priority > this.head.priority) return this.prepend(slot);
		var wholeClone = new msignal.SlotList(this.head);
		var subClone = wholeClone;
		var current = this.tail;
		while(current.nonEmpty) {
			if(priority > current.head.priority) {
				subClone.tail = current.prepend(slot);
				return wholeClone;
			}
			subClone = subClone.tail = new msignal.SlotList(current.head);
			current = current.tail;
		}
		subClone.tail = new msignal.SlotList(slot);
		return wholeClone;
	}
	,append: function(slot) {
		if(slot == null) return this;
		if(!this.nonEmpty) return new msignal.SlotList(slot);
		if(this.tail == msignal.SlotList.NIL) return new msignal.SlotList(slot).prepend(this.head);
		var wholeClone = new msignal.SlotList(this.head);
		var subClone = wholeClone;
		var current = this.tail;
		while(current.nonEmpty) {
			subClone = subClone.tail = new msignal.SlotList(current.head);
			current = current.tail;
		}
		subClone.tail = new msignal.SlotList(slot);
		return wholeClone;
	}
	,prepend: function(slot) {
		return new msignal.SlotList(slot,this);
	}
	,get_length: function() {
		if(!this.nonEmpty) return 0;
		if(this.tail == msignal.SlotList.NIL) return 1;
		var result = 0;
		var p = this;
		while(p.nonEmpty) {
			++result;
			p = p.tail;
		}
		return result;
	}
	,length: null
	,nonEmpty: null
	,tail: null
	,head: null
	,__class__: msignal.SlotList
	,__properties__: {get_length:"get_length"}
}
function $iterator(o) { if( o instanceof Array ) return function() { return HxOverrides.iter(o); }; return typeof(o.iterator) == 'function' ? $bind(o,o.iterator) : o.iterator; };
var $_;
function $bind(o,m) { var f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; return f; };
if(Array.prototype.indexOf) HxOverrides.remove = function(a,o) {
	var i = a.indexOf(o);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
}; else null;
Math.__name__ = ["Math"];
Math.NaN = Number.NaN;
Math.NEGATIVE_INFINITY = Number.NEGATIVE_INFINITY;
Math.POSITIVE_INFINITY = Number.POSITIVE_INFINITY;
$hxClasses.Math = Math;
Math.isFinite = function(i) {
	return isFinite(i);
};
Math.isNaN = function(i) {
	return isNaN(i);
};
String.prototype.__class__ = $hxClasses.String = String;
String.__name__ = ["String"];
Array.prototype.__class__ = $hxClasses.Array = Array;
Array.__name__ = ["Array"];
Date.prototype.__class__ = $hxClasses.Date = Date;
Date.__name__ = ["Date"];
var Int = $hxClasses.Int = { __name__ : ["Int"]};
var Dynamic = $hxClasses.Dynamic = { __name__ : ["Dynamic"]};
var Float = $hxClasses.Float = Number;
Float.__name__ = ["Float"];
var Bool = $hxClasses.Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = $hxClasses.Class = { __name__ : ["Class"]};
var Enum = { };
var Void = $hxClasses.Void = { __ename__ : ["Void"]};
if(typeof(JSON) != "undefined") haxe.Json = JSON;
var q = window.jQuery;
js.JQuery = q;
q.fn.iterator = function() {
	return { pos : 0, j : this, hasNext : function() {
		return this.pos < this.j.length;
	}, next : function() {
		return $(this.j[this.pos++]);
	}};
};
if(typeof document != "undefined") js.Lib.document = document;
if(typeof window != "undefined") {
	js.Lib.window = window;
	js.Lib.window.onerror = function(msg,url,line) {
		var f = js.Lib.onerror;
		if(f == null) return false;
		return f(msg,[url + ":" + line]);
	};
}
js.XMLHttpRequest = window.XMLHttpRequest?XMLHttpRequest:window.ActiveXObject?function() {
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
msignal.SlotList.NIL = new msignal.SlotList(null,null);
var Editor = WYMeditor.editor;
var Wymeditor=window.jQuery;
/*!
 * jQuery UI 1.8.14
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI
 */
(function(c,j){function k(a,b){var d=a.nodeName.toLowerCase();if("area"===d){b=a.parentNode;d=b.name;if(!a.href||!d||b.nodeName.toLowerCase()!=="map")return false;a=c("img[usemap=#"+d+"]")[0];return!!a&&l(a)}return(/input|select|textarea|button|object/.test(d)?!a.disabled:"a"==d?a.href||b:b)&&l(a)}function l(a){return!c(a).parents().andSelf().filter(function(){return c.curCSS(this,"visibility")==="hidden"||c.expr.filters.hidden(this)}).length}c.ui=c.ui||{};if(!c.ui.version){c.extend(c.ui,{version:"1.8.14",
keyCode:{ALT:18,BACKSPACE:8,CAPS_LOCK:20,COMMA:188,COMMAND:91,COMMAND_LEFT:91,COMMAND_RIGHT:93,CONTROL:17,DELETE:46,DOWN:40,END:35,ENTER:13,ESCAPE:27,HOME:36,INSERT:45,LEFT:37,MENU:93,NUMPAD_ADD:107,NUMPAD_DECIMAL:110,NUMPAD_DIVIDE:111,NUMPAD_ENTER:108,NUMPAD_MULTIPLY:106,NUMPAD_SUBTRACT:109,PAGE_DOWN:34,PAGE_UP:33,PERIOD:190,RIGHT:39,SHIFT:16,SPACE:32,TAB:9,UP:38,WINDOWS:91}});c.fn.extend({_focus:c.fn.focus,focus:function(a,b){return typeof a==="number"?this.each(function(){var d=this;setTimeout(function(){c(d).focus();
b&&b.call(d)},a)}):this._focus.apply(this,arguments)},scrollParent:function(){var a;a=c.browser.msie&&/(static|relative)/.test(this.css("position"))||/absolute/.test(this.css("position"))?this.parents().filter(function(){return/(relative|absolute|fixed)/.test(c.curCSS(this,"position",1))&&/(auto|scroll)/.test(c.curCSS(this,"overflow",1)+c.curCSS(this,"overflow-y",1)+c.curCSS(this,"overflow-x",1))}).eq(0):this.parents().filter(function(){return/(auto|scroll)/.test(c.curCSS(this,"overflow",1)+c.curCSS(this,
"overflow-y",1)+c.curCSS(this,"overflow-x",1))}).eq(0);return/fixed/.test(this.css("position"))||!a.length?c(document):a},zIndex:function(a){if(a!==j)return this.css("zIndex",a);if(this.length){a=c(this[0]);for(var b;a.length&&a[0]!==document;){b=a.css("position");if(b==="absolute"||b==="relative"||b==="fixed"){b=parseInt(a.css("zIndex"),10);if(!isNaN(b)&&b!==0)return b}a=a.parent()}}return 0},disableSelection:function(){return this.bind((c.support.selectstart?"selectstart":"mousedown")+".ui-disableSelection",
function(a){a.preventDefault()})},enableSelection:function(){return this.unbind(".ui-disableSelection")}});c.each(["Width","Height"],function(a,b){function d(f,g,m,n){c.each(e,function(){g-=parseFloat(c.curCSS(f,"padding"+this,true))||0;if(m)g-=parseFloat(c.curCSS(f,"border"+this+"Width",true))||0;if(n)g-=parseFloat(c.curCSS(f,"margin"+this,true))||0});return g}var e=b==="Width"?["Left","Right"]:["Top","Bottom"],h=b.toLowerCase(),i={innerWidth:c.fn.innerWidth,innerHeight:c.fn.innerHeight,outerWidth:c.fn.outerWidth,
outerHeight:c.fn.outerHeight};c.fn["inner"+b]=function(f){if(f===j)return i["inner"+b].call(this);return this.each(function(){c(this).css(h,d(this,f)+"px")})};c.fn["outer"+b]=function(f,g){if(typeof f!=="number")return i["outer"+b].call(this,f);return this.each(function(){c(this).css(h,d(this,f,true,g)+"px")})}});c.extend(c.expr[":"],{data:function(a,b,d){return!!c.data(a,d[3])},focusable:function(a){return k(a,!isNaN(c.attr(a,"tabindex")))},tabbable:function(a){var b=c.attr(a,"tabindex"),d=isNaN(b);
return(d||b>=0)&&k(a,!d)}});c(function(){var a=document.body,b=a.appendChild(b=document.createElement("div"));c.extend(b.style,{minHeight:"100px",height:"auto",padding:0,borderWidth:0});c.support.minHeight=b.offsetHeight===100;c.support.selectstart="onselectstart"in b;a.removeChild(b).style.display="none"});c.extend(c.ui,{plugin:{add:function(a,b,d){a=c.ui[a].prototype;for(var e in d){a.plugins[e]=a.plugins[e]||[];a.plugins[e].push([b,d[e]])}},call:function(a,b,d){if((b=a.plugins[b])&&a.element[0].parentNode)for(var e=
0;e<b.length;e++)a.options[b[e][0]]&&b[e][1].apply(a.element,d)}},contains:function(a,b){return document.compareDocumentPosition?a.compareDocumentPosition(b)&16:a!==b&&a.contains(b)},hasScroll:function(a,b){if(c(a).css("overflow")==="hidden")return false;b=b&&b==="left"?"scrollLeft":"scrollTop";var d=false;if(a[b]>0)return true;a[b]=1;d=a[b]>0;a[b]=0;return d},isOverAxis:function(a,b,d){return a>b&&a<b+d},isOver:function(a,b,d,e,h,i){return c.ui.isOverAxis(a,d,h)&&c.ui.isOverAxis(b,e,i)}})}})(jQuery);
;/*!
 * jQuery UI Widget 1.8.14
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Widget
 */
(function(b,j){if(b.cleanData){var k=b.cleanData;b.cleanData=function(a){for(var c=0,d;(d=a[c])!=null;c++)b(d).triggerHandler("remove");k(a)}}else{var l=b.fn.remove;b.fn.remove=function(a,c){return this.each(function(){if(!c)if(!a||b.filter(a,[this]).length)b("*",this).add([this]).each(function(){b(this).triggerHandler("remove")});return l.call(b(this),a,c)})}}b.widget=function(a,c,d){var e=a.split(".")[0],f;a=a.split(".")[1];f=e+"-"+a;if(!d){d=c;c=b.Widget}b.expr[":"][f]=function(h){return!!b.data(h,
a)};b[e]=b[e]||{};b[e][a]=function(h,g){arguments.length&&this._createWidget(h,g)};c=new c;c.options=b.extend(true,{},c.options);b[e][a].prototype=b.extend(true,c,{namespace:e,widgetName:a,widgetEventPrefix:b[e][a].prototype.widgetEventPrefix||a,widgetBaseClass:f},d);b.widget.bridge(a,b[e][a])};b.widget.bridge=function(a,c){b.fn[a]=function(d){var e=typeof d==="string",f=Array.prototype.slice.call(arguments,1),h=this;d=!e&&f.length?b.extend.apply(null,[true,d].concat(f)):d;if(e&&d.charAt(0)==="_")return h;
e?this.each(function(){var g=b.data(this,a),i=g&&b.isFunction(g[d])?g[d].apply(g,f):g;if(i!==g&&i!==j){h=i;return false}}):this.each(function(){var g=b.data(this,a);g?g.option(d||{})._init():b.data(this,a,new c(d,this))});return h}};b.Widget=function(a,c){arguments.length&&this._createWidget(a,c)};b.Widget.prototype={widgetName:"widget",widgetEventPrefix:"",options:{disabled:false},_createWidget:function(a,c){b.data(c,this.widgetName,this);this.element=b(c);this.options=b.extend(true,{},this.options,
this._getCreateOptions(),a);var d=this;this.element.bind("remove."+this.widgetName,function(){d.destroy()});this._create();this._trigger("create");this._init()},_getCreateOptions:function(){return b.metadata&&b.metadata.get(this.element[0])[this.widgetName]},_create:function(){},_init:function(){},destroy:function(){this.element.unbind("."+this.widgetName).removeData(this.widgetName);this.widget().unbind("."+this.widgetName).removeAttr("aria-disabled").removeClass(this.widgetBaseClass+"-disabled ui-state-disabled")},
widget:function(){return this.element},option:function(a,c){var d=a;if(arguments.length===0)return b.extend({},this.options);if(typeof a==="string"){if(c===j)return this.options[a];d={};d[a]=c}this._setOptions(d);return this},_setOptions:function(a){var c=this;b.each(a,function(d,e){c._setOption(d,e)});return this},_setOption:function(a,c){this.options[a]=c;if(a==="disabled")this.widget()[c?"addClass":"removeClass"](this.widgetBaseClass+"-disabled ui-state-disabled").attr("aria-disabled",c);return this},
enable:function(){return this._setOption("disabled",false)},disable:function(){return this._setOption("disabled",true)},_trigger:function(a,c,d){var e=this.options[a];c=b.Event(c);c.type=(a===this.widgetEventPrefix?a:this.widgetEventPrefix+a).toLowerCase();d=d||{};if(c.originalEvent){a=b.event.props.length;for(var f;a;){f=b.event.props[--a];c[f]=c.originalEvent[f]}}this.element.trigger(c,d);return!(b.isFunction(e)&&e.call(this.element[0],c,d)===false||c.isDefaultPrevented())}}})(jQuery);
;/*!
 * jQuery UI Mouse 1.8.14
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Mouse
 *
 * Depends:
 *	jquery.ui.widget.js
 */
(function(b){var d=false;b(document).mousedown(function(){d=false});b.widget("ui.mouse",{options:{cancel:":input,option",distance:1,delay:0},_mouseInit:function(){var a=this;this.element.bind("mousedown."+this.widgetName,function(c){return a._mouseDown(c)}).bind("click."+this.widgetName,function(c){if(true===b.data(c.target,a.widgetName+".preventClickEvent")){b.removeData(c.target,a.widgetName+".preventClickEvent");c.stopImmediatePropagation();return false}});this.started=false},_mouseDestroy:function(){this.element.unbind("."+
this.widgetName)},_mouseDown:function(a){if(!d){this._mouseStarted&&this._mouseUp(a);this._mouseDownEvent=a;var c=this,f=a.which==1,g=typeof this.options.cancel=="string"?b(a.target).closest(this.options.cancel).length:false;if(!f||g||!this._mouseCapture(a))return true;this.mouseDelayMet=!this.options.delay;if(!this.mouseDelayMet)this._mouseDelayTimer=setTimeout(function(){c.mouseDelayMet=true},this.options.delay);if(this._mouseDistanceMet(a)&&this._mouseDelayMet(a)){this._mouseStarted=this._mouseStart(a)!==
false;if(!this._mouseStarted){a.preventDefault();return true}}true===b.data(a.target,this.widgetName+".preventClickEvent")&&b.removeData(a.target,this.widgetName+".preventClickEvent");this._mouseMoveDelegate=function(e){return c._mouseMove(e)};this._mouseUpDelegate=function(e){return c._mouseUp(e)};b(document).bind("mousemove."+this.widgetName,this._mouseMoveDelegate).bind("mouseup."+this.widgetName,this._mouseUpDelegate);a.preventDefault();return d=true}},_mouseMove:function(a){if(b.browser.msie&&
!(document.documentMode>=9)&&!a.button)return this._mouseUp(a);if(this._mouseStarted){this._mouseDrag(a);return a.preventDefault()}if(this._mouseDistanceMet(a)&&this._mouseDelayMet(a))(this._mouseStarted=this._mouseStart(this._mouseDownEvent,a)!==false)?this._mouseDrag(a):this._mouseUp(a);return!this._mouseStarted},_mouseUp:function(a){b(document).unbind("mousemove."+this.widgetName,this._mouseMoveDelegate).unbind("mouseup."+this.widgetName,this._mouseUpDelegate);if(this._mouseStarted){this._mouseStarted=
false;a.target==this._mouseDownEvent.target&&b.data(a.target,this.widgetName+".preventClickEvent",true);this._mouseStop(a)}return false},_mouseDistanceMet:function(a){return Math.max(Math.abs(this._mouseDownEvent.pageX-a.pageX),Math.abs(this._mouseDownEvent.pageY-a.pageY))>=this.options.distance},_mouseDelayMet:function(){return this.mouseDelayMet},_mouseStart:function(){},_mouseDrag:function(){},_mouseStop:function(){},_mouseCapture:function(){return true}})})(jQuery);
;/*
 * jQuery UI Position 1.8.14
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Position
 */
(function(c){c.ui=c.ui||{};var n=/left|center|right/,o=/top|center|bottom/,t=c.fn.position,u=c.fn.offset;c.fn.position=function(b){if(!b||!b.of)return t.apply(this,arguments);b=c.extend({},b);var a=c(b.of),d=a[0],g=(b.collision||"flip").split(" "),e=b.offset?b.offset.split(" "):[0,0],h,k,j;if(d.nodeType===9){h=a.width();k=a.height();j={top:0,left:0}}else if(d.setTimeout){h=a.width();k=a.height();j={top:a.scrollTop(),left:a.scrollLeft()}}else if(d.preventDefault){b.at="left top";h=k=0;j={top:b.of.pageY,
left:b.of.pageX}}else{h=a.outerWidth();k=a.outerHeight();j=a.offset()}c.each(["my","at"],function(){var f=(b[this]||"").split(" ");if(f.length===1)f=n.test(f[0])?f.concat(["center"]):o.test(f[0])?["center"].concat(f):["center","center"];f[0]=n.test(f[0])?f[0]:"center";f[1]=o.test(f[1])?f[1]:"center";b[this]=f});if(g.length===1)g[1]=g[0];e[0]=parseInt(e[0],10)||0;if(e.length===1)e[1]=e[0];e[1]=parseInt(e[1],10)||0;if(b.at[0]==="right")j.left+=h;else if(b.at[0]==="center")j.left+=h/2;if(b.at[1]==="bottom")j.top+=
k;else if(b.at[1]==="center")j.top+=k/2;j.left+=e[0];j.top+=e[1];return this.each(function(){var f=c(this),l=f.outerWidth(),m=f.outerHeight(),p=parseInt(c.curCSS(this,"marginLeft",true))||0,q=parseInt(c.curCSS(this,"marginTop",true))||0,v=l+p+(parseInt(c.curCSS(this,"marginRight",true))||0),w=m+q+(parseInt(c.curCSS(this,"marginBottom",true))||0),i=c.extend({},j),r;if(b.my[0]==="right")i.left-=l;else if(b.my[0]==="center")i.left-=l/2;if(b.my[1]==="bottom")i.top-=m;else if(b.my[1]==="center")i.top-=
m/2;i.left=Math.round(i.left);i.top=Math.round(i.top);r={left:i.left-p,top:i.top-q};c.each(["left","top"],function(s,x){c.ui.position[g[s]]&&c.ui.position[g[s]][x](i,{targetWidth:h,targetHeight:k,elemWidth:l,elemHeight:m,collisionPosition:r,collisionWidth:v,collisionHeight:w,offset:e,my:b.my,at:b.at})});c.fn.bgiframe&&f.bgiframe();f.offset(c.extend(i,{using:b.using}))})};c.ui.position={fit:{left:function(b,a){var d=c(window);d=a.collisionPosition.left+a.collisionWidth-d.width()-d.scrollLeft();b.left=
d>0?b.left-d:Math.max(b.left-a.collisionPosition.left,b.left)},top:function(b,a){var d=c(window);d=a.collisionPosition.top+a.collisionHeight-d.height()-d.scrollTop();b.top=d>0?b.top-d:Math.max(b.top-a.collisionPosition.top,b.top)}},flip:{left:function(b,a){if(a.at[0]!=="center"){var d=c(window);d=a.collisionPosition.left+a.collisionWidth-d.width()-d.scrollLeft();var g=a.my[0]==="left"?-a.elemWidth:a.my[0]==="right"?a.elemWidth:0,e=a.at[0]==="left"?a.targetWidth:-a.targetWidth,h=-2*a.offset[0];b.left+=
a.collisionPosition.left<0?g+e+h:d>0?g+e+h:0}},top:function(b,a){if(a.at[1]!=="center"){var d=c(window);d=a.collisionPosition.top+a.collisionHeight-d.height()-d.scrollTop();var g=a.my[1]==="top"?-a.elemHeight:a.my[1]==="bottom"?a.elemHeight:0,e=a.at[1]==="top"?a.targetHeight:-a.targetHeight,h=-2*a.offset[1];b.top+=a.collisionPosition.top<0?g+e+h:d>0?g+e+h:0}}}};if(!c.offset.setOffset){c.offset.setOffset=function(b,a){if(/static/.test(c.curCSS(b,"position")))b.style.position="relative";var d=c(b),
g=d.offset(),e=parseInt(c.curCSS(b,"top",true),10)||0,h=parseInt(c.curCSS(b,"left",true),10)||0;g={top:a.top-g.top+e,left:a.left-g.left+h};"using"in a?a.using.call(b,g):d.css(g)};c.fn.offset=function(b){var a=this[0];if(!a||!a.ownerDocument)return null;if(b)return this.each(function(){c.offset.setOffset(this,b)});return u.call(this)}}})(jQuery);
;/*
 * jQuery UI Draggable 1.8.14
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Draggables
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.mouse.js
 *	jquery.ui.widget.js
 */
(function(d){d.widget("ui.draggable",d.ui.mouse,{widgetEventPrefix:"drag",options:{addClasses:true,appendTo:"parent",axis:false,connectToSortable:false,containment:false,cursor:"auto",cursorAt:false,grid:false,handle:false,helper:"original",iframeFix:false,opacity:false,refreshPositions:false,revert:false,revertDuration:500,scope:"default",scroll:true,scrollSensitivity:20,scrollSpeed:20,snap:false,snapMode:"both",snapTolerance:20,stack:false,zIndex:false},_create:function(){if(this.options.helper==
"original"&&!/^(?:r|a|f)/.test(this.element.css("position")))this.element[0].style.position="relative";this.options.addClasses&&this.element.addClass("ui-draggable");this.options.disabled&&this.element.addClass("ui-draggable-disabled");this._mouseInit()},destroy:function(){if(this.element.data("draggable")){this.element.removeData("draggable").unbind(".draggable").removeClass("ui-draggable ui-draggable-dragging ui-draggable-disabled");this._mouseDestroy();return this}},_mouseCapture:function(a){var b=
this.options;if(this.helper||b.disabled||d(a.target).is(".ui-resizable-handle"))return false;this.handle=this._getHandle(a);if(!this.handle)return false;d(b.iframeFix===true?"iframe":b.iframeFix).each(function(){d('<div class="ui-draggable-iframeFix" style="background: #fff;"></div>').css({width:this.offsetWidth+"px",height:this.offsetHeight+"px",position:"absolute",opacity:"0.001",zIndex:1E3}).css(d(this).offset()).appendTo("body")});return true},_mouseStart:function(a){var b=this.options;this.helper=
this._createHelper(a);this._cacheHelperProportions();if(d.ui.ddmanager)d.ui.ddmanager.current=this;this._cacheMargins();this.cssPosition=this.helper.css("position");this.scrollParent=this.helper.scrollParent();this.offset=this.positionAbs=this.element.offset();this.offset={top:this.offset.top-this.margins.top,left:this.offset.left-this.margins.left};d.extend(this.offset,{click:{left:a.pageX-this.offset.left,top:a.pageY-this.offset.top},parent:this._getParentOffset(),relative:this._getRelativeOffset()});
this.originalPosition=this.position=this._generatePosition(a);this.originalPageX=a.pageX;this.originalPageY=a.pageY;b.cursorAt&&this._adjustOffsetFromHelper(b.cursorAt);b.containment&&this._setContainment();if(this._trigger("start",a)===false){this._clear();return false}this._cacheHelperProportions();d.ui.ddmanager&&!b.dropBehaviour&&d.ui.ddmanager.prepareOffsets(this,a);this.helper.addClass("ui-draggable-dragging");this._mouseDrag(a,true);d.ui.ddmanager&&d.ui.ddmanager.dragStart(this,a);return true},
_mouseDrag:function(a,b){this.position=this._generatePosition(a);this.positionAbs=this._convertPositionTo("absolute");if(!b){b=this._uiHash();if(this._trigger("drag",a,b)===false){this._mouseUp({});return false}this.position=b.position}if(!this.options.axis||this.options.axis!="y")this.helper[0].style.left=this.position.left+"px";if(!this.options.axis||this.options.axis!="x")this.helper[0].style.top=this.position.top+"px";d.ui.ddmanager&&d.ui.ddmanager.drag(this,a);return false},_mouseStop:function(a){var b=
false;if(d.ui.ddmanager&&!this.options.dropBehaviour)b=d.ui.ddmanager.drop(this,a);if(this.dropped){b=this.dropped;this.dropped=false}if((!this.element[0]||!this.element[0].parentNode)&&this.options.helper=="original")return false;if(this.options.revert=="invalid"&&!b||this.options.revert=="valid"&&b||this.options.revert===true||d.isFunction(this.options.revert)&&this.options.revert.call(this.element,b)){var c=this;d(this.helper).animate(this.originalPosition,parseInt(this.options.revertDuration,
10),function(){c._trigger("stop",a)!==false&&c._clear()})}else this._trigger("stop",a)!==false&&this._clear();return false},_mouseUp:function(a){this.options.iframeFix===true&&d("div.ui-draggable-iframeFix").each(function(){this.parentNode.removeChild(this)});d.ui.ddmanager&&d.ui.ddmanager.dragStop(this,a);return d.ui.mouse.prototype._mouseUp.call(this,a)},cancel:function(){this.helper.is(".ui-draggable-dragging")?this._mouseUp({}):this._clear();return this},_getHandle:function(a){var b=!this.options.handle||
!d(this.options.handle,this.element).length?true:false;d(this.options.handle,this.element).find("*").andSelf().each(function(){if(this==a.target)b=true});return b},_createHelper:function(a){var b=this.options;a=d.isFunction(b.helper)?d(b.helper.apply(this.element[0],[a])):b.helper=="clone"?this.element.clone().removeAttr("id"):this.element;a.parents("body").length||a.appendTo(b.appendTo=="parent"?this.element[0].parentNode:b.appendTo);a[0]!=this.element[0]&&!/(fixed|absolute)/.test(a.css("position"))&&
a.css("position","absolute");return a},_adjustOffsetFromHelper:function(a){if(typeof a=="string")a=a.split(" ");if(d.isArray(a))a={left:+a[0],top:+a[1]||0};if("left"in a)this.offset.click.left=a.left+this.margins.left;if("right"in a)this.offset.click.left=this.helperProportions.width-a.right+this.margins.left;if("top"in a)this.offset.click.top=a.top+this.margins.top;if("bottom"in a)this.offset.click.top=this.helperProportions.height-a.bottom+this.margins.top},_getParentOffset:function(){this.offsetParent=
this.helper.offsetParent();var a=this.offsetParent.offset();if(this.cssPosition=="absolute"&&this.scrollParent[0]!=document&&d.ui.contains(this.scrollParent[0],this.offsetParent[0])){a.left+=this.scrollParent.scrollLeft();a.top+=this.scrollParent.scrollTop()}if(this.offsetParent[0]==document.body||this.offsetParent[0].tagName&&this.offsetParent[0].tagName.toLowerCase()=="html"&&d.browser.msie)a={top:0,left:0};return{top:a.top+(parseInt(this.offsetParent.css("borderTopWidth"),10)||0),left:a.left+(parseInt(this.offsetParent.css("borderLeftWidth"),
10)||0)}},_getRelativeOffset:function(){if(this.cssPosition=="relative"){var a=this.element.position();return{top:a.top-(parseInt(this.helper.css("top"),10)||0)+this.scrollParent.scrollTop(),left:a.left-(parseInt(this.helper.css("left"),10)||0)+this.scrollParent.scrollLeft()}}else return{top:0,left:0}},_cacheMargins:function(){this.margins={left:parseInt(this.element.css("marginLeft"),10)||0,top:parseInt(this.element.css("marginTop"),10)||0,right:parseInt(this.element.css("marginRight"),10)||0,bottom:parseInt(this.element.css("marginBottom"),
10)||0}},_cacheHelperProportions:function(){this.helperProportions={width:this.helper.outerWidth(),height:this.helper.outerHeight()}},_setContainment:function(){var a=this.options;if(a.containment=="parent")a.containment=this.helper[0].parentNode;if(a.containment=="document"||a.containment=="window")this.containment=[a.containment=="document"?0:d(window).scrollLeft()-this.offset.relative.left-this.offset.parent.left,a.containment=="document"?0:d(window).scrollTop()-this.offset.relative.top-this.offset.parent.top,
(a.containment=="document"?0:d(window).scrollLeft())+d(a.containment=="document"?document:window).width()-this.helperProportions.width-this.margins.left,(a.containment=="document"?0:d(window).scrollTop())+(d(a.containment=="document"?document:window).height()||document.body.parentNode.scrollHeight)-this.helperProportions.height-this.margins.top];if(!/^(document|window|parent)$/.test(a.containment)&&a.containment.constructor!=Array){a=d(a.containment);var b=a[0];if(b){a.offset();var c=d(b).css("overflow")!=
"hidden";this.containment=[(parseInt(d(b).css("borderLeftWidth"),10)||0)+(parseInt(d(b).css("paddingLeft"),10)||0),(parseInt(d(b).css("borderTopWidth"),10)||0)+(parseInt(d(b).css("paddingTop"),10)||0),(c?Math.max(b.scrollWidth,b.offsetWidth):b.offsetWidth)-(parseInt(d(b).css("borderLeftWidth"),10)||0)-(parseInt(d(b).css("paddingRight"),10)||0)-this.helperProportions.width-this.margins.left-this.margins.right,(c?Math.max(b.scrollHeight,b.offsetHeight):b.offsetHeight)-(parseInt(d(b).css("borderTopWidth"),
10)||0)-(parseInt(d(b).css("paddingBottom"),10)||0)-this.helperProportions.height-this.margins.top-this.margins.bottom];this.relative_container=a}}else if(a.containment.constructor==Array)this.containment=a.containment},_convertPositionTo:function(a,b){if(!b)b=this.position;a=a=="absolute"?1:-1;var c=this.cssPosition=="absolute"&&!(this.scrollParent[0]!=document&&d.ui.contains(this.scrollParent[0],this.offsetParent[0]))?this.offsetParent:this.scrollParent,f=/(html|body)/i.test(c[0].tagName);return{top:b.top+
this.offset.relative.top*a+this.offset.parent.top*a-(d.browser.safari&&d.browser.version<526&&this.cssPosition=="fixed"?0:(this.cssPosition=="fixed"?-this.scrollParent.scrollTop():f?0:c.scrollTop())*a),left:b.left+this.offset.relative.left*a+this.offset.parent.left*a-(d.browser.safari&&d.browser.version<526&&this.cssPosition=="fixed"?0:(this.cssPosition=="fixed"?-this.scrollParent.scrollLeft():f?0:c.scrollLeft())*a)}},_generatePosition:function(a){var b=this.options,c=this.cssPosition=="absolute"&&
!(this.scrollParent[0]!=document&&d.ui.contains(this.scrollParent[0],this.offsetParent[0]))?this.offsetParent:this.scrollParent,f=/(html|body)/i.test(c[0].tagName),e=a.pageX,h=a.pageY;if(this.originalPosition){var g;if(this.containment){if(this.relative_container){g=this.relative_container.offset();g=[this.containment[0]+g.left,this.containment[1]+g.top,this.containment[2]+g.left,this.containment[3]+g.top]}else g=this.containment;if(a.pageX-this.offset.click.left<g[0])e=g[0]+this.offset.click.left;
if(a.pageY-this.offset.click.top<g[1])h=g[1]+this.offset.click.top;if(a.pageX-this.offset.click.left>g[2])e=g[2]+this.offset.click.left;if(a.pageY-this.offset.click.top>g[3])h=g[3]+this.offset.click.top}if(b.grid){h=b.grid[1]?this.originalPageY+Math.round((h-this.originalPageY)/b.grid[1])*b.grid[1]:this.originalPageY;h=g?!(h-this.offset.click.top<g[1]||h-this.offset.click.top>g[3])?h:!(h-this.offset.click.top<g[1])?h-b.grid[1]:h+b.grid[1]:h;e=b.grid[0]?this.originalPageX+Math.round((e-this.originalPageX)/
b.grid[0])*b.grid[0]:this.originalPageX;e=g?!(e-this.offset.click.left<g[0]||e-this.offset.click.left>g[2])?e:!(e-this.offset.click.left<g[0])?e-b.grid[0]:e+b.grid[0]:e}}return{top:h-this.offset.click.top-this.offset.relative.top-this.offset.parent.top+(d.browser.safari&&d.browser.version<526&&this.cssPosition=="fixed"?0:this.cssPosition=="fixed"?-this.scrollParent.scrollTop():f?0:c.scrollTop()),left:e-this.offset.click.left-this.offset.relative.left-this.offset.parent.left+(d.browser.safari&&d.browser.version<
526&&this.cssPosition=="fixed"?0:this.cssPosition=="fixed"?-this.scrollParent.scrollLeft():f?0:c.scrollLeft())}},_clear:function(){this.helper.removeClass("ui-draggable-dragging");this.helper[0]!=this.element[0]&&!this.cancelHelperRemoval&&this.helper.remove();this.helper=null;this.cancelHelperRemoval=false},_trigger:function(a,b,c){c=c||this._uiHash();d.ui.plugin.call(this,a,[b,c]);if(a=="drag")this.positionAbs=this._convertPositionTo("absolute");return d.Widget.prototype._trigger.call(this,a,b,
c)},plugins:{},_uiHash:function(){return{helper:this.helper,position:this.position,originalPosition:this.originalPosition,offset:this.positionAbs}}});d.extend(d.ui.draggable,{version:"1.8.14"});d.ui.plugin.add("draggable","connectToSortable",{start:function(a,b){var c=d(this).data("draggable"),f=c.options,e=d.extend({},b,{item:c.element});c.sortables=[];d(f.connectToSortable).each(function(){var h=d.data(this,"sortable");if(h&&!h.options.disabled){c.sortables.push({instance:h,shouldRevert:h.options.revert});
h.refreshPositions();h._trigger("activate",a,e)}})},stop:function(a,b){var c=d(this).data("draggable"),f=d.extend({},b,{item:c.element});d.each(c.sortables,function(){if(this.instance.isOver){this.instance.isOver=0;c.cancelHelperRemoval=true;this.instance.cancelHelperRemoval=false;if(this.shouldRevert)this.instance.options.revert=true;this.instance._mouseStop(a);this.instance.options.helper=this.instance.options._helper;c.options.helper=="original"&&this.instance.currentItem.css({top:"auto",left:"auto"})}else{this.instance.cancelHelperRemoval=
false;this.instance._trigger("deactivate",a,f)}})},drag:function(a,b){var c=d(this).data("draggable"),f=this;d.each(c.sortables,function(){this.instance.positionAbs=c.positionAbs;this.instance.helperProportions=c.helperProportions;this.instance.offset.click=c.offset.click;if(this.instance._intersectsWith(this.instance.containerCache)){if(!this.instance.isOver){this.instance.isOver=1;this.instance.currentItem=d(f).clone().removeAttr("id").appendTo(this.instance.element).data("sortable-item",true);
this.instance.options._helper=this.instance.options.helper;this.instance.options.helper=function(){return b.helper[0]};a.target=this.instance.currentItem[0];this.instance._mouseCapture(a,true);this.instance._mouseStart(a,true,true);this.instance.offset.click.top=c.offset.click.top;this.instance.offset.click.left=c.offset.click.left;this.instance.offset.parent.left-=c.offset.parent.left-this.instance.offset.parent.left;this.instance.offset.parent.top-=c.offset.parent.top-this.instance.offset.parent.top;
c._trigger("toSortable",a);c.dropped=this.instance.element;c.currentItem=c.element;this.instance.fromOutside=c}this.instance.currentItem&&this.instance._mouseDrag(a)}else if(this.instance.isOver){this.instance.isOver=0;this.instance.cancelHelperRemoval=true;this.instance.options.revert=false;this.instance._trigger("out",a,this.instance._uiHash(this.instance));this.instance._mouseStop(a,true);this.instance.options.helper=this.instance.options._helper;this.instance.currentItem.remove();this.instance.placeholder&&
this.instance.placeholder.remove();c._trigger("fromSortable",a);c.dropped=false}})}});d.ui.plugin.add("draggable","cursor",{start:function(){var a=d("body"),b=d(this).data("draggable").options;if(a.css("cursor"))b._cursor=a.css("cursor");a.css("cursor",b.cursor)},stop:function(){var a=d(this).data("draggable").options;a._cursor&&d("body").css("cursor",a._cursor)}});d.ui.plugin.add("draggable","opacity",{start:function(a,b){a=d(b.helper);b=d(this).data("draggable").options;if(a.css("opacity"))b._opacity=
a.css("opacity");a.css("opacity",b.opacity)},stop:function(a,b){a=d(this).data("draggable").options;a._opacity&&d(b.helper).css("opacity",a._opacity)}});d.ui.plugin.add("draggable","scroll",{start:function(){var a=d(this).data("draggable");if(a.scrollParent[0]!=document&&a.scrollParent[0].tagName!="HTML")a.overflowOffset=a.scrollParent.offset()},drag:function(a){var b=d(this).data("draggable"),c=b.options,f=false;if(b.scrollParent[0]!=document&&b.scrollParent[0].tagName!="HTML"){if(!c.axis||c.axis!=
"x")if(b.overflowOffset.top+b.scrollParent[0].offsetHeight-a.pageY<c.scrollSensitivity)b.scrollParent[0].scrollTop=f=b.scrollParent[0].scrollTop+c.scrollSpeed;else if(a.pageY-b.overflowOffset.top<c.scrollSensitivity)b.scrollParent[0].scrollTop=f=b.scrollParent[0].scrollTop-c.scrollSpeed;if(!c.axis||c.axis!="y")if(b.overflowOffset.left+b.scrollParent[0].offsetWidth-a.pageX<c.scrollSensitivity)b.scrollParent[0].scrollLeft=f=b.scrollParent[0].scrollLeft+c.scrollSpeed;else if(a.pageX-b.overflowOffset.left<
c.scrollSensitivity)b.scrollParent[0].scrollLeft=f=b.scrollParent[0].scrollLeft-c.scrollSpeed}else{if(!c.axis||c.axis!="x")if(a.pageY-d(document).scrollTop()<c.scrollSensitivity)f=d(document).scrollTop(d(document).scrollTop()-c.scrollSpeed);else if(d(window).height()-(a.pageY-d(document).scrollTop())<c.scrollSensitivity)f=d(document).scrollTop(d(document).scrollTop()+c.scrollSpeed);if(!c.axis||c.axis!="y")if(a.pageX-d(document).scrollLeft()<c.scrollSensitivity)f=d(document).scrollLeft(d(document).scrollLeft()-
c.scrollSpeed);else if(d(window).width()-(a.pageX-d(document).scrollLeft())<c.scrollSensitivity)f=d(document).scrollLeft(d(document).scrollLeft()+c.scrollSpeed)}f!==false&&d.ui.ddmanager&&!c.dropBehaviour&&d.ui.ddmanager.prepareOffsets(b,a)}});d.ui.plugin.add("draggable","snap",{start:function(){var a=d(this).data("draggable"),b=a.options;a.snapElements=[];d(b.snap.constructor!=String?b.snap.items||":data(draggable)":b.snap).each(function(){var c=d(this),f=c.offset();this!=a.element[0]&&a.snapElements.push({item:this,
width:c.outerWidth(),height:c.outerHeight(),top:f.top,left:f.left})})},drag:function(a,b){for(var c=d(this).data("draggable"),f=c.options,e=f.snapTolerance,h=b.offset.left,g=h+c.helperProportions.width,n=b.offset.top,o=n+c.helperProportions.height,i=c.snapElements.length-1;i>=0;i--){var j=c.snapElements[i].left,l=j+c.snapElements[i].width,k=c.snapElements[i].top,m=k+c.snapElements[i].height;if(j-e<h&&h<l+e&&k-e<n&&n<m+e||j-e<h&&h<l+e&&k-e<o&&o<m+e||j-e<g&&g<l+e&&k-e<n&&n<m+e||j-e<g&&g<l+e&&k-e<o&&
o<m+e){if(f.snapMode!="inner"){var p=Math.abs(k-o)<=e,q=Math.abs(m-n)<=e,r=Math.abs(j-g)<=e,s=Math.abs(l-h)<=e;if(p)b.position.top=c._convertPositionTo("relative",{top:k-c.helperProportions.height,left:0}).top-c.margins.top;if(q)b.position.top=c._convertPositionTo("relative",{top:m,left:0}).top-c.margins.top;if(r)b.position.left=c._convertPositionTo("relative",{top:0,left:j-c.helperProportions.width}).left-c.margins.left;if(s)b.position.left=c._convertPositionTo("relative",{top:0,left:l}).left-c.margins.left}var t=
p||q||r||s;if(f.snapMode!="outer"){p=Math.abs(k-n)<=e;q=Math.abs(m-o)<=e;r=Math.abs(j-h)<=e;s=Math.abs(l-g)<=e;if(p)b.position.top=c._convertPositionTo("relative",{top:k,left:0}).top-c.margins.top;if(q)b.position.top=c._convertPositionTo("relative",{top:m-c.helperProportions.height,left:0}).top-c.margins.top;if(r)b.position.left=c._convertPositionTo("relative",{top:0,left:j}).left-c.margins.left;if(s)b.position.left=c._convertPositionTo("relative",{top:0,left:l-c.helperProportions.width}).left-c.margins.left}if(!c.snapElements[i].snapping&&
(p||q||r||s||t))c.options.snap.snap&&c.options.snap.snap.call(c.element,a,d.extend(c._uiHash(),{snapItem:c.snapElements[i].item}));c.snapElements[i].snapping=p||q||r||s||t}else{c.snapElements[i].snapping&&c.options.snap.release&&c.options.snap.release.call(c.element,a,d.extend(c._uiHash(),{snapItem:c.snapElements[i].item}));c.snapElements[i].snapping=false}}}});d.ui.plugin.add("draggable","stack",{start:function(){var a=d(this).data("draggable").options;a=d.makeArray(d(a.stack)).sort(function(c,f){return(parseInt(d(c).css("zIndex"),
10)||0)-(parseInt(d(f).css("zIndex"),10)||0)});if(a.length){var b=parseInt(a[0].style.zIndex)||0;d(a).each(function(c){this.style.zIndex=b+c});this[0].style.zIndex=b+a.length}}});d.ui.plugin.add("draggable","zIndex",{start:function(a,b){a=d(b.helper);b=d(this).data("draggable").options;if(a.css("zIndex"))b._zIndex=a.css("zIndex");a.css("zIndex",b.zIndex)},stop:function(a,b){a=d(this).data("draggable").options;a._zIndex&&d(b.helper).css("zIndex",a._zIndex)}})})(jQuery);
;/*
 * jQuery UI Droppable 1.8.14
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Droppables
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.widget.js
 *	jquery.ui.mouse.js
 *	jquery.ui.draggable.js
 */
(function(d){d.widget("ui.droppable",{widgetEventPrefix:"drop",options:{accept:"*",activeClass:false,addClasses:true,greedy:false,hoverClass:false,scope:"default",tolerance:"intersect"},_create:function(){var a=this.options,b=a.accept;this.isover=0;this.isout=1;this.accept=d.isFunction(b)?b:function(c){return c.is(b)};this.proportions={width:this.element[0].offsetWidth,height:this.element[0].offsetHeight};d.ui.ddmanager.droppables[a.scope]=d.ui.ddmanager.droppables[a.scope]||[];d.ui.ddmanager.droppables[a.scope].push(this);
a.addClasses&&this.element.addClass("ui-droppable")},destroy:function(){for(var a=d.ui.ddmanager.droppables[this.options.scope],b=0;b<a.length;b++)a[b]==this&&a.splice(b,1);this.element.removeClass("ui-droppable ui-droppable-disabled").removeData("droppable").unbind(".droppable");return this},_setOption:function(a,b){if(a=="accept")this.accept=d.isFunction(b)?b:function(c){return c.is(b)};d.Widget.prototype._setOption.apply(this,arguments)},_activate:function(a){var b=d.ui.ddmanager.current;this.options.activeClass&&
this.element.addClass(this.options.activeClass);b&&this._trigger("activate",a,this.ui(b))},_deactivate:function(a){var b=d.ui.ddmanager.current;this.options.activeClass&&this.element.removeClass(this.options.activeClass);b&&this._trigger("deactivate",a,this.ui(b))},_over:function(a){var b=d.ui.ddmanager.current;if(!(!b||(b.currentItem||b.element)[0]==this.element[0]))if(this.accept.call(this.element[0],b.currentItem||b.element)){this.options.hoverClass&&this.element.addClass(this.options.hoverClass);
this._trigger("over",a,this.ui(b))}},_out:function(a){var b=d.ui.ddmanager.current;if(!(!b||(b.currentItem||b.element)[0]==this.element[0]))if(this.accept.call(this.element[0],b.currentItem||b.element)){this.options.hoverClass&&this.element.removeClass(this.options.hoverClass);this._trigger("out",a,this.ui(b))}},_drop:function(a,b){var c=b||d.ui.ddmanager.current;if(!c||(c.currentItem||c.element)[0]==this.element[0])return false;var e=false;this.element.find(":data(droppable)").not(".ui-draggable-dragging").each(function(){var g=
d.data(this,"droppable");if(g.options.greedy&&!g.options.disabled&&g.options.scope==c.options.scope&&g.accept.call(g.element[0],c.currentItem||c.element)&&d.ui.intersect(c,d.extend(g,{offset:g.element.offset()}),g.options.tolerance)){e=true;return false}});if(e)return false;if(this.accept.call(this.element[0],c.currentItem||c.element)){this.options.activeClass&&this.element.removeClass(this.options.activeClass);this.options.hoverClass&&this.element.removeClass(this.options.hoverClass);this._trigger("drop",
a,this.ui(c));return this.element}return false},ui:function(a){return{draggable:a.currentItem||a.element,helper:a.helper,position:a.position,offset:a.positionAbs}}});d.extend(d.ui.droppable,{version:"1.8.14"});d.ui.intersect=function(a,b,c){if(!b.offset)return false;var e=(a.positionAbs||a.position.absolute).left,g=e+a.helperProportions.width,f=(a.positionAbs||a.position.absolute).top,h=f+a.helperProportions.height,i=b.offset.left,k=i+b.proportions.width,j=b.offset.top,l=j+b.proportions.height;
switch(c){case "fit":return i<=e&&g<=k&&j<=f&&h<=l;case "intersect":return i<e+a.helperProportions.width/2&&g-a.helperProportions.width/2<k&&j<f+a.helperProportions.height/2&&h-a.helperProportions.height/2<l;case "pointer":return d.ui.isOver((a.positionAbs||a.position.absolute).top+(a.clickOffset||a.offset.click).top,(a.positionAbs||a.position.absolute).left+(a.clickOffset||a.offset.click).left,j,i,b.proportions.height,b.proportions.width);case "touch":return(f>=j&&f<=l||h>=j&&h<=l||f<j&&h>l)&&(e>=
i&&e<=k||g>=i&&g<=k||e<i&&g>k);default:return false}};d.ui.ddmanager={current:null,droppables:{"default":[]},prepareOffsets:function(a,b){var c=d.ui.ddmanager.droppables[a.options.scope]||[],e=b?b.type:null,g=(a.currentItem||a.element).find(":data(droppable)").andSelf(),f=0;a:for(;f<c.length;f++)if(!(c[f].options.disabled||a&&!c[f].accept.call(c[f].element[0],a.currentItem||a.element))){for(var h=0;h<g.length;h++)if(g[h]==c[f].element[0]){c[f].proportions.height=0;continue a}c[f].visible=c[f].element.css("display")!=
"none";if(c[f].visible){e=="mousedown"&&c[f]._activate.call(c[f],b);c[f].offset=c[f].element.offset();c[f].proportions={width:c[f].element[0].offsetWidth,height:c[f].element[0].offsetHeight}}}},drop:function(a,b){var c=false;d.each(d.ui.ddmanager.droppables[a.options.scope]||[],function(){if(this.options){if(!this.options.disabled&&this.visible&&d.ui.intersect(a,this,this.options.tolerance))c=c||this._drop.call(this,b);if(!this.options.disabled&&this.visible&&this.accept.call(this.element[0],a.currentItem||
a.element)){this.isout=1;this.isover=0;this._deactivate.call(this,b)}}});return c},dragStart:function(a,b){a.element.parentsUntil("body").bind("scroll.droppable",function(){a.options.refreshPositions||d.ui.ddmanager.prepareOffsets(a,b)})},drag:function(a,b){a.options.refreshPositions&&d.ui.ddmanager.prepareOffsets(a,b);d.each(d.ui.ddmanager.droppables[a.options.scope]||[],function(){if(!(this.options.disabled||this.greedyChild||!this.visible)){var c=d.ui.intersect(a,this,this.options.tolerance);if(c=
!c&&this.isover==1?"isout":c&&this.isover==0?"isover":null){var e;if(this.options.greedy){var g=this.element.parents(":data(droppable):eq(0)");if(g.length){e=d.data(g[0],"droppable");e.greedyChild=c=="isover"?1:0}}if(e&&c=="isover"){e.isover=0;e.isout=1;e._out.call(e,b)}this[c]=1;this[c=="isout"?"isover":"isout"]=0;this[c=="isover"?"_over":"_out"].call(this,b);if(e&&c=="isout"){e.isout=0;e.isover=1;e._over.call(e,b)}}}})},dragStop:function(a,b){a.element.parentsUntil("body").unbind("scroll.droppable");
a.options.refreshPositions||d.ui.ddmanager.prepareOffsets(a,b)}}})(jQuery);
;/*
 * jQuery UI Sortable 1.8.14
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Sortables
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.mouse.js
 *	jquery.ui.widget.js
 */
(function(d){d.widget("ui.sortable",d.ui.mouse,{widgetEventPrefix:"sort",options:{appendTo:"parent",axis:false,connectWith:false,containment:false,cursor:"auto",cursorAt:false,dropOnEmpty:true,forcePlaceholderSize:false,forceHelperSize:false,grid:false,handle:false,helper:"original",items:"> *",opacity:false,placeholder:false,revert:false,scroll:true,scrollSensitivity:20,scrollSpeed:20,scope:"default",tolerance:"intersect",zIndex:1E3},_create:function(){var a=this.options;this.containerCache={};this.element.addClass("ui-sortable");
this.refresh();this.floating=this.items.length?a.axis==="x"||/left|right/.test(this.items[0].item.css("float"))||/inline|table-cell/.test(this.items[0].item.css("display")):false;this.offset=this.element.offset();this._mouseInit()},destroy:function(){this.element.removeClass("ui-sortable ui-sortable-disabled").removeData("sortable").unbind(".sortable");this._mouseDestroy();for(var a=this.items.length-1;a>=0;a--)this.items[a].item.removeData("sortable-item");return this},_setOption:function(a,b){if(a===
"disabled"){this.options[a]=b;this.widget()[b?"addClass":"removeClass"]("ui-sortable-disabled")}else d.Widget.prototype._setOption.apply(this,arguments)},_mouseCapture:function(a,b){if(this.reverting)return false;if(this.options.disabled||this.options.type=="static")return false;this._refreshItems(a);var c=null,e=this;d(a.target).parents().each(function(){if(d.data(this,"sortable-item")==e){c=d(this);return false}});if(d.data(a.target,"sortable-item")==e)c=d(a.target);if(!c)return false;if(this.options.handle&&
!b){var f=false;d(this.options.handle,c).find("*").andSelf().each(function(){if(this==a.target)f=true});if(!f)return false}this.currentItem=c;this._removeCurrentsFromItems();return true},_mouseStart:function(a,b,c){b=this.options;var e=this;this.currentContainer=this;this.refreshPositions();this.helper=this._createHelper(a);this._cacheHelperProportions();this._cacheMargins();this.scrollParent=this.helper.scrollParent();this.offset=this.currentItem.offset();this.offset={top:this.offset.top-this.margins.top,
left:this.offset.left-this.margins.left};this.helper.css("position","absolute");this.cssPosition=this.helper.css("position");d.extend(this.offset,{click:{left:a.pageX-this.offset.left,top:a.pageY-this.offset.top},parent:this._getParentOffset(),relative:this._getRelativeOffset()});this.originalPosition=this._generatePosition(a);this.originalPageX=a.pageX;this.originalPageY=a.pageY;b.cursorAt&&this._adjustOffsetFromHelper(b.cursorAt);this.domPosition={prev:this.currentItem.prev()[0],parent:this.currentItem.parent()[0]};
this.helper[0]!=this.currentItem[0]&&this.currentItem.hide();this._createPlaceholder();b.containment&&this._setContainment();if(b.cursor){if(d("body").css("cursor"))this._storedCursor=d("body").css("cursor");d("body").css("cursor",b.cursor)}if(b.opacity){if(this.helper.css("opacity"))this._storedOpacity=this.helper.css("opacity");this.helper.css("opacity",b.opacity)}if(b.zIndex){if(this.helper.css("zIndex"))this._storedZIndex=this.helper.css("zIndex");this.helper.css("zIndex",b.zIndex)}if(this.scrollParent[0]!=
document&&this.scrollParent[0].tagName!="HTML")this.overflowOffset=this.scrollParent.offset();this._trigger("start",a,this._uiHash());this._preserveHelperProportions||this._cacheHelperProportions();if(!c)for(c=this.containers.length-1;c>=0;c--)this.containers[c]._trigger("activate",a,e._uiHash(this));if(d.ui.ddmanager)d.ui.ddmanager.current=this;d.ui.ddmanager&&!b.dropBehaviour&&d.ui.ddmanager.prepareOffsets(this,a);this.dragging=true;this.helper.addClass("ui-sortable-helper");this._mouseDrag(a);
return true},_mouseDrag:function(a){this.position=this._generatePosition(a);this.positionAbs=this._convertPositionTo("absolute");if(!this.lastPositionAbs)this.lastPositionAbs=this.positionAbs;if(this.options.scroll){var b=this.options,c=false;if(this.scrollParent[0]!=document&&this.scrollParent[0].tagName!="HTML"){if(this.overflowOffset.top+this.scrollParent[0].offsetHeight-a.pageY<b.scrollSensitivity)this.scrollParent[0].scrollTop=c=this.scrollParent[0].scrollTop+b.scrollSpeed;else if(a.pageY-this.overflowOffset.top<
b.scrollSensitivity)this.scrollParent[0].scrollTop=c=this.scrollParent[0].scrollTop-b.scrollSpeed;if(this.overflowOffset.left+this.scrollParent[0].offsetWidth-a.pageX<b.scrollSensitivity)this.scrollParent[0].scrollLeft=c=this.scrollParent[0].scrollLeft+b.scrollSpeed;else if(a.pageX-this.overflowOffset.left<b.scrollSensitivity)this.scrollParent[0].scrollLeft=c=this.scrollParent[0].scrollLeft-b.scrollSpeed}else{if(a.pageY-d(document).scrollTop()<b.scrollSensitivity)c=d(document).scrollTop(d(document).scrollTop()-
b.scrollSpeed);else if(d(window).height()-(a.pageY-d(document).scrollTop())<b.scrollSensitivity)c=d(document).scrollTop(d(document).scrollTop()+b.scrollSpeed);if(a.pageX-d(document).scrollLeft()<b.scrollSensitivity)c=d(document).scrollLeft(d(document).scrollLeft()-b.scrollSpeed);else if(d(window).width()-(a.pageX-d(document).scrollLeft())<b.scrollSensitivity)c=d(document).scrollLeft(d(document).scrollLeft()+b.scrollSpeed)}c!==false&&d.ui.ddmanager&&!b.dropBehaviour&&d.ui.ddmanager.prepareOffsets(this,
a)}this.positionAbs=this._convertPositionTo("absolute");if(!this.options.axis||this.options.axis!="y")this.helper[0].style.left=this.position.left+"px";if(!this.options.axis||this.options.axis!="x")this.helper[0].style.top=this.position.top+"px";for(b=this.items.length-1;b>=0;b--){c=this.items[b];var e=c.item[0],f=this._intersectsWithPointer(c);if(f)if(e!=this.currentItem[0]&&this.placeholder[f==1?"next":"prev"]()[0]!=e&&!d.ui.contains(this.placeholder[0],e)&&(this.options.type=="semi-dynamic"?!d.ui.contains(this.element[0],
e):true)){this.direction=f==1?"down":"up";if(this.options.tolerance=="pointer"||this._intersectsWithSides(c))this._rearrange(a,c);else break;this._trigger("change",a,this._uiHash());break}}this._contactContainers(a);d.ui.ddmanager&&d.ui.ddmanager.drag(this,a);this._trigger("sort",a,this._uiHash());this.lastPositionAbs=this.positionAbs;return false},_mouseStop:function(a,b){if(a){d.ui.ddmanager&&!this.options.dropBehaviour&&d.ui.ddmanager.drop(this,a);if(this.options.revert){var c=this;b=c.placeholder.offset();
c.reverting=true;d(this.helper).animate({left:b.left-this.offset.parent.left-c.margins.left+(this.offsetParent[0]==document.body?0:this.offsetParent[0].scrollLeft),top:b.top-this.offset.parent.top-c.margins.top+(this.offsetParent[0]==document.body?0:this.offsetParent[0].scrollTop)},parseInt(this.options.revert,10)||500,function(){c._clear(a)})}else this._clear(a,b);return false}},cancel:function(){var a=this;if(this.dragging){this._mouseUp({target:null});this.options.helper=="original"?this.currentItem.css(this._storedCSS).removeClass("ui-sortable-helper"):
this.currentItem.show();for(var b=this.containers.length-1;b>=0;b--){this.containers[b]._trigger("deactivate",null,a._uiHash(this));if(this.containers[b].containerCache.over){this.containers[b]._trigger("out",null,a._uiHash(this));this.containers[b].containerCache.over=0}}}if(this.placeholder){this.placeholder[0].parentNode&&this.placeholder[0].parentNode.removeChild(this.placeholder[0]);this.options.helper!="original"&&this.helper&&this.helper[0].parentNode&&this.helper.remove();d.extend(this,{helper:null,
dragging:false,reverting:false,_noFinalSort:null});this.domPosition.prev?d(this.domPosition.prev).after(this.currentItem):d(this.domPosition.parent).prepend(this.currentItem)}return this},serialize:function(a){var b=this._getItemsAsjQuery(a&&a.connected),c=[];a=a||{};d(b).each(function(){var e=(d(a.item||this).attr(a.attribute||"id")||"").match(a.expression||/(.+)[-=_](.+)/);if(e)c.push((a.key||e[1]+"[]")+"="+(a.key&&a.expression?e[1]:e[2]))});!c.length&&a.key&&c.push(a.key+"=");return c.join("&")},
toArray:function(a){var b=this._getItemsAsjQuery(a&&a.connected),c=[];a=a||{};b.each(function(){c.push(d(a.item||this).attr(a.attribute||"id")||"")});return c},_intersectsWith:function(a){var b=this.positionAbs.left,c=b+this.helperProportions.width,e=this.positionAbs.top,f=e+this.helperProportions.height,g=a.left,h=g+a.width,i=a.top,k=i+a.height,j=this.offset.click.top,l=this.offset.click.left;j=e+j>i&&e+j<k&&b+l>g&&b+l<h;return this.options.tolerance=="pointer"||this.options.forcePointerForContainers||
this.options.tolerance!="pointer"&&this.helperProportions[this.floating?"width":"height"]>a[this.floating?"width":"height"]?j:g<b+this.helperProportions.width/2&&c-this.helperProportions.width/2<h&&i<e+this.helperProportions.height/2&&f-this.helperProportions.height/2<k},_intersectsWithPointer:function(a){var b=d.ui.isOverAxis(this.positionAbs.top+this.offset.click.top,a.top,a.height);a=d.ui.isOverAxis(this.positionAbs.left+this.offset.click.left,a.left,a.width);b=b&&a;a=this._getDragVerticalDirection();
var c=this._getDragHorizontalDirection();if(!b)return false;return this.floating?c&&c=="right"||a=="down"?2:1:a&&(a=="down"?2:1)},_intersectsWithSides:function(a){var b=d.ui.isOverAxis(this.positionAbs.top+this.offset.click.top,a.top+a.height/2,a.height);a=d.ui.isOverAxis(this.positionAbs.left+this.offset.click.left,a.left+a.width/2,a.width);var c=this._getDragVerticalDirection(),e=this._getDragHorizontalDirection();return this.floating&&e?e=="right"&&a||e=="left"&&!a:c&&(c=="down"&&b||c=="up"&&!b)},
_getDragVerticalDirection:function(){var a=this.positionAbs.top-this.lastPositionAbs.top;return a!=0&&(a>0?"down":"up")},_getDragHorizontalDirection:function(){var a=this.positionAbs.left-this.lastPositionAbs.left;return a!=0&&(a>0?"right":"left")},refresh:function(a){this._refreshItems(a);this.refreshPositions();return this},_connectWith:function(){var a=this.options;return a.connectWith.constructor==String?[a.connectWith]:a.connectWith},_getItemsAsjQuery:function(a){var b=[],c=[],e=this._connectWith();
if(e&&a)for(a=e.length-1;a>=0;a--)for(var f=d(e[a]),g=f.length-1;g>=0;g--){var h=d.data(f[g],"sortable");if(h&&h!=this&&!h.options.disabled)c.push([d.isFunction(h.options.items)?h.options.items.call(h.element):d(h.options.items,h.element).not(".ui-sortable-helper").not(".ui-sortable-placeholder"),h])}c.push([d.isFunction(this.options.items)?this.options.items.call(this.element,null,{options:this.options,item:this.currentItem}):d(this.options.items,this.element).not(".ui-sortable-helper").not(".ui-sortable-placeholder"),
this]);for(a=c.length-1;a>=0;a--)c[a][0].each(function(){b.push(this)});return d(b)},_removeCurrentsFromItems:function(){for(var a=this.currentItem.find(":data(sortable-item)"),b=0;b<this.items.length;b++)for(var c=0;c<a.length;c++)a[c]==this.items[b].item[0]&&this.items.splice(b,1)},_refreshItems:function(a){this.items=[];this.containers=[this];var b=this.items,c=[[d.isFunction(this.options.items)?this.options.items.call(this.element[0],a,{item:this.currentItem}):d(this.options.items,this.element),
this]],e=this._connectWith();if(e)for(var f=e.length-1;f>=0;f--)for(var g=d(e[f]),h=g.length-1;h>=0;h--){var i=d.data(g[h],"sortable");if(i&&i!=this&&!i.options.disabled){c.push([d.isFunction(i.options.items)?i.options.items.call(i.element[0],a,{item:this.currentItem}):d(i.options.items,i.element),i]);this.containers.push(i)}}for(f=c.length-1;f>=0;f--){a=c[f][1];e=c[f][0];h=0;for(g=e.length;h<g;h++){i=d(e[h]);i.data("sortable-item",a);b.push({item:i,instance:a,width:0,height:0,left:0,top:0})}}},refreshPositions:function(a){if(this.offsetParent&&
this.helper)this.offset.parent=this._getParentOffset();for(var b=this.items.length-1;b>=0;b--){var c=this.items[b];if(!(c.instance!=this.currentContainer&&this.currentContainer&&c.item[0]!=this.currentItem[0])){var e=this.options.toleranceElement?d(this.options.toleranceElement,c.item):c.item;if(!a){c.width=e.outerWidth();c.height=e.outerHeight()}e=e.offset();c.left=e.left;c.top=e.top}}if(this.options.custom&&this.options.custom.refreshContainers)this.options.custom.refreshContainers.call(this);else for(b=
this.containers.length-1;b>=0;b--){e=this.containers[b].element.offset();this.containers[b].containerCache.left=e.left;this.containers[b].containerCache.top=e.top;this.containers[b].containerCache.width=this.containers[b].element.outerWidth();this.containers[b].containerCache.height=this.containers[b].element.outerHeight()}return this},_createPlaceholder:function(a){var b=a||this,c=b.options;if(!c.placeholder||c.placeholder.constructor==String){var e=c.placeholder;c.placeholder={element:function(){var f=
d(document.createElement(b.currentItem[0].nodeName)).addClass(e||b.currentItem[0].className+" ui-sortable-placeholder").removeClass("ui-sortable-helper")[0];if(!e)f.style.visibility="hidden";return f},update:function(f,g){if(!(e&&!c.forcePlaceholderSize)){g.height()||g.height(b.currentItem.innerHeight()-parseInt(b.currentItem.css("paddingTop")||0,10)-parseInt(b.currentItem.css("paddingBottom")||0,10));g.width()||g.width(b.currentItem.innerWidth()-parseInt(b.currentItem.css("paddingLeft")||0,10)-parseInt(b.currentItem.css("paddingRight")||
0,10))}}}}b.placeholder=d(c.placeholder.element.call(b.element,b.currentItem));b.currentItem.after(b.placeholder);c.placeholder.update(b,b.placeholder)},_contactContainers:function(a){for(var b=null,c=null,e=this.containers.length-1;e>=0;e--)if(!d.ui.contains(this.currentItem[0],this.containers[e].element[0]))if(this._intersectsWith(this.containers[e].containerCache)){if(!(b&&d.ui.contains(this.containers[e].element[0],b.element[0]))){b=this.containers[e];c=e}}else if(this.containers[e].containerCache.over){this.containers[e]._trigger("out",
a,this._uiHash(this));this.containers[e].containerCache.over=0}if(b)if(this.containers.length===1){this.containers[c]._trigger("over",a,this._uiHash(this));this.containers[c].containerCache.over=1}else if(this.currentContainer!=this.containers[c]){b=1E4;e=null;for(var f=this.positionAbs[this.containers[c].floating?"left":"top"],g=this.items.length-1;g>=0;g--)if(d.ui.contains(this.containers[c].element[0],this.items[g].item[0])){var h=this.items[g][this.containers[c].floating?"left":"top"];if(Math.abs(h-
f)<b){b=Math.abs(h-f);e=this.items[g]}}if(e||this.options.dropOnEmpty){this.currentContainer=this.containers[c];e?this._rearrange(a,e,null,true):this._rearrange(a,null,this.containers[c].element,true);this._trigger("change",a,this._uiHash());this.containers[c]._trigger("change",a,this._uiHash(this));this.options.placeholder.update(this.currentContainer,this.placeholder);this.containers[c]._trigger("over",a,this._uiHash(this));this.containers[c].containerCache.over=1}}},_createHelper:function(a){var b=
this.options;a=d.isFunction(b.helper)?d(b.helper.apply(this.element[0],[a,this.currentItem])):b.helper=="clone"?this.currentItem.clone():this.currentItem;a.parents("body").length||d(b.appendTo!="parent"?b.appendTo:this.currentItem[0].parentNode)[0].appendChild(a[0]);if(a[0]==this.currentItem[0])this._storedCSS={width:this.currentItem[0].style.width,height:this.currentItem[0].style.height,position:this.currentItem.css("position"),top:this.currentItem.css("top"),left:this.currentItem.css("left")};if(a[0].style.width==
""||b.forceHelperSize)a.width(this.currentItem.width());if(a[0].style.height==""||b.forceHelperSize)a.height(this.currentItem.height());return a},_adjustOffsetFromHelper:function(a){if(typeof a=="string")a=a.split(" ");if(d.isArray(a))a={left:+a[0],top:+a[1]||0};if("left"in a)this.offset.click.left=a.left+this.margins.left;if("right"in a)this.offset.click.left=this.helperProportions.width-a.right+this.margins.left;if("top"in a)this.offset.click.top=a.top+this.margins.top;if("bottom"in a)this.offset.click.top=
this.helperProportions.height-a.bottom+this.margins.top},_getParentOffset:function(){this.offsetParent=this.helper.offsetParent();var a=this.offsetParent.offset();if(this.cssPosition=="absolute"&&this.scrollParent[0]!=document&&d.ui.contains(this.scrollParent[0],this.offsetParent[0])){a.left+=this.scrollParent.scrollLeft();a.top+=this.scrollParent.scrollTop()}if(this.offsetParent[0]==document.body||this.offsetParent[0].tagName&&this.offsetParent[0].tagName.toLowerCase()=="html"&&d.browser.msie)a=
{top:0,left:0};return{top:a.top+(parseInt(this.offsetParent.css("borderTopWidth"),10)||0),left:a.left+(parseInt(this.offsetParent.css("borderLeftWidth"),10)||0)}},_getRelativeOffset:function(){if(this.cssPosition=="relative"){var a=this.currentItem.position();return{top:a.top-(parseInt(this.helper.css("top"),10)||0)+this.scrollParent.scrollTop(),left:a.left-(parseInt(this.helper.css("left"),10)||0)+this.scrollParent.scrollLeft()}}else return{top:0,left:0}},_cacheMargins:function(){this.margins={left:parseInt(this.currentItem.css("marginLeft"),
10)||0,top:parseInt(this.currentItem.css("marginTop"),10)||0}},_cacheHelperProportions:function(){this.helperProportions={width:this.helper.outerWidth(),height:this.helper.outerHeight()}},_setContainment:function(){var a=this.options;if(a.containment=="parent")a.containment=this.helper[0].parentNode;if(a.containment=="document"||a.containment=="window")this.containment=[0-this.offset.relative.left-this.offset.parent.left,0-this.offset.relative.top-this.offset.parent.top,d(a.containment=="document"?
document:window).width()-this.helperProportions.width-this.margins.left,(d(a.containment=="document"?document:window).height()||document.body.parentNode.scrollHeight)-this.helperProportions.height-this.margins.top];if(!/^(document|window|parent)$/.test(a.containment)){var b=d(a.containment)[0];a=d(a.containment).offset();var c=d(b).css("overflow")!="hidden";this.containment=[a.left+(parseInt(d(b).css("borderLeftWidth"),10)||0)+(parseInt(d(b).css("paddingLeft"),10)||0)-this.margins.left,a.top+(parseInt(d(b).css("borderTopWidth"),
10)||0)+(parseInt(d(b).css("paddingTop"),10)||0)-this.margins.top,a.left+(c?Math.max(b.scrollWidth,b.offsetWidth):b.offsetWidth)-(parseInt(d(b).css("borderLeftWidth"),10)||0)-(parseInt(d(b).css("paddingRight"),10)||0)-this.helperProportions.width-this.margins.left,a.top+(c?Math.max(b.scrollHeight,b.offsetHeight):b.offsetHeight)-(parseInt(d(b).css("borderTopWidth"),10)||0)-(parseInt(d(b).css("paddingBottom"),10)||0)-this.helperProportions.height-this.margins.top]}},_convertPositionTo:function(a,b){if(!b)b=
this.position;a=a=="absolute"?1:-1;var c=this.cssPosition=="absolute"&&!(this.scrollParent[0]!=document&&d.ui.contains(this.scrollParent[0],this.offsetParent[0]))?this.offsetParent:this.scrollParent,e=/(html|body)/i.test(c[0].tagName);return{top:b.top+this.offset.relative.top*a+this.offset.parent.top*a-(d.browser.safari&&this.cssPosition=="fixed"?0:(this.cssPosition=="fixed"?-this.scrollParent.scrollTop():e?0:c.scrollTop())*a),left:b.left+this.offset.relative.left*a+this.offset.parent.left*a-(d.browser.safari&&
this.cssPosition=="fixed"?0:(this.cssPosition=="fixed"?-this.scrollParent.scrollLeft():e?0:c.scrollLeft())*a)}},_generatePosition:function(a){var b=this.options,c=this.cssPosition=="absolute"&&!(this.scrollParent[0]!=document&&d.ui.contains(this.scrollParent[0],this.offsetParent[0]))?this.offsetParent:this.scrollParent,e=/(html|body)/i.test(c[0].tagName);if(this.cssPosition=="relative"&&!(this.scrollParent[0]!=document&&this.scrollParent[0]!=this.offsetParent[0]))this.offset.relative=this._getRelativeOffset();
var f=a.pageX,g=a.pageY;if(this.originalPosition){if(this.containment){if(a.pageX-this.offset.click.left<this.containment[0])f=this.containment[0]+this.offset.click.left;if(a.pageY-this.offset.click.top<this.containment[1])g=this.containment[1]+this.offset.click.top;if(a.pageX-this.offset.click.left>this.containment[2])f=this.containment[2]+this.offset.click.left;if(a.pageY-this.offset.click.top>this.containment[3])g=this.containment[3]+this.offset.click.top}if(b.grid){g=this.originalPageY+Math.round((g-
this.originalPageY)/b.grid[1])*b.grid[1];g=this.containment?!(g-this.offset.click.top<this.containment[1]||g-this.offset.click.top>this.containment[3])?g:!(g-this.offset.click.top<this.containment[1])?g-b.grid[1]:g+b.grid[1]:g;f=this.originalPageX+Math.round((f-this.originalPageX)/b.grid[0])*b.grid[0];f=this.containment?!(f-this.offset.click.left<this.containment[0]||f-this.offset.click.left>this.containment[2])?f:!(f-this.offset.click.left<this.containment[0])?f-b.grid[0]:f+b.grid[0]:f}}return{top:g-
this.offset.click.top-this.offset.relative.top-this.offset.parent.top+(d.browser.safari&&this.cssPosition=="fixed"?0:this.cssPosition=="fixed"?-this.scrollParent.scrollTop():e?0:c.scrollTop()),left:f-this.offset.click.left-this.offset.relative.left-this.offset.parent.left+(d.browser.safari&&this.cssPosition=="fixed"?0:this.cssPosition=="fixed"?-this.scrollParent.scrollLeft():e?0:c.scrollLeft())}},_rearrange:function(a,b,c,e){c?c[0].appendChild(this.placeholder[0]):b.item[0].parentNode.insertBefore(this.placeholder[0],
this.direction=="down"?b.item[0]:b.item[0].nextSibling);this.counter=this.counter?++this.counter:1;var f=this,g=this.counter;window.setTimeout(function(){g==f.counter&&f.refreshPositions(!e)},0)},_clear:function(a,b){this.reverting=false;var c=[];!this._noFinalSort&&this.currentItem.parent().length&&this.placeholder.before(this.currentItem);this._noFinalSort=null;if(this.helper[0]==this.currentItem[0]){for(var e in this._storedCSS)if(this._storedCSS[e]=="auto"||this._storedCSS[e]=="static")this._storedCSS[e]=
"";this.currentItem.css(this._storedCSS).removeClass("ui-sortable-helper")}else this.currentItem.show();this.fromOutside&&!b&&c.push(function(f){this._trigger("receive",f,this._uiHash(this.fromOutside))});if((this.fromOutside||this.domPosition.prev!=this.currentItem.prev().not(".ui-sortable-helper")[0]||this.domPosition.parent!=this.currentItem.parent()[0])&&!b)c.push(function(f){this._trigger("update",f,this._uiHash())});if(!d.ui.contains(this.element[0],this.currentItem[0])){b||c.push(function(f){this._trigger("remove",
f,this._uiHash())});for(e=this.containers.length-1;e>=0;e--)if(d.ui.contains(this.containers[e].element[0],this.currentItem[0])&&!b){c.push(function(f){return function(g){f._trigger("receive",g,this._uiHash(this))}}.call(this,this.containers[e]));c.push(function(f){return function(g){f._trigger("update",g,this._uiHash(this))}}.call(this,this.containers[e]))}}for(e=this.containers.length-1;e>=0;e--){b||c.push(function(f){return function(g){f._trigger("deactivate",g,this._uiHash(this))}}.call(this,
this.containers[e]));if(this.containers[e].containerCache.over){c.push(function(f){return function(g){f._trigger("out",g,this._uiHash(this))}}.call(this,this.containers[e]));this.containers[e].containerCache.over=0}}this._storedCursor&&d("body").css("cursor",this._storedCursor);this._storedOpacity&&this.helper.css("opacity",this._storedOpacity);if(this._storedZIndex)this.helper.css("zIndex",this._storedZIndex=="auto"?"":this._storedZIndex);this.dragging=false;if(this.cancelHelperRemoval){if(!b){this._trigger("beforeStop",
a,this._uiHash());for(e=0;e<c.length;e++)c[e].call(this,a);this._trigger("stop",a,this._uiHash())}return false}b||this._trigger("beforeStop",a,this._uiHash());this.placeholder[0].parentNode.removeChild(this.placeholder[0]);this.helper[0]!=this.currentItem[0]&&this.helper.remove();this.helper=null;if(!b){for(e=0;e<c.length;e++)c[e].call(this,a);this._trigger("stop",a,this._uiHash())}this.fromOutside=false;return true},_trigger:function(){d.Widget.prototype._trigger.apply(this,arguments)===false&&this.cancel()},
_uiHash:function(a){var b=a||this;return{helper:b.helper,placeholder:b.placeholder||d([]),position:b.position,originalPosition:b.originalPosition,offset:b.positionAbs,item:b.currentItem,sender:a?a.element:null}}});d.extend(d.ui.sortable,{version:"1.8.14"})})(jQuery);
;;
var Sortable = window.jQuery;
var SortableEvent={create:"sortcreate",sortstart:"start",sort:"sort",change:"sortchange",sortbeforeStop:"beforeStop",stop:"sortstop",update:"sortupdate",receive:"sortreceive",remove:"sortremove",over:"sortover",out:"sortout",activate:"sortactivate",deactivate:"sortdeactivate"}
DateTools.DAYS_OF_MONTH = [31,28,31,30,31,30,31,31,30,31,30,31];
feffects.Tween.aTweens = new haxe.FastList();
feffects.Tween.aPaused = new haxe.FastList();
feffects.Tween.jsDate = new Date().getTime();
feffects.Tween.interval = 10;
haxe.Serializer.USE_CACHE = false;
haxe.Serializer.USE_ENUM_INDEX = false;
haxe.Serializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:";
haxe.Unserializer.DEFAULT_RESOLVER = Type;
haxe.Unserializer.BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789%:";
haxe.Unserializer.CODES = null;
js.Lib.onerror = null;
microbe.TagManager.voPackage = "vo.";
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
microbe.jsTools.BackJS.debug = 0;
microbe.jsTools.BackJS.base_url = js.Lib.window.location.protocol + "//" + js.Lib.window.location.host;
microbe.jsTools.BackJS.back_url = microbe.jsTools.BackJS.base_url + "/index.php/pipo/";
msignal.Signal.__meta__ = { fields : { createSlot : { IgnoreCover : null}}};
microbe.jsTools.ElementBinder.debug = 0;
microbe.jsTools.MapParser.debug = 0;
microbe.tools.Debug.debug = false;
microbe.jsTools.BackJS.main();

//@ sourceMappingURL=backjs.js.map