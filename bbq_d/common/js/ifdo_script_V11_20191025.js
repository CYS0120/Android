// Do not Modify This Script Plz.
// for BBQ Main WebSite With Jquery
// 2019.7.12 Bangnam
var _NB_gs = 'wlog.ifdo.co.kr'; 
var _NB_MKTCD = 'NTA219190440';

// 도메인 추출
var _durl = document.URL.split('?');
var _bdm = document.domain;
_bdm = _bdm.replace('www.','');
// 각 도메인별 분석코드 할당.
switch(_bdm){
	case 'bbq.co.kr': _NB_MKTCD = 'NTA219190440';break;
	case 'm.bbq.co.kr': _NB_MKTCD = 'NTA219190440';break;
	case 'mall.bbq.co.kr': _NB_MKTCD = 'NTA219192448';break;
	case 'mallbbq.cafe24.com': _NB_MKTCD = 'NTA219192448';break;
	case 'ckpalace.co.kr': _NB_MKTCD = 'NTA319192449';break;
	case 'bbqbarbecue.co.kr': _NB_MKTCD = 'NTA119192450';break;
	case 'unine.co.kr': _NB_MKTCD = 'NTA419192451';break;
	case 'alltokk.co.kr': _NB_MKTCD = 'NTA219192452';break;
	case 'soshin275.co.kr': _NB_MKTCD = 'NTA319192453';break;
	case 'watamikorea.co.kr': _NB_MKTCD = 'NTA119192454';break;
}

function strip_tags (input, allowed) {
    allowed = (((allowed || "") + "").toLowerCase().match(/<[a-z][a-z0-9]*>/g) || []).join(''); // making sure the allowed arg is a string containing only tags in lowercase (<a><b><c>)
    var tags = /<\/?([a-z][a-z0-9]*)\b[^>]*>/gi,
        commentsAndPhpTags = /<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/gi;
    return input.replace(commentsAndPhpTags, '').replace(tags, function ($0, $1) {        
		return allowed.indexOf('<' + $1.toLowerCase() + '>') > -1 ? $0 : '';
    });
}
// Mobile menuView
_is_mobile_view = (_bdm=='m.bbq.co.kr'&& _durl[0].indexOf('/menu/menuView.asp') > 0 )?1:0;
_is_view = (_bdm=='bbq.co.kr'&& _durl[0].indexOf('/menu/menuView.asp') > 0 )?1:0;
_is_mobile_cart = (_bdm=='m.bbq.co.kr'&& _durl[0].indexOf('/order/cart.asp') > 0 )?1:0;
_is_mobile_order = (_bdm=='m.bbq.co.kr'&& _durl[0].indexOf('/order/orderComplete.asp') > 0 )?1:0;
_is_cart = (_bdm=='bbq.co.kr'&& _durl[0].indexOf('/order/cart.asp') > 0 )?1:0;
_is_order = (_bdm=='bbq.co.kr'&& _durl[0].indexOf('/order/orderComplete.asp') > 0 )?1:0;

if( _is_mobile_view || _is_view ){
	var _m_top = document.getElementsByClassName('btn_menu_cart');
	if( _m_top.length > 0 ){
		var _NB_TMP = _m_top[0].getAttribute('onclick');
		var _NB_ARR = _NB_TMP.split('$$');
		if( _NB_ARR.length == 6 ){
			var _NB_PD = strip_tags(_NB_ARR[4]);
			var _NB_AMT = parseInt(_NB_ARR[3]);
			var _NB_IMG2 = _NB_ARR[5].split("'");
			var _NB_IMG = _NB_IMG2[0];
		}
	}
}
if( _is_mobile_cart ){
	var _cart_arr = document.getElementsByClassName('order_menu');
	if( _cart_arr.length > 0 ){
		var _NB_LO = [];
		for( var i=0; i < _cart_arr.length; i ++ ){
			var _l_name = _cart_arr[i].getElementsByTagName('dt')[0].textContent;
			var _pd_ar = _cart_arr[i].getElementsByTagName('dd')[0].textContent;
			var _pd_ar2 = _pd_ar.split(' / ');
			var _l_price = parseInt(_pd_ar2[0].replace(/[^0-9]/gi,''))
			var _l_num = parseInt(_pd_ar2[1].replace(/[^0-9]/gi,''))
			if(_l_name!=''&&_l_price > 0 &&_l_num > 0 ){
				var _t_obj = {};
				_t_obj['PN'] = _l_name;
				_t_obj['PC'] = '';
				_t_obj['AM'] = _l_num;
				_t_obj['PR'] =  _l_price * _l_num;
				_t_obj['CT'] = '';
				_NB_LO.push(_t_obj);
			}
			
		}
		
	}
	var _NB_PM = 'u';// 장바구니
}
if( _is_mobile_order ){
	var _cart_arr = document.getElementsByClassName('order_menu');
	if( _cart_arr.length > 0 ){
		var _NB_LO = [];
		for( var i=0; i < _cart_arr.length; i ++ ){
			var _l_name = _cart_arr[i].getElementsByTagName('dt')[0].textContent;
			var _pd_ar = _cart_arr[i].getElementsByTagName('dd')[0].textContent;
			var _pd_ar2 = _pd_ar.split(' / ');
			var _l_price = parseInt(_pd_ar2[0].replace(/[^0-9]/gi,''))
			var _l_num = parseInt(_pd_ar2[1].replace(/[^0-9]/gi,''))
			if(_l_name!=''&&_l_price > 0 &&_l_num > 0 ){
				var _t_obj = {};
				_t_obj['PN'] = _l_name;
				_t_obj['PC'] = '';
				_t_obj['AM'] = _l_num;
				_t_obj['PR'] =  _l_price * _l_num;
				_t_obj['CT'] = '';
				_NB_LO.push(_t_obj);
			}
			
		}
		
	}
	var _NB_PM = 'b';// 구매완료
}
if( _is_cart ){
	var _cart_arr = document.getElementsByClassName('pdt-info div-table');
	if( _cart_arr.length > 0 ){
		var _NB_LO = [];
		
		for( var _ci=0; _ci < _cart_arr.length; _ci ++ ){
			var _cart_sub = _cart_arr[_ci].getElementsByTagName('dl');			
		
			for( var i=0; i < _cart_sub.length; i ++ ){
				var _l_name = _cart_sub[i].getElementsByTagName('dt')[0].textContent;
				var _l_num = parseInt(_cart_sub[i].getElementsByTagName('input')[0].getAttribute('value'));
				var _l_pr = _cart_sub[i].getElementsByClassName('sum')[0].textContent;
				var _l_price = parseInt(_l_pr.replace(/[^0-9]/gi,''))
				if(_l_name!=''&&_l_price > 0 &&_l_num > 0 ){
					var _t_obj = {};
					_t_obj['PN'] = _l_name;
					_t_obj['PC'] = '';
					_t_obj['AM'] = _l_num;
					_t_obj['PR'] =  _l_price ;
					_t_obj['CT'] = '';
					_NB_LO.push(_t_obj);
				}
				
			}
		}
		
	}
	var _NB_PM = 'u';// 장바구니
}
if( _is_order ){
	var _cart_arr = document.getElementsByClassName('pdt-info div-table');
	if( _cart_arr.length > 0 ){
		var _NB_LO = [];
		
		for( var _ci=0; _ci < _cart_arr.length; _ci ++ ){
			var _cart_sub = _cart_arr[_ci].getElementsByTagName('dl');
		
			for( var i=0; i < _cart_sub.length; i ++ ){
				var _l_name = _cart_sub[i].getElementsByTagName('dt')[0].textContent;
				var _l_num_str = _cart_sub[i].getElementsByClassName('pm')[0].textContent;
				var _l_pr = _cart_sub[i].getElementsByClassName('sum')[0].textContent;
				var _l_price = parseInt(_l_pr.replace(/[^0-9]/gi,''))
				var _l_num = parseInt(_l_num_str.replace(/[^0-9]/gi,''))
				if(_l_name!=''&&_l_price > 0 &&_l_num > 0 ){
					var _t_obj = {};
					_t_obj['PN'] = _l_name;
					_t_obj['PC'] = '';
					_t_obj['AM'] = _l_num;
					_t_obj['PR'] =  _l_price * _l_num;
					_t_obj['CT'] = '';
					_NB_LO.push(_t_obj);
				}
				
			}
		}
		
	}
	var _NB_PM = 'b';// 장바구니
}


if( typeof _NB_CHAT_PSTATUS == 'undefined'){
! function(t, e) {
	"object" == typeof exports && "object" == typeof module ? module.exports = e() : "function" == typeof define && define.amd ? define([], e) : "object" == typeof exports ? exports.io = e() : t.io = e()
}(this, function() {
	return function(t) {
		function e(r) {
			if (n[r]) return n[r].exports;
			var o = n[r] = {
				exports: {},
				id: r,
				loaded: !1
			};
			return t[r].call(o.exports, o, o.exports, e), o.loaded = !0, o.exports
		}
		var n = {};
		return e.m = t, e.c = n, e.p = "", e(0)
	}([function(t, e, n) {
		"use strict";

		function r(t, e) {
			"object" === ("undefined" == typeof t ? "undefined" : o(t)) && (e = t, t = void 0), e = e || {};
			var n, r = i(t),
				s = r.source,
				u = r.id,
				h = r.path,
				f = p[u] && h in p[u].nsps,
				l = e.forceNew || e["force new connection"] || !1 === e.multiplex || f;
			return l ? (c("ignoring socket cache for %s", s), n = a(s, e)) : (p[u] || (c("new io instance for %s", s), p[u] = a(s, e)), n = p[u]), r.query && !e.query && (e.query = r.query), n.socket(r.path, e)
		}
		var o = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function(t) {
				return typeof t
			} : function(t) {
				return t && "function" == typeof Symbol && t.constructor === Symbol && t !== Symbol.prototype ? "symbol" : typeof t
			},
			i = n(1),
			s = n(7),
			a = n(12),
			c = n(3)("socket.io-client");
		t.exports = e = r;
		var p = e.managers = {};
		e.protocol = s.protocol, e.connect = r, e.Manager = n(12), e.Socket = n(36)
	}, function(t, e, n) {
		"use strict";

		function r(t, e) {
			var n = t;
			e = e || "undefined" != typeof location && location, null == t && (t = e.protocol + "//" + e.host), "string" == typeof t && ("/" === t.charAt(0) && (t = "/" === t.charAt(1) ? e.protocol + t : e.host + t), /^(https?|wss?):\/\//.test(t) || (i("protocol-less url %s", t), t = "undefined" != typeof e ? e.protocol + "//" + t : "https://" + t), i("parse %s", t), n = o(t)), n.port || (/^(http|ws)$/.test(n.protocol) ? n.port = "80" : /^(http|ws)s$/.test(n.protocol) && (n.port = "443")), n.path = n.path || "/";
			var r = n.host.indexOf(":") !== -1,
				s = r ? "[" + n.host + "]" : n.host;
			return n.id = n.protocol + "://" + s + ":" + n.port, n.href = n.protocol + "://" + s + (e && e.port === n.port ? "" : ":" + n.port), n
		}
		var o = n(2),
			i = n(3)("socket.io-client:url");
		t.exports = r
	}, function(t, e) {
		var n = /^(?:(?![^:@]+:[^:@\/]*@)(http|https|ws|wss):\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?((?:[a-f0-9]{0,4}:){2,7}[a-f0-9]{0,4}|[^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/,
			r = ["source", "protocol", "authority", "userInfo", "user", "password", "host", "port", "relative", "path", "directory", "file", "query", "anchor"];
		t.exports = function(t) {
			var e = t,
				o = t.indexOf("["),
				i = t.indexOf("]");
			o != -1 && i != -1 && (t = t.substring(0, o) + t.substring(o, i).replace(/:/g, ";") + t.substring(i, t.length));
			for (var s = n.exec(t || ""), a = {}, c = 14; c--;) a[r[c]] = s[c] || "";
			return o != -1 && i != -1 && (a.source = e, a.host = a.host.substring(1, a.host.length - 1).replace(/;/g, ":"), a.authority = a.authority.replace("[", "").replace("]", "").replace(/;/g, ":"), a.ipv6uri = !0), a
		}
	}, function(t, e, n) {
		(function(r) {
			function o() {
				return !("undefined" == typeof window || !window.process || "renderer" !== window.process.type) || ("undefined" == typeof navigator || !navigator.userAgent || !navigator.userAgent.toLowerCase().match(/(edge|trident)\/(\d+)/)) && ("undefined" != typeof document && document.documentElement && document.documentElement.style && document.documentElement.style.WebkitAppearance || "undefined" != typeof window && window.console && (window.console.firebug || window.console.exception && window.console.table) || "undefined" != typeof navigator && navigator.userAgent && navigator.userAgent.toLowerCase().match(/firefox\/(\d+)/) && parseInt(RegExp.$1, 10) >= 31 || "undefined" != typeof navigator && navigator.userAgent && navigator.userAgent.toLowerCase().match(/applewebkit\/(\d+)/))
			}

			function i(t) {
				var n = this.useColors;
				if (t[0] = (n ? "%c" : "") + this.namespace + (n ? " %c" : " ") + t[0] + (n ? "%c " : " ") + "+" + e.humanize(this.diff), n) {
					var r = "color: " + this.color;
					t.splice(1, 0, r, "color: inherit");
					var o = 0,
						i = 0;
					t[0].replace(/%[a-zA-Z%]/g, function(t) {
						"%%" !== t && (o++, "%c" === t && (i = o))
					}), t.splice(i, 0, r)
				}
			}

			function s() {
				return "object" == typeof console && console.log && Function.prototype.apply.call(console.log, console, arguments)
			}

			function a(t) {
				try {
					null == t ? e.storage.removeItem("debug") : e.storage.debug = t
				} catch (n) {}
			}

			function c() {
				var t;
				try {
					t = e.storage.debug
				} catch (n) {}
				return !t && "undefined" != typeof r && "env" in r && (t = r.env.DEBUG), t
			}

			function p() {
				try {
					return window.localStorage
				} catch (t) {}
			}
			e = t.exports = n(5), e.log = s, e.formatArgs = i, e.save = a, e.load = c, e.useColors = o, e.storage = "undefined" != typeof chrome && "undefined" != typeof chrome.storage ? chrome.storage.local : p(), e.colors = ["#0000CC", "#0000FF", "#0033CC", "#0033FF", "#0066CC", "#0066FF", "#0099CC", "#0099FF", "#00CC00", "#00CC33", "#00CC66", "#00CC99", "#00CCCC", "#00CCFF", "#3300CC", "#3300FF", "#3333CC", "#3333FF", "#3366CC", "#3366FF", "#3399CC", "#3399FF", "#33CC00", "#33CC33", "#33CC66", "#33CC99", "#33CCCC", "#33CCFF", "#6600CC", "#6600FF", "#6633CC", "#6633FF", "#66CC00", "#66CC33", "#9900CC", "#9900FF", "#9933CC", "#9933FF", "#99CC00", "#99CC33", "#CC0000", "#CC0033", "#CC0066", "#CC0099", "#CC00CC", "#CC00FF", "#CC3300", "#CC3333", "#CC3366", "#CC3399", "#CC33CC", "#CC33FF", "#CC6600", "#CC6633", "#CC9900", "#CC9933", "#CCCC00", "#CCCC33", "#FF0000", "#FF0033", "#FF0066", "#FF0099", "#FF00CC", "#FF00FF", "#FF3300", "#FF3333", "#FF3366", "#FF3399", "#FF33CC", "#FF33FF", "#FF6600", "#FF6633", "#FF9900", "#FF9933", "#FFCC00", "#FFCC33"], e.formatters.j = function(t) {
				try {
					return JSON.stringify(t)
				} catch (e) {
					return "[UnexpectedJSONParseError]: " + e.message
				}
			}, e.enable(c())
		}).call(e, n(4))
	}, function(t, e) {
		function n() {
			throw new Error("setTimeout has not been defined")
		}

		function r() {
			throw new Error("clearTimeout has not been defined")
		}

		function o(t) {
			if (u === setTimeout) return setTimeout(t, 0);
			if ((u === n || !u) && setTimeout) return u = setTimeout, setTimeout(t, 0);
			try {
				return u(t, 0)
			} catch (e) {
				try {
					return u.call(null, t, 0)
				} catch (e) {
					return u.call(this, t, 0)
				}
			}
		}

		function i(t) {
			if (h === clearTimeout) return clearTimeout(t);
			if ((h === r || !h) && clearTimeout) return h = clearTimeout, clearTimeout(t);
			try {
				return h(t)
			} catch (e) {
				try {
					return h.call(null, t)
				} catch (e) {
					return h.call(this, t)
				}
			}
		}

		function s() {
			y && l && (y = !1, l.length ? d = l.concat(d) : m = -1, d.length && a())
		}

		function a() {
			if (!y) {
				var t = o(s);
				y = !0;
				for (var e = d.length; e;) {
					for (l = d, d = []; ++m < e;) l && l[m].run();
					m = -1, e = d.length
				}
				l = null, y = !1, i(t)
			}
		}

		function c(t, e) {
			this.fun = t, this.array = e
		}

		function p() {}
		var u, h, f = t.exports = {};
		! function() {
			try {
				u = "function" == typeof setTimeout ? setTimeout : n
			} catch (t) {
				u = n
			}
			try {
				h = "function" == typeof clearTimeout ? clearTimeout : r
			} catch (t) {
				h = r
			}
		}();
		var l, d = [],
			y = !1,
			m = -1;
		f.nextTick = function(t) {
			var e = new Array(arguments.length - 1);
			if (arguments.length > 1)
				for (var n = 1; n < arguments.length; n++) e[n - 1] = arguments[n];
			d.push(new c(t, e)), 1 !== d.length || y || o(a)
		}, c.prototype.run = function() {
			this.fun.apply(null, this.array)
		}, f.title = "browser", f.browser = !0, f.env = {}, f.argv = [], f.version = "", f.versions = {}, f.on = p, f.addListener = p, f.once = p, f.off = p, f.removeListener = p, f.removeAllListeners = p, f.emit = p, f.prependListener = p, f.prependOnceListener = p, f.listeners = function(t) {
			return []
		}, f.binding = function(t) {
			throw new Error("process.binding is not supported")
		}, f.cwd = function() {
			return "/"
		}, f.chdir = function(t) {
			throw new Error("process.chdir is not supported")
		}, f.umask = function() {
			return 0
		}
	}, function(t, e, n) {
		function r(t) {
			var n, r = 0;
			for (n in t) r = (r << 5) - r + t.charCodeAt(n), r |= 0;
			return e.colors[Math.abs(r) % e.colors.length]
		}

		function o(t) {
			function n() {
				if (n.enabled) {
					var t = n,
						r = +new Date,
						i = r - (o || r);
					t.diff = i, t.prev = o, t.curr = r, o = r;
					for (var s = new Array(arguments.length), a = 0; a < s.length; a++) s[a] = arguments[a];
					s[0] = e.coerce(s[0]), "string" != typeof s[0] && s.unshift("%O");
					var c = 0;
					s[0] = s[0].replace(/%([a-zA-Z%])/g, function(n, r) {
						if ("%%" === n) return n;
						c++;
						var o = e.formatters[r];
						if ("function" == typeof o) {
							var i = s[c];
							n = o.call(t, i), s.splice(c, 1), c--
						}
						return n
					}), e.formatArgs.call(t, s);
					var p = n.log || e.log || console.log.bind(console);
					p.apply(t, s)
				}
			}
			var o;
			return n.namespace = t, n.enabled = e.enabled(t), n.useColors = e.useColors(), n.color = r(t), n.destroy = i, "function" == typeof e.init && e.init(n), e.instances.push(n), n
		}

		function i() {
			var t = e.instances.indexOf(this);
			return t !== -1 && (e.instances.splice(t, 1), !0)
		}

		function s(t) {
			e.save(t), e.names = [], e.skips = [];
			var n, r = ("string" == typeof t ? t : "").split(/[\s,]+/),
				o = r.length;
			for (n = 0; n < o; n++) r[n] && (t = r[n].replace(/\*/g, ".*?"), "-" === t[0] ? e.skips.push(new RegExp("^" + t.substr(1) + "$")) : e.names.push(new RegExp("^" + t + "$")));
			for (n = 0; n < e.instances.length; n++) {
				var i = e.instances[n];
				i.enabled = e.enabled(i.namespace)
			}
		}

		function a() {
			e.enable("")
		}

		function c(t) {
			if ("*" === t[t.length - 1]) return !0;
			var n, r;
			for (n = 0, r = e.skips.length; n < r; n++)
				if (e.skips[n].test(t)) return !1;
			for (n = 0, r = e.names.length; n < r; n++)
				if (e.names[n].test(t)) return !0;
			return !1
		}

		function p(t) {
			return t instanceof Error ? t.stack || t.message : t
		}
		e = t.exports = o.debug = o["default"] = o, e.coerce = p, e.disable = a, e.enable = s, e.enabled = c, e.humanize = n(6), e.instances = [], e.names = [], e.skips = [], e.formatters = {}
	}, function(t, e) {
		function n(t) {
			if (t = String(t), !(t.length > 100)) {
				var e = /^((?:\d+)?\.?\d+) *(milliseconds?|msecs?|ms|seconds?|secs?|s|minutes?|mins?|m|hours?|hrs?|h|days?|d|years?|yrs?|y)?$/i.exec(t);
				if (e) {
					var n = parseFloat(e[1]),
						r = (e[2] || "ms").toLowerCase();
					switch (r) {
						case "years":
						case "year":
						case "yrs":
						case "yr":
						case "y":
							return n * u;
						case "days":
						case "day":
						case "d":
							return n * p;
						case "hours":
						case "hour":
						case "hrs":
						case "hr":
						case "h":
							return n * c;
						case "minutes":
						case "minute":
						case "mins":
						case "min":
						case "m":
							return n * a;
						case "seconds":
						case "second":
						case "secs":
						case "sec":
						case "s":
							return n * s;
						case "milliseconds":
						case "millisecond":
						case "msecs":
						case "msec":
						case "ms":
							return n;
						default:
							return
					}
				}
			}
		}

		function r(t) {
			return t >= p ? Math.round(t / p) + "d" : t >= c ? Math.round(t / c) + "h" : t >= a ? Math.round(t / a) + "m" : t >= s ? Math.round(t / s) + "s" : t + "ms"
		}

		function o(t) {
			return i(t, p, "day") || i(t, c, "hour") || i(t, a, "minute") || i(t, s, "second") || t + " ms"
		}

		function i(t, e, n) {
			if (!(t < e)) return t < 1.5 * e ? Math.floor(t / e) + " " + n : Math.ceil(t / e) + " " + n + "s"
		}
		var s = 1e3,
			a = 60 * s,
			c = 60 * a,
			p = 24 * c,
			u = 365.25 * p;
		t.exports = function(t, e) {
			e = e || {};
			var i = typeof t;
			if ("string" === i && t.length > 0) return n(t);
			if ("number" === i && isNaN(t) === !1) return e["long"] ? o(t) : r(t);
			throw new Error("val is not a non-empty string or a valid number. val=" + JSON.stringify(t))
		}
	}, function(t, e, n) {
		function r() {}

		function o(t) {
			var n = "" + t.type;
			if (e.BINARY_EVENT !== t.type && e.BINARY_ACK !== t.type || (n += t.attachments + "-"), t.nsp && "/" !== t.nsp && (n += t.nsp + ","), null != t.id && (n += t.id), null != t.data) {
				var r = i(t.data);
				if (r === !1) return g;
				n += r
			}
			return f("encoded %j as %s", t, n), n
		}

		function i(t) {
			try {
				return JSON.stringify(t)
			} catch (e) {
				return !1
			}
		}

		function s(t, e) {
			function n(t) {
				var n = d.deconstructPacket(t),
					r = o(n.packet),
					i = n.buffers;
				i.unshift(r), e(i)
			}
			d.removeBlobs(t, n)
		}

		function a() {
			this.reconstructor = null
		}

		function c(t) {
			var n = 0,
				r = {
					type: Number(t.charAt(0))
				};
			if (null == e.types[r.type]) return h("unknown packet type " + r.type);
			if (e.BINARY_EVENT === r.type || e.BINARY_ACK === r.type) {
				for (var o = "";
					"-" !== t.charAt(++n) && (o += t.charAt(n), n != t.length););
				if (o != Number(o) || "-" !== t.charAt(n)) throw new Error("Illegal attachments");
				r.attachments = Number(o)
			}
			if ("/" === t.charAt(n + 1))
				for (r.nsp = ""; ++n;) {
					var i = t.charAt(n);
					if ("," === i) break;
					if (r.nsp += i, n === t.length) break
				} else r.nsp = "/";
			var s = t.charAt(n + 1);
			if ("" !== s && Number(s) == s) {
				for (r.id = ""; ++n;) {
					var i = t.charAt(n);
					if (null == i || Number(i) != i) {
						--n;
						break
					}
					if (r.id += t.charAt(n), n === t.length) break
				}
				r.id = Number(r.id)
			}
			if (t.charAt(++n)) {
				var a = p(t.substr(n)),
					c = a !== !1 && (r.type === e.ERROR || y(a));
				if (!c) return h("invalid payload");
				r.data = a
			}
			return f("decoded %s as %j", t, r), r
		}

		function p(t) {
			try {
				return JSON.parse(t)
			} catch (e) {
				return !1
			}
		}

		function u(t) {
			this.reconPack = t, this.buffers = []
		}

		function h(t) {
			return {
				type: e.ERROR,
				data: "parser error: " + t
			}
		}
		var f = n(3)("socket.io-parser"),
			l = n(8),
			d = n(9),
			y = n(10),
			m = n(11);
		e.protocol = 4, e.types = ["CONNECT", "DISCONNECT", "EVENT", "ACK", "ERROR", "BINARY_EVENT", "BINARY_ACK"], e.CONNECT = 0, e.DISCONNECT = 1, e.EVENT = 2, e.ACK = 3, e.ERROR = 4, e.BINARY_EVENT = 5, e.BINARY_ACK = 6, e.Encoder = r, e.Decoder = a;
		var g = e.ERROR + '"encode error"';
		r.prototype.encode = function(t, n) {
			if (f("encoding packet %j", t), e.BINARY_EVENT === t.type || e.BINARY_ACK === t.type) s(t, n);
			else {
				var r = o(t);
				n([r])
			}
		}, l(a.prototype), a.prototype.add = function(t) {
			var n;
			if ("string" == typeof t) n = c(t), e.BINARY_EVENT === n.type || e.BINARY_ACK === n.type ? (this.reconstructor = new u(n), 0 === this.reconstructor.reconPack.attachments && this.emit("decoded", n)) : this.emit("decoded", n);
			else {
				if (!m(t) && !t.base64) throw new Error("Unknown type: " + t);
				if (!this.reconstructor) throw new Error("got binary data when not reconstructing a packet");
				n = this.reconstructor.takeBinaryData(t), n && (this.reconstructor = null, this.emit("decoded", n))
			}
		}, a.prototype.destroy = function() {
			this.reconstructor && this.reconstructor.finishedReconstruction()
		}, u.prototype.takeBinaryData = function(t) {
			if (this.buffers.push(t), this.buffers.length === this.reconPack.attachments) {
				var e = d.reconstructPacket(this.reconPack, this.buffers);
				return this.finishedReconstruction(), e
			}
			return null
		}, u.prototype.finishedReconstruction = function() {
			this.reconPack = null, this.buffers = []
		}
	}, function(t, e, n) {
		function r(t) {
			if (t) return o(t)
		}

		function o(t) {
			for (var e in r.prototype) t[e] = r.prototype[e];
			return t
		}
		t.exports = r, r.prototype.on = r.prototype.addEventListener = function(t, e) {
			return this._callbacks = this._callbacks || {}, (this._callbacks["$" + t] = this._callbacks["$" + t] || []).push(e), this
		}, r.prototype.once = function(t, e) {
			function n() {
				this.off(t, n), e.apply(this, arguments)
			}
			return n.fn = e, this.on(t, n), this
		}, r.prototype.off = r.prototype.removeListener = r.prototype.removeAllListeners = r.prototype.removeEventListener = function(t, e) {
			if (this._callbacks = this._callbacks || {}, 0 == arguments.length) return this._callbacks = {}, this;
			var n = this._callbacks["$" + t];
			if (!n) return this;
			if (1 == arguments.length) return delete this._callbacks["$" + t], this;
			for (var r, o = 0; o < n.length; o++)
				if (r = n[o], r === e || r.fn === e) {
					n.splice(o, 1);
					break
				} return this
		}, r.prototype.emit = function(t) {
			this._callbacks = this._callbacks || {};
			var e = [].slice.call(arguments, 1),
				n = this._callbacks["$" + t];
			if (n) {
				n = n.slice(0);
				for (var r = 0, o = n.length; r < o; ++r) n[r].apply(this, e)
			}
			return this
		}, r.prototype.listeners = function(t) {
			return this._callbacks = this._callbacks || {}, this._callbacks["$" + t] || []
		}, r.prototype.hasListeners = function(t) {
			return !!this.listeners(t).length
		}
	}, function(t, e, n) {
		function r(t, e) {
			if (!t) return t;
			if (s(t)) {
				var n = {
					_placeholder: !0,
					num: e.length
				};
				return e.push(t), n
			}
			if (i(t)) {
				for (var o = new Array(t.length), a = 0; a < t.length; a++) o[a] = r(t[a], e);
				return o
			}
			if ("object" == typeof t && !(t instanceof Date)) {
				var o = {};
				for (var c in t) o[c] = r(t[c], e);
				return o
			}
			return t
		}

		function o(t, e) {
			if (!t) return t;
			if (t && t._placeholder) return e[t.num];
			if (i(t))
				for (var n = 0; n < t.length; n++) t[n] = o(t[n], e);
			else if ("object" == typeof t)
				for (var r in t) t[r] = o(t[r], e);
			return t
		}
		var i = n(10),
			s = n(11),
			a = Object.prototype.toString,
			c = "function" == typeof Blob || "undefined" != typeof Blob && "[object BlobConstructor]" === a.call(Blob),
			p = "function" == typeof File || "undefined" != typeof File && "[object FileConstructor]" === a.call(File);
		e.deconstructPacket = function(t) {
			var e = [],
				n = t.data,
				o = t;
			return o.data = r(n, e), o.attachments = e.length, {
				packet: o,
				buffers: e
			}
		}, e.reconstructPacket = function(t, e) {
			return t.data = o(t.data, e), t.attachments = void 0, t
		}, e.removeBlobs = function(t, e) {
			function n(t, a, u) {
				if (!t) return t;
				if (c && t instanceof Blob || p && t instanceof File) {
					r++;
					var h = new FileReader;
					h.onload = function() {
						u ? u[a] = this.result : o = this.result, --r || e(o)
					}, h.readAsArrayBuffer(t)
				} else if (i(t))
					for (var f = 0; f < t.length; f++) n(t[f], f, t);
				else if ("object" == typeof t && !s(t))
					for (var l in t) n(t[l], l, t)
			}
			var r = 0,
				o = t;
			n(o), r || e(o)
		}
	}, function(t, e) {
		var n = {}.toString;
		t.exports = Array.isArray || function(t) {
			return "[object Array]" == n.call(t)
		}
	}, function(t, e) {
		function n(t) {
			return r && Buffer.isBuffer(t) || o && (t instanceof ArrayBuffer || i(t))
		}
		t.exports = n;
		var r = "function" == typeof Buffer && "function" == typeof Buffer.isBuffer,
			o = "function" == typeof ArrayBuffer,
			i = function(t) {
				return "function" == typeof ArrayBuffer.isView ? ArrayBuffer.isView(t) : t.buffer instanceof ArrayBuffer
			}
	}, function(t, e, n) {
		"use strict";

		function r(t, e) {
			if (!(this instanceof r)) return new r(t, e);
			t && "object" === ("undefined" == typeof t ? "undefined" : o(t)) && (e = t, t = void 0), e = e || {}, e.path = e.path || "/socket.io", this.nsps = {}, this.subs = [], this.opts = e, this.reconnection(e.reconnection !== !1), this.reconnectionAttempts(e.reconnectionAttempts || 1 / 0), this.reconnectionDelay(e.reconnectionDelay || 1e3), this.reconnectionDelayMax(e.reconnectionDelayMax || 5e3), this.randomizationFactor(e.randomizationFactor || .5), this.backoff = new l({
				min: this.reconnectionDelay(),
				max: this.reconnectionDelayMax(),
				jitter: this.randomizationFactor()
			}), this.timeout(null == e.timeout ? 2e4 : e.timeout), this.readyState = "closed", this.uri = t, this.connecting = [], this.lastPing = null, this.encoding = !1, this.packetBuffer = [];
			var n = e.parser || c;
			this.encoder = new n.Encoder, this.decoder = new n.Decoder, this.autoConnect = e.autoConnect !== !1, this.autoConnect && this.open()
		}
		var o = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function(t) {
				return typeof t
			} : function(t) {
				return t && "function" == typeof Symbol && t.constructor === Symbol && t !== Symbol.prototype ? "symbol" : typeof t
			},
			i = n(13),
			s = n(36),
			a = n(8),
			c = n(7),
			p = n(38),
			u = n(39),
			h = n(3)("socket.io-client:manager"),
			f = n(35),
			l = n(40),
			d = Object.prototype.hasOwnProperty;
		t.exports = r, r.prototype.emitAll = function() {
			this.emit.apply(this, arguments);
			for (var t in this.nsps) d.call(this.nsps, t) && this.nsps[t].emit.apply(this.nsps[t], arguments)
		}, r.prototype.updateSocketIds = function() {
			for (var t in this.nsps) d.call(this.nsps, t) && (this.nsps[t].id = this.generateId(t))
		}, r.prototype.generateId = function(t) {
			return ("/" === t ? "" : t + "#") + this.engine.id
		}, a(r.prototype), r.prototype.reconnection = function(t) {
			return arguments.length ? (this._reconnection = !!t, this) : this._reconnection
		}, r.prototype.reconnectionAttempts = function(t) {
			return arguments.length ? (this._reconnectionAttempts = t, this) : this._reconnectionAttempts
		}, r.prototype.reconnectionDelay = function(t) {
			return arguments.length ? (this._reconnectionDelay = t, this.backoff && this.backoff.setMin(t), this) : this._reconnectionDelay
		}, r.prototype.randomizationFactor = function(t) {
			return arguments.length ? (this._randomizationFactor = t, this.backoff && this.backoff.setJitter(t), this) : this._randomizationFactor
		}, r.prototype.reconnectionDelayMax = function(t) {
			return arguments.length ? (this._reconnectionDelayMax = t, this.backoff && this.backoff.setMax(t), this) : this._reconnectionDelayMax
		}, r.prototype.timeout = function(t) {
			return arguments.length ? (this._timeout = t, this) : this._timeout
		}, r.prototype.maybeReconnectOnOpen = function() {
			!this.reconnecting && this._reconnection && 0 === this.backoff.attempts && this.reconnect()
		}, r.prototype.open = r.prototype.connect = function(t, e) {
			if (h("readyState %s", this.readyState), ~this.readyState.indexOf("open")) return this;
			h("opening %s", this.uri), this.engine = i(this.uri, this.opts);
			var n = this.engine,
				r = this;
			this.readyState = "opening", this.skipReconnect = !1;
			var o = p(n, "open", function() {
					r.onopen(), t && t()
				}),
				s = p(n, "error", function(e) {
					if (h("connect_error"), r.cleanup(), r.readyState = "closed", r.emitAll("connect_error", e), t) {
						var n = new Error("Connection error");
						n.data = e, t(n)
					} else r.maybeReconnectOnOpen()
				});
			if (!1 !== this._timeout) {
				var a = this._timeout;
				h("connect attempt will timeout after %d", a);
				var c = setTimeout(function() {
					h("connect attempt timed out after %d", a), o.destroy(), n.close(), n.emit("error", "timeout"), r.emitAll("connect_timeout", a)
				}, a);
				this.subs.push({
					destroy: function() {
						clearTimeout(c)
					}
				})
			}
			return this.subs.push(o), this.subs.push(s), this
		}, r.prototype.onopen = function() {
			h("open"), this.cleanup(), this.readyState = "open", this.emit("open");
			var t = this.engine;
			this.subs.push(p(t, "data", u(this, "ondata"))), this.subs.push(p(t, "ping", u(this, "onping"))), this.subs.push(p(t, "pong", u(this, "onpong"))), this.subs.push(p(t, "error", u(this, "onerror"))), this.subs.push(p(t, "close", u(this, "onclose"))), this.subs.push(p(this.decoder, "decoded", u(this, "ondecoded")))
		}, r.prototype.onping = function() {
			this.lastPing = new Date, this.emitAll("ping")
		}, r.prototype.onpong = function() {
			this.emitAll("pong", new Date - this.lastPing)
		}, r.prototype.ondata = function(t) {
			this.decoder.add(t)
		}, r.prototype.ondecoded = function(t) {
			this.emit("packet", t)
		}, r.prototype.onerror = function(t) {
			h("error", t), this.emitAll("error", t)
		}, r.prototype.socket = function(t, e) {
			function n() {
				~f(o.connecting, r) || o.connecting.push(r)
			}
			var r = this.nsps[t];
			if (!r) {
				r = new s(this, t, e), this.nsps[t] = r;
				var o = this;
				r.on("connecting", n), r.on("connect", function() {
					r.id = o.generateId(t)
				}), this.autoConnect && n()
			}
			return r
		}, r.prototype.destroy = function(t) {
			var e = f(this.connecting, t);
			~e && this.connecting.splice(e, 1), this.connecting.length || this.close()
		}, r.prototype.packet = function(t) {
			h("writing packet %j", t);
			var e = this;
			t.query && 0 === t.type && (t.nsp += "?" + t.query), e.encoding ? e.packetBuffer.push(t) : (e.encoding = !0, this.encoder.encode(t, function(n) {
				for (var r = 0; r < n.length; r++) e.engine.write(n[r], t.options);
				e.encoding = !1, e.processPacketQueue()
			}))
		}, r.prototype.processPacketQueue = function() {
			if (this.packetBuffer.length > 0 && !this.encoding) {
				var t = this.packetBuffer.shift();
				this.packet(t)
			}
		}, r.prototype.cleanup = function() {
			h("cleanup");
			for (var t = this.subs.length, e = 0; e < t; e++) {
				var n = this.subs.shift();
				n.destroy()
			}
			this.packetBuffer = [], this.encoding = !1, this.lastPing = null, this.decoder.destroy()
		}, r.prototype.close = r.prototype.disconnect = function() {
			h("disconnect"), this.skipReconnect = !0, this.reconnecting = !1, "opening" === this.readyState && this.cleanup(), this.backoff.reset(), this.readyState = "closed", this.engine && this.engine.close()
		}, r.prototype.onclose = function(t) {
			h("onclose"), this.cleanup(), this.backoff.reset(), this.readyState = "closed", this.emit("close", t), this._reconnection && !this.skipReconnect && this.reconnect()
		}, r.prototype.reconnect = function() {
			if (this.reconnecting || this.skipReconnect) return this;
			var t = this;
			if (this.backoff.attempts >= this._reconnectionAttempts) h("reconnect failed"), this.backoff.reset(), this.emitAll("reconnect_failed"), this.reconnecting = !1;
			else {
				var e = this.backoff.duration();
				h("will wait %dms before reconnect attempt", e), this.reconnecting = !0;
				var n = setTimeout(function() {
					t.skipReconnect || (h("attempting reconnect"), t.emitAll("reconnect_attempt", t.backoff.attempts), t.emitAll("reconnecting", t.backoff.attempts), t.skipReconnect || t.open(function(e) {
						e ? (h("reconnect attempt error"), t.reconnecting = !1, t.reconnect(), t.emitAll("reconnect_error", e.data)) : (h("reconnect success"), t.onreconnect())
					}))
				}, e);
				this.subs.push({
					destroy: function() {
						clearTimeout(n)
					}
				})
			}
		}, r.prototype.onreconnect = function() {
			var t = this.backoff.attempts;
			this.reconnecting = !1, this.backoff.reset(), this.updateSocketIds(), this.emitAll("reconnect", t)
		}
	}, function(t, e, n) {
		t.exports = n(14), t.exports.parser = n(21)
	}, function(t, e, n) {
		function r(t, e) {
			return this instanceof r ? (e = e || {}, t && "object" == typeof t && (e = t, t = null), t ? (t = u(t), e.hostname = t.host, e.secure = "https" === t.protocol || "wss" === t.protocol, e.port = t.port, t.query && (e.query = t.query)) : e.host && (e.hostname = u(e.host).host), this.secure = null != e.secure ? e.secure : "undefined" != typeof location && "https:" === location.protocol, e.hostname && !e.port && (e.port = this.secure ? "443" : "80"), this.agent = e.agent || !1, this.hostname = e.hostname || ("undefined" != typeof location ? location.hostname : "localhost"), this.port = e.port || ("undefined" != typeof location && location.port ? location.port : this.secure ? 443 : 80), this.query = e.query || {}, "string" == typeof this.query && (this.query = h.decode(this.query)), this.upgrade = !1 !== e.upgrade, this.path = (e.path || "/engine.io").replace(/\/$/, "") + "/", this.forceJSONP = !!e.forceJSONP, this.jsonp = !1 !== e.jsonp, this.forceBase64 = !!e.forceBase64, this.enablesXDR = !!e.enablesXDR, this.timestampParam = e.timestampParam || "t", this.timestampRequests = e.timestampRequests, this.transports = e.transports || ["polling", "websocket"], this.transportOptions = e.transportOptions || {}, this.readyState = "", this.writeBuffer = [], this.prevBufferLen = 0, this.policyPort = e.policyPort || 843, this.rememberUpgrade = e.rememberUpgrade || !1, this.binaryType = null, this.onlyBinaryUpgrades = e.onlyBinaryUpgrades, this.perMessageDeflate = !1 !== e.perMessageDeflate && (e.perMessageDeflate || {}), !0 === this.perMessageDeflate && (this.perMessageDeflate = {}), this.perMessageDeflate && null == this.perMessageDeflate.threshold && (this.perMessageDeflate.threshold = 1024), this.pfx = e.pfx || null, this.key = e.key || null, this.passphrase = e.passphrase || null, this.cert = e.cert || null, this.ca = e.ca || null, this.ciphers = e.ciphers || null, this.rejectUnauthorized = void 0 === e.rejectUnauthorized || e.rejectUnauthorized, this.forceNode = !!e.forceNode, this.isReactNative = "undefined" != typeof navigator && "string" == typeof navigator.product && "reactnative" === navigator.product.toLowerCase(), ("undefined" == typeof self || this.isReactNative) && (e.extraHeaders && Object.keys(e.extraHeaders).length > 0 && (this.extraHeaders = e.extraHeaders), e.localAddress && (this.localAddress = e.localAddress)), this.id = null, this.upgrades = null, this.pingInterval = null, this.pingTimeout = null, this.pingIntervalTimer = null, this.pingTimeoutTimer = null, void this.open()) : new r(t, e)
		}

		function o(t) {
			var e = {};
			for (var n in t) t.hasOwnProperty(n) && (e[n] = t[n]);
			return e
		}
		var i = n(15),
			s = n(8),
			a = n(3)("engine.io-client:socket"),
			c = n(35),
			p = n(21),
			u = n(2),
			h = n(29);
		t.exports = r, r.priorWebsocketSuccess = !1, s(r.prototype), r.protocol = p.protocol, r.Socket = r, r.Transport = n(20), r.transports = n(15), r.parser = n(21), r.prototype.createTransport = function(t) {
			a('creating transport "%s"', t);
			var e = o(this.query);
			e.EIO = p.protocol, e.transport = t;
			var n = this.transportOptions[t] || {};
			this.id && (e.sid = this.id);
			var r = new i[t]({
				query: e,
				socket: this,
				agent: n.agent || this.agent,
				hostname: n.hostname || this.hostname,
				port: n.port || this.port,
				secure: n.secure || this.secure,
				path: n.path || this.path,
				forceJSONP: n.forceJSONP || this.forceJSONP,
				jsonp: n.jsonp || this.jsonp,
				forceBase64: n.forceBase64 || this.forceBase64,
				enablesXDR: n.enablesXDR || this.enablesXDR,
				timestampRequests: n.timestampRequests || this.timestampRequests,
				timestampParam: n.timestampParam || this.timestampParam,
				policyPort: n.policyPort || this.policyPort,
				pfx: n.pfx || this.pfx,
				key: n.key || this.key,
				passphrase: n.passphrase || this.passphrase,
				cert: n.cert || this.cert,
				ca: n.ca || this.ca,
				ciphers: n.ciphers || this.ciphers,
				rejectUnauthorized: n.rejectUnauthorized || this.rejectUnauthorized,
				perMessageDeflate: n.perMessageDeflate || this.perMessageDeflate,
				extraHeaders: n.extraHeaders || this.extraHeaders,
				forceNode: n.forceNode || this.forceNode,
				localAddress: n.localAddress || this.localAddress,
				requestTimeout: n.requestTimeout || this.requestTimeout,
				protocols: n.protocols || void 0,
				isReactNative: this.isReactNative
			});
			return r
		}, r.prototype.open = function() {
			var t;
			if (this.rememberUpgrade && r.priorWebsocketSuccess && this.transports.indexOf("websocket") !== -1) t = "websocket";
			else {
				if (0 === this.transports.length) {
					var e = this;
					return void setTimeout(function() {
						e.emit("error", "No transports available")
					}, 0)
				}
				t = this.transports[0]
			}
			this.readyState = "opening";
			try {
				t = this.createTransport(t)
			} catch (n) {
				return this.transports.shift(), void this.open()
			}
			t.open(), this.setTransport(t)
		}, r.prototype.setTransport = function(t) {
			a("setting transport %s", t.name);
			var e = this;
			this.transport && (a("clearing existing transport %s", this.transport.name), this.transport.removeAllListeners()), this.transport = t, t.on("drain", function() {
				e.onDrain()
			}).on("packet", function(t) {
				e.onPacket(t)
			}).on("error", function(t) {
				e.onError(t)
			}).on("close", function() {
				e.onClose("transport close")
			})
		}, r.prototype.probe = function(t) {
			function e() {
				if (f.onlyBinaryUpgrades) {
					var e = !this.supportsBinary && f.transport.supportsBinary;
					h = h || e
				}
				h || (a('probe transport "%s" opened', t), u.send([{
					type: "ping",
					data: "probe"
				}]), u.once("packet", function(e) {
					if (!h)
						if ("pong" === e.type && "probe" === e.data) {
							if (a('probe transport "%s" pong', t), f.upgrading = !0, f.emit("upgrading", u), !u) return;
							r.priorWebsocketSuccess = "websocket" === u.name, a('pausing current transport "%s"', f.transport.name), f.transport.pause(function() {
								h || "closed" !== f.readyState && (a("changing transport and sending upgrade packet"), p(), f.setTransport(u), u.send([{
									type: "upgrade"
								}]), f.emit("upgrade", u), u = null, f.upgrading = !1, f.flush())
							})
						} else {
							a('probe transport "%s" failed', t);
							var n = new Error("probe error");
							n.transport = u.name, f.emit("upgradeError", n)
						}
				}))
			}

			function n() {
				h || (h = !0, p(), u.close(), u = null)
			}

			function o(e) {
				var r = new Error("probe error: " + e);
				r.transport = u.name, n(), a('probe transport "%s" failed because of error: %s', t, e), f.emit("upgradeError", r)
			}

			function i() {
				o("transport closed")
			}

			function s() {
				o("socket closed")
			}

			function c(t) {
				u && t.name !== u.name && (a('"%s" works - aborting "%s"', t.name, u.name), n())
			}

			function p() {
				u.removeListener("open", e), u.removeListener("error", o), u.removeListener("close", i), f.removeListener("close", s), f.removeListener("upgrading", c)
			}
			a('probing transport "%s"', t);
			var u = this.createTransport(t, {
					probe: 1
				}),
				h = !1,
				f = this;
			r.priorWebsocketSuccess = !1, u.once("open", e), u.once("error", o), u.once("close", i), this.once("close", s), this.once("upgrading", c), u.open()
		}, r.prototype.onOpen = function() {
			if (a("socket open"), this.readyState = "open", r.priorWebsocketSuccess = "websocket" === this.transport.name, this.emit("open"), this.flush(), "open" === this.readyState && this.upgrade && this.transport.pause) {
				a("starting upgrade probes");
				for (var t = 0, e = this.upgrades.length; t < e; t++) this.probe(this.upgrades[t])
			}
		}, r.prototype.onPacket = function(t) {
			if ("opening" === this.readyState || "open" === this.readyState || "closing" === this.readyState) switch (a('socket receive: type "%s", data "%s"', t.type, t.data), this.emit("packet", t), this.emit("heartbeat"), t.type) {
				case "open":
					this.onHandshake(JSON.parse(t.data));
					break;
				case "pong":
					this.setPing(), this.emit("pong");
					break;
				case "error":
					var e = new Error("server error");
					e.code = t.data, this.onError(e);
					break;
				case "message":
					this.emit("data", t.data), this.emit("message", t.data)
			} else a('packet received with socket readyState "%s"', this.readyState)
		}, r.prototype.onHandshake = function(t) {
			this.emit("handshake", t), this.id = t.sid, this.transport.query.sid = t.sid, this.upgrades = this.filterUpgrades(t.upgrades), this.pingInterval = t.pingInterval, this.pingTimeout = t.pingTimeout, this.onOpen(), "closed" !== this.readyState && (this.setPing(), this.removeListener("heartbeat", this.onHeartbeat), this.on("heartbeat", this.onHeartbeat))
		}, r.prototype.onHeartbeat = function(t) {
			clearTimeout(this.pingTimeoutTimer);
			var e = this;
			e.pingTimeoutTimer = setTimeout(function() {
				"closed" !== e.readyState && e.onClose("ping timeout")
			}, t || e.pingInterval + e.pingTimeout)
		}, r.prototype.setPing = function() {
			var t = this;
			clearTimeout(t.pingIntervalTimer), t.pingIntervalTimer = setTimeout(function() {
				a("writing ping packet - expecting pong within %sms", t.pingTimeout), t.ping(), t.onHeartbeat(t.pingTimeout)
			}, t.pingInterval)
		}, r.prototype.ping = function() {
			var t = this;
			this.sendPacket("ping", function() {
				t.emit("ping")
			})
		}, r.prototype.onDrain = function() {
			this.writeBuffer.splice(0, this.prevBufferLen), this.prevBufferLen = 0, 0 === this.writeBuffer.length ? this.emit("drain") : this.flush()
		}, r.prototype.flush = function() {
			"closed" !== this.readyState && this.transport.writable && !this.upgrading && this.writeBuffer.length && (a("flushing %d packets in socket", this.writeBuffer.length), this.transport.send(this.writeBuffer), this.prevBufferLen = this.writeBuffer.length, this.emit("flush"))
		}, r.prototype.write = r.prototype.send = function(t, e, n) {
			return this.sendPacket("message", t, e, n), this
		}, r.prototype.sendPacket = function(t, e, n, r) {
			if ("function" == typeof e && (r = e, e = void 0), "function" == typeof n && (r = n, n = null), "closing" !== this.readyState && "closed" !== this.readyState) {
				n = n || {}, n.compress = !1 !== n.compress;
				var o = {
					type: t,
					data: e,
					options: n
				};
				this.emit("packetCreate", o), this.writeBuffer.push(o), r && this.once("flush", r), this.flush()
			}
		}, r.prototype.close = function() {
			function t() {
				r.onClose("forced close"), a("socket closing - telling transport to close"), r.transport.close()
			}

			function e() {
				r.removeListener("upgrade", e), r.removeListener("upgradeError", e), t()
			}

			function n() {
				r.once("upgrade", e), r.once("upgradeError", e)
			}
			if ("opening" === this.readyState || "open" === this.readyState) {
				this.readyState = "closing";
				var r = this;
				this.writeBuffer.length ? this.once("drain", function() {
					this.upgrading ? n() : t()
				}) : this.upgrading ? n() : t()
			}
			return this
		}, r.prototype.onError = function(t) {
			a("socket error %j", t), r.priorWebsocketSuccess = !1, this.emit("error", t), this.onClose("transport error", t)
		}, r.prototype.onClose = function(t, e) {
			if ("opening" === this.readyState || "open" === this.readyState || "closing" === this.readyState) {
				a('socket close with reason: "%s"', t);
				var n = this;
				clearTimeout(this.pingIntervalTimer), clearTimeout(this.pingTimeoutTimer), this.transport.removeAllListeners("close"), this.transport.close(), this.transport.removeAllListeners(), this.readyState = "closed", this.id = null, this.emit("close", t, e), n.writeBuffer = [], n.prevBufferLen = 0
			}
		}, r.prototype.filterUpgrades = function(t) {
			for (var e = [], n = 0, r = t.length; n < r; n++) ~c(this.transports, t[n]) && e.push(t[n]);
			return e
		}
	}, function(t, e, n) {
		function r(t) {
			var e, n = !1,
				r = !1,
				a = !1 !== t.jsonp;
			if ("undefined" != typeof location) {
				var c = "https:" === location.protocol,
					p = location.port;
				p || (p = c ? 443 : 80), n = t.hostname !== location.hostname || p !== t.port, r = t.secure !== c
			}
			if (t.xdomain = n, t.xscheme = r, e = new o(t), "open" in e && !t.forceJSONP) return new i(t);
			if (!a) throw new Error("JSONP disabled");
			return new s(t)
		}
		var o = n(16),
			i = n(18),
			s = n(32),
			a = n(33);
		e.polling = r, e.websocket = a
	}, function(t, e, n) {
		var r = n(17);
		t.exports = function(t) {
			var e = t.xdomain,
				n = t.xscheme,
				o = t.enablesXDR;
			try {
				if ("undefined" != typeof XMLHttpRequest && (!e || r)) return new XMLHttpRequest
			} catch (i) {}
			try {
				if ("undefined" != typeof XDomainRequest && !n && o) return new XDomainRequest
			} catch (i) {}
			if (!e) try {
				return new(self[["Active"].concat("Object").join("X")])("Microsoft.XMLHTTP")
			} catch (i) {}
		}
	}, function(t, e) {
		try {
			t.exports = "undefined" != typeof XMLHttpRequest && "withCredentials" in new XMLHttpRequest
		} catch (n) {
			t.exports = !1
		}
	}, function(t, e, n) {
		function r() {}

		function o(t) {
			if (c.call(this, t), this.requestTimeout = t.requestTimeout, this.extraHeaders = t.extraHeaders, "undefined" != typeof location) {
				var e = "https:" === location.protocol,
					n = location.port;
				n || (n = e ? 443 : 80), this.xd = "undefined" != typeof location && t.hostname !== location.hostname || n !== t.port, this.xs = t.secure !== e
			}
		}

		function i(t) {
			this.method = t.method || "GET", this.uri = t.uri, this.xd = !!t.xd, this.xs = !!t.xs, this.async = !1 !== t.async, this.data = void 0 !== t.data ? t.data : null, this.agent = t.agent, this.isBinary = t.isBinary, this.supportsBinary = t.supportsBinary, this.enablesXDR = t.enablesXDR, this.requestTimeout = t.requestTimeout, this.pfx = t.pfx, this.key = t.key, this.passphrase = t.passphrase, this.cert = t.cert, this.ca = t.ca, this.ciphers = t.ciphers, this.rejectUnauthorized = t.rejectUnauthorized, this.extraHeaders = t.extraHeaders, this.create()
		}

		function s() {
			for (var t in i.requests) i.requests.hasOwnProperty(t) && i.requests[t].abort()
		}
		var a = n(16),
			c = n(19),
			p = n(8),
			u = n(30),
			h = n(3)("engine.io-client:polling-xhr");
		if (t.exports = o, t.exports.Request = i, u(o, c), o.prototype.supportsBinary = !0, o.prototype.request = function(t) {
				return t = t || {}, t.uri = this.uri(), t.xd = this.xd, t.xs = this.xs, t.agent = this.agent || !1, t.supportsBinary = this.supportsBinary, t.enablesXDR = this.enablesXDR, t.pfx = this.pfx, t.key = this.key, t.passphrase = this.passphrase, t.cert = this.cert, t.ca = this.ca, t.ciphers = this.ciphers, t.rejectUnauthorized = this.rejectUnauthorized, t.requestTimeout = this.requestTimeout, t.extraHeaders = this.extraHeaders, new i(t)
			}, o.prototype.doWrite = function(t, e) {
				var n = "string" != typeof t && void 0 !== t,
					r = this.request({
						method: "POST",
						data: t,
						isBinary: n
					}),
					o = this;
				r.on("success", e), r.on("error", function(t) {
					o.onError("xhr post error", t)
				}), this.sendXhr = r
			}, o.prototype.doPoll = function() {
				h("xhr poll");
				var t = this.request(),
					e = this;
				t.on("data", function(t) {
					e.onData(t)
				}), t.on("error", function(t) {
					e.onError("xhr poll error", t)
				}), this.pollXhr = t
			}, p(i.prototype), i.prototype.create = function() {
				var t = {
					agent: this.agent,
					xdomain: this.xd,
					xscheme: this.xs,
					enablesXDR: this.enablesXDR
				};
				t.pfx = this.pfx, t.key = this.key, t.passphrase = this.passphrase, t.cert = this.cert, t.ca = this.ca, t.ciphers = this.ciphers, t.rejectUnauthorized = this.rejectUnauthorized;
				var e = this.xhr = new a(t),
					n = this;
				try {
					h("xhr open %s: %s", this.method, this.uri), e.open(this.method, this.uri, this.async);
					try {
						if (this.extraHeaders) {
							e.setDisableHeaderCheck && e.setDisableHeaderCheck(!0);
							for (var r in this.extraHeaders) this.extraHeaders.hasOwnProperty(r) && e.setRequestHeader(r, this.extraHeaders[r])
						}
					} catch (o) {}
					if ("POST" === this.method) try {
						this.isBinary ? e.setRequestHeader("Content-type", "application/octet-stream") : e.setRequestHeader("Content-type", "text/plain;charset=UTF-8")
					} catch (o) {}
					try {
						e.setRequestHeader("Accept", "*/*")
					} catch (o) {}
					"withCredentials" in e && (e.withCredentials = !0), this.requestTimeout && (e.timeout = this.requestTimeout), this.hasXDR() ? (e.onload = function() {
						n.onLoad()
					}, e.onerror = function() {
						n.onError(e.responseText)
					}) : e.onreadystatechange = function() {
						if (2 === e.readyState) try {
							var t = e.getResponseHeader("Content-Type");
							n.supportsBinary && "application/octet-stream" === t && (e.responseType = "arraybuffer")
						} catch (r) {}
						4 === e.readyState && (200 === e.status || 1223 === e.status ? n.onLoad() : setTimeout(function() {
							n.onError(e.status)
						}, 0))
					}, h("xhr data %s", this.data), e.send(this.data)
				} catch (o) {
					return void setTimeout(function() {
						n.onError(o)
					}, 0)
				}
				"undefined" != typeof document && (this.index = i.requestsCount++, i.requests[this.index] = this)
			}, i.prototype.onSuccess = function() {
				this.emit("success"), this.cleanup()
			}, i.prototype.onData = function(t) {
				this.emit("data", t), this.onSuccess()
			}, i.prototype.onError = function(t) {
				this.emit("error", t), this.cleanup(!0)
			}, i.prototype.cleanup = function(t) {
				if ("undefined" != typeof this.xhr && null !== this.xhr) {
					if (this.hasXDR() ? this.xhr.onload = this.xhr.onerror = r : this.xhr.onreadystatechange = r, t) try {
						this.xhr.abort()
					} catch (e) {}
					"undefined" != typeof document && delete i.requests[this.index], this.xhr = null
				}
			}, i.prototype.onLoad = function() {
				var t;
				try {
					var e;
					try {
						e = this.xhr.getResponseHeader("Content-Type")
					} catch (n) {}
					t = "application/octet-stream" === e ? this.xhr.response || this.xhr.responseText : this.xhr.responseText
				} catch (n) {
					this.onError(n)
				}
				null != t && this.onData(t)
			}, i.prototype.hasXDR = function() {
				return "undefined" != typeof XDomainRequest && !this.xs && this.enablesXDR
			}, i.prototype.abort = function() {
				this.cleanup()
			}, i.requestsCount = 0, i.requests = {}, "undefined" != typeof document)
			if ("function" == typeof attachEvent) attachEvent("onunload", s);
			else if ("function" == typeof addEventListener) {
			var f = "onpagehide" in self ? "pagehide" : "unload";
			addEventListener(f, s, !1)
		}
	}, function(t, e, n) {
		function r(t) {
			var e = t && t.forceBase64;
			u && !e || (this.supportsBinary = !1), o.call(this, t)
		}
		var o = n(20),
			i = n(29),
			s = n(21),
			a = n(30),
			c = n(31),
			p = n(3)("engine.io-client:polling");
		t.exports = r;
		var u = function() {
			var t = n(16),
				e = new t({
					xdomain: !1
				});
			return null != e.responseType
		}();
		a(r, o), r.prototype.name = "polling", r.prototype.doOpen = function() {
			this.poll()
		}, r.prototype.pause = function(t) {
			function e() {
				p("paused"), n.readyState = "paused", t()
			}
			var n = this;
			if (this.readyState = "pausing", this.polling || !this.writable) {
				var r = 0;
				this.polling && (p("we are currently polling - waiting to pause"), r++, this.once("pollComplete", function() {
					p("pre-pause polling complete"), --r || e()
				})), this.writable || (p("we are currently writing - waiting to pause"), r++, this.once("drain", function() {
					p("pre-pause writing complete"), --r || e()
				}))
			} else e()
		}, r.prototype.poll = function() {
			p("polling"), this.polling = !0, this.doPoll(), this.emit("poll")
		}, r.prototype.onData = function(t) {
			var e = this;
			p("polling got data %s", t);
			var n = function(t, n, r) {
				return "opening" === e.readyState && e.onOpen(), "close" === t.type ? (e.onClose(), !1) : void e.onPacket(t)
			};
			s.decodePayload(t, this.socket.binaryType, n), "closed" !== this.readyState && (this.polling = !1, this.emit("pollComplete"), "open" === this.readyState ? this.poll() : p('ignoring poll - transport state "%s"', this.readyState))
		}, r.prototype.doClose = function() {
			function t() {
				p("writing close packet"), e.write([{
					type: "close"
				}])
			}
			var e = this;
			"open" === this.readyState ? (p("transport open - closing"), t()) : (p("transport not open - deferring close"), this.once("open", t))
		}, r.prototype.write = function(t) {
			var e = this;
			this.writable = !1;
			var n = function() {
				e.writable = !0, e.emit("drain")
			};
			s.encodePayload(t, this.supportsBinary, function(t) {
				e.doWrite(t, n)
			})
		}, r.prototype.uri = function() {
			var t = this.query || {},
				e = this.secure ? "https" : "http",
				n = "";
			!1 !== this.timestampRequests && (t[this.timestampParam] = c()), this.supportsBinary || t.sid || (t.b64 = 1), t = i.encode(t), this.port && ("https" === e && 443 !== Number(this.port) || "http" === e && 80 !== Number(this.port)) && (n = ":" + this.port), t.length && (t = "?" + t);
			var r = this.hostname.indexOf(":") !== -1;
			return e + "://" + (r ? "[" + this.hostname + "]" : this.hostname) + n + this.path + t
		}
	}, function(t, e, n) {
		function r(t) {
			this.path = t.path, this.hostname = t.hostname, this.port = t.port, this.secure = t.secure, this.query = t.query, this.timestampParam = t.timestampParam, this.timestampRequests = t.timestampRequests, this.readyState = "", this.agent = t.agent || !1, this.socket = t.socket, this.enablesXDR = t.enablesXDR, this.pfx = t.pfx, this.key = t.key, this.passphrase = t.passphrase, this.cert = t.cert, this.ca = t.ca, this.ciphers = t.ciphers, this.rejectUnauthorized = t.rejectUnauthorized, this.forceNode = t.forceNode, this.isReactNative = t.isReactNative, this.extraHeaders = t.extraHeaders, this.localAddress = t.localAddress
		}
		var o = n(21),
			i = n(8);
		t.exports = r, i(r.prototype), r.prototype.onError = function(t, e) {
			var n = new Error(t);
			return n.type = "TransportError", n.description = e, this.emit("error", n), this
		}, r.prototype.open = function() {
			return "closed" !== this.readyState && "" !== this.readyState || (this.readyState = "opening", this.doOpen()), this
		}, r.prototype.close = function() {
			return "opening" !== this.readyState && "open" !== this.readyState || (this.doClose(), this.onClose()), this
		}, r.prototype.send = function(t) {
			if ("open" !== this.readyState) throw new Error("Transport not open");
			this.write(t)
		}, r.prototype.onOpen = function() {
			this.readyState = "open", this.writable = !0, this.emit("open")
		}, r.prototype.onData = function(t) {
			var e = o.decodePacket(t, this.socket.binaryType);
			this.onPacket(e)
		}, r.prototype.onPacket = function(t) {
			this.emit("packet", t)
		}, r.prototype.onClose = function() {
			this.readyState = "closed", this.emit("close")
		}
	}, function(t, e, n) {
		function r(t, n) {
			var r = "b" + e.packets[t.type] + t.data.data;
			return n(r)
		}

		function o(t, n, r) {
			if (!n) return e.encodeBase64Packet(t, r);
			var o = t.data,
				i = new Uint8Array(o),
				s = new Uint8Array(1 + o.byteLength);
			s[0] = v[t.type];
			for (var a = 0; a < i.length; a++) s[a + 1] = i[a];
			return r(s.buffer)
		}

		function i(t, n, r) {
			if (!n) return e.encodeBase64Packet(t, r);
			var o = new FileReader;
			return o.onload = function() {
				e.encodePacket({
					type: t.type,
					data: o.result
				}, n, !0, r)
			}, o.readAsArrayBuffer(t.data)
		}

		function s(t, n, r) {
			if (!n) return e.encodeBase64Packet(t, r);
			if (g) return i(t, n, r);
			var o = new Uint8Array(1);
			o[0] = v[t.type];
			var s = new k([o.buffer, t.data]);
			return r(s)
		}

		function a(t) {
			try {
				t = d.decode(t, {
					strict: !1
				})
			} catch (e) {
				return !1
			}
			return t
		}

		function c(t, e, n) {
			for (var r = new Array(t.length), o = l(t.length, n), i = function(t, n, o) {
					e(n, function(e, n) {
						r[t] = n, o(e, r)
					})
				}, s = 0; s < t.length; s++) i(s, t[s], o)
		}
		var p, u = n(22),
			h = n(23),
			f = n(24),
			l = n(25),
			d = n(26);
		"undefined" != typeof ArrayBuffer && (p = n(27));
		var y = "undefined" != typeof navigator && /Android/i.test(navigator.userAgent),
			m = "undefined" != typeof navigator && /PhantomJS/i.test(navigator.userAgent),
			g = y || m;
		e.protocol = 3;
		var v = e.packets = {
				open: 0,
				close: 1,
				ping: 2,
				pong: 3,
				message: 4,
				upgrade: 5,
				noop: 6
			},
			b = u(v),
			w = {
				type: "error",
				data: "parser error"
			},
			k = n(28);
		e.encodePacket = function(t, e, n, i) {
			"function" == typeof e && (i = e, e = !1), "function" == typeof n && (i = n, n = null);
			var a = void 0 === t.data ? void 0 : t.data.buffer || t.data;
			if ("undefined" != typeof ArrayBuffer && a instanceof ArrayBuffer) return o(t, e, i);
			if ("undefined" != typeof k && a instanceof k) return s(t, e, i);
			if (a && a.base64) return r(t, i);
			var c = v[t.type];
			return void 0 !== t.data && (c += n ? d.encode(String(t.data), {
				strict: !1
			}) : String(t.data)), i("" + c)
		}, e.encodeBase64Packet = function(t, n) {
			var r = "b" + e.packets[t.type];
			if ("undefined" != typeof k && t.data instanceof k) {
				var o = new FileReader;
				return o.onload = function() {
					var t = o.result.split(",")[1];
					n(r + t)
				}, o.readAsDataURL(t.data)
			}
			var i;
			try {
				i = String.fromCharCode.apply(null, new Uint8Array(t.data))
			} catch (s) {
				for (var a = new Uint8Array(t.data), c = new Array(a.length), p = 0; p < a.length; p++) c[p] = a[p];
				i = String.fromCharCode.apply(null, c)
			}
			return r += btoa(i), n(r)
		}, e.decodePacket = function(t, n, r) {
			if (void 0 === t) return w;
			if ("string" == typeof t) {
				if ("b" === t.charAt(0)) return e.decodeBase64Packet(t.substr(1), n);
				if (r && (t = a(t), t === !1)) return w;
				var o = t.charAt(0);
				return Number(o) == o && b[o] ? t.length > 1 ? {
					type: b[o],
					data: t.substring(1)
				} : {
					type: b[o]
				} : w
			}
			var i = new Uint8Array(t),
				o = i[0],
				s = f(t, 1);
			return k && "blob" === n && (s = new k([s])), {
				type: b[o],
				data: s
			}
		}, e.decodeBase64Packet = function(t, e) {
			var n = b[t.charAt(0)];
			if (!p) return {
				type: n,
				data: {
					base64: !0,
					data: t.substr(1)
				}
			};
			var r = p.decode(t.substr(1));
			return "blob" === e && k && (r = new k([r])), {
				type: n,
				data: r
			}
		}, e.encodePayload = function(t, n, r) {
			function o(t) {
				return t.length + ":" + t
			}

			function i(t, r) {
				e.encodePacket(t, !!s && n, !1, function(t) {
					r(null, o(t))
				})
			}
			"function" == typeof n && (r = n, n = null);
			var s = h(t);
			return n && s ? k && !g ? e.encodePayloadAsBlob(t, r) : e.encodePayloadAsArrayBuffer(t, r) : t.length ? void c(t, i, function(t, e) {
				return r(e.join(""))
			}) : r("0:")
		}, e.decodePayload = function(t, n, r) {
			if ("string" != typeof t) return e.decodePayloadAsBinary(t, n, r);
			"function" == typeof n && (r = n, n = null);
			var o;
			if ("" === t) return r(w, 0, 1);
			for (var i, s, a = "", c = 0, p = t.length; c < p; c++) {
				var u = t.charAt(c);
				if (":" === u) {
					if ("" === a || a != (i = Number(a))) return r(w, 0, 1);
					if (s = t.substr(c + 1, i), a != s.length) return r(w, 0, 1);
					if (s.length) {
						if (o = e.decodePacket(s, n, !1), w.type === o.type && w.data === o.data) return r(w, 0, 1);
						var h = r(o, c + i, p);
						if (!1 === h) return
					}
					c += i, a = ""
				} else a += u
			}
			return "" !== a ? r(w, 0, 1) : void 0
		}, e.encodePayloadAsArrayBuffer = function(t, n) {
			function r(t, n) {
				e.encodePacket(t, !0, !0, function(t) {
					return n(null, t)
				})
			}
			return t.length ? void c(t, r, function(t, e) {
				var r = e.reduce(function(t, e) {
						var n;
						return n = "string" == typeof e ? e.length : e.byteLength, t + n.toString().length + n + 2
					}, 0),
					o = new Uint8Array(r),
					i = 0;
				return e.forEach(function(t) {
					var e = "string" == typeof t,
						n = t;
					if (e) {
						for (var r = new Uint8Array(t.length), s = 0; s < t.length; s++) r[s] = t.charCodeAt(s);
						n = r.buffer
					}
					e ? o[i++] = 0 : o[i++] = 1;
					for (var a = n.byteLength.toString(), s = 0; s < a.length; s++) o[i++] = parseInt(a[s]);
					o[i++] = 255;
					for (var r = new Uint8Array(n), s = 0; s < r.length; s++) o[i++] = r[s]
				}), n(o.buffer)
			}) : n(new ArrayBuffer(0))
		}, e.encodePayloadAsBlob = function(t, n) {
			function r(t, n) {
				e.encodePacket(t, !0, !0, function(t) {
					var e = new Uint8Array(1);
					if (e[0] = 1, "string" == typeof t) {
						for (var r = new Uint8Array(t.length), o = 0; o < t.length; o++) r[o] = t.charCodeAt(o);
						t = r.buffer, e[0] = 0
					}
					for (var i = t instanceof ArrayBuffer ? t.byteLength : t.size, s = i.toString(), a = new Uint8Array(s.length + 1), o = 0; o < s.length; o++) a[o] = parseInt(s[o]);
					if (a[s.length] = 255, k) {
						var c = new k([e.buffer, a.buffer, t]);
						n(null, c)
					}
				})
			}
			c(t, r, function(t, e) {
				return n(new k(e))
			})
		}, e.decodePayloadAsBinary = function(t, n, r) {
			"function" == typeof n && (r = n, n = null);
			for (var o = t, i = []; o.byteLength > 0;) {
				for (var s = new Uint8Array(o), a = 0 === s[0], c = "", p = 1; 255 !== s[p]; p++) {
					if (c.length > 310) return r(w, 0, 1);
					c += s[p]
				}
				o = f(o, 2 + c.length), c = parseInt(c);
				var u = f(o, 0, c);
				if (a) try {
					u = String.fromCharCode.apply(null, new Uint8Array(u))
				} catch (h) {
					var l = new Uint8Array(u);
					u = "";
					for (var p = 0; p < l.length; p++) u += String.fromCharCode(l[p])
				}
				i.push(u), o = f(o, c)
			}
			var d = i.length;
			i.forEach(function(t, o) {
				r(e.decodePacket(t, n, !0), o, d)
			})
		}
	}, function(t, e) {
		t.exports = Object.keys || function(t) {
			var e = [],
				n = Object.prototype.hasOwnProperty;
			for (var r in t) n.call(t, r) && e.push(r);
			return e
		}
	}, function(t, e, n) {
		function r(t) {
			if (!t || "object" != typeof t) return !1;
			if (o(t)) {
				for (var e = 0, n = t.length; e < n; e++)
					if (r(t[e])) return !0;
				return !1
			}
			if ("function" == typeof Buffer && Buffer.isBuffer && Buffer.isBuffer(t) || "function" == typeof ArrayBuffer && t instanceof ArrayBuffer || s && t instanceof Blob || a && t instanceof File) return !0;
			if (t.toJSON && "function" == typeof t.toJSON && 1 === arguments.length) return r(t.toJSON(), !0);
			for (var i in t)
				if (Object.prototype.hasOwnProperty.call(t, i) && r(t[i])) return !0;
			return !1
		}
		var o = n(10),
			i = Object.prototype.toString,
			s = "function" == typeof Blob || "undefined" != typeof Blob && "[object BlobConstructor]" === i.call(Blob),
			a = "function" == typeof File || "undefined" != typeof File && "[object FileConstructor]" === i.call(File);
		t.exports = r
	}, function(t, e) {
		t.exports = function(t, e, n) {
			var r = t.byteLength;
			if (e = e || 0, n = n || r, t.slice) return t.slice(e, n);
			if (e < 0 && (e += r), n < 0 && (n += r), n > r && (n = r), e >= r || e >= n || 0 === r) return new ArrayBuffer(0);
			for (var o = new Uint8Array(t), i = new Uint8Array(n - e), s = e, a = 0; s < n; s++, a++) i[a] = o[s];
			return i.buffer
		}
	}, function(t, e) {
		function n(t, e, n) {
			function o(t, r) {
				if (o.count <= 0) throw new Error("after called too many times");
				--o.count, t ? (i = !0, e(t), e = n) : 0 !== o.count || i || e(null, r)
			}
			var i = !1;
			return n = n || r, o.count = t, 0 === t ? e() : o
		}

		function r() {}
		t.exports = n
	}, function(t, e) {
		function n(t) {
			for (var e, n, r = [], o = 0, i = t.length; o < i;) e = t.charCodeAt(o++), e >= 55296 && e <= 56319 && o < i ? (n = t.charCodeAt(o++), 56320 == (64512 & n) ? r.push(((1023 & e) << 10) + (1023 & n) + 65536) : (r.push(e), o--)) : r.push(e);
			return r
		}

		function r(t) {
			for (var e, n = t.length, r = -1, o = ""; ++r < n;) e = t[r], e > 65535 && (e -= 65536, o += d(e >>> 10 & 1023 | 55296), e = 56320 | 1023 & e), o += d(e);
			return o
		}

		function o(t, e) {
			if (t >= 55296 && t <= 57343) {
				if (e) throw Error("Lone surrogate U+" + t.toString(16).toUpperCase() + " is not a scalar value");
				return !1
			}
			return !0
		}

		function i(t, e) {
			return d(t >> e & 63 | 128)
		}

		function s(t, e) {
			if (0 == (4294967168 & t)) return d(t);
			var n = "";
			return 0 == (4294965248 & t) ? n = d(t >> 6 & 31 | 192) : 0 == (4294901760 & t) ? (o(t, e) || (t = 65533), n = d(t >> 12 & 15 | 224), n += i(t, 6)) : 0 == (4292870144 & t) && (n = d(t >> 18 & 7 | 240), n += i(t, 12), n += i(t, 6)), n += d(63 & t | 128)
		}

		function a(t, e) {
			e = e || {};
			for (var r, o = !1 !== e.strict, i = n(t), a = i.length, c = -1, p = ""; ++c < a;) r = i[c], p += s(r, o);
			return p
		}

		function c() {
			if (l >= f) throw Error("Invalid byte index");
			var t = 255 & h[l];
			if (l++, 128 == (192 & t)) return 63 & t;
			throw Error("Invalid continuation byte")
		}

		function p(t) {
			var e, n, r, i, s;
			if (l > f) throw Error("Invalid byte index");
			if (l == f) return !1;
			if (e = 255 & h[l], l++, 0 == (128 & e)) return e;
			if (192 == (224 & e)) {
				if (n = c(), s = (31 & e) << 6 | n, s >= 128) return s;
				throw Error("Invalid continuation byte")
			}
			if (224 == (240 & e)) {
				if (n = c(), r = c(), s = (15 & e) << 12 | n << 6 | r, s >= 2048) return o(s, t) ? s : 65533;
				throw Error("Invalid continuation byte")
			}
			if (240 == (248 & e) && (n = c(), r = c(), i = c(), s = (7 & e) << 18 | n << 12 | r << 6 | i, s >= 65536 && s <= 1114111)) return s;
			throw Error("Invalid UTF-8 detected")
		}

		function u(t, e) {
			e = e || {};
			var o = !1 !== e.strict;
			h = n(t), f = h.length, l = 0;
			for (var i, s = [];
				(i = p(o)) !== !1;) s.push(i);
			return r(s)
		} /*! https://mths.be/utf8js v2.1.2 by @mathias */
		var h, f, l, d = String.fromCharCode;
		t.exports = {
			version: "2.1.2",
			encode: a,
			decode: u
		}
	}, function(t, e) {
		! function() {
			"use strict";
			for (var t = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", n = new Uint8Array(256), r = 0; r < t.length; r++) n[t.charCodeAt(r)] = r;
			e.encode = function(e) {
				var n, r = new Uint8Array(e),
					o = r.length,
					i = "";
				for (n = 0; n < o; n += 3) i += t[r[n] >> 2], i += t[(3 & r[n]) << 4 | r[n + 1] >> 4], i += t[(15 & r[n + 1]) << 2 | r[n + 2] >> 6], i += t[63 & r[n + 2]];
				return o % 3 === 2 ? i = i.substring(0, i.length - 1) + "=" : o % 3 === 1 && (i = i.substring(0, i.length - 2) + "=="), i
			}, e.decode = function(t) {
				var e, r, o, i, s, a = .75 * t.length,
					c = t.length,
					p = 0;
				"=" === t[t.length - 1] && (a--, "=" === t[t.length - 2] && a--);
				var u = new ArrayBuffer(a),
					h = new Uint8Array(u);
				for (e = 0; e < c; e += 4) r = n[t.charCodeAt(e)], o = n[t.charCodeAt(e + 1)], i = n[t.charCodeAt(e + 2)], s = n[t.charCodeAt(e + 3)], h[p++] = r << 2 | o >> 4, h[p++] = (15 & o) << 4 | i >> 2, h[p++] = (3 & i) << 6 | 63 & s;
				return u
			}
		}()
	}, function(t, e) {
		function n(t) {
			return t.map(function(t) {
				if (t.buffer instanceof ArrayBuffer) {
					var e = t.buffer;
					if (t.byteLength !== e.byteLength) {
						var n = new Uint8Array(t.byteLength);
						n.set(new Uint8Array(e, t.byteOffset, t.byteLength)), e = n.buffer
					}
					return e
				}
				return t
			})
		}

		function r(t, e) {
			e = e || {};
			var r = new i;
			return n(t).forEach(function(t) {
				r.append(t)
			}), e.type ? r.getBlob(e.type) : r.getBlob()
		}

		function o(t, e) {
			return new Blob(n(t), e || {})
		}
		var i = "undefined" != typeof i ? i : "undefined" != typeof WebKitBlobBuilder ? WebKitBlobBuilder : "undefined" != typeof MSBlobBuilder ? MSBlobBuilder : "undefined" != typeof MozBlobBuilder && MozBlobBuilder,
			s = function() {
				try {
					var t = new Blob(["hi"]);
					return 2 === t.size
				} catch (e) {
					return !1
				}
			}(),
			a = s && function() {
				try {
					var t = new Blob([new Uint8Array([1, 2])]);
					return 2 === t.size
				} catch (e) {
					return !1
				}
			}(),
			c = i && i.prototype.append && i.prototype.getBlob;
		"undefined" != typeof Blob && (r.prototype = Blob.prototype, o.prototype = Blob.prototype), t.exports = function() {
			return s ? a ? Blob : o : c ? r : void 0
		}()
	}, function(t, e) {
		e.encode = function(t) {
			var e = "";
			for (var n in t) t.hasOwnProperty(n) && (e.length && (e += "&"), e += encodeURIComponent(n) + "=" + encodeURIComponent(t[n]));
			return e
		}, e.decode = function(t) {
			for (var e = {}, n = t.split("&"), r = 0, o = n.length; r < o; r++) {
				var i = n[r].split("=");
				e[decodeURIComponent(i[0])] = decodeURIComponent(i[1])
			}
			return e
		}
	}, function(t, e) {
		t.exports = function(t, e) {
			var n = function() {};
			n.prototype = e.prototype, t.prototype = new n, t.prototype.constructor = t
		}
	}, function(t, e) {
		"use strict";

		function n(t) {
			var e = "";
			do e = s[t % a] + e, t = Math.floor(t / a); while (t > 0);
			return e
		}

		function r(t) {
			var e = 0;
			for (u = 0; u < t.length; u++) e = e * a + c[t.charAt(u)];
			return e
		}

		function o() {
			var t = n(+new Date);
			return t !== i ? (p = 0, i = t) : t + "." + n(p++)
		}
		for (var i, s = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_".split(""), a = 64, c = {}, p = 0, u = 0; u < a; u++) c[s[u]] = u;
		o.encode = n, o.decode = r, t.exports = o
	}, function(t, e, n) {
		(function(e) {
			function r() {}

			function o() {
				return "undefined" != typeof self ? self : "undefined" != typeof window ? window : "undefined" != typeof e ? e : {}
			}

			function i(t) {
				if (s.call(this, t), this.query = this.query || {}, !c) {
					var e = o();
					c = e.___eio = e.___eio || []
				}
				this.index = c.length;
				var n = this;
				c.push(function(t) {
					n.onData(t)
				}), this.query.j = this.index, "function" == typeof addEventListener && addEventListener("beforeunload", function() {
					n.script && (n.script.onerror = r)
				}, !1)
			}
			var s = n(19),
				a = n(30);
			t.exports = i;
			var c, p = /\n/g,
				u = /\\n/g;
			a(i, s), i.prototype.supportsBinary = !1, i.prototype.doClose = function() {
				this.script && (this.script.parentNode.removeChild(this.script), this.script = null), this.form && (this.form.parentNode.removeChild(this.form), this.form = null, this.iframe = null), s.prototype.doClose.call(this)
			}, i.prototype.doPoll = function() {
				var t = this,
					e = document.createElement("script");
				this.script && (this.script.parentNode.removeChild(this.script), this.script = null), e.async = !0, e.src = this.uri(), e.onerror = function(e) {
					t.onError("jsonp poll error", e)
				};
				var n = document.getElementsByTagName("script")[0];
				n ? n.parentNode.insertBefore(e, n) : (document.head || document.body).appendChild(e), this.script = e;
				var r = "undefined" != typeof navigator && /gecko/i.test(navigator.userAgent);
				r && setTimeout(function() {
					var t = document.createElement("iframe");
					document.body.appendChild(t), document.body.removeChild(t)
				}, 100)
			}, i.prototype.doWrite = function(t, e) {
				function n() {
					r(), e()
				}

				function r() {
					if (o.iframe) try {
						o.form.removeChild(o.iframe)
					} catch (t) {
						o.onError("jsonp polling iframe removal error", t)
					}
					try {
						var e = '<iframe src="javascript:0" name="' + o.iframeId + '">';
						i = document.createElement(e)
					} catch (t) {
						i = document.createElement("iframe"), i.name = o.iframeId, i.src = "javascript:0"
					}
					i.id = o.iframeId, o.form.appendChild(i), o.iframe = i
				}
				var o = this;
				if (!this.form) {
					var i, s = document.createElement("form"),
						a = document.createElement("textarea"),
						c = this.iframeId = "eio_iframe_" + this.index;
					s.className = "socketio", s.style.position = "absolute", s.style.top = "-1000px", s.style.left = "-1000px", s.target = c, s.method = "POST", s.setAttribute("accept-charset", "utf-8"), a.name = "d", s.appendChild(a), document.body.appendChild(s), this.form = s, this.area = a
				}
				this.form.action = this.uri(), r(), t = t.replace(u, "\\\n"), this.area.value = t.replace(p, "\\n");
				try {
					this.form.submit()
				} catch (h) {}
				this.iframe.attachEvent ? this.iframe.onreadystatechange = function() {
					"complete" === o.iframe.readyState && n()
				} : this.iframe.onload = n
			}
		}).call(e, function() {
			return this
		}())
	}, function(t, e, n) {
		function r(t) {
			var e = t && t.forceBase64;
			e && (this.supportsBinary = !1), this.perMessageDeflate = t.perMessageDeflate, this.usingBrowserWebSocket = o && !t.forceNode, this.protocols = t.protocols, this.usingBrowserWebSocket || (l = i), s.call(this, t)
		}
		var o, i, s = n(20),
			a = n(21),
			c = n(29),
			p = n(30),
			u = n(31),
			h = n(3)("engine.io-client:websocket");
		if ("undefined" == typeof self) try {
			i = n(34)
		} catch (f) {} else o = self.WebSocket || self.MozWebSocket;
		var l = o || i;
		t.exports = r, p(r, s), r.prototype.name = "websocket", r.prototype.supportsBinary = !0, r.prototype.doOpen = function() {
			if (this.check()) {
				var t = this.uri(),
					e = this.protocols,
					n = {
						agent: this.agent,
						perMessageDeflate: this.perMessageDeflate
					};
				n.pfx = this.pfx, n.key = this.key, n.passphrase = this.passphrase, n.cert = this.cert, n.ca = this.ca, n.ciphers = this.ciphers, n.rejectUnauthorized = this.rejectUnauthorized, this.extraHeaders && (n.headers = this.extraHeaders), this.localAddress && (n.localAddress = this.localAddress);
				try {
					this.ws = this.usingBrowserWebSocket && !this.isReactNative ? e ? new l(t, e) : new l(t) : new l(t, e, n)
				} catch (r) {
					return this.emit("error", r)
				}
				void 0 === this.ws.binaryType && (this.supportsBinary = !1), this.ws.supports && this.ws.supports.binary ? (this.supportsBinary = !0, this.ws.binaryType = "nodebuffer") : this.ws.binaryType = "arraybuffer", this.addEventListeners()
			}
		}, r.prototype.addEventListeners = function() {
			var t = this;
			this.ws.onopen = function() {
				t.onOpen()
			}, this.ws.onclose = function() {
				t.onClose()
			}, this.ws.onmessage = function(e) {
				t.onData(e.data)
			}, this.ws.onerror = function(e) {
				t.onError("websocket error", e)
			}
		}, r.prototype.write = function(t) {
			function e() {
				n.emit("flush"), setTimeout(function() {
					n.writable = !0, n.emit("drain")
				}, 0)
			}
			var n = this;
			this.writable = !1;
			for (var r = t.length, o = 0, i = r; o < i; o++) ! function(t) {
				a.encodePacket(t, n.supportsBinary, function(o) {
					if (!n.usingBrowserWebSocket) {
						var i = {};
						if (t.options && (i.compress = t.options.compress), n.perMessageDeflate) {
							var s = "string" == typeof o ? Buffer.byteLength(o) : o.length;
							s < n.perMessageDeflate.threshold && (i.compress = !1)
						}
					}
					try {
						n.usingBrowserWebSocket ? n.ws.send(o) : n.ws.send(o, i)
					} catch (a) {
						h("websocket closed before onclose event")
					}--r || e()
				})
			}(t[o])
		}, r.prototype.onClose = function() {
			s.prototype.onClose.call(this)
		}, r.prototype.doClose = function() {
			"undefined" != typeof this.ws && this.ws.close()
		}, r.prototype.uri = function() {
			var t = this.query || {},
				e = this.secure ? "wss" : "ws",
				n = "";
			this.port && ("wss" === e && 443 !== Number(this.port) || "ws" === e && 80 !== Number(this.port)) && (n = ":" + this.port), this.timestampRequests && (t[this.timestampParam] = u()), this.supportsBinary || (t.b64 = 1), t = c.encode(t), t.length && (t = "?" + t);
			var r = this.hostname.indexOf(":") !== -1;
			return e + "://" + (r ? "[" + this.hostname + "]" : this.hostname) + n + this.path + t
		}, r.prototype.check = function() {
			return !(!l || "__initialize" in l && this.name === r.prototype.name)
		}
	}, function(t, e) {}, function(t, e) {
		var n = [].indexOf;
		t.exports = function(t, e) {
			if (n) return t.indexOf(e);
			for (var r = 0; r < t.length; ++r)
				if (t[r] === e) return r;
			return -1
		}
	}, function(t, e, n) {
		"use strict";

		function r(t, e, n) {
			this.io = t, this.nsp = e, this.json = this, this.ids = 0, this.acks = {}, this.receiveBuffer = [], this.sendBuffer = [], this.connected = !1, this.disconnected = !0, this.flags = {}, n && n.query && (this.query = n.query), this.io.autoConnect && this.open()
		}
		var o = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function(t) {
				return typeof t
			} : function(t) {
				return t && "function" == typeof Symbol && t.constructor === Symbol && t !== Symbol.prototype ? "symbol" : typeof t
			},
			i = n(7),
			s = n(8),
			a = n(37),
			c = n(38),
			p = n(39),
			u = n(3)("socket.io-client:socket"),
			h = n(29),
			f = n(23);
		t.exports = e = r;
		var l = {
				connect: 1,
				connect_error: 1,
				connect_timeout: 1,
				connecting: 1,
				disconnect: 1,
				error: 1,
				reconnect: 1,
				reconnect_attempt: 1,
				reconnect_failed: 1,
				reconnect_error: 1,
				reconnecting: 1,
				ping: 1,
				pong: 1
			},
			d = s.prototype.emit;
		s(r.prototype), r.prototype.subEvents = function() {
			if (!this.subs) {
				var t = this.io;
				this.subs = [c(t, "open", p(this, "onopen")), c(t, "packet", p(this, "onpacket")), c(t, "close", p(this, "onclose"))]
			}
		}, r.prototype.open = r.prototype.connect = function() {
			return this.connected ? this : (this.subEvents(), this.io.open(), "open" === this.io.readyState && this.onopen(), this.emit("connecting"), this)
		}, r.prototype.send = function() {
			var t = a(arguments);
			return t.unshift("message"), this.emit.apply(this, t), this
		}, r.prototype.emit = function(t) {
			if (l.hasOwnProperty(t)) return d.apply(this, arguments), this;
			var e = a(arguments),
				n = {
					type: (void 0 !== this.flags.binary ? this.flags.binary : f(e)) ? i.BINARY_EVENT : i.EVENT,
					data: e
				};
			return n.options = {}, n.options.compress = !this.flags || !1 !== this.flags.compress, "function" == typeof e[e.length - 1] && (u("emitting packet with ack id %d", this.ids), this.acks[this.ids] = e.pop(), n.id = this.ids++), this.connected ? this.packet(n) : this.sendBuffer.push(n), this.flags = {}, this
		}, r.prototype.packet = function(t) {
			t.nsp = this.nsp, this.io.packet(t)
		}, r.prototype.onopen = function() {
			if (u("transport is open - connecting"), "/" !== this.nsp)
				if (this.query) {
					var t = "object" === o(this.query) ? h.encode(this.query) : this.query;
					u("sending connect packet with query %s", t), this.packet({
						type: i.CONNECT,
						query: t
					})
				} else this.packet({
					type: i.CONNECT
				})
		}, r.prototype.onclose = function(t) {
			u("close (%s)", t), this.connected = !1, this.disconnected = !0, delete this.id, this.emit("disconnect", t)
		}, r.prototype.onpacket = function(t) {
			var e = t.nsp === this.nsp,
				n = t.type === i.ERROR && "/" === t.nsp;
			if (e || n) switch (t.type) {
				case i.CONNECT:
					this.onconnect();
					break;
				case i.EVENT:
					this.onevent(t);
					break;
				case i.BINARY_EVENT:
					this.onevent(t);
					break;
				case i.ACK:
					this.onack(t);
					break;
				case i.BINARY_ACK:
					this.onack(t);
					break;
				case i.DISCONNECT:
					this.ondisconnect();
					break;
				case i.ERROR:
					this.emit("error", t.data)
			}
		}, r.prototype.onevent = function(t) {
			var e = t.data || [];
			u("emitting event %j", e), null != t.id && (u("attaching ack callback to event"), e.push(this.ack(t.id))), this.connected ? d.apply(this, e) : this.receiveBuffer.push(e)
		}, r.prototype.ack = function(t) {
			var e = this,
				n = !1;
			return function() {
				if (!n) {
					n = !0;
					var r = a(arguments);
					u("sending ack %j", r), e.packet({
						type: f(r) ? i.BINARY_ACK : i.ACK,
						id: t,
						data: r
					})
				}
			}
		}, r.prototype.onack = function(t) {
			var e = this.acks[t.id];
			"function" == typeof e ? (u("calling ack %s with %j", t.id, t.data), e.apply(this, t.data), delete this.acks[t.id]) : u("bad ack %s", t.id)
		}, r.prototype.onconnect = function() {
			this.connected = !0, this.disconnected = !1, this.emit("connect"), this.emitBuffered()
		}, r.prototype.emitBuffered = function() {
			var t;
			for (t = 0; t < this.receiveBuffer.length; t++) d.apply(this, this.receiveBuffer[t]);
			for (this.receiveBuffer = [], t = 0; t < this.sendBuffer.length; t++) this.packet(this.sendBuffer[t]);
			this.sendBuffer = []
		}, r.prototype.ondisconnect = function() {
			u("server disconnect (%s)", this.nsp), this.destroy(), this.onclose("io server disconnect")
		}, r.prototype.destroy = function() {
			if (this.subs) {
				for (var t = 0; t < this.subs.length; t++) this.subs[t].destroy();
				this.subs = null
			}
			this.io.destroy(this)
		}, r.prototype.close = r.prototype.disconnect = function() {
			return this.connected && (u("performing disconnect (%s)", this.nsp), this.packet({
				type: i.DISCONNECT
			})), this.destroy(), this.connected && this.onclose("io client disconnect"), this
		}, r.prototype.compress = function(t) {
			return this.flags.compress = t, this
		}, r.prototype.binary = function(t) {
			return this.flags.binary = t, this
		}
	}, function(t, e) {
		function n(t, e) {
			var n = [];
			e = e || 0;
			for (var r = e || 0; r < t.length; r++) n[r - e] = t[r];
			return n
		}
		t.exports = n
	}, function(t, e) {
		"use strict";

		function n(t, e, n) {
			return t.on(e, n), {
				destroy: function() {
					t.removeListener(e, n)
				}
			}
		}
		t.exports = n
	}, function(t, e) {
		var n = [].slice;
		t.exports = function(t, e) {
			if ("string" == typeof e && (e = t[e]), "function" != typeof e) throw new Error("bind() requires a function");
			var r = n.call(arguments, 2);
			return function() {
				return e.apply(t, r.concat(n.call(arguments)))
			}
		}
	}, function(t, e) {
		function n(t) {
			t = t || {}, this.ms = t.min || 100, this.max = t.max || 1e4, this.factor = t.factor || 2, this.jitter = t.jitter > 0 && t.jitter <= 1 ? t.jitter : 0, this.attempts = 0
		}
		t.exports = n, n.prototype.duration = function() {
			var t = this.ms * Math.pow(this.factor, this.attempts++);
			if (this.jitter) {
				var e = Math.random(),
					n = Math.floor(e * this.jitter * t);
				t = 0 == (1 & Math.floor(10 * e)) ? t - n : t + n
			}
			return 0 | Math.min(t, this.max)
		}, n.prototype.reset = function() {
			this.attempts = 0
		}, n.prototype.setMin = function(t) {
			this.ms = t
		}, n.prototype.setMax = function(t) {
			this.max = t
		}, n.prototype.setJitter = function(t) {
			this.jitter = t
		}
	}])
});

function NB_IndexDB_lib() {
	this.iDB = window.indexedDB||window.mozIndexedDB||window.webkitIndexedDB||window.msIndexedDB;
	this.dbname = "ifdo_webpush_config";	
	this.tversion = 2;
	this.iDBConn = null;
}

NB_IndexDB_lib.prototype = Object.create(null, {
	constructor: {
		value : NB_IndexDB_lib
	},
	init : {
		value : function(handler) {
			var instance = this;
			if(!this.iDB) {
				console.log('IndexedDB is not available.!!');
				return null;
			}
			if ( this.iDBConn ) {
				handler();
			} else {
				var request = this.iDB.open(this.dbname, this.tversion);
				request.onerror = function(event) {
	  				console.error('NB_IndexDB_lib init', event);
	  				return null;
				};
				request.onsuccess = function(event) {
	  				instance.iDBConn = event.target.result;			  
	  				handler();
				};							
				request.onupgradeneeded=function(event){
					instance.iDBConn = event.target.result;
					instance.iDBConn.createObjectStore("ifdo_webpush",{keyPath:"id"})
				};
			}			
		}
	},
	select_indexdb : {
		value : function(tname,data,handler) {
			var instance = this;
			this.init( function() { instance.iDBConn.transaction([tname],"readonly").objectStore(tname).get(data).onsuccess=handler; } );
		}
	},
	update_indexdb : {
		value : function(tname,data) {
			var instance = this;
			this.init( function() { instance.iDBConn.transaction([tname],"readwrite").objectStore(tname).put(data); } );
		}
	},
	delete_indexdb : {
		value : function(tname,data) {
			var instance = this;
			this.init( function() { instance.iDBConn.transaction([tname],"readwrite").objectStore(tname)["delete"](data); } );
		}
	},
});

function NB_User_Chat_util() {	
}

NB_User_Chat_util.prototype = Object.create(null, {
	constructor: {
		value: NB_User_Chat_util
	},
	
	// Layout 기본 Library - START		
	cc : { 
		value : function(t,a,b,c,d,e,f,g,h) {
			var v = a.createElement(b);
			if(c) t == 1 ? v.id = c:v.className = c;
			if(d) d.appendChild(v);
			if(e) v.addEventListener(e,f,g);
			if(h) b == 'img' ? v.src = h : v.innerHTML = h;
			
			return v;
		}
	},
	cct : { 
		value : function(t,b,c,d,e,f,g,h) {
			var v = document.createElement(b);
			if(c) t == 1 ? v.id = c:v.className = c;
			if(d) d.insertBefore(v, d.firstChild);
			if(e) v.addEventListener(e,f,g);
			if(h) b == 'img' ? v.src = h : v.innerHTML = h;
			
			return v;
		}
	},		
	de : {
		value : function(a) {
			return document.getElementById(a);
		}
	},
	fi : {
		value : function(a,b) {
			if(b) {
				var i = document.getElementById(b);
		 		var t = i.contentDocument || i.contentWindow.document;	
		 		return t.getElementById(a);
			} else {
				var i = document.getElementById(a);
				return i.contentDocument || i.contentWindow.document;
			}
		}
	},
	ii : {
		value : function(a,b) {
			return a.getElementById(b);
		}
	},
	ic : {
		value : function(a,b,c) {		
			return c !== undefined ? a.getElementsByClassName(b)[c] : a.getElementsByClassName(b);
		}
	},
	it : {
		value : function(a,b,c) {		
			return c !== undefined ? a.getElementsByTagName(b)[c] : a.getElementsByTagName(b);
		}
	},	
	gs : {
		value : function(a,b) {
			return parseInt(window.getComputedStyle(a).getPropertyValue(b), 10);
		}
	},	
	dataURItoBlob : { 		
		value : function(dataURI) {
		    // convert base64 to raw binary data held in a string
		    // doesn't handle URLEncoded DataURIs - see SO answer #6850276 for code that does this
		    var byteString = atob(dataURI.split(',')[1]);
		
		    // separate out the mime component
		    var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]
		
		    // write the bytes of the string to an ArrayBuffer
		    var ab = new ArrayBuffer(byteString.length);
		    var ia = new Uint8Array(ab);
		    for (var i = 0; i < byteString.length; i++) {
		        ia[i] = byteString.charCodeAt(i);
		    }
		
		    // write the ArrayBuffer to a blob, and you're done
		    var bb = new Blob([ab]);
		    return bb;
		}
	},
	hasUnicode : {
		value : function(a) { 
			for (var i = 0; i < a.length; i++) { 
				if (a.charCodeAt(i) > 127) 
					return true; 
			}
			return false; 
		}
	},
	convertB64 : {
		value : function(a) {
			if( this.hasUnicode(a)) 
				return this.b64EncodeUnicode(a); 
			else 
				return Base64.encode(a);
		}
	},
	b64EncodeUnicode : {
		value : function(str) { 
			return btoa(encodeURIComponent(str).replace(/%([0-9A-F]{2})/g, function toSolidBytes(match, p1) { return String.fromCharCode('0x' + p1); })); 
		}
	},
	su : {
		value : function(a) {
			return this.hasUnicode(a) ? this.b64EncodeUnicode(a) : Base64.encode(a);
		}
	},
	replacebr : {
		value : function(str) {
			if( str == null || str == '' ) return '';
    		var result = str.replace(/\r/g, "");
    		return result.replace(/\n/g, "<br>");
    	}
    },
    strellipsis : {
		value : function(str) {
			var ell_str = "";
    		if ( str != null && str != '' && str.length > 100 ) {
    			ell_str = str.substring( 0, 100 ) + "..."; 
    		} else {
    			ell_str = str;
    		}
    		return ell_str;
    	}
    },
	fadein : {
		value : function(el) {
			el.style.opacity = 0;
  
  			var tick = function() {
    			el.style.opacity = +el.style.opacity + 0.01;
	        	if (+el.style.opacity < 1) {
	      			(window.requestAnimationFrame && requestAnimationFrame(tick)) || setTimeout(tick, 16)
	    		}
			};
			
			tick();
		}
	},	
	fadeout : {
		value : function(el) {
			el.style.opacity = 1;
  
  			var tick = function() {
    			el.style.opacity = +el.style.opacity - 0.01;
	        	if (+el.style.opacity > 0) {
	      			(window.requestAnimationFrame && requestAnimationFrame(tick)) || setTimeout(tick, 16)
	    		} else {
	    			//el.innerHTML = '';
	    		}
			};
			
			tick();
		}
	},
	validateEmail : {
		value : function(email) { 
			var re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i; 
			return re.test(email); 
		}
	},
	ci : {
		value : function(id,b) {
			var iframe = document.createElement('iframe');
			iframe.id = id;
			iframe.setAttribute('allowFullScreen', '');

			b.appendChild(iframe);	
			return iframe.contentDocument || iframe.contentWindow.document;
		}
	},
	getbrowserinfo : {
		value : function() {
			var ua=navigator.userAgent,tem,M=ua.match(/(edge|opera|chrome|safari|firefox|msie|trident(?=\/))\/?\s*(\d+)/i) || [],Edge = ua.match(/(edge(?=\/))\/?\s*(\d+)/i) || [];
			if(/trident/i.test(M[1])){
				tem=/\brv[ :]+(\d+)/g.exec(ua) || []; 
				return {name:'IE',version:(tem[1]||'')};
			} else if ( Edge != null && Edge != '' ) {
				return { name: 'Edge', version: Edge[2] };
			} else if(M[1]==='Chrome'){
				tem=ua.match(/\bOPR\/(\d+)/)
				if(tem!=null){
					return {name:'Opera', version:tem[1]};
				}
			}   
			M=M[2]? [M[1], M[2]]: [navigator.appName, navigator.appVersion, '-?'];
			if((tem=ua.match(/version\/(\d+)/i))!=null) {M.splice(1,1,tem[1]);}
			return { name: M[0], version: M[1] };
		},
	},	
	stripedHTML : {
		value : function(htmlstring) {
			return htmlstring.replace(/<[^>]+>/g, '');
		}
	},	
	linkify : { 
		value : function(inputText) {
			if ( this.ishtml(inputText) )
				return inputText;
				
		    var replacedText, replacePattern1, replacePattern2, replacePattern3;
		
		    //URLs starting with http://, https://, or ftp://
		    replacePattern1 = /(\b(https?|ftp):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/gim;
		    replacedText = inputText.replace(replacePattern1, '<a href="$1" target="_blank">$1</a>');
		
		    //URLs starting with "www." (without // before it, or it'd re-link the ones done above).
		    replacePattern2 = /(^|[^\/])(www\.[\S]+(\b|$))/gim;
		    replacedText = replacedText.replace(replacePattern2, '$1<a href="http://$2" target="_blank">$2</a>');
		
		    //Change email addresses to mailto:: links.
		    replacePattern3 = /(([a-zA-Z0-9\-\_\.])+@[a-zA-Z\_]+?(\.[a-zA-Z]{2,6})+)/gim;
		    replacedText = replacedText.replace(replacePattern3, '<a href="mailto:$1">$1</a>');
		
		    return replacedText;
		}	
	},
	ishtml : {
		value : function(str) {
			var a = document.createElement('div');
			a.innerHTML = str;
			
			for (var c = a.childNodes, i = c.length; i--; ) {
				if (c[i].nodeType == 1) return true; 
			}	
	  		return false;
		}
	},
	evalInnerHTML : {
		value : function(element, text) {
			element.innerHTML = text;
			var scripts = Array.prototype.slice.call(element.getElementsByTagName("script"));
			for (var i = 0; i < scripts.length; i++) {
				if (scripts[i].src != "") {
					var tag = document.createElement("script");
					tag.src = scripts[i].src;
					element.appendChild(tag);
				}
				else {
					eval(scripts[i].innerHTML);
				}
			}
		}
	},
	getStyleProperty  : {
		value : function(propName, element){
			var prefixes = ['Moz', 'Webkit', 'Khtml', 'O', 'Ms'];
			var _cache = { };

			element = element || document.documentElement;
			var style = element.style,prefixed,uPropName;

			// check cache only when no element is given
			if (arguments.length == 1 && typeof _cache[propName] == 'string') {
				return _cache[propName];
			}
		
			// test standard property first
			if (typeof style[propName] == 'string') {
				return (_cache[propName] = propName);
			}

			// capitalize
			uPropName = propName.charAt(0).toUpperCase() + propName.slice(1);

			// test vendor specific properties
			for (var i=0, l=prefixes.length; i<l; i++) {
				prefixed = prefixes[i] + uPropName;
				if (typeof style[prefixed] == 'string') {
					return (_cache[propName] = prefixed);
				}
			}
		}
	},	
	CopyToClipboard  : {
		value : function (containerid) {
		    const el = document.createElement('textarea');
		    el.value = document.getElementById(containerid).childNodes[0].nodeValue;
		    document.body.appendChild(el);
		    el.select();
		    document.execCommand('copy');
		    document.body.removeChild(el);			
		}
	},
	getTimeFromDate : {
		value : function(date) {
		    var am_pm = "AM";
		    var hour = date.getHours();
		    if(hour>=12) am_pm = "PM";
		    if (hour == 0) hour = 12;
		    if(hour>12) hour = hour - 12;
		    if(hour<10) hour = "0"+hour;

		    var minute = date.getMinutes();
		    if (minute<10) minute = "0"+minute;
		    /*
		    var sec = date.getSeconds();
		    if(sec<10) sec = "0"+sec;
		    */
		    return hour+":"+minute+" "+am_pm;
		}
	}
	// Layout 기본 Library -- END
});

var RGBvalues = (function() {

    var _hex2dec = function(v) {
        return parseInt(v, 16)
    };

    var _splitHEX = function(hex) {
        var c;
        if (hex.length === 4) {
            c = (hex.replace('#','')).split('');
            return {
                r: _hex2dec((c[0] + c[0])),
                g: _hex2dec((c[1] + c[1])),
                b: _hex2dec((c[2] + c[2]))
            };
        } else {
             return {
                r: _hex2dec(hex.slice(1,3)),
                g: _hex2dec(hex.slice(3,5)),
                b: _hex2dec(hex.slice(5))
            };
        }
    };

    var _splitRGB = function(rgb) {
        var c = (rgb.slice(rgb.indexOf('(')+1, rgb.indexOf(')'))).split(',');
        var flag = false, obj;
        c = c.map(function(n,i) {
            return (i !== 3) ? parseInt(n, 10) : flag = true, parseFloat(n);
        });
        obj = {
            r: c[0],
            g: c[1],
            b: c[2]
        };
        if (flag) obj.a = c[3];
        return obj;
    };

    var color = function(col) {
        var slc = col.slice(0,1);
        if (slc === '#') {
            return _splitHEX(col);
        } else if (slc.toLowerCase() === 'r') {
            return _splitRGB(col);
        } else {
            return _splitHEX('#48cfad');
        }
    };

    return {
        color: color
    };
}());

function NB_User_Chat_Control(gcode, member_key, room_no, deviceid, page){
	this.gcode = gcode;
	this.member_key = member_key;
	this.deviceid = deviceid;
	this.room_no = room_no;
	this.page = encodeURIComponent(page);	
	this.version = '1.0';
	
	this.og_image = ( document.head.querySelector('[property="og:image"]') ? document.head.querySelector('[property="og:image"]').content : '' );
	this.conn = null;
	//this.conn = this.init();	
}

NB_User_Chat_Control.prototype = Object.create(null, {
	constructor: {
		value: NB_User_Chat_Control
	},
	getHostId : {
		value: function() {
			var hostid = (new Date()).getSeconds() % 4;
			var id = "";
			switch(hostid) {
			case 0 :
				id = (window.location.protocol=="https:" ? "https://chat.ifdo.co.kr:8443":"http://chat.ifdo.co.kr:8080");
				break;
			case 1 :
				id = (window.location.protocol=="https:" ? "https://chat.ifdo.co.kr:8444":"http://chat.ifdo.co.kr:8081");
				break;
			case 2 :
				id = (window.location.protocol=="https:" ? "https://chat2.ifdo.co.kr:8443":"http://chat2.ifdo.co.kr:8080");
				break;
			default:
				id = (window.location.protocol=="https:" ? "https://chat2.ifdo.co.kr:8444":"http://chat2.ifdo.co.kr:8081");
			}
			return id;
		}
	},
	init: {
		value: function() {
			this.conn = io.connect(this.getHostId(), { query:"gcode="+this.gcode
											, path: "/ifdo"
											,reconnection: ( _NB_MKTCD == "NMA119126320" ? false : true )
											,reconnectionDelay: 1000
											,reconnectionDelayMax : 1000
											,reconnectionAttempts: 3
											,transports:['websocket']
											});
		}
	},
	login : {
		value :function() {
			this.conn.emit('login', { 	gcode : this.gcode
										,mode:"send"
										,room_no :this.room_no
										,deviceid:this.deviceid
										,rand: Math.random()
										,version: this.version
										,cur_stamp:cur_stamp
										,cpage: this.page
										,member_key:_NB_ID 
										,useragent: navigator.userAgent
									});
		}
	},
	get_message : {
		value :function(a,b) {
			this.conn.emit('get_message', { gcode : this.gcode
											,mode:"send"
											,manager:b
											,room_no:a
											,deviceid:this.deviceid
											,member_key:this.member_key 
											,cpage: this.page
											,rand: Math.random()
											,version: this.version
											,cur_stamp:cur_stamp
											,useragent: navigator.userAgent
										});
		}
	},
	set_message : {
		value :function(a,b,c) {
			this.conn.emit('set_message', { gcode : this.gcode
											,mode:"send"
											,room_no:this.room_no
											,deviceid:this.deviceid
											,member_key:this.member_key 
											,message : a
											,msgurltype : (c ? c : 0)
											,msgurl : b
											,cpage: this.page	
											,cimage : this.og_image
											,rand: Math.random()
											,version: this.version 
											,useragent: navigator.userAgent
										});
		}
	},
	save_file : {
		value :function(a,b) {
			this.conn.emit('save_file', { gcode : this.gcode
											,mode:"send"
											,room_no:this.room_no
											,deviceid:this.deviceid
											,member_key:this.member_key 
											,cpage: this.page	
											,cimage : this.og_image
											,upload : { filetype : a.type, filedata : b.target.result, file_name : a.name }										
											,rand: Math.random()
											,version: this.version 
											,useragent: navigator.userAgent
										});											
		}
	},
	add_room : {
		value :function() {
			this.conn.emit('add_room', {	gcode : this.gcode
											,mode:"send"
											,room_no:0
											,deviceid:this.deviceid
											,cpage: this.page
											,member_key:this.member_key 
											,rand: Math.random()
											,version: this.version 
											,useragent: navigator.userAgent
											});
		}
	},
	get_room : {
		value :function() {
			this.conn.emit('get_room', { 	gcode : this.gcode
											,mode:"send"
											,room_no:0
											,deviceid:this.deviceid
											,cpage: this.page
											,member_key:this.member_key 
											,rand: Math.random()
											,version: this.version
											,useragent: navigator.userAgent
											});			
		}
	},
	recv_ackmsg : {
		value :function(a) {
			this.conn.emit('recv_ackmsg', {  gcode : this.gcode
											,mode:"send"
											,room_no:this.room_no
											,deviceid:this.deviceid
											,msgid: a
											,cpage: this.page
											,cimage : this.og_image
											,member_key:this.member_key 
											,rand: Math.random()
											,version: this.version
											,useragent: navigator.userAgent
										});						
		}
	},
	close_room : {
		value :function(e) {
			this.conn.emit('close_room', {  gcode : this.gcode
											,mode:"send"
											,room_no:this.room_no
											,deviceid:this.deviceid
											,member_key:this.member_key 
											,email:e
											,rand: Math.random()
											,version: this.version
											,useragent: navigator.userAgent
										});						
		}
	},	
	contact_msg : {
		value : function(a,b,c,d) {
			this.conn.emit('contact_msg', {  gcode : this.gcode
											,mode:"send"
											,room_no:this.room_no
											,deviceid:this.deviceid
											,member_key:this.member_key 
											,email:a
											,wname:b
											,title:c
											,content:d
											,rand: Math.random()
											,version: this.version
											,useragent: navigator.userAgent
										});						
		}
	},
	getmoremessage : {
		value: function(a,b) {
			this.conn.emit('get_moremessage', { gcode : this.gcode
											,mode:"send"
											,room_no:a
											,deviceid:this.deviceid
											,member_key:this.member_key 											
											,manager : this.mid
											,idx : b
											,rand: Math.random()
											,version: this.version
											,useragent: navigator.userAgent
											});
		}
	},	
	getlogparam : {
		value:function(param,icon) {
			this.conn.emit('get_logparam', { 	gcode : this.gcode
												,mode:"send"
												,param:param
												,deviceid:this.deviceid
												,pvcnt:page_count
												,iconshow:icon
												,dnd: _CKO.get('_DNOTODAY') == null ? "" : _CKO.get('_DNOTODAY')
												,cur_stamp:cur_stamp												
												,rand: Math.random()
												,useragent: navigator.userAgent
											});	
		}
	},
	recvlogparam : {
		value:function(param) {
			this.conn.emit('recv_logparam', { 	gcode : this.gcode
												,mode:"send"
												,deviceid:this.deviceid
												,member_key:this.member_key 											
												,amsg:param.automsg
												,logdata:param.log_curdata
												,deviceid:this.deviceid
												,cur_stamp:cur_stamp
												,rand: Math.random()	
												,version: this.version																					
												,useragent: navigator.userAgent
											});	
		}
	},	
	recvnewchatroom : {
		value:function(param) {
			this.conn.emit('recv_new_chatroom', { 	gcode : this.gcode
												,mode:"send"
												,deviceid:this.deviceid
												,manager:param.manager
												,room_no:param.room_no
												,rand: Math.random()	
												,version: this.version		
												,useragent: navigator.userAgent
											});	
		}
	},	
	getdownloadfile : {
		value:function(fid) {
			this.conn.emit('get_downloadfile', { 	gcode : this.gcode
												,mode:"send"
												,deviceid:this.deviceid
												,fileid:fid
												,room_no:this.room_no
												,rand: Math.random()	
												,version: this.version
												,useragent: navigator.userAgent
											});	
		}
	},	
	recvpushmessage: {
		value:function(room_no, msgseq) {
			this.conn.emit('recv_pushmessage', { 	
												gcode : this.gcode
												,mode:"send"
												,deviceid:this.deviceid
												,room_no:room_no
												,msgseq:msgseq
												,cur_stamp:cur_stamp												
												,rand: Math.random()
												,useragent: navigator.userAgent
											});	
		}
	},	
	registersubscriber : {
		value:function(msg) {
			delete msg.msgtype;
			this.conn.emit('add_subscriber', { 	
												gcode : this.gcode
												,mode:"send"
												,deviceid:this.deviceid
												,endpoint: msg.endpoint
												,subscription:JSON.stringify(msg)
												,cur_stamp:cur_stamp												
												,rand: Math.random()
												,useragent: navigator.userAgent
											});	
		}
	},
	removesubscriber : {
		value:function(msg) {
			this.conn.emit('remove_subscriber', { 	
												gcode : this.gcode
												,mode:"send"
												,deviceid:this.deviceid
												,endpoint: msg.endpoint
												,cur_stamp:cur_stamp												
												,rand: Math.random()
												,useragent: navigator.userAgent
											});	
		}
	},
	add_botroom : {
		value :function() {
			this.conn.emit('add_botroom', {	gcode : this.gcode
											,mode:"send"
											,room_no:0
											,deviceid:this.deviceid
											,cpage: this.page
											,member_key:this.member_key 
											,rand: Math.random()
											,version: this.version 
											,useragent: navigator.userAgent
											});
		}
	},	
	getstatframe : {
		value:function(param,src,pwidth) {
			this.conn.emit('get_statframe', { 	gcode : this.gcode
												,mode:"send"
												,param:param
												,deviceid:this.deviceid
												,src:src
												,pwidth:pwidth
												,cur_stamp:cur_stamp												
												,rand: Math.random()
												,useragent: navigator.userAgent
											});	
		}
	},	
});

function NB_User_Chat_Layout(chatcontrol,util,chatmodal) {
	this.chatctrl = chatcontrol;
	this.chatmodal = chatmodal;
	this.util = util;
	this.root = this.util.fi("_NB_IFRAMECHAT");
	this.msgcnt_div = this.util.de("_NBNCNT");
	this.lpop_div = this.util.de('_NB_LPOP');
	this.npush_div = this.util.de('_NB_NPUSH');
	this.nbcbox_div = this.util.de('_NBCBOX');
	this.chaticon_div = this.util.de('_NBCHATICO');
	this.chatimg = this.util.de('_NBCHATIMG');
	
	//this.menu_div = this.util.ii(this.root,'_NBMENU');
	//this.sendbox_div = this.util.ii(this.root,'_NB_SENDBOX');
	//this.inbox_class = this.util.ic(this.root,'in_box',0);
	//this.nbchat_div =  this.util.ii(this.root,'_NBCHAT');
	
	this.chatopenimg = this.util.ic(this.chaticon_div,'_NBCHATOPENIMG',0);
	this.chatcloseimg = this.util.ic(this.chaticon_div,'_NBCHATCLOSEIMG',0);

	this.icon_pos_bottom = 30;
	this.icon_pos_right = 30;
	this.icon_show = 'y';
	this.chat_bot = 'n';
	this.isrest = 'n';
	
	_NB_CHAT_PRESTATUS = 'mainlist';
	_NB_CHAT_PSTATUS = 'mainlist';
	this._NB_INPUTBOX_STATUS = 'hidden';
	this.bg_color = '';
	this.gradation = '';
	this.ms_gradation = '';
	this.linear_gradation = '';
	this.btn_gradation = '';
	
	this._LPOPUP_TIMEOUT = 10000;

	var _nbcbox_div = this.nbcbox_div;
	this.nbcbox_div.addEventListener("transitionend", function() {
		if( !_nbcbox_div.classList.contains("active") ) {
			_nbcbox_div.style.removeProperty("right");
			_nbcbox_div.style.removeProperty("bottom");
			_nbcbox_div.style.removeProperty("position");
			_nbcbox_div.style = "";
		}
	});
	this.nbcbox_div.addEventListener("webkitTransitionEnd", function() {
		if( !_nbcbox_div.classList.contains("active") ) {
			_nbcbox_div.style.removeProperty("right");
			_nbcbox_div.style.removeProperty("bottom");
			_nbcbox_div.style.removeProperty("position");
			_nbcbox_div.style = "";			
		}
	});	
	this.nbcbox_div.addEventListener("msTransitionEnd", function() {
		if( !_nbcbox_div.classList.contains("active") ) {
			_nbcbox_div.style.removeProperty("right");
			_nbcbox_div.style.removeProperty("bottom");
			_nbcbox_div.style.removeProperty("position");
			_nbcbox_div.style = "";			
		}
	});	
	this.input_box = new NB_User_Chat_InputBox(chatcontrol, this.util, this.root, this.sendbox_div);
}

NB_User_Chat_Layout.prototype = Object.create(null, {
	constructor: {
		value: NB_User_Chat_Layout
	},
	init : {
		value : function(data) {
			this.chatbot_yn = data.chatbot_yn;
			this.setlayoutstyle(data.layout);
			this.recvmsgcountlayout(data.unreadtcnt);
			if(data.lastmsg != null )
				this.showlpopmessage(data.lastmsg);
		}
	},
	recvmsgcountlayout : {
		value : function(c) {
			this.msgcnt_div.innerHTML = c && c > 99 ? '99+' : c == 0 ? '' : c;
		}
	},	
	setlayoutstyle : {
		value : function(layout) {
			let chat_layout = this.getdefaultChatStyle(layout.chat_style);
			this.chaticon_div.style.display = ( layout.icon_show == 'n' ? 'none' : 'block' );
			if( layout['bg_color'] != "" ){
				this.bg_color=layout['bg_color'];						
				
				var rgbobj = RGBvalues.color(layout['bg_color']);				
				this.gradation = 'background-image: radial-gradient( at 100% 100%, rgb('+parseInt(rgbobj.r / 3.2)+', '+parseInt(rgbobj.g / 2)+', '+parseInt(rgbobj.b / 1.4)+') , rgb('+rgbobj.r+', '+rgbobj.g+', '+rgbobj.b+') )';
				this.btn_gradation = 'radial-gradient( at 100% 100%, rgb('+parseInt(rgbobj.r / 3.2)+', '+parseInt(rgbobj.g/2)+', '+parseInt(rgbobj.b/1.4)+') , rgb('+rgbobj.r+', '+rgbobj.g+', '+rgbobj.b+') )';
				this.linear_gradation = 'background-image: linear-gradient( to top, rgb('+parseInt(rgbobj.r/3.2)+', '+parseInt(rgbobj.g/2)+', '+parseInt(rgbobj.b/1.4)+') , rgb('+rgbobj.r+', '+rgbobj.g+', '+rgbobj.b+') )'; 
				//this.ms_linear_gradation = '-ms-linear-gradient( to top, rgba('+rgbobj.r+', '+rgbobj.g+', '+rgbobj.b+', 0.75) , rgb('+rgbobj.r+', '+rgbobj.g+', '+rgbobj.b+') )'; 
				//this.ms_gradation = '-ms-radial-gradient( circle, rgba('+rgbobj.r+', '+rgbobj.g+', '+rgbobj.b+', 0.75) , rgb('+rgbobj.r+', '+rgbobj.g+', '+rgbobj.b+') )';
				
				if( layout['bg_img'] != "" ){ 		
					var css_string = 'background: transparent;' + 'background-image: url(\''+layout['bg_img']+'\'); background-repeat: no-repeat;';
					if ( layout['bg_style'] != '' ) {
						var json = JSON.parse(layout['bg_style']);
						css_string += 'background-position : ' + json['background-position'] + ";";
					}
					this.gradation = css_string;
					this.linear_gradation = css_string;
				}
				this.chatimg.style.backgroundImage = this.btn_gradation;
			}
			
			if ( window._NB_isMobile ) {
				this.icon_pos_right = layout.icon_m_right;	
				this.icon_pos_bottom = layout.icon_m_bottom;
			} else {
				this.icon_pos_right = layout.icon_right;	
				this.icon_pos_bottom = layout.icon_bottom;
				
				if ( layout.icon_show == 'y' )
					this.npush_div.style.bottom = (this.icon_pos_bottom + 10 + 61) + "px";
			}
			
			this.icon_show = layout.icon_show; 			
			this.chaticon_div.style.right = this.icon_pos_right + "px";
			this.chaticon_div.style.bottom = this.icon_pos_bottom + "px";
			
			this.lpop_div.style.right = this.icon_pos_right + "px";
			this.lpop_div.style.bottom = (this.icon_pos_bottom + 30) + "px";			
			
			this.chatopenimg.src = chat_layout.icon_imgurl;
		}
	},	
	addroomlayout : {
		value : function(data) {
			var rootlayout = this.util.ii(this.root,'_NBICHATLAYOUT');			
			this.clearlayout();
			this.newchatlayout(data, rootlayout);
		}
	},	
	mainlayout : {
		value : function(data) {
			var instance = this;
			var chat_style = this.getdefaultChatStyle(data.layout.chat_style);
			var rootlayout = this.util.ii(this.root,'_NBICHATLAYOUT');	
			rootlayout.style.bottom = "40px";
			
			var background_div = this.util.cc(0,this.root,'div','_NBTOPBACKGROUND',rootlayout);			
			background_div.setAttribute("style",this.gradation);
			
			var top_div = this.util.cc(0,this.root,'div','_NBTOPLAYOUT',rootlayout);
				var topimgcc_div = this.util.cc(0,this.root,'div','_NBTOPIMAGECONTAINER',top_div);
					//this.util.cc(0,this.root,'img','',topimgcc_div,'','','','https://cdn-naning9.bizhost.kr/img2/logo.png');
					var brandname_div = this.util.cc(0,this.root,'div','_NBTOPTITLE _NBBOXCONTYPE15',topimgcc_div,'','','',chat_style.brand_name);
					brandname_div.style.color = chat_style.brand_color;
					brandname_div.style.fontWeight = chat_style.brand_bold;
			
				var title_div = this.util.cc(0,this.root,'div','_NBTOPTITLECONTAINER',top_div,'','','',data.layout.title);
				title_div.style.color = chat_style.chat_color;
				title_div.style.fontWeight = chat_style.chat_bold;

			if ( window._NB_isMobile ) {
				var mobile_closebtn = this.util.cc(0,this.root,'div','_NBMCLOSEBTNLAYOUT',top_div);	
				var closechat_img = this.util.cc(0,this.root,'div','_NBCLOSEBUTTON',mobile_closebtn,'click',function() { instance.clickchaticon(); },'','');				
			}
				
			if ( data.workinfo.isrest == 'y' ) {
				this.restlayout(data, chat_style);
			}			
			if ( data.room_list.length == 0 && data.workinfo.isrest == 'n') {
				this.introlayout(data, chat_style);
			} else if ( data.room_list.length > 0 ){
				this.chatlistlayout(data);
			}
			
			this.isrest = data.workinfo.isrest;
			
			var ifdologo_box = this.util.cc(0,this.root,'div','_NBLOGOCONTENTBOX',rootlayout.parentNode);
				var ifdologo_div = this.util.cc(0,this.root,'div','_NB_IFDOLOGODIV',ifdologo_box, 'click', function() {
						window.open('//ifdo.co.kr/?NbParam=5756413d', '_blank');
					}, 'false', '');
					this.util.cc(0,this.root,'img','_NB_IFDOLOGO',ifdologo_div,'','','','//img.ifdo.co.kr/img/icon_chatlogo_'+( window._NB_isMobile ? 'm' : 'p' )+'.png');
		}
	},
	restlayout : {
		value : function(data, chat_style) {
			var instance = this;
			var rootlayout = this.util.ii(this.root,'_NBICHATLAYOUT');
			var logimg_div = this.util.cc(0,this.root,'div','_NBLOGOIMGCONTAINER',rootlayout);
			this.util.cc(0,this.root,'img','',logimg_div,'','','',chat_style.chat_logo);
		
		var introbox_div = this.util.cc(0,this.root,'div','_NBCONTENTBOX _NBBOXSTYLE1 _NBSHADOW',rootlayout);
			var introcc1_div = this.util.cc(0,this.root,'div','_NBINTROCONTENTCONTAINER _HBH60',introbox_div);
				this.util.cc(0,this.root,'div','_NBBOXTITLE _NBBOXCONTYPE12 _NBTEXTTOPPADDING30',introcc1_div,'','','','죄송합니다.<br>지금은 상담 운영시간이 아닙니다.<font size="4">&#x1f319;</font>');
				var introcontent1_div = this.util.cc(0,this.root,'div','_NBBOXCONTYPE1 _NBTEXTTOPPADDING5',introcc1_div);
					var introcontent1_span = this.util.cc(1,this.root,'span','_nbworktimedesctitle',introcontent1_div, 'click',function(){
						var desc_span = instance.util.ic(instance.root,'_NBWORKTIMEDESC', 0);
						desc_span.classList.toggle('ON');
					},'false','&#x1F558; 상담 운영 시간 보기');
					this.util.cc(0,this.root,'span','_NBWORKTIMEDESC',introcontent1_div,'','','',this.util.replacebr(data.layout.txt_add)); 
		
			var introdivide_div = this.util.cc(0,this.root,'div','_NBBOXDIVIDER',introbox_div);
			
			var introcc2_div = this.util.cc(0,this.root,'div','_NBINTROCONTENTCONTAINER',introbox_div);
				var introcontent2_div = this.util.cc(0,this.root,'div','_NBBOXCONTYPE11 _NBTEXTCENTERSTYLE',introcc2_div);
					this.util.cc(0,this.root,'span','',introcontent2_div, '','','','이메일로 문의주시면<br>순차적으로 회신 드리도록 하겠습니다.');

				var introbtncc_div = this.util.cc(0,this.root,'div','_NBBOXBTNWRAP',introcc2_div);
					var introcontent2_div = this.util.cc(0,this.root,'div','_NBBOXBTNTYPE1 _NBEMAILBTNTYPE _NBBOXCONTYPE3',introbtncc_div,'click',function(){
						instance.contactuslayout(data);
						//instance.clearlayout();
						//instance.chatctrl.add_room();
					},'false','이메일 문의 하기');
			
			if ( this.chatbot_yn != 'y' )
				return;
			
			this.util.cc(0,this.root,'div','_NBBOXDIVIDER',introbox_div);
			
			var introcc3_div = this.util.cc(0,this.root,'div','_NBINTROCONTENTCONTAINER',introbox_div);
			var introcontent3_div = this.util.cc(0,this.root,'div','_NBBOXCONTYPE11 _NBTEXTCENTERSTYLE',introcc3_div);
				this.util.cc(0,this.root,'span','',introcontent3_div, '','','','챗봇 상담은 가능합니다.<br>챗봇을 이용하시겠습니까?');

			var introbtncc3_div = this.util.cc(0,this.root,'div','_NBBOXBTNWRAP',introcc3_div);
				var introcontent3_div = this.util.cc(0,this.root,'div','_NBBOXBTNTYPE1 _NBBOXCONTYPE3',introbtncc3_div,'click',function(){
					instance.clearlayout();
					instance.chatctrl.add_botroom();
				},'false','챗봇 상담하기');
				introcontent3_div.style.backgroundImage = this.btn_gradation;			
		}
	},
	getdefaultChatStyle : {
		value : function(data) {
			if ( data == '' ) {
				var chat_style = {
					icon_imgurl:"//img.ifdo.co.kr/img/icon_chat_widget.png",
					brand_name:"",
					brand_color:"#000000",
					brand_bold:"bold",
					chat_color:"#ffffff",
					chat_bold:"bold",
					chat_logo:"//img.ifdo.co.kr/img/icon_chat_logo_default.png"						
				};
				return chat_style;
			} else {
				return JSON.parse(data);
			}
		}
	},
	totalroomlistlayout : {
		value : function(data) {
			var instance = this;
			var chat_style = this.getdefaultChatStyle(data.layout.chat_style);
			var rootdiv = this.util.ii(this.root,'_NBICHATLAYOUT');
			rootdiv.style.bottom = "40px";
			
			let chattitle_div = this.util.cc(0,this.root,'div','_NBCHATTITLECONTAINER',rootdiv);
			chattitle_div.setAttribute("style",this.gradation);
			chattitle_div.style.height = "125px"; // IE 에서 사이즈 1 추가 됨. 고정방식으로 처리
			
			let wchattitle_div = this.util.cc(0,this.root,'div','_NBCHATTITLEWRAP',chattitle_div);
			let chatbackbutton = this.util.cc(0,this.root,'div','_NBCHATBACKBUTTON',wchattitle_div,'click', function() {
				instance.chatctrl.get_room();
			}, 'false', '');
			this.util.cc(0,this.root,'img','',chatbackbutton,'','','','//img.ifdo.co.kr/img/ic_arrow_back.png');	
			
			//this.util.cc(0,this.root,'img','_NBCHATTITLELOGO',wchattitle_div,'','','','https://cdn-naning9.bizhost.kr/img2/logo.png');
			var brand_div = this.util.cc(0,this.root,'div','_NBCHATTITLETEXT _NBBOXCONTYPE15',wchattitle_div,'','','',chat_style.brand_name);
			brand_div.style.color = chat_style.brand_color;
			brand_div.style.fontWeight = chat_style.brand_bold;
			
			let wchatinfo_div = this.util.cc(0,this.root,'div','_NBCHATNEWINFOWRAP _NBBOXCONTYPE7',chattitle_div);			
			let ingchatcnt = this.util.cc(0,this.root,'div','_NBCHATINGINFO',wchatinfo_div,'','','','<font size="4">&#x1F4AC;</font> 진행중인 상담 ('+ data.layout.room_cnt +')');
			ingchatcnt.id = '_NBINGCHATCNT';
			
			let managerinfo_div = this.util.cc(0,this.root,'div','_NBCHATWAITMANAGERSINFO',wchatinfo_div);
			let managerinfo_span = this.util.cc(0,this.root,'span','',managerinfo_div);
			
			// 로그인한 매니져 loop
			for(var i = 0; i < data.actmanager.length; i++) {
				let manager = data.actmanager[i];
				if ( manager.seq == 1 ) continue;
				
				this.util.cc(0,this.root,'img','_NBCHATWAITMANAGER',managerinfo_span,'','','',manager.prof_url);
			}
			
			let chatlistbox_div = this.util.cc(0,this.root,'div','_NBCHATLISTBOX _NBBOXSTYLE2',rootdiv);
			let chatlist_div = this.util.cc(0,this.root,'div','_NBCHATPROCLIST',chatlistbox_div);
			chatlist_div.id = '_NBCHATPROCLIST';
			
			for(var i = 0; i < data.room_list.length && i < 10; i++) {
				this.chatproclistlayout(data.room_list[i], chatlist_div, 'down');	
			}
			this.util.cc(0,this.root,'div','_NBCHATPROCEMPTYCONTAINER',chatlistbox_div);
			
			
			let cntbottombox_div = this.util.cc(0,this.root,'div','_NBCONTENTBOTTOMBOX',rootdiv);			
			var introbtncc_div = this.util.cc(0,this.root,'div','_NBBOXBTNWRAP',cntbottombox_div);
			
			if ( data.workinfo.isrest == 'n') {
				let newchatbtn = this.util.cc(0,this.root,'div','_NBBOXBTNTYPE1 _NBBOXCONTYPE9',introbtncc_div,'click',function(){
					_NB_CHAT_PRESTATUS = 'roomlist';
					instance.clearlayout();
					instance.chatbot_yn == 'y' ? instance.chatctrl.add_botroom() : instance.chatctrl.add_room();
				},'false','새로운 상담 시작');
				newchatbtn.style.backgroundImage = this.btn_gradation;
			} else
				this.util.cc(0,this.root,'div','_NBBOXBTNTYPE1 _NBEMAILBTNTYPE _NBBOXCONTYPE3',introbtncc_div,'click',function(){
					_NB_CHAT_PRESTATUS = 'roomlist';
					instance.contactuslayout(data);
				},'false','이메일 문의 하기');			
		
			var ifdologo_box = this.util.cc(0,this.root,'div','_NBLOGOCONTENTBOX',rootdiv.parentNode);
			var ifdologo_div = this.util.cc(0, this.root, 'div', '_NB_IFDOLOGODIV',ifdologo_box, 'click', function() {
				window.open('//ifdo.co.kr/?NbParam=5756413d', '_blank');
			}, 'false', '');	
				this.util.cc(0,this.root,'img','_NB_IFDOLOGO',ifdologo_div,'','','','//img.ifdo.co.kr/img/icon_chatlogo_'+( window._NB_isMobile ? 'm' : 'p' )+'.png');
		}
	},
	introlayout : {
		value : function(data, chat_style) {
			var instance = this;
			var rootlayout = this.util.ii(this.root,'_NBICHATLAYOUT');
			
			var logimg_div = this.util.cc(0,this.root,'div','_NBLOGOIMGCONTAINER',rootlayout);
				this.util.cc(0,this.root,'img','',logimg_div,'','','',chat_style.chat_logo);
			
			var introbox_div = this.util.cc(0,this.root,'div','_NBCONTENTBOX _NBBOXSTYLE1 _NBSHADOW',rootlayout);
				var introcc1_div = this.util.cc(0,this.root,'div','_NBINTROCONTENTCONTAINER _HBH60',introbox_div);
					this.util.cc(0,this.root,'div','_NBBOXTITLE',introcc1_div,'','','','상담을 시작하세요');
					var introcontent1_div = this.util.cc(0,this.root,'div','_NBBOXCONTYPE1 _NBTEXTTOPPADDING5',introcc1_div);
						var introcontent1_span = this.util.cc(0,this.root,'span','',introcontent1_div, '','','',this.getResponseTimeText(data.layout));
			
				var introdivide_div = this.util.cc(0,this.root,'div','_NBBOXDIVIDER',introbox_div);
				
				var introcc2_div = this.util.cc(0,this.root,'div','_NBINTROCONTENTCONTAINER',introbox_div);
					var introcontent2_div = this.util.cc(0,this.root,'div','_NBBOXCONTYPE2',introcc2_div);
					var introcontent2_span = this.util.cc(0,this.root,'span','',introcontent2_div, '','','',this.util.replacebr(data.layout.contents));

					var introbtncc_div = this.util.cc(0,this.root,'div','_NBBOXBTNWRAP',introcc2_div);
						var introcontent2_div = this.util.cc(0,this.root,'div','_NBBOXBTNTYPE1 _NBBOXCONTYPE9',introbtncc_div,'click',function(){
							instance.clearlayout();
							instance.chatbot_yn == 'y' ? instance.chatctrl.add_botroom() : instance.chatctrl.add_room();
						},'false','새로운 상담 시작');
						introcontent2_div.style.backgroundImage = this.btn_gradation;
		}		
	},	
	chatlistlayout : {
		value : function(data) {
			var instance = this;
			var rootlayout = this.util.ii(this.root,'_NBICHATLAYOUT');
			var croot_div = data.workinfo.isrest == 'n' ? this.util.cc(0,this.root,'div','_NBCONTENTBOX _NBBOXSTYLE2',rootlayout) : this.util.cc(0,this.root,'div','_NBCONTENTBOX _NBBOXSTYLE2 _NBSHADOW _NBTEXTTOPMARGIN20',rootlayout) ;
				var cprocic_div = this.util.cc(0,this.root,'div','_NBCHATPROCCONTAINER _HBH60',croot_div);
					var ingchat_div = this.util.cc(0,this.root,'div','_NBBOXTITLE ' + (data.workinfo.isrest == 'n' ? '_NBBOXCONTYPE14' : '_NBBOXCONTYPE13'),cprocic_div,'','','','<font size="4">&#x1F4AC;</font> 진행중인 상담 (' + data.layout.room_cnt + ')');
					ingchat_div.id = '_NBINGCHATCNT';
				
				var cproclist_div = this.util.cc(1,this.root,'div','_NBCHATPROCLIST',croot_div);
				// 채팅 리스트 3개만
				for(var i = 0; i < data.room_list.length && i < 3; i++) {
					this.chatproclistlayout(data.room_list[i], cproclist_div, 'down');	
				}
				
				if( data.layout.room_cnt > 3 ) {
					var moreproc_div = this.util.cc(0,this.root,'div','_NBCHATPROCCONTAINER',croot_div);
						this.util.cc(0,this.root,'div','_NBCHATINFOMOREWRAP _NBBOXCONTYPE8',moreproc_div,'click',function(){
							_NB_CHAT_PRESTATUS = "roomlist";
							instance.chatctrl.get_room();
						},'false','진행중인 상담 더보기');
				} else {
					this.util.cc(0,this.root,'div','_NBCHATPROCEMPTYCONTAINER',croot_div);
				}
				
			if ( data.workinfo.isrest == 'n' ) {
				var btnroot_div = this.util.cc(0,this.root,'div','_NBCONTENTBOX',rootlayout);
					var btncon_div = this.util.cc(0,this.root,'div','_NBINTROCONTENTCONTAINER',btnroot_div);
						var btnwrap_div = this.util.cc(0,this.root,'div','_NBBOXBTNWRAP',btncon_div);
							let newchatbtn = this.util.cc(0,this.root,'div','_NBBOXBTNTYPE1 _NBBOXCONTYPE3',btnwrap_div,'click',function() {
								instance.clearlayout();
								instance.chatbot_yn == 'y' ? instance.chatctrl.add_botroom() : instance.chatctrl.add_room();
							},'false','새로운 상담 시작');
							newchatbtn.style.backgroundImage = this.btn_gradation;
						
						this.util.cc(0,this.root,'div','_NBCHATRESPINFO _NBBOXCONTYPE1',btncon_div,'','','',this.getResponseTimeText(data.layout));
			}
		}
	},
	
	chatproclistlayout : {
		value : function(data, rootdiv, loc) {
			var instance = this;
			let cprocic_div = ( loc == 'down' ? this.util.cc(0,this.root,'div','_NBCHATPROCWARP',rootdiv) : this.util.cct(0,'div','_NBCHATPROCWARP',rootdiv) );
			let msg = ( loc == 'down' ? data.lastmsg : data );
			
			cprocic_div.setAttribute('ifdoc-roomno',data.room_no);
				let cinfo_div = this.util.cc(0,this.root,'div','_NBCHATINFOWRAP',cprocic_div, 'click', function() { 
					instance.chatctrl.get_message(data.room_no, data.managerid);
				}, 'false', '');
					let cprocimg_div = this.util.cc(0,this.root,'div','_NBCHATINFOIMGWRAP',cinfo_div);
						this.util.cc(0,this.root,'img','',cprocimg_div,'','','',msg.prof_url);
						
					let cproccnt_div = this.util.cc(0,this.root,'div','_NBCHATINFOCONTENTWRAP',cinfo_div);
						let cprocuinfo_div = this.util.cc(0,this.root,'div','_NBCHATUINFOWARP',cproccnt_div);
							this.util.cc(0,this.root,'div','_NBCHATUSERNAME _NBBOXCONTYPE5',cprocuinfo_div,'','','',( loc == 'down' ? data.manager_name : msg.name ) );
							this.util.cc(0,this.root,'div','_NBCHATELAPSEDTIME _NBBOXCONTYPE6',cprocuinfo_div,'','','', msg.chour );
							
						let msg_div = this.util.cc(0,this.root,'div','_NBCHATEMSGCONTENT _NBBOXCONTYPE2',cproccnt_div,'','','', this.util.stripedHTML(msg.message) );
						if( msg.msgurltype == 1 )
							 this.util.cc(0,this.root,'img','',msg_div,'','','', msg.msgurl );

				var unreadcnt = parseInt(msg != null && msg.unreadcnt !== undefined ? msg.unreadcnt : 0 );		
				this.util.cc(0,this.root,'div','_NBCHATINFOBADGE _NBBADGETYPE1',cprocic_div,'','','',unreadcnt > 99 ? '99+' : unreadcnt > 0 ? '' + unreadcnt : '');
		}
	},	
	
	deletechatproclistlayout : {
		value : function(data) {
			var rl = this.util.ic(this.root,'_NBCHATPROCWARP');
			for( var i=0;i<rl.length;i++) {
				if ( rl[i].getAttribute('ifdoc-roomno') == data.room_no ) {
					rl[i].parentNode.removeChild(rl[i]);
					break;
				}
			}
		}
	},
	
	addchatproclistlayout : {
		value : function(data) {
			var cproclist_div = this.util.ii(this.root,'_NBCHATPROCLIST');
			this.chatproclistlayout(data, cproclist_div, 'up');
			
			if ( _NB_CHAT_PSTATUS == 'mainlist' ) {
				var rl = this.util.ic(this.root,'_NBCHATPROCWARP');
				if ( rl.length > 3 )
					rl[3].parentNode.removeChild(rl[3]);
			}
		}
	},
	
	setingchatcntlayout : {
		value : function(data) {
			var ingchatcnt_div = this.util.ii(this.root,'_NBINGCHATCNT');
			ingchatcnt_div.innerHTML = '<font size="4">&#x1F4AC;</font> 진행중인 상담 (' + data.layout.room_cnt + ')';			
		}
	},
	
	newchatlayout : {
		value : function(data, rootdiv) {
			var instance = this;
			let chattitle_div = this.util.cc(0,this.root,'div','_NBCHATTITLECONTAINER',rootdiv);
			chattitle_div.setAttribute("style",this.linear_gradation);
			
			let wchattitle_div = this.util.cc(0,this.root,'div','_NBCHATTITLEWRAP',chattitle_div);
			let chatbackbutton = this.util.cc(0,this.root,'div','_NBCHATBACKBUTTON',wchattitle_div,'click', function() {
				instance.chatctrl.get_room();
			}, 'false', '');
			this.util.cc(0,this.root,'img','',chatbackbutton,'','','','//img.ifdo.co.kr/img/ic_arrow_back.png');
						
			// 하단 입력창 생성
			let sendbox_div = this.util.cc(0,this.root,'div','_nb_sbox_main',rootdiv);		
			sendbox_div.id = "_NB_SENDBOX";
			let input_box = new NB_User_Chat_InputBox(this.chatctrl, this.util, this.root, sendbox_div);
			input_box.init(data.layout);
			this._NB_INPUTBOX_STATUS = 'show';
			
			this.createchatlayout(data, rootdiv, chattitle_div, wchattitle_div);
		}
	},
	
	createchatlayout : {
		value : function(data, rootdiv, chattitle_div, wchattitle_div) {
			var instance = this;
			var chat_style = this.getdefaultChatStyle(data.layout.chat_style);
			var chatmodal = this.chatmodal;
			if ( data.room === undefined || data.room.managerid == '0' ) {
				//this.util.cc(0,this.root,'img','_NBCHATTITLELOGO',wchattitle_div,'','','','https://cdn-naning9.bizhost.kr/img2/logo.png');
				var brand_div = this.util.cc(0,this.root,'div','_NBCHATTITLETEXT _NBBOXCONTYPE15',wchattitle_div,'','','',chat_style.brand_name);
				brand_div.style.color = chat_style.brand_color;
				brand_div.style.fontWeight = chat_style.brand_bold;
				
				if ( data.room !== undefined )
					this.util.cc(0,this.root,'div','_NBCLOSEBUTTON',rootdiv,'click',function(){
						if ( data.manager == 1 ) chatmodal.closechatbotmodal(); 
						else chatmodal.closechatmodal(); 					
					},'false','');
				
				let wchatinfo_div = this.util.cc(0,this.root,'div','_NBCHATNEWINFOWRAP _NBBOXCONTYPE7',chattitle_div);
				this.util.cc(0,this.root,'div','_NBCHATSPEEDINFO',wchatinfo_div,'','','',this.getResponseTimeText(data.layout));
				
				let managerinfo_div = this.util.cc(0,this.root,'div','_NBCHATWAITMANAGERSINFO',wchatinfo_div);
				let managerinfo_span = this.util.cc(0,this.root,'span','',managerinfo_div);
				
				// 로그인한 매니져 loop
				for(var i = 0; i < data.actmanager.length; i++) {
					let manager = data.actmanager[i];
					if ( manager.seq == 1 ) continue;
					
					this.util.cc(0,this.root,'img','_NBCHATWAITMANAGER',managerinfo_span,'','','',manager.prof_url);
				}
				
				let chatdiv = this.util.cc(1,this.root,'div','_NBCHAT',rootdiv);
				chatdiv.className = '_NEWCHATSTYLE';				
			} else {
				let wmaninfo_div = this.util.cc(0,this.root,'div','_NBMANAGERINFOWRAP',wchattitle_div);
				this.util.cc(0,this.root,'img','_NBMANAGERPROFILEIMG',wmaninfo_div,'','','',data.room.prof_url);
				let maninfo_div = this.util.cc(0,this.root,'div','_NBMANAGERINFO',wmaninfo_div);
					let brand_div = this.util.cc(0,this.root,'div','_NBSITETITLE _NBBOXCONTYPE9',maninfo_div,'','','',chat_style.brand_name);
					brand_div.style.color = chat_style.brand_color;
					brand_div.style.fontWeight = chat_style.brand_bold;
					
					this.util.cc(0,this.root,'div','_NBMANAGERNAME _NBBOXCONTYPE10 _NBTEXTTOPPADDING5',maninfo_div,'','','',data.room.manager_name);
					
				this.util.cc(0,this.root,'div','_NBCLOSEBUTTON',rootdiv,'click',function(){
					if ( data.manager == 1 ) chatmodal.closechatbotmodal(); 
					else chatmodal.closechatmodal(); 					
				},'false','');
					
					
				let chatdiv = this.util.cc(1,this.root,'div','_NBCHAT',rootdiv);
				chatdiv.className = '_INGCHATSTYLE';				
			}
		}
	},
	
	setgetmessagelayout : {
		value :function(data) {
			var instance = this;
			var rootlayout = this.util.ii(this.root,'_NBICHATLAYOUT');

			if( data.room && data.room.room_no != "" ) 
				this.chatctrl.room_no = data.room.room_no; 			

			this.clearlayout();
			this.newchatlayout(data, rootlayout);
			
			var mesgs = data.message_list;
			var rootdiv = this.util.ii(this.root,'_NBCHAT');
			if ( data.ismoremsg !== undefined && data.ismoremsg.tcnt != 0 )
				this.chatmorelayout(rootdiv, data);
			
			if(mesgs && mesgs.length != 0){
				var date_pivot = '';
				for( var j=0;j<mesgs.length;j++) {
					if ( date_pivot == '' || date_pivot != mesgs[j]['cdate'] ) {
						this.chatdatelayout(rootdiv, data.layout, mesgs[j]);
						date_pivot = mesgs[j]['cdate'];
					}
					this.display_message(mesgs[j], data.layout, rootdiv, false);
				}
			}
			
			if ( data.cstatus.status == 4 || data.cstatus.status == 3 )
				this.chatstatlayout(data);
			
			if ( data.cstatus.status == 4 )
				this.hiddeninputbox();
			
			this.movechatbottom();
			this.recvmsgcountlayout(data.unreadtcnt);
			
			_NB_CHAT_PRESTATUS = _NB_CHAT_PSTATUS; 
			_NB_CHAT_PSTATUS = 'chatting';
		}
	},
	
	recvmessagelayout : {
		value : function(data) {
			if ( !this.nbcbox_div.classList.contains("active") ) {
				if ( data.message_list[0].mode != 'send' || data.message_list[0].msgurltype != 5 ) {
					this.recvmsgcountlayout(data.unreadtcnt);				
					this.showlpopmessage(data.message_list[0]);				
				}
			} else if(_NB_CHAT_PSTATUS == 'chatting' && data.room.room_no == this.chatctrl.room_no ){
				this.addmessagelayout(data);
			} else if ( _NB_CHAT_PSTATUS == 'chatting' && data.room.room_no != this.chatctrl.room_no ) {
				this.recvmsgcountlayout(data.unreadtcnt);
			} else if ( _NB_CHAT_PSTATUS == 'mainlist' && !$("#_NBCHATPROCLIST").length ){
				this.chatctrl.get_room();
			} else {
				data.message_list[0].unreadcnt = data.room.unreadcnt;
				this.deletechatproclistlayout(data.message_list[0]);
				this.addchatproclistlayout(data.message_list[0]);
				this.setingchatcntlayout(data);
				
				this.recvmsgcountlayout(data.unreadtcnt);
			}
		}
	},
	
	setmanagerlayout : {
		value : function(data) {
			if( _NB_CHAT_PSTATUS == "roomlist" || _NB_CHAT_PSTATUS == "mainlist" ) { 
				var rl = this.util.ic(this.root,'_NBCHATPROCWARP');
				for( var i=0;i<rl.length;i++) {
					if ( rl[i].getAttribute('ifdoc-roomno') == data.actlist.room_no ) {
							this.modifyroommanagerprint(rl[i],data)
						break;
					}			
				}				
			} else if ( _NB_CHAT_PSTATUS == "chatting") {
				if ( this.chatctrl.room_no == data.actlist.room_no )
					this.modifychattitleprint(data);
			}
		}
	},

	modifyroommanagerprint : {
		value : function(r,m) {
			if ( m == null )
				return;
				
			var img_div = this.util.it(this.util.ic(r,'_NBCHATINFOIMGWRAP',0),'img',0);
			img_div.src = m.manager.manager_url;
			
			var msgmname_div = this.util.ic(r,'_NBCHATUSERNAME',0);
			msgmname_div.innerHTML = m.manager.manager_name;
		}
	},
	
	modifychattitleprint : {
		value : function(data) {
			let instance = this;
			var chat_style = this.getdefaultChatStyle(data.layout.chat_style);
			var chatmodal = this.chatmodal;			
			let rootdiv = this.util.ii(this.root,'_NBICHATLAYOUT');			
			let chattitle_div = this.util.ic(rootdiv,'_NBCHATTITLECONTAINER', 0);
			chattitle_div.setAttribute("style",this.linear_gradation);
			
			let delchatinfo_div = this.util.ic(chattitle_div, '_NBCHATNEWINFOWRAP', 0);
			if ( delchatinfo_div ) chattitle_div.removeChild(delchatinfo_div);
			let delwchattitle_div = this.util.ic(chattitle_div, '_NBCHATTITLEWRAP', 0);
			if ( delwchattitle_div )  chattitle_div.removeChild(delwchattitle_div);

			let wchattitle_div = this.util.cc(0,this.root,'div','_NBCHATTITLEWRAP',chattitle_div);
			let chatbackbutton = this.util.cc(0,this.root,'div','_NBCHATBACKBUTTON',wchattitle_div,'click', function() {
				instance.chatctrl.get_room();
			}, 'false', '');
			this.util.cc(0,this.root,'img','',chatbackbutton,'','','','//img.ifdo.co.kr/img/ic_arrow_back.png');
			
			let wmaninfo_div = this.util.cc(0,this.root,'div','_NBMANAGERINFOWRAP',wchattitle_div);
			this.util.cc(0,this.root,'img','_NBMANAGERPROFILEIMG',wmaninfo_div,'','','',data.manager.manager_url);
			let maninfo_div = this.util.cc(0,this.root,'div','_NBMANAGERINFO',wmaninfo_div);
				let brand_div = this.util.cc(0,this.root,'div','_NBSITETITLE _NBBOXCONTYPE9',maninfo_div,'','','',chat_style.brand_name);
				brand_div.style.color = chat_style.brand_color;
				brand_div.style.fontWeight = chat_style.brand_bold;				
				this.util.cc(0,this.root,'div','_NBMANAGERNAME _NBBOXCONTYPE10 _NBTEXTTOPPADDING5',maninfo_div,'','','',data.manager.manager_name);
				
			this.util.cc(0,this.root,'div','_NBCLOSEBUTTON',rootdiv,'click',function(){
				chatmodal.closechatmodal(); 					
			},'false','');

			
			let chatdiv = this.util.ii(this.root,'_NBCHAT');
			chatdiv.className = '_INGCHATSTYLE';
		}
	},
	
	setmessagelayout : { 
		value : function(data) {
			if( data.room && data.room.room_no != "" ) 
				this.chatctrl.room_no = data.room.room_no; 
			
			if ( this.util.ii(this.root, '_NB_ITXT') )
				this.util.ii(this.root, '_NB_ITXT').value = '';
			
			//if ( data.isfirst == 'y' ) {}
			this.addmessagelayout(data);

			_NB_CHAT_PRESTATUS = _NB_CHAT_PSTATUS;
			_NB_CHAT_PSTATUS = 'chatting';
		}
	},
	
	getResponseTimeText : {
		value : function(data) {
			var resp_minute = parseInt(data.avg_response_time);
			var resp_text = '';
			
			if ( resp_minute >= 0 && resp_minute <= 10 ) {
				resp_text = '응답시간 매우 빠름 <font size="4">&#x26A1;</font><br>보통 수분 이내에 응답. (10분 기준)';
			} else if ( resp_minute <= 30 ) {
				resp_text = '응답시간 빠름 <font size="4">&#x1F325;</font><br>보통 30분 이내에 응답. (10~30분)';
			} else {
				resp_text = '응답시간 보통 <font size="4">&#x1F327;</font><br>보통 1시간 내에 응답 (30분 이상)';
			}
			
			return resp_text;
		}
	},
	
	addbotmessagelayout : { 
		value : function(data) {
			var instance = this;
			var rootlayout = this.util.ii(this.root,'_NBICHATLAYOUT');

			if( data.room && data.room.room_no != "" ) 
				this.chatctrl.room_no = data.room.room_no; 			

			if ( data.isfirst == 'y' ) {
				this.clearlayout();
				this.newchatlayout(data, rootlayout);
				this.hiddeninputbox();
				_NB_CHAT_PRESTATUS = _NB_CHAT_PSTATUS; 
			}
			
			this.addmessagelayout(data);			
			_NB_CHAT_PSTATUS = 'chatting';						
		}
	},	
	
	clearlayout : {
		value : function() {
			var rootlayout = this.util.ii(this.root, '_NBICHATLAYOUT');
			rootlayout.innerHTML = '';
			rootlayout.style.bottom = "0px";
			
			var logolayout = this.util.ic(this.root, '_NBLOGOCONTENTBOX', 0);
			if ( logolayout )
				logolayout.parentNode.removeChild(logolayout);
		}
	},
	
	clickchaticon : {
		value : function() {
			this.lpop_div.innerHTML = '';

			if( this.nbcbox_div.classList.contains("active") ) {
				if ( _NB_CHAT_PSTATUS == 'mainlist')
					this.clearlayout();								
				this.nbcbox_div.classList.remove("active");	
				
				this.chatcloseimg.classList.remove("active");
				this.chatopenimg.classList.add("active");
			} else {
				this.nbcbox_div.classList.add('active');
				this.resizelayout();
				
				this.chatcloseimg.classList.add("active");
				this.chatopenimg.classList.remove("active");
				
				if ( _NB_CHAT_PSTATUS == 'mainlist' || _NB_CHAT_PSTATUS == 'roomlist' ) {
					this.chatctrl.get_room();
				}
			}
		}
	},
	
	resizelayout : {
		value : function() {
			if( window._NB_isMobile ){
				this.nbcbox_div.style.position ='fixed';
				this.nbcbox_div.style.left = 0;
				this.nbcbox_div.style.top = 0;
				this.nbcbox_div.style.right = 0;
				this.nbcbox_div.style.bottom = 0;
				this.nbcbox_div.style.width = '100%';
				this.nbcbox_div.style.height = '100%';
				this.nbcbox_div.style.maxHeight  = 'none';
			} else {
				if( this.nbcbox_div.classList.contains("active") ) {
					this.nbcbox_div.style.position ='fixed';
					this.nbcbox_div.style.right = this.icon_pos_right + 'px';
					this.nbcbox_div.style.bottom = ( this.icon_pos_bottom + 20 + 60 ) + 'px';
				}
			}			
		}
	},
	
	setroomlistlayout : {
		value : function(data) {
			this.clearlayout();
			
			if ( _NB_CHAT_PRESTATUS == 'roomlist' ) {
				_NB_CHAT_PRESTATUS='mainlist';
				_NB_CHAT_PSTATUS='roomlist';
				this.totalroomlistlayout(data);
			} else {
				this.mainlayout(data);			
				_NB_CHAT_PSTATUS='mainlist';
			}
			
			this.chatctrl.room_no = 0;
		}
	},	
	
	getmessagechatbotlayout : {
		value :function(data) {
			if( data.room && data.room.room_no != "" ) 
				this.chatctrl.room_no = data.room.room_no; 

			this.clearlayout();
			this.setchattitlelayout(data);
			this.chatbotinputboxlayout(data.layout);
			
			var mesgs = data.message_list;
			var rootdiv = this.util.ii(this.root,'_NBCHAT');
			if ( data.ismoremsg.tcnt != 0 )
				this.chatmorelayout(rootdiv, data);
			
			if(mesgs && mesgs.length != 0){
				var date_pivot = '';
				for( var j=0;j<mesgs.length;j++) {				
					if ( date_pivot == '' || date_pivot != mesgs[j]['cdate'] ) {
						this.chatdatelayout(rootdiv, data.layout, mesgs[j]);
						date_pivot = mesgs[j]['cdate'];
					}
					this.display_message(mesgs[j], data.layout, rootdiv, false);
				}
			}
						
			this.movechatbottom();
			this.recvmsgcountlayout(data.unreadtcnt);
			
			_NB_CHAT_PSTATUS = 'chatting';
		}
	},	
	
	setmoremessagelayout : {
		value :function(data) {
			var mesgs = data.message_list;
			
			var prevroot_div = this.util.cct(0,'div','_NBPREVCHATMSGCONTAINER',this.util.ii(this.root,'_NBCHAT'));
			
			if ( data.ismoremsg.tcnt != 0 )
				this.chatmorelayout(prevroot_div,data);
			
			if(mesgs && mesgs.length != 0){
				var date_pivot = '';
				
				this.delete_datetitle(data);
				
				for( var j=0;j<mesgs.length;j++) {					
					if ( date_pivot == '' || date_pivot != mesgs[j]['cdate'] ) {
						this.chatdatelayout(prevroot_div, data.layout, mesgs[j]);
						date_pivot = mesgs[j]['cdate'];
					}
					this.display_message(mesgs[j], data.layout, prevroot_div, false);
				}
			}			
			
			_NB_CHAT_PSTATUS = 'chatting';
		}
	},
	
	display_message : {
		value:function(msg, layout, rootdiv, istyping) {
			if ( msg['opt'] == 'msg' )
				msg['mode'] == 'send' ? this.chatrightlayout(rootdiv, layout, msg) : this.chatleftlayout(rootdiv, layout, msg, istyping);
			else if ( msg['opt'] == 'accept' || msg['opt'] == 'leave' )
				this.display_invite(msg, layout, rootdiv);			
		}
	},

	display_invite : {
		value:function(msg,layout,rootdiv) {
			var layoutdiv = this.util.cc(0,this.root,'div','_NBCHATINVITELAYOUT',rootdiv);
			var wrapdiv = this.util.cc(0,this.root,'div','_NBCHATINVITEWRAPUP',layoutdiv);
			this.util.cc(0,this.root,'img','_NBCHATINVITE_PROFILE',wrapdiv,'','','',msg.prof_url);
			this.util.cc(0,this.root,'div','_NBCHATINVITE_TITLE',wrapdiv,'','','',msg.message);
			this.util.cc(0,this.root,'div','_NBCHATINVITE_DATE',wrapdiv,'','','',msg.chour);
		}
	},
	delete_datetitle : {
		value:function(data) {
			var msglist = data.message_list;
			if(msglist && msglist.length != 0){
				var first_date_div = this.util.ic(this.util.ii(this.root,'_NBCHAT'),'_NBCHATMSGCENTERLAYOUT',0);
				var first_date = first_date_div.textContent;
				if ( first_date == msglist[msglist.length-1]['cdate'] ) {
					first_date_div.parentNode.removeChild(first_date_div);
				}
			}
		}
	},
		
	setchattitlelayout : {
		value : function(data) {
			var layout = data.layout;
			var room = data.room;
			var chatctrl = this.chatctrl;
			var chatmodal = this.chatmodal;
			
			var tit1_div = this.util.cc(1,this.root,'div','_NBMTIT1',this.util.ii(this.root,'_NBTITLELAYOUT'));
			var nbmprv_div = this.util.cc(0,this.root,'div','_NBMPRV',tit1_div);
			
			var roomlist_img = this.util.cc(0,this.root,'img','_NB_ROOMLISTBTN',nbmprv_div,'click',function() {chatctrl.get_room();},'false','data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA0AAAAMCAYAAAC5tzfZAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBIWXMAAAsSAAALEgHS3X78AAAAHElEQVQoz2NgIAD+QwEhdSNSAxPRJlLVecNEIwBxh1er8naKggAAAABJRU5ErkJggg==');
		
			var mlayout_div = this.util.cc(1,this.root,'div','_NBMTITMANAGER',tit1_div);
			if ( room.manager != 0 || data.actmanager == null || ( data.actmanager.length == 1 && data.actmanager[0].uid == 0 )) {
				var img_span = this.util.cc(0,this.root,'span','',mlayout_div);	
				this.util.cc(0,this.root,'img','_NBMANAGERIMG',img_span,'','','',room['prof_url']);
			} else {
				var managers = data.actmanager;
				for( var idx = 0; idx < managers.length; idx++) {
					var manager = managers[idx];
					if ( manager.uid == 0 ) continue;
					var img_span = this.util.cc(0,this.root,'span','',mlayout_div);	
					var man_img = this.util.cc(0,this.root,'img','_NBMANAGERIMG',img_span,'','','',manager['prof_url']);
					if ( idx != 0 )
						man_img.style.marginLeft = "-10px";
					img_span.style.zIndex = 10 - idx;
				}
			}
			
			if ( room['mstatus'] == 'ON' )
				var online_div = this.util.cc(1,this.root,'div','_NB_ONLINE',mlayout_div);	
				
			var mname_span = this.util.cc(0,this.root,'span','_NBTITTXT',mlayout_div,'','','',room['manager_name']);
			var endchat_div = this.util.cc(0,this.root,'div','_NBMRIGHT',mlayout_div);
			var endchat_span = this.util.cc(0,this.root,'img','_NB_X_CLOSE',endchat_div, 'click',function() { 
					if ( room.manager == 1 ) chatmodal.closechatbotmodal(); 
					else chatmodal.closechatmodal(); 
				}, 'false', 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA0AAAAMCAYAAAC5tzfZAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBIWXMAAAsSAAALEgHS3X78AAAATUlEQVQoz52SSQ4AIAgDW///ZzxpgmwCN6BDtEAREQAgSRRxtDdRhQAwmgxMh3rNn1coUQQwAq/AMWhVjnlhoHcFrf+MnUt73eVyckYbdeyLjFsww0oAAAAASUVORK5CYII=');			//_NB_CLEAR_F
		}
	},
	chatdatelayout : {
		value : function(rootdiv, layout, message) {
			var msglayout_div = this.util.cc(0,this.root,'div','_NBCHATMSGCENTERLAYOUT',rootdiv);
			this.util.cc(0,this.root,'div','_NBCHATMSG_DATE',msglayout_div,'','','',message['cdate']);
		}
	},
	chatleftlayout : {
		value : function(rootdiv, layout, message, istyping) {
			var msglayout_div = this.util.cc(0,this.root,'div','_NBCHATMSGLLAYOUT',rootdiv);

			var msgmanpic_div = this.util.cc(0,this.root,'div','_NBCHATADMINPICTURE',msglayout_div);
			var msgmanpicbg_div = this.util.cc(0,this.root,'div','_NBCHATADMINPICTUREBG',msgmanpic_div);
			this.util.cc(0,this.root,'img','',msgmanpicbg_div,'','','',message['prof_url']);

			var msgwrapup_div = this.util.cc(0,this.root,'div','_NBCHATMSGLWRAPUP',msglayout_div);			
			this.util.cc(0,this.root,'div','_NBCHATMSGLMANAGERID',msgwrapup_div,'','','',message['name']);
			
			var msg_container = this.util.cc(0,this.root,'div','_NBCHATMSGLCONTAINER',msgwrapup_div);			
			var msg_div = this.util.cc(0,this.root,'div','_NBCHATLEFTMSGBOX',msg_container);			
			var msg_admincontainer = this.util.cc(0,this.root,'div','_NBCHATADMINMSGCONTAINER',msg_div);
			
			var msgmanmsg_div = this.util.cc(0,this.root,'div','_NBCHATADMINMSG',msg_admincontainer,'','','',message['msgurltype'] == 2 || ( message['msgurltype'] >= 4 && message['msgurltype'] <= 8 )   ? '' : this.util.replacebr(this.util.linkify(message['message'])));	
			if( message['msgurltype'] == 1 )
				this.util.cc(0,this.root,'img','_NBCHATEMOTICON',msgmanmsg_div,'','','',message['msgurl']);
			else if ( message['msgurltype'] == 2 ) 
				this.downloadlayout(msgmanmsg_div, message, true);
			else if ( message['msgurltype'] == 6 ) 
				this.evalmsglayout(msgmanmsg_div, message);
			else if (  message['msgurltype'] == 4  || message['msgurltype'] == 8 ) {
				if ( istyping )
					this.typinganimation(msgmanmsg_div, message);
				else
					this.chatbotmsglayout(msgmanmsg_div, message);
			}
			
			var msgtimelayout_div = this.util.cc(0,this.root,'div','_NBCHATMSGTIMELAYOUT',msg_container);
			this.util.cc(0,this.root,'div','_NBCHATMSGTIME',msgtimelayout_div,'','','',message['chour']);
		}
	},
	chatrightlayout : {
		value : function(rootdiv, layout, message) {
			var msglayout_div = this.util.cc(0,this.root,'div','_NBCHATMSGRLAYOUT',rootdiv);
			var msgtimelayout_div = this.util.cc(0,this.root,'div','_NBCHATMSGTIMELAYOUT',msglayout_div);
			this.util.cc(0,this.root,'div','_NBCHATMSGTIME',msgtimelayout_div,'','','',message['chour']);
			var msg_div = this.util.cc(0,this.root,'div','_NBCHATRIGHTMSGBOX',msglayout_div,'','','',message['msgurltype'] == 2 ||  ( message['msgurltype'] >= 4 && message['msgurltype'] <= 8 ) ? '' :	this.util.linkify(this.util.replacebr(message['message'])));

			if ( this.bg_color )			
				msg_div.style.backgroundColor = this.bg_color;
			
			if( message['msgurltype'] == 1 )
				this.util.cc(0,this.root,'img','_NBCHATEMOTICON',msg_div,'','','',message['msgurl']);
			else if ( message['msgurltype'] == 2 ) 
				this.downloadlayout(msg_div, message,false);	
			else if ( message['msgurltype'] == 5 || message['msgurltype'] == 7 ) {
				var msgjson = JSON.parse(message.message);	
				msg_div.innerHTML = this.util.replacebr(msgjson.content);
			}
				
		}
	},
	chatbotmsglayout : {
		value : function(rootdiv, message) {
			var chatctrl = this.chatctrl;
			var util = this.util;
			var mouseovercolor = this.bg_color ? this.bg_color : '#1991eb';
			var msgjson = JSON.parse(message.message);
			
			rootdiv.innerHTML = this.util.replacebr(this.util.linkify(msgjson.content));
			if ( msgjson.response_text.length != 0 && message.msgurltype != 8 ) {
				var btncontainer = this.util.cc(0,this.root,'div','_NBCHATBTNCONTAINER',rootdiv);
				var btnwrapup = this.util.cc(0,this.root,'div','_NBCHATBTNWRAPUP',btncontainer);				
				var selectjson = JSON.parse(msgjson.response_text);
				for(var idx=0; idx < selectjson.length; idx++ ) {
					if(selectjson[idx].mseq == '1' && this.isrest == 'y' ) continue;
					var btn_select = this.util.cc(0,this.root,'btn','_nbchatbotbutton',btnwrapup,'click',function(idx) {
						var seq = this.getAttribute('ifdo-botseq');
						var msgseq = this.getAttribute('ifdo-msgseq');
						var txt = this.textContent || this.innerText;						
						var msg = { 'content' : txt, 'master_seq' : seq, 'seq' : msgseq };
						chatctrl.set_message(encodeURIComponent(util.convertB64(JSON.stringify(msg))),'',5);
						this.parentNode.parentNode.parentNode.removeChild(this.parentNode.parentNode);
						return false;						
					},false,selectjson[idx].title);
					btn_select.setAttribute('ifdo-botseq',selectjson[idx].mseq);
					btn_select.setAttribute('ifdo-msgseq',message.seq);				
					btn_select.style.borderColor = mouseovercolor;
					btn_select.style.color = mouseovercolor;
					btn_select.onmouseover = function() { this.style.backgroundColor = mouseovercolor; this.style.color = '#fff'; }
					btn_select.onmouseout = function() { this.style.backgroundColor = '#fff'; this.style.color = mouseovercolor; }						
				}
			}
			
			if ( msgjson.master_seq == 1 )
				this.showinputbox();
		}
	},
	
	typinganimation : {
		value : function(rootdiv, message) {
			var instance = this;
			var type_anim = this.util.cc(0,this.root,'div','typing-indicator',rootdiv,'','','','');
			this.util.cc(0,this.root,'span','',type_anim,'','','','');
			this.util.cc(0,this.root,'span','',type_anim,'','','','');
			this.util.cc(0,this.root,'span','',type_anim,'','','','');
			
			setTimeout(function() {
					type_anim.parentNode.removeChild(type_anim);
					instance.chatbotmsglayout(rootdiv, message);
					instance.movechatbottom();
				}, 1000);
		}
	},
	evalmsglayout : {
		value : function(rootdiv, message) {
			var chatctrl = this.chatctrl;
			var util = this.util;
			var msgjson = JSON.parse(message.message);
			
			rootdiv.innerHTML = this.util.replacebr(msgjson.content);
			if ( msgjson.select.length != 0 ) {
				var btncontainer = this.util.cc(0,this.root,'div','_NBCHATBTNCONTAINER',rootdiv);
				var btnwrapup = this.util.cc(0,this.root,'div','_NBCHATBTNWRAPUP',btncontainer);
				for(var idx=0; idx < msgjson.select.length; idx++ ) {
					var btn_select = this.util.cc(0,this.root,'btn','_nbchatresultbutton',btnwrapup,'click',function(idx) {
						var seq = this.getAttribute('ifdo-evalseq');
						var qseq = this.getAttribute('ifdo-questseq');
						var txt = this.textContent || this.innerText;						
						var msg = { 'content' : txt, 'eval_seq' : seq, 'quest_seq' : qseq };
						chatctrl.set_message(encodeURIComponent(util.convertB64(JSON.stringify(msg))),'',7);
						return false;						
					},false,msgjson.select[idx].txt_option);
					btn_select.setAttribute('ifdo-evalseq',msgjson.select[idx].eval_seq);
					btn_select.setAttribute('ifdo-questseq',msgjson.quest_seq);
				}
			}
		}
	},
	downloadlayout : {
		value : function(d,m,l) {
			var chatctrl = this.chatctrl;				
			
			
			if ( m.filetype.substr(0,5) == 'image') {

				var icon_div = this.util.cc(0,this.root,'div','_NBCHATFILEICON',d);
				this.util.cc(0,this.root,'img','',icon_div,'','','','data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA7FJREFUeNqsl0tIG0EYx7+kUYgWImrxERB6UCESUMRHQ0WPqUiwh1IM1AciUi8KvfnC90EICiISPVRQoUJRKYH2JJYKtRr1IETwAbK+KvFBQKgHI51vOrts0t1NduMHf9jHzPeb/fabb2Z0FxcXoNGeEWWxa47Ir8WJQUVbK9FrIgdRoUybTaIvRItEO9E41UURAYS5iMpVftx3og9sULKmV3hnJPpI5NUAB9bHy3wY1Q4A/+0PonqI3eqZr6xoB2Am+qXwn7VYIfNpjjQADJWHKF0r6ezsDM7Pz6VepTPfRqVZ4CbK1wLGZHa5XLC/v/8vjGYztLa2QnZ2trhZPmPUSs0CO9FXrfCOjg54eHiAhoYGiIuLg/n5efD7/TA6OgqpqanhXV4RfQv/Bb1a4BhuHj4wMABlZWVQWloKPT09cH9/DwsLC1LdesNz4AVRsRZ4V1eXAM/MzBTemUwmyMjIgJubG6muxYwpDMCpFY4WDkdbW1uDo6MjsFqtci7eiQdQrjbTeXhfXx/odDrY2NgQ3uM1JiTC7Xa7nJuX/Cx4SmRRA+/u7hbgGH68T0hIgKKiIgofHh6GnJwcaG9vB71ettgi06hnFepJLHCDwUAjIobj/dzcHMzOzsq5Q+ZzHIBJLby/vz8EPjQ0BBzHhcCnpqbA4/FAUlKSkluTPlp4Z2enAA8Gg/Sehx8cHPwHX15ehrq6OqiqqoJIq2FAqcH19TX9UvyXYnh8fLwAx4STgldXV0f6toCB7WZkbWJiAu7u7mBwcDBqOFZDh8MRCR5ENkbgVm73cnh4CF6vF5xOJ6SkpNDqxsP39vYoPDc3NwTe2NgYDRzNh2x+MVplW64Q297epqGvqKiApaUlWtXGxsYofGRkhMIxIm63G1ZWVig80j8X2ap4NZwheh/eAoFYUnGOY13HRWZ6eppOt7y8vBB4U1MTVFZWqqlnM+IB/CRaD18P0tLSIBAI0ETEsF5dXcHu7i69rqmpiQW+zpjKyzGCm5uboaCgANra2mgk+Ofj4+OwtbVF3yuUWzkTluPwXfEnorfiB5hYk5OTQqk9OTkBn88HiYmJ0NLSAjabTS38M9EbuW25ke3dQhLy8vKSltXj42NITk4Gi8VCEzNClZMynG0lRH+UzgVZbBCa94Uy9pvBuUi7Yo413HlE+I4UXOlcgA1t/FSJ0WaYL07tyeiW7V5L+KKh0lZZ31rmS/PZUHy4cLADqlUh1IvsgLr5WIdTOTOLEhUT7FSLk78CDAD7tKyLQYFAYAAAAABJRU5ErkJggg==');	
							
				var download_div = this.util.cc(0,this.root,'div','_NBCHATIMAGEFILELAYOUT',d);
				var download_img = this.util.cc(0,this.root,'img','_NBCHATIMAGEFILE',download_div,'click',this.downloadshowimage,'false','data:'+m.filetype+';base64,'+m.filedata);
				download_img.setAttribute("title","크게 보실려면 클릭하세요.");
			} else {
				var download_div = this.util.cc(0,this.root,'div','_NBCHATDOWNLOADFILECONTAINER',d,'click',function() { 
						var fid = $(this).attr("ifdoc-fileid");
						chatctrl.getdownloadfile(fid);
					} ,'false','');
				download_div.setAttribute("ifdoc-filename",m['filename']);
				download_div.setAttribute("ifdoc-fileid", m.fileid);
				
				var download_img = this.util.cc(0,this.root,'img','_NBCHATDOWNLOADFILEICON',download_div,'','','','data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA7FJREFUeNqsl0tIG0EYx7+kUYgWImrxERB6UCESUMRHQ0WPqUiwh1IM1AciUi8KvfnC90EICiISPVRQoUJRKYH2JJYKtRr1IETwAbK+KvFBQKgHI51vOrts0t1NduMHf9jHzPeb/fabb2Z0FxcXoNGeEWWxa47Ir8WJQUVbK9FrIgdRoUybTaIvRItEO9E41UURAYS5iMpVftx3og9sULKmV3hnJPpI5NUAB9bHy3wY1Q4A/+0PonqI3eqZr6xoB2Am+qXwn7VYIfNpjjQADJWHKF0r6ezsDM7Pz6VepTPfRqVZ4CbK1wLGZHa5XLC/v/8vjGYztLa2QnZ2trhZPmPUSs0CO9FXrfCOjg54eHiAhoYGiIuLg/n5efD7/TA6OgqpqanhXV4RfQv/Bb1a4BhuHj4wMABlZWVQWloKPT09cH9/DwsLC1LdesNz4AVRsRZ4V1eXAM/MzBTemUwmyMjIgJubG6muxYwpDMCpFY4WDkdbW1uDo6MjsFqtci7eiQdQrjbTeXhfXx/odDrY2NgQ3uM1JiTC7Xa7nJuX/Cx4SmRRA+/u7hbgGH68T0hIgKKiIgofHh6GnJwcaG9vB71ettgi06hnFepJLHCDwUAjIobj/dzcHMzOzsq5Q+ZzHIBJLby/vz8EPjQ0BBzHhcCnpqbA4/FAUlKSkluTPlp4Z2enAA8Gg/Sehx8cHPwHX15ehrq6OqiqqoJIq2FAqcH19TX9UvyXYnh8fLwAx4STgldXV0f6toCB7WZkbWJiAu7u7mBwcDBqOFZDh8MRCR5ENkbgVm73cnh4CF6vF5xOJ6SkpNDqxsP39vYoPDc3NwTe2NgYDRzNh2x+MVplW64Q297epqGvqKiApaUlWtXGxsYofGRkhMIxIm63G1ZWVig80j8X2ap4NZwheh/eAoFYUnGOY13HRWZ6eppOt7y8vBB4U1MTVFZWqqlnM+IB/CRaD18P0tLSIBAI0ETEsF5dXcHu7i69rqmpiQW+zpjKyzGCm5uboaCgANra2mgk+Ofj4+OwtbVF3yuUWzkTluPwXfEnorfiB5hYk5OTQqk9OTkBn88HiYmJ0NLSAjabTS38M9EbuW25ke3dQhLy8vKSltXj42NITk4Gi8VCEzNClZMynG0lRH+UzgVZbBCa94Uy9pvBuUi7Yo413HlE+I4UXOlcgA1t/FSJ0WaYL07tyeiW7V5L+KKh0lZZ31rmS/PZUHy4cLADqlUh1IvsgLr5WIdTOTOLEhUT7FSLk78CDAD7tKyLQYFAYAAAAABJRU5ErkJggg==');
				download_img.setAttribute("title","클릭하시면 다운로드 받을 수 있습니다.");
			}	
			
			this.util.cc(0,this.root,'div','_NBCHATFILENAME',d,'','','',m['filename']);
			
			if(l) {
				var downbtn_div = this.util.cc(0,this.root,'div','_NBCHATFILESAVELAYOUT',d);
				var downbtn = this.util.cc(0,this.root,'btn','_NBCHATFILESAVEBUTTON',downbtn_div,'click',function() { 
						var fid = $(this).attr("ifdoc-fileid");
						chatctrl.getdownloadfile(fid);
					},'','저장하기');
				downbtn.setAttribute("ifdoc-filename",m.filename);
				downbtn.setAttribute("ifdoc-fileid",m.fileid);
			}
		}
	},
	savedownloadfile :  {
		value : function(data) {
			if ('undefined' === typeof window.navigator.msSaveOrOpenBlob) {
				this.downloadattachfile2(data.fileinfo);
			} else {
				this.downloadattachfile(data.fileinfo);
			}
		}
	},
	downloadattachfile : {
		value : function(fi) {
		    // convert base64 to raw binary data held in a string
		    // doesn't handle URLEncoded DataURIs - see SO answer #6850276 for code that does this
		    var byteString = atob(fi.filedata);
		
		    // separate out the mime component
		    var mimeString = fi.filetype;
		
		    // write the bytes of the string to an ArrayBuffer
		    var ab = new ArrayBuffer(byteString.length);
		    var ia = new Uint8Array(ab);
		    for (var i = 0; i < byteString.length; i++) {
		        ia[i] = byteString.charCodeAt(i);
		    }
		
		    // write the ArrayBuffer to a blob, and you're done
		    var bb = new Blob([ab]);
		    
		    window.navigator.msSaveOrOpenBlob(bb, fi.filename);			
		}
	},
	downloadattachfile2 : {
		value : function(fi) {
		    // convert base64 to raw binary data held in a string
		    // doesn't handle URLEncoded DataURIs - see SO answer #6850276 for code that does this
		    var byteString = atob(fi.filedata);
		
		    // separate out the mime component
		    var mimeString = fi.filetype;
		
		    // write the bytes of the string to an ArrayBuffer
		    var ab = new ArrayBuffer(byteString.length);
		    var ia = new Uint8Array(ab);
		    for (var i = 0; i < byteString.length; i++) {
		        ia[i] = byteString.charCodeAt(i);
		    }
		
		    // write the ArrayBuffer to a blob, and you're done
		    var bb = new Blob([ab]);
		    var url = window.URL.createObjectURL(bb);

	        var e = document.createElement('a');
	        e.setAttribute('href', url);
	        e.setAttribute('download', fi.filename);
	        document.body.appendChild(e);
	        e.click();
	        document.body.removeChild(e);			
		}
	},
	downloadshowimage : {
		value : function() {
			var image_html = "<html><head><title>IFDO 이미지 보기</title><style>body{margin:0;cursor:pointer;overflow:auto;}img{width:100%;height:auto;}</style></head><body scroll=auto onclick='window.close();'><img src='"+this.src+"' title='클릭하시면 닫힙니다.'></body></html>";		
			var newwindow = window.open('', "image", "width=" + 100 +",height="+100+",top=0,left=0,scrollbars=auto,resizable=1,toolbar=0,menubar=0,location=0,directories=0,status=1");
			newwindow.document.open();
			newwindow.document.write(image_html)
			newwindow.document.close();
			
			var tmpimg = new Image();			
			tmpimg.onload = function() {
				var image_width = this.width > 1024 ? 1024 : this.width;
				var image_height = this.height > 768 ? 768 : this.height;
				
				newwindow.resizeTo(image_width, image_height);
				newwindow.focus();  
			}
			tmpimg.src = this.src;	
			tmpimg = null;			
		}
	},
	addmessagelayout : {
		value:function(data) {			
			if(data.message_list && data.message_list.length != 0){				
				var last_date_divs = this.util.ic(this.root,'_NBCHATMSGCENTERLAYOUT');
				var date_pivot = last_date_divs && last_date_divs.length > 0 ? last_date_divs[last_date_divs.length - 1].textContent : '';
				var rootdiv = this.util.ii(this.root,'_NBCHAT');
				if ( data.message_list != null ) {
					for( var j=0;j<data.message_list.length;j++) {
						if ( date_pivot == '' || date_pivot != data.message_list[j]['cdate'] ) {						
							this.chatdatelayout(rootdiv, data.layout,data.message_list[j]);
							date_pivot = data.message_list[j]['cdate'];						
						}
						this.display_message(data.message_list[j],data.layout, rootdiv, true);
						if( data.message_list[j]['mode'] != 'send' ) this.chatctrl.recv_ackmsg(data.message_list[j]['seq']);
					}
				}
			}
			
			this.movechatbottom();
		}
	},
	
	chatbotinputboxlayout : {
		value : function(layout) {
			var chatctrl = this.chatctrl;
			var util = this.util;
			var sendbox_div = this.util.ii(this.root,'_NB_SENDBOX');

			this.input_box.init(layout);
			this.hiddeninputbox();			
		}
	},
	savefilelayout : {
		value : function(data) {
			if( data.room && data.room.room_no != "" ) 
				this.chatctrl.room_no = data.room.room_no; 
				
			if ( data.isfirst == 'y' ) {
				this.clearlayout_es();
				this.setchattitlelayout(data);
				this.input_box.init(data.layout);
			}
			
			this.addmessagelayout(data);

			_NB_CHAT_PSTATUS = 'chatting';
		}
	},
	chatstatlayout : {
		value : function(data) {
			var chatmodal = this.chatmodal;
			var chatctrl = this.chatctrl;
			
			var msgcontainer_div = this.util.cc(0,this.root,'div','_NBCHATSTATMSGBOX',this.util.ii(this.root,'_NBCHAT'));
			var msgtitlelayout_div = this.util.cc(0,this.root,'div','_NBCHATSTATTITLELAYOUT',msgcontainer_div);
			this.util.cc(0,this.root,'div','_NBCHATSTATTITLE',msgtitlelayout_div,'','','','상담 종료');
			
			
			var msgcontentlayout_div = this.util.cc(0,this.root,'div','_NBCHATSTATCONTENTLAYOUT',msgcontainer_div);
		
			var msgcontentbody_div = this.util.cc(0,this.root,'div','_NBCHATSTATCONTENTBODY',msgcontentlayout_div);
			this.util.cc(0,this.root,'div','_NBCHATSTATBODYCONTENT',msgcontentbody_div,'','','','상담이 종료되었습니다.<br>궁금하신 점 있으시면 언제든지 실시간 채팅 상담을<br>이용해주세요~<br>감사합니다.<br><br>');
			this.util.cc(0,this.root,'div','_NBCHATSTATBODYSTATCONTENT',msgcontentbody_div,'','','','상담 시작 : ' + data.cstatus.start_time);
			this.util.cc(0,this.root,'div','_NBCHATSTATBODYSTATCONTENT',msgcontentbody_div,'','','','상담 종료 : ' + data.cstatus.end_time);
			this.util.cc(0,this.root,'div','_NBCHATSTATBODYSTATCONTENT',msgcontentbody_div,'','','','소요 시간 : ' + data.cstatus.chat_time);
			
			var msgbuttonlist_div = this.util.cc(0,this.root,'div','_NBCHATSTATBUTTONLAYOUT',msgcontainer_div);
			var closebtn_div = this.util.cc(0,this.root,'btn','_NBCHATCLOSEBUTTON',msgbuttonlist_div,'click',function(){chatctrl.close_room('');},'false','상담 종료');
			closebtn_div.style.backgroundImage = this.btn_gradation;
			this.util.cc(0,this.root,'btn','_NBCHATSAVEBUTTON _nbchatbtn_leftmargin',msgbuttonlist_div,'click',function() { chatmodal.closechatmodal(); }, 'false','상담 내용 저장');
		}
	},
	movechatbottom : {
		value : function() {
			var chatlayout = this.util.ii(this.root,'_NBCHAT');
			chatlayout.scrollTop = chatlayout.scrollHeight;
		}
	},
	chatmorelayout : {
		value : function(rootdiv,data) {
			var chatctrl = this.chatctrl;
			
			var msgcontainer_div = this.util.cc(0,this.root,'div','_NBCHATMOREMSGBOX',rootdiv);
			var msgtitlelayout_div = this.util.cc(0,this.root,'div','_NBCHATMORETITLELAYOUT',msgcontainer_div);
			var msgtitleline_div = this.util.cc(0,this.root,'div','_NBCHATMORETITLELINE',msgtitlelayout_div);
			var msgtitle = this.util.cc(0,this.root,'div','_NBCHATMORETITLE',msgtitleline_div,'click',function() { this.parentNode.parentNode.parentNode.removeChild(this.parentNode.parentNode); chatctrl.getmoremessage(data.ismoremsg.room_no,data.ismoremsg.idx); },'flase','이전 메시지 보기');			
		}
	},
	recvinvitelayout : {
		value : function(data) {
			if(_NB_CHAT_PSTATUS == 'chatting' && data.invite_msg.room_no == this.chatctrl.room_no ){
				this.addmessagelayout(data);
			}
		}
	},
	closelpopmessage : {
		value : function() {
			if ( this.icon_show == 'n' ) 
				return;
						
			var lpoplayout = this.util.ic(document, '_NB_LPOPLAYOUT', 0);
			if ( lpoplayout ) {
				var instance = this;
				this.lpop_div.className = "off";
				setTimeout(function(){
					instance.lpop_div.removeChild(lpoplayout);
				}, 500);				
			}
		}
	},
	showlpopmessage : {
		value : function(msg) {
			if ( this.icon_show == 'n' ) 
				return;
			
			var lpoplayout = this.util.ic(document, '_NB_LPOPLAYOUT', 0);
			if ( lpoplayout ) {
				var instance = this;
				this.lpop_div.className = "";
				this.lpop_div.removeChild(lpoplayout);
				setTimeout(function(){
					instance.createlpopmessage(msg);
					//instance.chatctrl.recvpushmessage(msg.room_no, msg.seq);
				}, 50);					
			} else {
				this.createlpopmessage(msg);
				//this.chatctrl.recvpushmessage(msg.room_no, msg.seq);
			}
			/*
			if ( this.lpoptimer ) {
				clearTimeout(this.lpoptimer);
			}
			*/
		}
	},
	createlpopmessage : {
		value : function(msg) {
			var instance = this;
			var layout_div = this.util.cc(0,this.root,'div','_NB_LPOPLAYOUT',this.lpop_div);
			var closebtn_div = this.util.cc(0,this.root,'div','_NB_LPOPCLOSEBTN',layout_div);	
			var closebtn_img = this.util.cc(0,this.root,'img','',closebtn_div,'click',function(){
				instance.closelpopmessage(msg.room_no, msg.seq);
				instance.chatctrl.recvpushmessage(msg.room_no, msg.seq);
			},'false','data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA8AAAAOCAYAAADwikbvAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAMtJREFUeNqkk8sKwkAMRWunVKnWfoALN/r//yM+ViK48S0Ivm7gjsQ0LYKBg9CZc5NOxzT5owJ/h2ACXuDasr8PpqADLhkfdkEPjEEKto44oCjrhe4s3TImV+AhyQ3iCaxkyqA2HE3AkwGlEedcS4IZTQfIOeRg5ImebAMKHk5NTJjo1YEnH+tkxabO8bNJxxunKLl2bpO1KOPPOEHpBWi5UuIeLCjGzbWA4NwcEZfmnW3AXe5GqmQRd44YawPW6tJ8Vf7j/+Gz7y3AAB6dMorRCbfIAAAAAElFTkSuQmCC');
			
			var msgcontain_div = this.util.cc(0,this.root,'div','_NB_LPOPCONTAINER',layout_div,'click',function(){instance.clickchaticon();},'false','');
			var managerpic_div = this.util.cc(0,this.root,'div','_NB_LPOPMANAGERPICTURE',msgcontain_div);
			var managerpic_img = this.util.cc(0,this.root,'img','',managerpic_div,'','','',msg.prof_url);
			
			var managerbody_headerdiv = this.util.cc(0,this.root,'div','_NB_LPOPBODY_TITLE',managerpic_div);
			var managername_div = this.util.cc(0,this.root,'div','_NB_LPOPMANAGERNAME',managerbody_headerdiv,'','','', msg.name);	
			var time_div = this.util.cc(0,this.root,'div','_NB_LPOPMSGGAP',managerbody_headerdiv,'','','', msg.gap);
				
			var managerbody_div = this.util.cc(0,this.root,'div','_NB_LPOPBODY',msgcontain_div);				
			var message_div = this.util.cc(0,this.root,'div','_NB_LPOPCONTENTMSG',managerbody_div,'','','',this.util.replacebr(this.util.strellipsis(msg.message)));
			if ( msg.msgurltype == 1 )
				this.util.cc(0,this.root,'img','',message_div,'','','',msg.msgurl);	
			this.lpop_div.className = "on";
			//this.util.fadein(this.lpop_div);
			//this.lpoptimer = setTimeout(this.util.fadeout,this._LPOPUP_TIMEOUT,this.lpop_div);
		}		
	},
	hiddeninputbox : {
		value : function() {
			if ( this._NB_INPUTBOX_STATUS == 'hidden' )
				return;
				
			var sendbox_div = this.util.ii(this.root,'_NB_SENDBOX');
			var inbox_class = this.util.ic(this.root,'in_box',0);
			var nbchat_div =  this.util.ii(this.root,'_NBCHAT');			

			if ( inbox_class ) inbox_class.style.display = 'none';
			sendbox_div.style.height = sendbox_div.clientHeight - 70;
			nbchat_div.style.height = nbchat_div.clientHeight + 70;
			this._NB_INPUTBOX_STATUS = 'hidden';
		}
	},
	showinputbox : {
		value : function() {
			if ( this._NB_INPUTBOX_STATUS == 'show' )
				return;

			var sendbox_div = this.util.ii(this.root,'_NB_SENDBOX');
			var inbox_class = this.util.ic(this.root,'in_box',0);
			var nbchat_div =  this.util.ii(this.root,'_NBCHAT');			

			if ( inbox_class ) inbox_class.style.display = 'block';
			sendbox_div.style.height = this.util.gs(sendbox_div, 'height') + 70;
			nbchat_div.style.height = this.util.gs(nbchat_div, 'height') - 70;
			this._NB_INPUTBOX_STATUS = 'show';
		}
	},		
	hiddensendbox : {
		value : function() {
			var sendbox_div = this.util.ii(this.root,'_NB_SENDBOX');
			var nbchat_div =  this.util.ii(this.root,'_NBCHAT');
			sendbox_div.style.display = 'none';
			nbchat_div.style.height = this.util.gs(nbchat_div, 'height') + 109;
		}
	},
	showsendbox : {
		value : function() {
			if ( _NB_CHAT_PSTATUS != 'contactus' ) 
				return;
			
			var sendbox_div = this.util.ii(this.root,'_NB_SENDBOX');
			var nbchat_div =  this.util.ii(this.root,'_NBCHAT');
			sendbox_div.style.display = 'block';
			nbchat_div.style.height = this.util.gs(nbchat_div, 'height') - 109;
		}
	},
	contactuslayout : {
		value : function(data) {
			this.clearlayout();
			this.contactustitlelayout(data.layout);
			this.contactusbodylayout(data.layout);
			//this.hiddensendbox();
			_NB_CHAT_PSTATUS = 'contactus';
		}
	},
	contactustitlelayout : {
		value : function(layout) {
			var chatctrl = this.chatctrl;
			var instance = this;
			var rootlayout = this.util.ii(this.root,'_NBICHATLAYOUT');
			
			let chattitle_div = this.util.cc(0,this.root,'div','_NBCHATTITLECONTAINER',rootlayout);
			chattitle_div.setAttribute("style",this.linear_gradation);
			
			let wchattitle_div = this.util.cc(0,this.root,'div','_NBCHATTITLEWRAP',chattitle_div);
			let chatbackbutton = this.util.cc(0,this.root,'div','_NBCHATBACKBUTTON',wchattitle_div,'click', function() {
				
				instance.chatctrl.get_room();
			}, 'false', '');
			this.util.cc(0,this.root,'img','',chatbackbutton,'','','','//img.ifdo.co.kr/img/ic_arrow_back.png');
			
			let wmaninfo_div = this.util.cc(0,this.root,'div','_NBMANAGERINFOWRAP',wchattitle_div);
			let maninfo_div = this.util.cc(0,this.root,'div','_NBMANAGERINFO',wmaninfo_div);
				this.util.cc(0,this.root,'div','_NBSITETITLE _NBBOXCONTYPE9',maninfo_div,'','','','문의하기');
				this.util.cc(0,this.root,'div','_NBMANAGERNAME _NBBOXCONTYPE10 _NBTEXTTOPPADDING5',maninfo_div,'','','',layout.title);
				
			let chatdiv = this.util.cc(1,this.root,'div','_NBCHAT',rootlayout);
			chatdiv.className = '_CONTACTSTYLE';			
		}
	},
	contactusbodylayout : {
		value : function(layout) {
			var instance = this;
			
			var nbchat_div =  this.util.ii(this.root,'_NBCHAT');
			var main_layout = this.util.cc(0,this.root,'div','_nbinputformlayout',nbchat_div);
			this.util.cc(0,this.root,'div','_nbcontenttitle',main_layout,'','','','* Email');
			var email_input = this.util.cc(1,this.root,'input','_NBCONTACTEMAIL',main_layout);
			email_input.className = '_nbinputedit';
			email_input.setAttribute('type','email');
			email_input.setAttribute('placeholder','Email');
			
			this.util.cc(0,this.root,'div','_nbcontenttitle',main_layout,'','','','* 이름');
			var name_input = this.util.cc(1,this.root,'input','_NBCONTACTNAME',main_layout);
			name_input.className = '_nbinputedit';
			name_input.setAttribute('type','text');
			name_input.setAttribute('placeholder','이름');
			
			this.util.cc(0,this.root,'div','_nbcontenttitle',main_layout,'','','','* 제목');
			var title_input = this.util.cc(1,this.root,'input','_NBCONTACTTITLE',main_layout);
			title_input.className = '_nbinputedit';
			title_input.setAttribute('type','text');
			title_input.setAttribute('placeholder','제목');			
			
			this.util.cc(0,this.root,'div','_nbcontenttitle',main_layout,'','','','* 문의 내용');
			var content_input = this.util.cc(1,this.root,'textarea','_NBCONTACTCONTENT',main_layout);
			content_input.className = '_nbinputedit _nbinputtext';
			content_input.setAttribute('rows','8');
			content_input.setAttribute('placeholder','문의 내용을 입력하세요.');
			
			var privacy_div = this.util.cc(0,this.root,'div','_nbinputcheckbox',main_layout);
			var privacy_input = this.util.cc(1,this.root,'input','_NBCONTACTAGREE',privacy_div);
			privacy_input.setAttribute('type','checkbox');
			var privacy_checkbox = this.util.cc(0,this.root,'label','',privacy_div);
			privacy_checkbox.setAttribute('for','_NBCONTACTAGREE');
			var privacy_content_div = this.util.cc(0,this.root,'div','_nbinputcheckboxwrapup',privacy_div);
			var privacy_content_link = this.util.cc(0,this.root,'span','_nbcheckboxlink',privacy_content_div,'click',function(){instance.chatmodal.confirmmodal('개인정보수집 및 이용에 대한 안내','<br>수집한 개인정보는 정보통신망 이용촉진 및 정보보호 등에 관한 법률과 기타 관계 법령에 의거하여 보호합니다.(주)니블스카이는 상담을 희망하는 경우 아래와 같이 개인정보를 수집하고 있습니다.<br><br>1. 수집 개인정보 항목 : [필수] 이메일  <br>2. 개인정보의 수집 및 이용목적 : 온라인상담신청에 따른 본인확인 및 원활한 의사소통 경로 확보<br>3. 개인정보의 이용기간 : 원칙적으로 개인정보 수집 및 이용목적이 달성된 후에 해당 정보를 지체없이 파기합니다.<br>단, 상법, 전자상거래 등에서의 소비자보호에 관한 법률 등 관계법령의 규정에 의하여 보존할 필요가 있는 경우 회사는 관계법령에서 정한 일정한 기간 동안 개인정보를 보관할 수 있습니다.<br><br>그 밖의 사항은 개인정보 처리방침을 준수합니다.');},'false','개인정보수집 및 이용');
			this.util.cc(0,this.root,'span','',privacy_content_div,'','','','에 대해 동의합니다.');
			
			var button_layout = this.util.cc(0,this.root,'div','_nbinputbuttonlayout',main_layout);
			var button_contact = this.util.cc(0,this.root,'btn','_nbinputbutton ',button_layout,'click',function() { instance.clicksendcontactmsg(email_input, name_input, title_input, content_input, privacy_input);},'false','전송하기');
			button_contact.style.backgroundImage = this.btn_gradation;
		}
	},	
	clicksendcontactmsg : {
		value : function(a,b,c,d,e) {
			var errmsg = '';
			if ( ! e.checked ) {
				errmsg='개인정보수집 및 이용에 대해 동의해주세요'; 
			} else if ( a.value.trim() == '' ) {
				errmsg='이메일주소를 입력하세요';
			} else if ( b.value.trim() == '' ) {
				errmsg='이름을 입력하세요';
			} else if ( c.value.trim() == '' ) {
				errmsg='제목을 입력하세요';
			} else if ( d.value.trim() == '' ) {
				errmsg='문의내용을 입력하세요';
			} else if ( !this.util.validateEmail(a.value) ) {
				errmsg='이메일 형식에 맞지 않습니다.';
			}
			
			if ( errmsg == '' )
				this.chatctrl.contact_msg(a.value,encodeURIComponent(b.value),encodeURIComponent(c.value),encodeURIComponent(d.value));
			else 
				this.chatmodal.confirmmodal('오류',errmsg);
		}		
	},
});


function NB_User_Chat_InputBox(chatcontrol, util, root, sendbox_div) {
	this.chatctrl = chatcontrol;
	this.util = util;
	this.root = root;
	this.sendbox_div = sendbox_div;
}

NB_User_Chat_InputBox.prototype = Object.create(null, {
	constructor: {
		value: NB_User_Chat_InputBox
	},	
	init : {
		value : function(layout) {
			var chatctrl = this.chatctrl;
			var uploadfunc = this.uploadfile;
			var sendmsgfunc = this.sendmessage;
			var utilobject = this.util;
			var inputfile_div = this.util.cc(1, this.root, 'input', '_NB_FILEUP', this.sendbox_div, 'change', function(){uploadfunc(this, chatctrl);}, 'false');	
			inputfile_div.type = 'file';
			inputfile_div.name = '_NB_UPFILE';
			inputfile_div.setAttribute('capture', 'camera');
			inputfile_div.style.display = 'none';		
			
			var resplist_div = this.util.cc(1, this.root, 'div', '_NB_RESPLIST', this.sendbox_div);
			
			var inbox_div = this.util.cc(0, this.root, 'div', 'in_box', this.sendbox_div );
			var text_div = this.util.cc(1, this.root, 'textarea', '_NB_ITXT', inbox_div, 'keydown', function(e) {
					if( e.keyCode != 8 && e.keyCode == 13 && !e.shiftKey ) {
						sendmsgfunc(this,'',0,utilobject,chatctrl);
					} 
				}, 'false' );
			text_div.setAttribute('placeholder','메시지를 입력하세요.(줄바꿈 Shift+Enter)');
			
			var inspan = this.util.cc(1, this.root, 'span', '', inbox_div );
			var emolayout_div = this.util.cc(1, this.root, 'div', '_NB_EMO_LAYER', inspan);
			var inul = this.util.cc(1, this.root, 'ul', '', emolayout_div );
			for( var idx = 1; idx <= 16; idx++ ) (function(idx,u,c,r) {
				var inli = u.cc(1, r, 'li', '', inul, 'click', function(){c.set_message('','//img.ifdo.co.kr/img/emoti'+idx+'.png',1);emolayout_div.style.display='none';}, 'false');	
				u.cc(1, r, 'img', '', inli,'','','','//img.ifdo.co.kr/img/emoti'+idx+'.png');	
			}(idx, this.util, this.chatctrl, this.root));
			
			var buttons_div = this.util.cc(1, this.root, 'div', '_INPUTBOX_BUTTONS', inbox_div );
			this.util.cc(1, this.root, 'img', '_NB_FILEICO', buttons_div,'click',function(){inputfile_div.click();},'false','data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA8AAAAPCAYAAAA71pVKAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBIWXMAAAsSAAALEgHS3X78AAABe0lEQVQoz6XST2jPcRzH8cdvpCwlJ1YOK0rJxcVJijE5TH3aRaKV0qj9PiIX7bOD+uwitfqmxYXDblY+kT9zEClymgMHh6WUi1w4zUG4fMa3WXbwOb17v9/P3q/36/3hP15ntYbclJMYxxbMYyLF8AJ6VgHHkXAK23ALs7kpu2DtP8BJHMW+FMOnmp7JTelDF6M9K0Cd3JSrOIL92JSbMt1qWcDmv2TnpnRwDXtxoO75BK9qfR3Gau6P7NyUNbiBHRjEdjzAuRTD7QrO4gumf0+uE2+iH4exE49wpoK9uIdvOIYfbdljFRxCH+5gJMVwNzdlA+7jM45XL+ba8FlcTDEsYgAPUwxzuSkba+MCRjCM67jUhvvxtsbPMZSbkvAMrzGKE5jCYIphvg1/rAZJMbyr0npxJcXQxWlMYiDF8GbJ5E41bAK7MZxi+LnsfF1cqOD7dm0JXo/H9QyX6wpbcb6e7VCK4cPyD9VTpS7iIF5iBl/xFN+xZyUQfgFnNHoZAfbYjQAAAABJRU5ErkJggg==' );
			var emoji_img = this.util.cc(1, this.root, 'img', '_NB_EMOICO', buttons_div,'','','','data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA8AAAAPCAYAAAA71pVKAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAABmJLR0QAAAAAAAD5Q7t/AAAACXBIWXMAAAsSAAALEgHS3X78AAABQUlEQVQoz6XTv2qVQRAF8N/3IeIDKHYW2sdCQRsDPsJWuRbpBCG57APINoHFIuXiLQS7FLmptkhvkVhosPEBtNBKjL0XJFpkLyzBkIjT7J85Z2Y4MzPoLJc6Yg1P8BA38B3vsIu9FMPJEj92xNs4wrQBV1IMA1bae4qjhgNDRzzEixTDzDmWS93EczxKMXweWqnv8SrF8NoFlkt9imd4MGKCxWWI0HALTEasY9ZF3s+l7p/JdvbvJdZH3Meby2Tt7AB35VJ//yNRLvVqLnVxBce51Jsphm/NMcOtv3C+pBg22/06foz4gMcdaPechPPuvoqPI3acDsBSzbfYxlf8aud2iuGwI0+x8399brM6wVYudeMC4ga2MEkxnAyd4w728NNpHw9w3MRZbaVew1qK4RNttrsA/VbdW6raRJ1j3m/VH4dtedWLDZPAAAAAAElFTkSuQmCC' );
			/*
			var button_send = this.util.cc(1, this.root, 'btn', '_NB_SENDBTN', buttons_div,'click',function(){sendmsgfunc(text_div,'',0,utilobject,chatctrl);},'false','SEND' );	
			
			var ifdologo_div = this.util.cc(1, this.root, 'div', '_NB_IFDOLOGODIV', this.sendbox_div );
			var ifdoanchor = this.util.cc(0, this.root, 'a', '', ifdologo_div );
			ifdoanchor.setAttribute('target', '_blank');
			ifdoanchor.setAttribute('href', '//ifdo.co.kr');
			var ifdoimg = this.util.cc(1, this.root, 'img', '_NB_IFDOLOGO', ifdoanchor, '','','', 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGMAAAAKCAYAAACgwOAHAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAkZJREFUeNrsVzFuwkAQPCRaHoAfAA8wD4Ce5AFQUcRJDfRADzzAkagSSE3oIT1+QHiAnf54QG6jOWm1OhtjogihnLQy+Pb25mZ296D0slio//Hnw8czMRbTh26vp8rmWTPWFM4R7BqGZ6xtbGOBswORhQXjbnHGoXhPfCwd/tpYS7ybCu5i4EzDdGesb6wiuCYMuoxggbEDNqzge3jBQX9zVIEncogRXICxIkjh710JmWT4hkzIQLzjSTUCx0M820ygSZk5z9jmSziGCN7Gxjtjc2OvEI+CrjHXwmZNfHatm4LcBGQ2UvzIZ4zDxSdIXeOgtHaCPTTLeKqAVQHRojPWhAJP27HWtqY5sNo9bIWrco7eRmQ9gvw1iKRgHcx7zLeJObuuA38S74Fl0xNITvNrgNAGYk4zMHYZCbT2g7WCGp5FWm7AslwB4yHHuoQRLytcOZIrcYkxYG2qBmV9pqACGB9V1AFYCn7E+grI8FmF2VFnMWKRLdKvxjJLnzi8ZnHr6NkKIlYF/nMr41SbSmurrmo+snYVufy5GJ9swxkrIUvaASStGKE+iPxCNmpUhhbZ1EH8wHFgl9+A7V3P2f8J2zviRAKPKihGeEYV2TvDS1m3AyaLy94ZHnD/iGEVWznK0AIasZ6+wtwGIDaI0Re9MER78RB3n3Fg6TeGbTPItKTvkRjk94y5IVoWifuWUVE6o9KOOUTQQow444dPjDutL9puhHtElW70f0aALKXqus/R6q7mf8YtjiMqZ36FQqTeYd8CDABNXcDRI1WomAAAAABJRU5ErkJggg==');
			var footer_div = this.util.cc(0, this.root, 'div', 'nbui-resizable-handle nbui-resizable-se nbui-icon', ifdologo_div );
			footer_div.style = 'z-index: 99999;'	
			*/
			/*
			var ifdoanchor = this.util.cc(0, this.root, 'a', '', this.sendbox_div );
			ifdoanchor.setAttribute('target', '_blank');
			ifdoanchor.setAttribute('href', '//ifdo.co.kr/?NbParam=5756413d');
			*/
			
			var ifdologo_div = this.util.cc(0, this.root, 'div', '_NB_IFDOLOGODIV',this.sendbox_div, 'click', function() {
				window.open('//ifdo.co.kr/?NbParam=5756413d', '_blank');
			}, 'false', '');
			var ifdoimg = this.util.cc(0, this.root, 'img', '_NB_IFDOLOGO', ifdologo_div, '','','', '//img.ifdo.co.kr/img/icon_chatlogo_'+( window._NB_isMobile ? 'm' : 'p' )+'.png');
			
			inbox_div.onmouseover = function() {
				this.style.border = '1px solid '+layout['bg_color'];
			};
			inbox_div.onmouseout = function() {
				this.style.border = '1px solid #c1c8d7';
			};
			emolayout_div.onmouseleave = function() {	
				if(emolayout_div.style.display =='block') 
					emolayout_div.style.display = 'none';
			};
			emoji_img.onclick = function() {	
				if(emolayout_div.style.display =='block') 
					emolayout_div.style.display = 'none';
				else 
					emolayout_div.style.display = 'block';
			};	
			/*
			text_div.onkeydown = function(e) {
				if ( e.keyCode == 13 && !e.shiftKey ) {
                	button_send.click();
                	return false;
                }
			};
			*/
		}
	},	
	uploadfile : {
		value : function(a, b) {
			if ( a.value == '' )
				return;
							
			if (!(window.File && window.FileReader && window.FileList && window.Blob)) {
				alert('지원되지 않는 파일 형식입니다.');    
				return;
			}	
	
			var reader = new FileReader();
		
		    // Closure to capture the file information.
		    reader.onload = (function(theFile) {
		        return function(e) {
		        	b.save_file(theFile, e);
		        };
		      })(a.files[0]);
		
		    // Read in the image file as a data URL.
		    try {
			    reader.readAsDataURL(a.files[0]);
			} catch(err) {
				console.log(err);
			}
		    a.value = '';
		}
	},
	sendmessage : {
		value :  function(a,b,c,d,e) {			
			if ( a.value == '' ) {
				a.value = '';
				return;
			}
				
			var msg = encodeURIComponent(d.convertB64(a.value));				

			if( !msg && b == '' )
				return;
			
			e.set_message(msg,b,c);
			
			var emotilayout = d.fi('_NB_EMO_LAYER','_NB_IFRAMECHAT');
			if( emotilayout.style.display == 'block' )
				emotilayout.style.display = 'none';	
			
			//a.classList.remove('active');		
		}
	},	
});

function NB_Chat_ModalBox(chatcontrol,util) {
	this.chatctrl = chatcontrol;
	this.util = util;
	this.root = this.util.fi("_NB_IFRAMECHAT");
	this.modal_container = this.util.ii(this.root,'_NBMODALCONTAINER');
}

NB_Chat_ModalBox.prototype = Object.create(null, {
	constructor: {
		value: NB_Chat_ModalBox
	},
	closechatmodal : {
		value : function () {
			var instance = this;
			var chatctrl = this.chatctrl;
			var util = this.util;
			
			var modal_layout = this.util.cc(0,this.root,'div','_nbmodallayout',this.modal_container);
			var modal_content_div = this.util.cc(0,this.root,'div','_nbmodalcontent',modal_layout);
			var modal_header_div = this.util.cc(0,this.root,'div','_nbmodalheader',modal_content_div);
			var modal_body_div = this.util.cc(0,this.root,'div','_nbmodalbody',modal_content_div,'','','','상담종료를 하시면 모든 대화내용이 지워집니다.<br>이메일 주소를 입력하면 상담내용을 이메일로 보내드립니다.<br>상담을 종료하시겠습니까?<br>');
			var modal_footer_div = this.util.cc(0,this.root,'div','_nbmodalfooter',modal_content_div);	
			
			this.util.cc(0,this.root,'div','_nbmodalheadertitle',modal_header_div,'','','','상담 종료 안내');		
			var header_close_div = this.util.cc(0,this.root,'div','_nbmodalclose',modal_header_div);
			this.util.cc(0,this.root,'img','',header_close_div,'click',function(){instance.closemodalbox(modal_layout);},'false','data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAMCAYAAABSgIzaAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAANFJREFUeNp80jsLwjAYheFodBAXr1XxAro6C27irxdEnQUncbCorS4O3lrPBycQ0mjgAdvmTdtUpZRqwhwG6v+owgyGcqAhgD604QU3T1SDKZTgAaHmxCJXDDyxiQoQwQZSzYtnJ/7AFeqMZN4Flrymcs4jjWHE33vo+SJf6MbKF5nNcYcs1rUWPTDOTLKHvN8E8nCHMs9vYffrjnZ0ggUk0KAUYjdsWVEIK0YRg0wsYYVbbqI1IzNiJ37Kd5awwzse+XETz4bFPC9/z7fM/QowAPnONz+wMuZoAAAAAElFTkSuQmCC');
			
			var body_input_div = this.util.cc(0,this.root,'div','_nbinputlayout',modal_body_div);
			this.util.cc(0,this.root,'label','',body_input_div,'','','','Email (*선택사항)');
			var input_email = this.util.cc(1,this.root,'input','_NBINPUTEMAIL',body_input_div);
			input_email.setAttribute('type','email');
			input_email.setAttribute('placeholder','Email');
			
			var btn_no = this.util.cc(1,this.root,'btn','_NBMODALNO',modal_footer_div,'click',function(){instance.closemodalbox(modal_layout);},'false','아니오');
			btn_no.className = '_nbmodalbutton _nbmodalbtntype2';
			var btn_yes = this.util.cc(1,this.root,'btn','_NBMODALYES',modal_footer_div,'click',function(){
					if ( input_email.value == '' || util.validateEmail(input_email.value) ) {					
						instance.sendclosechatmsg(chatctrl,modal_layout,input_email.value);
					} else {
						instance.confirmmodal('오류','이메일 형식이 올바르지 않습니다.');
					}
				},'false','상담 종료');
			btn_yes.className = '_nbmodalbutton _nbmodalbtntype1 _nbmodalbuttonright';
		}
	},
	closechatbotmodal : {
		value : function () {
			var instance = this;
			var chatctrl = this.chatctrl;
			var util = this.util;
			
			var modal_layout = this.util.cc(0,this.root,'div','_nbmodallayout',this.modal_container);
			var modal_content_div = this.util.cc(0,this.root,'div','_nbmodalcontent',modal_layout);
			var modal_header_div = this.util.cc(0,this.root,'div','_nbmodalheader',modal_content_div);
			var modal_body_div = this.util.cc(0,this.root,'div','_nbmodalbody',modal_content_div,'','','','상담종료를 하시면 모든 대화내용이 지워집니다.<br>상담을 종료하시겠습니까?<br>');
			var modal_footer_div = this.util.cc(0,this.root,'div','_nbmodalfooter',modal_content_div);	
			
			this.util.cc(0,this.root,'div','_nbmodalheadertitle',modal_header_div,'','','','상담 종료 안내');		
			var header_close_div = this.util.cc(0,this.root,'div','_nbmodalclose',modal_header_div);
			this.util.cc(0,this.root,'img','',header_close_div,'click',function(){instance.closemodalbox(modal_layout);},'false','data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAMCAYAAABSgIzaAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAANFJREFUeNp80jsLwjAYheFodBAXr1XxAro6C27irxdEnQUncbCorS4O3lrPBycQ0mjgAdvmTdtUpZRqwhwG6v+owgyGcqAhgD604QU3T1SDKZTgAaHmxCJXDDyxiQoQwQZSzYtnJ/7AFeqMZN4Flrymcs4jjWHE33vo+SJf6MbKF5nNcYcs1rUWPTDOTLKHvN8E8nCHMs9vYffrjnZ0ggUk0KAUYjdsWVEIK0YRg0wsYYVbbqI1IzNiJ37Kd5awwzse+XETz4bFPC9/z7fM/QowAPnONz+wMuZoAAAAAElFTkSuQmCC');
			
			var btn_no = this.util.cc(1,this.root,'btn','_NBMODALNO',modal_footer_div,'click',function(){instance.closemodalbox(modal_layout);},'false','아니오');
			btn_no.className = '_nbmodalbutton _nbmodalbtntype2';
			var btn_yes = this.util.cc(1,this.root,'btn','_NBMODALYES',modal_footer_div,'click',function(){
					instance.sendclosechatmsg(chatctrl,modal_layout,'');
				},'false','종료');
			btn_yes.className = '_nbmodalbutton _nbmodalbtntype1 _nbmodalbuttonright';
		}
	},
	confirmmodal : {
		value : function (a,b) {
			var instance = this;
			var chatctrl = this.chatctrl;
			
			var modal_layout = this.util.cc(0,this.root,'div','_nbmodallayout',this.modal_container);
			var modal_content_div = this.util.cc(0,this.root,'div','_nbmodalcontent',modal_layout);
			var modal_header_div = this.util.cc(0,this.root,'div','_nbmodalheader',modal_content_div);
			var modal_body_div = this.util.cc(0,this.root,'div','_nbmodalbody',modal_content_div,'','','',b);
			var modal_footer_div = this.util.cc(0,this.root,'div','_nbmodalfooter _nbmodalbuttoncenter',modal_content_div);	
			
			this.util.cc(0,this.root,'div','_nbmodalheadertitle',modal_header_div,'','','',a);		
			var btn_no = this.util.cc(0,this.root,'btn','_nbmodalbutton _nbmodalbtntype1',modal_footer_div,'click',function(){instance.closemodalbox(modal_layout);},'false','확인');
		}
	},
	closemodalbox : {
		value : function(ml) {
			ml.parentNode.removeChild(ml);
		}
	},
	sendclosechatmsg : {
		value : function(cc,ml,e) {
			cc.close_room(e);
			ml.parentNode.removeChild(ml);
		}
	},
});

function NB_Eventmsg_PopupBox(chatcontrol,chatlayout, util) {
	this.chatctrl = chatcontrol;
	this.util = util;
	this.chatlayout = chatlayout;
	this.event_div = this.util.de('_NB_EVENT');
}

NB_Eventmsg_PopupBox.prototype = Object.create(null, {
	constructor: {
		value: NB_Eventmsg_PopupBox
	},
	init : {
		value: function(data) {
			var instance = this;
			
			this.eventmsg(data);
			/*
			setTimeout(function() {
				if ( window._NB_isMobile ) {
					instance.event_div.style.top = "0px";	
					instance.event_div.style.height = "100%";
				} else {
					instance.event_div.style.right = instance.chatlayout.icon_show == 'y' ? instance.chatlayout.icon_pos_right + "px" : "20px";
				}
			}, 1000);
			*/			
		}
	},
	showEventMsg : {
		value : function() {
			var instance = this;
			setTimeout(function() {
				if ( window._NB_isMobile ) {
					instance.event_div.style.top = "0px";	
					instance.event_div.style.height = "100%";
					instance.event_div.style.left = "0px";
				} else {
					instance.event_div.style.right = instance.chatlayout.icon_show == 'y' ? instance.chatlayout.icon_pos_right + "px" : "20px";
				}
			}, 1000);
		}
	},	
	eventmsg : {
		value: function(data){
			var instance = this;
			var gcode = this.chatctrl.gcode;
			var deviceid = this.chatctrl.deviceid;
			var jsonobj = JSON.parse(data.message);
			var nplayout_div = this.util.cc(0,document,'div','_NB_NPUSHLAYOUT',this.event_div);
			var npcontainer_div = this.util.cc(0,document,'div','_NB_NPUSHCONTAINER',nplayout_div);
			
			var nppimg_div = this.util.cc(0,document,'div','_NB_NPUSHMANAGERPICTURE',npcontainer_div);
			this.util.cc(0,document,'img','',nppimg_div,'','','',jsonobj.profileurl);
			var npname_div = this.util.cc(0,document,'div','_NB_NPUSHNAME',nppimg_div,'','','',jsonobj.name);
			var npname_div = this.util.cc(0,document,'div','_NB_NPUSHSUBTITLE',nppimg_div,'','','',jsonobj.subtitle);

			var closebtn_div = this.util.cc(0,document,'div','_NB_NPUSHCLOSEBTN',npcontainer_div);	
			var closebtn_img = this.util.cc(0,document,'img','',closebtn_div,'click',function(){
				if ( window._NB_isMobile ) {
					instance.event_div.style.top = "-100%";
					instance.event_div.style.height = "0px";
				} else {
					instance.event_div.style.right = "-370px";
				}
				var self = this;
				setTimeout(function(){
					self.parentNode.parentNode.parentNode.parentNode.removeChild(self.parentNode.parentNode.parentNode);
				}, 1000);
			},'false','data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA8AAAAOCAYAAADwikbvAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAMtJREFUeNqkk8sKwkAMRWunVKnWfoALN/r//yM+ViK48S0Ivm7gjsQ0LYKBg9CZc5NOxzT5owJ/h2ACXuDasr8PpqADLhkfdkEPjEEKto44oCjrhe4s3TImV+AhyQ3iCaxkyqA2HE3AkwGlEedcS4IZTQfIOeRg5ImebAMKHk5NTJjo1YEnH+tkxabO8bNJxxunKLl2bpO1KOPPOEHpBWi5UuIeLCjGzbWA4NwcEZfmnW3AXe5GqmQRd44YawPW6tJ8Vf7j/+Gz7y3AAB6dMorRCbfIAAAAAElFTkSuQmCC');
			
			var npbody_div = this.util.cc(0,document,'div','_NB_NPUSHBODY',npcontainer_div);
			var nbbodytitle_div = this.util.cc(0,document,'div','_NB_NPUSHTITLE',npbody_div,'','','',jsonobj.title);
			nbbodytitle_div.style.color = jsonobj.tcolor;
			this.util.cc(0,document,'div','_NB_NPUSHCONTENTS',npbody_div,'','','',this.util.replacebr(jsonobj.contents));

			if ( jsonobj.imgurl != '' ) {
				var npimgwrap_div = this.util.cc(0,document,'div','_NB_NPUSHIMAGEWRAP',npbody_div);
				var imagesize = jsonobj.imgsize.split('*');				
				var npushimage = this.util.cc(0,document,'img','',npimgwrap_div,'click',function(){
					if ( window._NB_isMobile ) {
						instance.event_div.style.top = "-100%";
						instance.event_div.style.height = "0px";
					} else {
						instance.event_div.style.right = "-370px";
					}
					instance.event_div.removeChild(nplayout_div);
					instance.clickeventmsg(gcode, deviceid, data,'i');
					setTimeout(function(){
						location.href = data.automsg.applink;
					}, 1000);					
				},'false',jsonobj.imgurl);
				
				if ( imagesize.length == 2 && imagesize[0] < 324 ) {
					npushimage.style.width = imagesize[0] + "px"; 
				}
			}
			if ( jsonobj.btntitle != '' ) {
				var npbtnwrap_div = this.util.cc(0,document,'div','_NB_NPUSHBUTTONWRAP',npbody_div);
				var npbtn_div = this.util.cc(0,document,'div','_NB_NPUSHBUTTON',npbtnwrap_div,'click',function(){
					if ( window._NB_isMobile ) {
						instance.event_div.style.top = "-100%";
						instance.event_div.style.height = "0px";
					} else {
						instance.event_div.style.right = "-370px";
					}
					instance.event_div.removeChild(nplayout_div);
					instance.clickeventmsg(gcode, deviceid, data,'b'); 
					setTimeout(function(){
						location.href = data.automsg.applink;
					}, 1000);					
				},'false',jsonobj.btntitle);
				npbtn_div.style.color = jsonobj.btnfcolor;
				npbtn_div.style.backgroundColor = jsonobj.btnbcolor;
			}
		}
	},
	clickeventmsg : {
		value : function(gcode, deviceid, data, type) {		
			var jsonobj = JSON.parse(data.automsg.message);
			//location.href = data.automsg.applink;
			var newurl = '//wlog.ifdo.co.kr/WGT/MV.apz?mode=move_page&deviceid='+deviceid+'&mseq='+data.automsg.seq+'&mtype='+data.automsg.mtype+'&guid='+gcode+'&url='+data.automsg.applink+'&unique_value='+data.automsg.unique_value+'&evt=click';
			var imgobj = new Image(); 
			imgobj.src= newurl +'&rand='+ Math.random();			
			//parent.open(newurl,'_parent');
			/*
			var win = parent.open(newurl,'_blank'); 
			win.opener = null;
			parent.open(newurl,'_parent');
			*/ 
		}
	},	
});

function NB_Automsg_PopupBox(chatcontrol,chatlayout, util) {
	this.chatctrl = chatcontrol;
	this.chatlayout = chatlayout;
	this.util = util;
	this.proot = this.util.ii(document,'_NBCHATLAYOUT');
	this.root = this.util.ii(document,'_NB_AUTOMSG_CONTAINER');
	this.npush_div = this.util.de('_NB_NPUSH');
	this._NOTICEPOPUP_TIMEOUT = 5000;
}

NB_Automsg_PopupBox.prototype = Object.create(null, {
	constructor: {
		value: NB_Automsg_PopupBox
	},
	init : {
		value: function(data) {
			var instance = this;

			if ( data.automsg.mtype == 'msg' )
				this.displaypopupmsg(data);			
			else if ( data.automsg.mtype == 'redirect' )
				this.redirectpopupmsg(data);	
			else if ( data.automsg.mtype == 'layer' || data.automsg.mtype == 'coupon' || data.automsg.mtype == 'notice' ) {			
				var iframe_id = '_nb_automsg_' + data.automsg.seq;
				var root_iframe = this.util.ci(iframe_id, this.root);	
				var head_str = "<style> ._NB_POP_X{background: rgb(150,158,156); border-radius: 20px; top: -15px; width: 30px; height: 30px; text-align: center; right: -15px; line-height: 40px; float: right; display: block; position: absolute;cursor:pointer;background-image:url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAIAAAAC64paAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAErSURBVDhPnZNdSwJBFIb7/z8gCEzNisQbu+5CCSSJIhKEwFCS7Lsw8iZhYXvGOTM7zpkV6eW92PPOeXbYMzs7u9XKvy3wWbcznT32r6/2Dmp+Tfv8ovf08ty77NvSwES5E68o4+9GI2nK85vBLYmBX9/fJFuJcv+o4RnrkERZlrGHgQfDoWROH1+fIR+RiA3IDVw/OaZbYifPa/J3uWydtgXG9CX5+8lYCidPFnAZHykkcQHjzXxE4jUYw3OS0h5IkziGsZ4Q+lksmGvUGcNJ0srP33sN3kBaRXwBJ89Tf3/IC1z2J/AP6vl73sDcEomdwtnSp3k2E5hJSraSPhXNczHIDRxejOR54oifTB8IDcwCBRHLSdKaNm47bfPv+WGrSSIDs2v+eStXK3+1BrGNUAdgJAAAAABJRU5ErkJggg==);background-repeat:no-repeat;background-position:center center;} .freead_wrap { text-align: right;vertical-align: middle;padding-top: 2px; } .freead_wrap a{font-family: VERDANA;font-size: 9px;text-decoration:none;color: rgba(150, 158, 156, 1);} </style>";			
				var coupon_script = ( data.automsg.mtype == 'coupon' ? "<script src='//ifdo.co.kr/js/clipboard.min.js' type='text/javascript'><\/script><script type='text/javascript'>if( typeof Clipboard == 'function' && typeof document.getElementById('_NB_COUPON_TXT') == 'object'){var _C_BD = new Clipboard('.coupon_copy_btn');_C_BD.on('success', function(e) {alert('쿠폰코드가 복사되었습니다.');});_C_BD.on('error', function(e) {alert('복사하지 못했습니다.');});}<\/script>" : "" );					
				//coupon_script += "<script type='text/javascript'>function onMoveClickLink(orgurl,newwin) {	var newurl = 'http://wlog.ifdo.co.kr/WGT/MV.apz?mode=move_page&deviceid="+this.chatctrl.deviceid+"&mseq="+data.automsg.seq+"&mtype="+data.automsg.mtype+"&guid="+this.chatctrl.gcode+"&url='+encodeURIComponent(orgurl)+'&unique_value="+data.automsg.unique_value+"'; if( newwin == 'y' ) { var win = parent.open(newurl,'_blank'); win.opener = null; } else parent.open(newurl,'_parent'); }<\/script>";
				coupon_script += "<script type='text/javascript'>function onMoveClickLink(orgurl,newwin) { if( orgurl.indexOf('javascript') >= 0 ){ var pfunc = orgurl.replace('javascript:',''); var sc = 'window.top.' + pfunc; eval(sc); } var newurl = 'https://wlog.ifdo.co.kr/WGT/MV.apz?mode=move_page&deviceid="+this.chatctrl.deviceid+"&mseq="+data.automsg.seq+"&mtype="+data.automsg.mtype+"&guid="+this.chatctrl.gcode+"&url='+encodeURIComponent(orgurl)+'&unique_value="+data.automsg.unique_value+"'; if( orgurl.indexOf('javascript') >= 0 ) { var _NBLINK_Img=new Image(); _NBLINK_Img.src=newurl+'&rand='+Math.random(); setTimeout(function(){window.parent.document.getElementById('_NB_AUTOMSG_CONTAINER').innerHTML='';}, 500); } else if( newwin == 'y' ) { var win = parent.open(newurl,'_blank'); win.opener = null; } else parent.open(newurl,'_parent'); }<\/script>";
				                                                 				
				root_iframe.open();
				root_iframe.write("<html><head>"+head_str+"</head><body>"+( data.automsg.mtype == 'msg' ? data.automsg.message : data.makedimg.image_data )+coupon_script+"</body></html>");
				root_iframe.close();
				root_iframe.body.style.margin= "20px";
				root_iframe.body.style.overflow= "hidden";
				
				if ( data.automsg.mtype == 'notice' )
					data.automsg.etc1 = "{\"pos\":7,\"position\":\"fixed\"}";
					
				this.getiframestyle(iframe_id, data);

				if ( data.automsg.mtype == 'notice' )
					this.noticepopupmsg(iframe_id);		
				
				if ( data.automsg.mtype == 'coupon' || data.automsg.mtype == 'layer' ) {
					var input_pos = JSON.parse(data.automsg.etc1);
					
					if ( input_pos != null && input_pos.position == 'fixed' && ( data.automsg.popup_bguse === undefined || data.automsg.popup_bguse != 'n' ) ) {
						var modal = this.util.ii(document,'_NB_AUTOMSG_MODAL');
						if ( data.automsg.popup_bgop !== undefined ) {
							modal.style.opacity = data.automsg.popup_bgop; 
						}
						modal.style.display = 'block';
					}
					
					if ( input_pos != null && input_pos.position == 'absolute' ) {
						this.root.style.position = "static";
						this.proot.style.position = "static";
					}
				}
			} else if ( data.automsg.mtype == 'notice2' ) {				
				var iframe_id = '_nb_automsg_' + data.automsg.seq;
				this.root.innerHTML = data.automsg.message;
				var autoIframe = this.root.getElementsByTagName("iframe")[0];
				autoIframe.id = iframe_id;
				this.getiframestyle2(iframe_id);
				this.noticepopupmsg(iframe_id);		
			} else if ( data.automsg.mtype == 'iframe' || data.automsg.mtype == 'uhtml' ) {
				this.iframepopupmsg(data);
			} else if ( data.automsg.mtype == 'npush' ) {
				this.pushnotemsg(data);
				setTimeout(function() {
					if ( window._NB_isMobile ) {
						instance.npush_div.style.top = "0px";	
						instance.npush_div.style.height = "100%";
					} else {
						instance.npush_div.style.right = instance.chatlayout.icon_show == 'y' ? instance.chatlayout.icon_pos_right + "px" : "20px";
					}
				}, 1000);
			} else if ( data.automsg.mtype == "appshort" ) {
				this.appshortcutmsg(data);
				setTimeout(function() {
					instance.npush_div.style.top = "0px";
					instance.npush_div.style.height = "100%";
				}, 1000);
			} else if ( data.automsg.mtype == "ipop" || data.automsg.mtype == "ipopm" ) {
				var iframe_id = data.name;
				this.root.innerHTML += data.iframe;
				var datajson = JSON.parse(data.automsg.message);
				if ( data.automsg.mtype == "ipop" )
					this.getiframestyle_ipop(iframe_id, data, datajson);
				
				if ( data.automsg.etc1 === undefined || data.automsg.etc1 == '')
					data.automsg.etc1 = '{"pos":4,"position":"fixed"}';
				
				var input_pos = JSON.parse(data.automsg.etc1);				
				if ( input_pos != null && input_pos.position == 'absolute' ) {
					this.root.style.position = "static";
					this.proot.style.position = "static";
				}
				
				this.chatctrl.recvlogparam(data);
				
				delete data.iframe;
				delete data.automsg;
				delete data.log_curdata;
				
				this.sendiframemsg(data);				
			} else if ( data.automsg.mtype == "whistle" || data.automsg.mtype == "popcorn" || data.automsg.mtype == "floating" ) {
				if (data.automsg.mtype == "floating") {
					this.root.style.width = "100%";
				}
				var iframe_id = data.name;
				this.root.innerHTML += data.iframe;
				var datajson = JSON.parse(data.automsg.message);

				this.chatctrl.recvlogparam(data);
				
				delete data.iframe;
				delete data.automsg;
				delete data.log_curdata;
				
				this.sendiframemsg(data);				
			}
			
			if ( data.automsg !== undefined )
				this.chatctrl.recvlogparam(data);
		}
	},
	sendiframemsg : {
		value: function(data) {
			var f = document.createElement("form");
			f.setAttribute('method',"post");
			f.setAttribute('action',data.src);
			f.setAttribute('target',data.name);
			f.setAttribute('id',data.name + "_frm");
			
			Object.keys(data).forEach(function(key) {
				var i = document.createElement("input"); //input element, text
				i.setAttribute('type',"hidden");
				i.setAttribute('name',key);
				if ( key == 'logparam' ) {
					//i.setAttribute('value',data[key] + "&pwidth=" + _NB_SC.width);
					i.setAttribute('value',data[key] + "&pwidth=" + window.innerWidth);
				} else
					i.setAttribute('value',data[key]);				
				f.appendChild(i);
			});
			
			document.getElementsByTagName('body')[0].appendChild(f);	
			var bf = document.getElementById(data.name + "_frm");
			bf.submit();
			//bf.parentNode.removeChild(bf);				
		}
	},
	displaypopupmsg : {
		value: function(data) {
			//this.chatlayout.showlpopmessage(data.messageinfo);
		}
	},	
	pushnotemsg : {
		value: function(data){
			var instance = this;
			var gcode = this.chatctrl.gcode;
			var deviceid = this.chatctrl.deviceid;
			var jsonobj = JSON.parse(data.automsg.message);
			var nplayout_div = this.util.cc(0,document,'div','_NB_NPUSHLAYOUT',this.npush_div);
			var npcontainer_div = this.util.cc(0,document,'div','_NB_NPUSHCONTAINER',nplayout_div);
			
			var nppimg_div = this.util.cc(0,document,'div','_NB_NPUSHMANAGERPICTURE',npcontainer_div);
			this.util.cc(0,document,'img','',nppimg_div,'','','',jsonobj.profileurl);
			var npname_div = this.util.cc(0,document,'div','_NB_NPUSHNAME',nppimg_div,'','','',jsonobj.name);
			var npname_div = this.util.cc(0,document,'div','_NB_NPUSHSUBTITLE',nppimg_div,'','','',jsonobj.subtitle);

			var closebtn_div = this.util.cc(0,document,'div','_NB_NPUSHCLOSEBTN',npcontainer_div);	
			var closebtn_img = this.util.cc(0,document,'img','',closebtn_div,'click',function(){
				if ( window._NB_isMobile ) {
					instance.npush_div.style.top = "-100%";
					instance.npush_div.style.height = "0px";						
				} else {
					instance.npush_div.style.right = "-370px";
				}
				var self = this;
				setTimeout(function(){
					self.parentNode.parentNode.parentNode.parentNode.removeChild(self.parentNode.parentNode.parentNode);
				}, 1000);
			},'false','data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA8AAAAOCAYAAADwikbvAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAMtJREFUeNqkk8sKwkAMRWunVKnWfoALN/r//yM+ViK48S0Ivm7gjsQ0LYKBg9CZc5NOxzT5owJ/h2ACXuDasr8PpqADLhkfdkEPjEEKto44oCjrhe4s3TImV+AhyQ3iCaxkyqA2HE3AkwGlEedcS4IZTQfIOeRg5ImebAMKHk5NTJjo1YEnH+tkxabO8bNJxxunKLl2bpO1KOPPOEHpBWi5UuIeLCjGzbWA4NwcEZfmnW3AXe5GqmQRd44YawPW6tJ8Vf7j/+Gz7y3AAB6dMorRCbfIAAAAAElFTkSuQmCC');
			
			var npbody_div = this.util.cc(0,document,'div','_NB_NPUSHBODY',npcontainer_div);
			var nbbodytitle_div = this.util.cc(0,document,'div','_NB_NPUSHTITLE',npbody_div,'','','',jsonobj.title);
			nbbodytitle_div.style.color = jsonobj.tcolor;
			this.util.cc(0,document,'div','_NB_NPUSHCONTENTS',npbody_div,'','','',this.util.replacebr(jsonobj.contents));

			if ( data.automsg.couponcode !== undefined && data.automsg.couponcode != '' ) {
				var npcouponwrap_div = this.util.cc(0,document,'div','_NB_NPUSHCOUPONWRAP',npbody_div);
				var npcoupontitle_div = this.util.cc(0,document,'div','_NB_NPUSHCOUPONTITLE',npcouponwrap_div, '','','',jsonobj.ctitle !== undefined && jsonobj.ctitle != '' ? jsonobj.ctitle : '쿠폰 코드');
				npcoupontitle_div.style.color = jsonobj.ccolor;
				
				var npcouponnowrap_div = this.util.cc(0,document,'div','_NB_NPUSHCOUPONNOWRAP',npcouponwrap_div);				
				var npcouponno_div = this.util.cc(0,document,'div','_NB_NPUSHCOUPONNO _NB_AUTOMSG_TOOLTIP',npcouponnowrap_div,'click',function() {
					instance.util.CopyToClipboard('_NB_NPUSHCOUPONNO');
					alert('쿠폰코드가 복사되었습니다.');
				},'false',data.automsg.couponcode);
				if ( jsonobj.couponcolor !== undefined ) npcouponno_div.style.color = jsonobj.couponcolor;
				npcouponno_div.id = '_NB_NPUSHCOUPONNO';
				this.util.cc(0,document,'span','_NB_AUTOMSG_TOOLTIPTEXT',npcouponno_div, '','','','클릭하시면 복사됩니다.');
			}
			if ( jsonobj.imgurl != '' ) {
				var npimgwrap_div = this.util.cc(0,document,'div','_NB_NPUSHIMAGEWRAP',npbody_div);
				var imagesize = jsonobj.imgsize.split('*');
				var npushimage = this.util.cc(0,document,'img','',npimgwrap_div,'click',function(){ 
					instance.clickpushnote(gcode, deviceid, data,'i');
					if ( data.automsg.imglink !== undefined && data.automsg.imglink != '') {
						if ( window._NB_isMobile ) {
							instance.npush_div.style.top = "-100%";
							instance.npush_div.style.height = "0px";						
						} else {
							instance.npush_div.style.right = "-370px";
						}
					}
				},'false',jsonobj.imgurl);
				if ( imagesize.length ==2 && imagesize[0] < 324 ) {
					npushimage.style.width = imagesize[0] + "px"; 
				}
			}
			if ( jsonobj.btntitle != '' ) {
				var npbtnwrap_div = this.util.cc(0,document,'div','_NB_NPUSHBUTTONWRAP',npbody_div);
				var npbtn_div = this.util.cc(0,document,'div','_NB_NPUSHBUTTON',npbtnwrap_div,'click',function(){ 
					instance.clickpushnote(gcode, deviceid, data,'b'); 
					if ( window._NB_isMobile ) {
						instance.npush_div.style.top = "-100%";
						instance.npush_div.style.height = "0px";						
					} else {
						instance.npush_div.style.right = "-370px";
					}
				},'false',jsonobj.btntitle);
				npbtn_div.style.color = jsonobj.btnfcolor;
				npbtn_div.style.backgroundColor = jsonobj.btnbcolor;
			}
		}
	},
	clickpushnote : {
		value : function(gcode, deviceid, data, type) {		
			var jsonobj = JSON.parse(data.automsg.message);
			var newurl = 'http://wlog.ifdo.co.kr/WGT/MV.apz?mode=move_page&deviceid='+deviceid+'&mseq='+data.automsg.seq+'&mtype='+data.automsg.mtype+'&guid='+gcode+'&url='+encodeURIComponent( type == 'i' ? jsonobj.imglink : jsonobj.btnlink )+'&unique_value='+data.automsg.unique_value;
			if( data.automsg.newwin == 'y' ) { 
				var win = parent.open(newurl,'_blank'); 
				win.opener = null; 
			} else 
				parent.open(newurl,'_parent');
		}
	},
	
	appshortcutmsg : {
		value: function(data){
			var instance = this;
			var gcode = this.chatctrl.gcode;
			var deviceid = this.chatctrl.deviceid;
			var jsonobj = JSON.parse(data.automsg.message);
			var nplayout_div = this.util.cc(0,document,'div','_NB_NPUSHLAYOUT',this.npush_div);
			var npcontainer_div = this.util.cc(0,document,'div','_NB_NPUSHCONTAINER',nplayout_div);
			
			var nppimg_div = this.util.cc(0,document,'div','_NB_NPUSHMANAGERPICTURE',npcontainer_div);
			this.util.cc(0,document,'img','',nppimg_div,'','','',jsonobj.profileurl);
			var npname_div = this.util.cc(0,document,'div','_NB_NPUSHNAME',nppimg_div,'','','',jsonobj.name);
			var npname_div = this.util.cc(0,document,'div','_NB_NPUSHSUBTITLE',nppimg_div,'','','',jsonobj.subtitle);

			var closebtn_div = this.util.cc(0,document,'div','_NB_NPUSHCLOSEBTN',npcontainer_div);	
			var closebtn_img = this.util.cc(0,document,'img','',closebtn_div,'click',function(){
				if ( window._NB_isMobile ) {
					instance.npush_div.style.top = "-100%";
					instance.npush_div.style.height = "0px";
				} else {
					instance.npush_div.style.right = "-370px";
				}
				var self = this;
				setTimeout(function(){
					self.parentNode.parentNode.parentNode.parentNode.removeChild(self.parentNode.parentNode.parentNode);
				}, 1000);
			},'false','data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA8AAAAOCAYAAADwikbvAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAMtJREFUeNqkk8sKwkAMRWunVKnWfoALN/r//yM+ViK48S0Ivm7gjsQ0LYKBg9CZc5NOxzT5owJ/h2ACXuDasr8PpqADLhkfdkEPjEEKto44oCjrhe4s3TImV+AhyQ3iCaxkyqA2HE3AkwGlEedcS4IZTQfIOeRg5ImebAMKHk5NTJjo1YEnH+tkxabO8bNJxxunKLl2bpO1KOPPOEHpBWi5UuIeLCjGzbWA4NwcEZfmnW3AXe5GqmQRd44YawPW6tJ8Vf7j/+Gz7y3AAB6dMorRCbfIAAAAAElFTkSuQmCC');
			
			var npbody_div = this.util.cc(0,document,'div','_NB_NPUSHBODY',npcontainer_div);
			var nbbodytitle_div = this.util.cc(0,document,'div','_NB_NPUSHTITLE',npbody_div,'','','',jsonobj.title);
			nbbodytitle_div.style.color = jsonobj.tcolor;
			this.util.cc(0,document,'div','_NB_NPUSHCONTENTS',npbody_div,'','','',this.util.replacebr(jsonobj.contents));

			if ( jsonobj.imgurl != '' ) {
				var npimgwrap_div = this.util.cc(0,document,'div','_NB_NPUSHIMAGEWRAP',npbody_div);
				var imagesize = jsonobj.imgsize.split('*');				
				var npushimage = this.util.cc(0,document,'img','',npimgwrap_div,'click',function(){
					if ( window._NB_isMobile ) {
						instance.npush_div.style.top = "-100%";
						instance.npush_div.style.height = "0px";
					} else {
						instance.npush_div.style.right = "-370px";
					}
					instance.npush_div.removeChild(nplayout_div);
					instance.clickappshortcut(gcode, deviceid, data,'i');
					setTimeout(function(){
						location.href = data.automsg.applink;
					}, 1000);					
				},'false',jsonobj.imgurl);
				
				if ( imagesize.length == 2 && imagesize[0] < 324 ) {
					npushimage.style.width = imagesize[0] + "px"; 
				}
			}
			if ( jsonobj.btntitle != '' ) {
				var npbtnwrap_div = this.util.cc(0,document,'div','_NB_NPUSHBUTTONWRAP',npbody_div);
				var npbtn_div = this.util.cc(0,document,'div','_NB_NPUSHBUTTON',npbtnwrap_div,'click',function(){
					if ( window._NB_isMobile ) {
						instance.npush_div.style.top = "-100%";
						instance.npush_div.style.height = "0px";
					} else {
						instance.npush_div.style.right = "-370px";
					}
					instance.npush_div.removeChild(nplayout_div);
					instance.clickappshortcut(gcode, deviceid, data,'b'); 
					setTimeout(function(){
						location.href = data.automsg.applink;
					}, 1000);					
				},'false',jsonobj.btntitle);
				npbtn_div.style.color = jsonobj.btnfcolor;
				npbtn_div.style.backgroundColor = jsonobj.btnbcolor;
			}
		}
	},
	clickappshortcut : {
		value : function(gcode, deviceid, data, type) {		
			var jsonobj = JSON.parse(data.automsg.message);
			//location.href = data.automsg.applink;
			var newurl = 'http://wlog.ifdo.co.kr/WGT/MV.apz?mode=move_page&deviceid='+deviceid+'&mseq='+data.automsg.seq+'&mtype='+data.automsg.mtype+'&guid='+gcode+'&url='+data.automsg.applink+'&unique_value='+data.automsg.unique_value+'&evt=click';
			var imgobj = new Image(); 
			imgobj.src= newurl +'&rand='+ Math.random();			
			//parent.open(newurl,'_parent');
			/*
			var win = parent.open(newurl,'_blank'); 
			win.opener = null;
			parent.open(newurl,'_parent');
			*/ 
		}
	},
	redirectpopupmsg : {
		value: function(data) {
			var jsonobj = JSON.parse(data.automsg.etc1);
			if ( typeof jsonobj.target === 'undefined' || jsonobj.target == '' )
				document.location.href = data.automsg.message;
			else
				window.open(data.automsg.message, jsonobj.target);
		}
	},	
	noticepopupmsg : {
		value: function(id) {
			var iframe = this.util.ii(document,id);

			var screen_height = (window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight);
			var pos_top = iframe.offsetTop;
				
			iframe.style.top = screen_height + 'px';	

			var animateid = setInterval(moveanimate, 10);
			var pos = screen_height;

			function moveanimate() {
				if ( pos <= pos_top ) {
					clearInterval(animateid);
					iframe.style.top = pos_top + 'px';	
				} else {
					pos-=10;
					iframe.style.top = pos + 'px';						
				}
			}
		}
	},
	iframepopupmsg : {
		value: function(data) {
			var jsonobj = JSON.parse(data.automsg.etc1);
			var iframe_layout = this.util.ii(document,jsonobj.layer);
			if ( iframe_layout )
				//iframe_layout.innerHTML = data.automsg.message;
				this.util.evalInnerHTML(iframe_layout, data.automsg.message);
		}
	},	
	addfreeadlink : {
		value: function(iframedoc, rootdiv) {
			var free_ad_div = this.util.cc(0,iframedoc,'div','freead_wrap',rootdiv);
			var free_ad_link = this.util.cc(0,iframedoc,'a','',free_ad_div,'','','','powered by IFDO');
			free_ad_link.href = "https://www.ifdo.co.kr?nbsrc=nbimg&nbkw=0000000f";
			free_ad_link.setAttribute("target","_blank");
		}
	},
	getiframestyle : {
		value: function(id, data) {
			var iframe = this.util.ii(document,id);
			var popuplayer = this.util.ii(iframe.contentWindow.document,'mangos_pop_layer');
			if ( data.use_able.indexOf('f') == 0 )
				this.addfreeadlink(iframe.contentWindow.document, popuplayer);
			
			var screen_width = (window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth);
			var screen_height = (window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight);
			
			var iframe_width = popuplayer.offsetWidth + 40;
			var iframe_height = popuplayer.offsetHeight + 40;			
			
			var left_pos = Math.round((screen_width - iframe_width)/2);
			var top_pos = Math.round((screen_height - iframe_height)/2);
			
			var input_pos = JSON.parse(data.automsg.etc1);
			
			var iframe_style = 'width:'+iframe_width+'px;height:'+iframe_height+'px;border:0;position:' + ( input_pos.position ? input_pos.position : 'fixed' ) + ';overflow:hidden;z-index:99997;';
			var scale_pivot = 'left top';
			switch(input_pos.pos) {
				case 1 :
					iframe_style += 'left:' +left_pos+'px;top:10px';
					scale_pivot = 'center top';
					break;
				case 2 :
					iframe_style += 'right:0px;top:0px';
					scale_pivot = 'right top';
					break;
				case 3 :
					iframe_style += 'left:0px;top:'+top_pos+'px';
					scale_pivot = 'left center';
					break;
				case 4 :
					iframe_style += 'left:'+left_pos+'px;top:'+top_pos+'px';
					scale_pivot = 'center center';
					break;
				case 5 :
					iframe_style += 'right:0px;top:'+top_pos+'px';
					scale_pivot = 'right center';
					break;
				case 6 :
					iframe_style += 'left:0px;bottom:0px';
					scale_pivot = 'left bottom';
					break;
				case 7 :
					iframe_style += 'left:'+left_pos+'px;bottom:0px';
					scale_pivot = 'center bottom';
					break;
				case 8 :
					iframe_style += 'right:0px;bottom:0px';
					scale_pivot = 'right bottom';
					break;
				default :
					iframe_style += 'left:0px;top:0px';				
			}
			iframe.setAttribute('style',iframe_style);
			
			if ( screen_width < iframe_width ) {
				var ratio = ( screen_width - 40 ) / (iframe_width - 40);
				
				var transform = this.util.getStyleProperty("transform");
				if ( transform ) popuplayer.style[transform ]= 'scale('+ratio+')';
				var transformorg = this.util.getStyleProperty("transformOrigin");
				if ( transformorg ) popuplayer.style.transformOrigin = scale_pivot;				
			}
		}
	},	
	getiframestyle_ipop : {
		value: function(id, data, setting) {
			var iframe = this.util.ii(document,id);
			
			var screen_width = (window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth);
			var screen_height = (window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight);
			
			var iframe_width = setting.width_unit == '%' ? screen_width * setting.width / 100 : setting.width;
			var iframe_height = setting.height;			
			
			var left_pos = Math.round((screen_width - iframe_width)/2);
			var top_pos = Math.round((screen_height - iframe_height)/2);
			
			var input_pos = JSON.parse(data.automsg.etc1 === undefined || data.automsg.etc1 == '' ? '{"pos":4,"position":"fixed"}' : data.automsg.etc1);
			
			var iframe_style = 'width:'+iframe_width+'px;height:'+iframe_height+'px;border:0;position:' + ( input_pos.position ? input_pos.position : 'fixed' ) + ';overflow:hidden;z-index:99997;';			
			var scale_pivot = 'left top';
			switch(input_pos.pos) {
				case 1 :
					iframe_style += 'left:' +left_pos+'px;top:10px;';
					break;
				case 2 :
					iframe_style += 'right:0px;top:0px;';
					break;
				case 3 :
					iframe_style += 'left:0px;top:'+top_pos+'px;';
					break;
				case 4 :
					iframe_style += 'left:'+left_pos+'px;top:'+top_pos+'px;';
					break;
				case 5 :
					iframe_style += 'right:0px;top:'+top_pos+'px;';
					break;
				case 6 :
					iframe_style += 'left:0px;bottom:0px';
					break;
				case 7 :
					iframe_style += 'left:'+left_pos+'px;bottom:0px;';
					break;
				case 8 :
					iframe_style += 'right:0px;bottom:0px;';
					break;
				default :
					iframe_style += 'left:0px;top:0px;';				
			}			
			iframe.setAttribute('style',iframe_style);
			iframe.setAttribute('name',data.name);
		}
	},		
	getiframestyle2 : {
		value: function(id) {
			var iframe = this.util.ii(document,id);
			
			var screen_width = (window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth);
			var screen_height = (window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight);
			
			var left_pos = Math.round((screen_width - 1024)/2);
			var top_pos = Math.round((screen_height - 240)/2);
			
			var iframe_style = 'position:fixed;overflow:hidden;z-index:99997;background:#fff;';
			var scale_pivot = 'center bottom';
			iframe_style += 'left:'+left_pos+'px;bottom:0px';
			iframe.setAttribute('style',iframe_style);
		}
	},		
});

var getStyleProperty = (function(){
 
  var prefixes = ['Moz', 'Webkit', 'Khtml', 'O', 'Ms'];
  var _cache = { };
 
  function getStyleProperty(propName, element) {
    element = element || document.documentElement;
    var style = element.style,
         prefixed,
         uPropName;
 
    // check cache only when no element is given
    if (arguments.length == 1 && typeof _cache[propName] == 'string') {
      return _cache[propName];
    }
    // test standard property first
    if (typeof style[propName] == 'string') {
      return (_cache[propName] = propName);
    }
 
    // capitalize
    uPropName = propName.charAt(0).toUpperCase() + propName.slice(1);
 
    // test vendor specific properties
    for (var i=0, l=prefixes.length; i<l; i++) {
      prefixed = prefixes[i] + uPropName;
      if (typeof style[prefixed] == 'string') {
        return (_cache[propName] = prefixed);
      }
    }
  }
 
  return getStyleProperty;
})();

function NB_Webpush_PopupBox(util, dbconn, msgctrl) {
	this.util = util;
	this.dbconn = dbconn;
	this.layout = null;
	this.msgctrl = msgctrl;
	//this.init();
}

NB_Webpush_PopupBox.prototype = Object.create(null, {
	constructor: {
		value: NB_Webpush_PopupBox
	},
	init : {
		value : function(layout) {
			var instance = this;
			if ('serviceWorker' in navigator && 'PushManager' in window ) {
				this.layout = layout;
				this.dbconn.select_indexdb('ifdo_webpush','user_status', function(dbset) { 
					if ( dbset.target.result === undefined ) {
						instance.dbconn.update_indexdb('ifdo_webpush',{id:'open_wait',value:layout.webpush_display});							
						instance.displayallowpopup(dbset);		
					} else {
						var id = dbset.target.result.value;
						if ( id == 'W' ) {
							instance.setopenwait();
						}
					}
				});
			} else {
				//console.log('serviceWorker is not avaliabled');
			}			
		}
	},
	setopenwait : {
		value : function() {
			var instance = this;
			this.dbconn.select_indexdb('ifdo_webpush','open_wait', function(dbset) { 
				if ( dbset.target.result === undefined ) {
					instance.dbconn.update_indexdb('ifdo_webpush',{id:'open_wait',value:instance.layout.webpush_display});							
					instance.displayallowpopup(dbset);		
				} else {
					var id = dbset.target.result.value;
					if ( --id < 0 ) {
						instance.displayallowpopup(dbset);		
						instance.dbconn.update_indexdb('ifdo_webpush',{id:'open_wait',value:instance.layout.webpush_display});							
					} else {
						instance.dbconn.update_indexdb('ifdo_webpush',{id:'open_wait',value:id});							
					}
				}
			});			
		}
	},
	displayallowpopup : {
		value: function(dbset) {
			var instance = this;
			var layout = this.layout;
			var webpush_div = this.util.cct(1,'div','_NB_WEBPUSHPOPUP',document.body);
			var webpush_layout = this.util.cc(0,document,'div','_NBWEBPUSHLAYOUT',webpush_div);
			var webpush_textlayout = this.util.cc(0,document,'div','_NBWEBPUSHTEXT',webpush_layout,'','','',location.protocol + "//" + location.host + '의 알림을 허용하시겠습니까 ?');
			this.util.cct(0,'img','',webpush_textlayout,'','','','//ifdo.co.kr/webpush/img/ic_alarm.png');
			var webpush_buttonlayout = this.util.cc(0,document,'div','_NBWEBPUSHBTNLAYOUT',webpush_layout);
			this.util.cc(0,document,'button','_NBWEBPUSHBTN _NBWEBPUSHBTNOK',webpush_buttonlayout,'click',function() { instance.openwebpushwindow(layout); instance.closewebpush(); },'false','자세한 안내');
			this.util.cc(0,document,'button','_NBWEBPUSHBTN _NBWEBPUSHBTNDENY',webpush_buttonlayout,'click',function() { instance.setdenywebpush(); },'false','나중에');
		}
	},
	openwebpushwindow : {
		value : function(layout) {
			var dbconn = this.dbconn;
			var msgctrl = this.msgctrl;
			var width = 500;
			var height = 500;
			var screen_width=window.innerWidth?window.innerWidth:document.documentElement.clientWidth?document.documentElement.clientWidth:screen.width;
			var screen_height=window.innerHeight?window.innerHeight:document.documentElement.clientHeight?document.documentElement.clientHeight:screen.height;
			var left = screen_width/2 - width/2;
			var top = screen_height/2 - height/2;
			var cnt = layout.webpush_display === undefined ? 5 : layout.webpush_display;
			var popwin = window.open("https://wp"+layout.id+".ifdo.co.kr:9443/subscribe/register?gcode=" + _NB_MKTCD + "&display=" + cnt,"_blank","scrollbars=yes, width="+width+", height="+height+", top="+top+", left="+left);
			if(window.focus){
				popwin.focus()
			}
			window.addEventListener("message", function(event) {
				if ( event.origin.match(/[^.]*\.ifdo\.co\.kr[:\d]*$/) === null ) {
	    			return;
	    		}
	    		
	    		switch(event.data.msgtype) {
	    			case 'subscription' :
	    				console.log('subscription 이 발생했습니다. ', event.data);
	    				dbconn.update_indexdb('ifdo_webpush',{id:'user_status',value: event.data.endpoint});
	    				msgctrl.registersubscriber(event.data);
	    				break;
	    			case 'unsubscription' :
		    			console.log('unsubscription 이 발생했습니다. ', event.data);
		    			msgctrl.removesubscriber(event.data);
	    				break;
	    			case 'denied' :
	    				console.log('거부 되었습니다.', event.data);
	    				dbconn.update_indexdb('ifdo_webpush',{id:'user_status',value: 'D'});
	    				break;
	    		}
	    	}, false);
		}
	},
	setdenywebpush : {
		value : function() {
			this.dbconn.update_indexdb('ifdo_webpush',{id:'user_status',value:'W'});
			this.closewebpush();
		}
	},	
	closewebpush : {
		value : function() {
			var webpush_div = this.util.ii(document,'_NB_WEBPUSHPOPUP');
			webpush_div.parentNode.removeChild(webpush_div);			
		}
	},
});
	
function NB_TICKER_MsgBox(chatcontrol,chatlayout, util) {
	this.chatctrl = chatcontrol;
	this.chatlayout = chatlayout;
	this.util = util;
	this.root = this.util.ii(document,'_NB_TICKER');
}

NB_TICKER_MsgBox.prototype = Object.create(null, {
	constructor: {
		value: NB_TICKER_MsgBox
	},
	init : {
		value : function(data) {
			this.root.style.display = 'block';
			this.root.style.width = "100%";
			this.root.innerHTML = data.iframe;
			
			delete data.iframe;
			delete data.setting;
			
			var f = document.createElement("form");
			f.setAttribute('method',"post");
			f.setAttribute('action',data.src);
			f.setAttribute('target',data.name);
			f.setAttribute('id',data.name);
			
			Object.keys(data).forEach(function(key) {
				var i = document.createElement("input"); //input element, text
				i.setAttribute('type',"hidden");
				i.setAttribute('name',key);
				if ( key == 'logparam' )
					i.setAttribute('value',data[key] + "&pwidth=" + _NB_SC.width);
				else
					i.setAttribute('value',data[key]);
				
				f.appendChild(i);
			});
			
			document.getElementsByTagName('body')[0].appendChild(f);			
			var bf = document.getElementById(data.name);
			bf.submit();
			bf.parentNode.removeChild(bf);			
		}
	},		
});


function NB_Statistics_ListBox(chatcontrol, util, data){
	this.chatctrl = chatcontrol;
	this.util = util;
	this.data = data;
}

NB_Statistics_ListBox.prototype = Object.create(null, {
	constructor: {
		value: NB_Statistics_ListBox
	},
	
	init : {
		value : function() {
			var util = this.util;
			var chatctrl = this.chatctrl;
			var showStatFrame = function(data) {
				var pwidth = util.ii(document, data[1]).parentElement.clientWidth;
				chatctrl.getstatframe(_Img.src,data[1], pwidth);
			};

			this.data.forEach(function(value, index, arr) {
				eval(value[0])(value);		
			});				
		}
	},
});
_CKO={get:function(g){var f=document.cookie.split(/\s*;\s*/);var h=new RegExp("^(\\s*"+g+"\\s*=)");for(var e=0;e<f.length;e++){if(h.test(f[e])){return unescape(f[e].substr(RegExp.$1.length))}}return null},set:function(j,i,k,g,h){var l="";if(typeof k=="number" && k != 0){l="; expires="+(new Date((new Date()).getTime()+k*1000*60*60*24)).toUTCString()}; if(typeof h=="undefined"){h=""};if(typeof g=="undefined"){g="/"};var hh=j+"="+encodeURIComponent(i)+l+"; path="+g+(h!=""?"; domain="+h:"");document.cookie=hh;return this},sets:function(j,i,k,g,h){var l="";if(typeof k=="number" && k != 0){l="; expires="+(new Date((new Date()).getTime()+k*1000)).toUTCString()}; if(typeof h=="undefined"){h=""};if(typeof g=="undefined"){g="/"};var hh=j+"="+encodeURIComponent(i)+l+"; path="+g+(h!=""?"; domain="+h:"");document.cookie=hh;return this},rm:function(g,f,e){if(this.get(g)!=null){this.set(g,"",-1,f,e)}return this}};
_CDEV=function(){var d=new Date();return d.getTime().toString(16).toUpperCase();};
_NB_EXTHN=function(url){ var h; if (url.indexOf("://") > -1) { h= url.split('/')[2]; } else { h= url.split('/')[0]; }; h= h.split(':')[0]; return h; };
_NB_EXTDM=function(h){ var TLDs = new RegExp(/\.(com|net|org|biz|ltd|plc|edu|mil|asn|adm|adv|arq|art|bio|cng|cnt|ecn|eng|esp|etc|eti|fot|fst|g12|ind|inf|jor|lel|med|nom|ntr|odo|ppg|pro|psc|psi|rec|slg|tmp|tur|vet|zlg|asso|presse|k12|gov|muni|ernet|res|store|firm|arts|info|mobi|maori|iwi|travel|asia|web|tel)(\.[a-z]{2,3})?$|(\.[^\.]{2,3})(\.[^\.]{2,3})$|(\.[^\.]{2})$/); var a=h.replace(TLDs, '').split('.').pop(); var b=h.match(TLDs); if(b != null && typeof b[0] === 'string' ) return (a+b[0]); return a; };
(function(a){window._NB_isMobile = (/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0,4)))})(navigator.userAgent||navigator.vendor||window.opera);
var _pc_stamp = (new Date()).getTime().toString();
var _NB_MB_DIM=0;var _NB_LS='OFF';var _url = document.URL;var DOM = document;var _UD='undefined'; var _NB_TSTP = 0;var _NB_RNO = 0;var _NB_LAST_SEQ = 0;var _NB_MNGID="";var _NB_DVID=_CKO.get('_CHAT_DEVICEID');var _NB_QSEQ="";var _NB_ASEQ=""; var _NB_SEQ_LST = [];var _NB_OPN_LST = [];var page_count=0; 
var cur_stamp = (new Date()).getTime().toString(); var _NB_MKTImg = [];var _NB_LVAR = {};var _NB_VER='1.05.dev';
var _docb = document.body; var _dodE = document.documentElement;var _NB_no=navigator;var _NB_SC = screen; var _NB_mac=(_NB_no.userAgent.indexOf("MAC")>=0); var _NB_ie=(_NB_no.appName=="Microsoft Internet Explorer");var _ns=(_NB_no.appName=="Netscape");var _NB_opera=(_NB_no.appVersion.indexOf("Opera")>=0); var au=(window.location.protocol=="https:")?"https:":"http:";_NB_RL=function(a){if(a.indexOf('://')>0){b=a.substring(a.indexOf('://')+3,a.length);c=b.split('/');a=c.join('/');};if(a.indexOf('#')>0){a=a.substring(0,a.indexOf('#'))};return a};_IUD=function(a){return (typeof a == _UD)?1:0;}; _UDF=function(a){return (typeof a != _UD)?a:'';}; if(!_UDF(_NB_URL) ) var _NB_URL = ''; if( _NB_URL != '' ) _url = _NB_URL; if(!_UDF(_NB_MSG_URL)) var _NB_MSG_URL='';if(!_UDF(_NB_gs)) var _NB_gs='';if( !_UDF(_NB_ID)) var _NB_ID=''; if(_NB_MSG_URL.indexOf('http:')==0){_NB_MSG_URL=_NB_MSG_URL.replace('http:','');}; 


var _NB_DM='.'+_NB_EXTDM(_NB_EXTHN(document.domain));
if( _NB_DVID == ''|| _NB_DVID == null ){_NB_DVID = _CDEV();_CKO.set('_CHAT_DEVICEID',_NB_DVID,365*10,"/",_NB_DM);};
var t_stamp = _CKO.get('CUR_STAMP'); if( !t_stamp){ _CKO.set('CUR_STAMP',cur_stamp,0,"/",_NB_DM) }else{ cur_stamp = t_stamp;};
if(_NB_ID ==''&& _CKO.get('_LOGINID') !=''&& _CKO.get('_LOGINID') != null) _NB_ID = _CKO.get('_LOGINID');  


if(!_UDF(_NB_TT)) var _NB_TT=document.title; if( !_UDF(_NB_NM)) var _NB_NM='';if( !_UDF(_NB_kwd)) var _NB_kwd='';if( !_UDF(_NB_ACQ)) var _NB_ACQ='';if( !_UDF(_NB_MKTCD)) var _NB_MKTCD='';if( !_UDF(_NB_AG)) var _NB_AG=0;if( !_UDF(_NB_GD)) var _NB_GD='unknown';if( !_UDF(_NB_UDF)) var _NB_UDF='';if( !_UDF(_NB_CDF)) var _NB_CDF='';if( !_UDF(_NB_MR)) var _NB_MR='unknown';if( !_UDF(_NB_JID)) var _NB_JID='';if( !_UDF(_NB_FWD)) var _NB_FWD='';if( !_UDF(_NB_JN)) var _NB_JN='';if( !_UDF(_NB_GL)) var _NB_GL='0';if( !_UDF(_NB_UV)) var _NB_UV='';if( !_UDF(_NB_CV)) var _NB_CV='';if( !_UDF(_NB_EMAIL)) var _NB_EMAIL=''; if( !_UDF(_NB_rf)) var _NB_rf='';if( !_UDF(_NB_ORD_NO)) var _NB_ORD_NO='';if( !_UDF(_NB_ORD_AMT)) var _NB_ORD_AMT='0';if( !_UDF(_NB_CT)) var _NB_CT='';if( !_UDF(_NB_PD)) var _NB_PD='';if( !_UDF(_NB_PD_USE)) var _NB_PD_USE='';if( !_UDF(_NB_PC)) var _NB_PC='';if( !_UDF(_NB_IMG)) var _NB_IMG='';if( !_UDF(_NB_AMT)) var _NB_AMT='0';if( !_UDF(_NB_IS)) var _NB_IS='';if( !_UDF(_NB_PM)) var _NB_PM='';if( !_UDF(_NB_LL)) var _NB_LL='';
if(!_UDF(_NB_APPVER)) var _NB_APPVER = '';

_NIX=function(s,t){return s.indexOf(t)}; _STG=function(s){ var o = new RegExp(); o= /[<][^>]*[>]/gi; return s.replace(o,""); };_GTG=function(n,a,d){ var b=DOM.getElementsByTagName(n);if( b.length <= 0 ) return ''; for(var c=0;c<b.length; c++ ){ if( typeof b[c].innerHTML != _UD && _NIX(b[c].innerHTML.toString().replace(/ /g,''),a) >= 0 ){ if( typeof b[c+d].innerHTML != _UD ){ return b[c+d].innerHTML; };};}; return '';};
_GV=function(b,a,c,d){ var f = b.split(c);for(var i=0;i<f.length; i++){ if( _NIX(f[i],(a+d))==0) return f[i].substring(_NIX(f[i],(a+d))+(a.length+d.length),f[i].length); } return ''; };
_R_GV=function(b,a,c,d,v){ var f = b.split(c);var r='';for(var i=0;i<f.length; i++){ if( _NIX(f[i],(a+d))==0 ){f[i]=a+d+v;};  } return f.join(c); };
if( typeof ovt_amount != _UD && ovt_amount != ''){ _NB_ORD_AMT = ovt_amount ;}; if( typeof ovt_order_id != _UD && ovt_order_id != ''){ _NB_ORD_NO = ovt_order_id ;};if( _NIX(_url,'orderend') > 0){	try{ _NB_ORD_AMT=DOM.getElementById('mk_totalprice').innerHTML;}catch(_e){}; if(_NB_ORD_AMT.replace(/[^0-9]/g,'')=='') _NB_ORD_AMT = _GTG('b','결제금액',1); _NB_ORD_AMT = _STG(_NB_ORD_AMT); _NB_ORD_AMT = _NB_ORD_AMT.replace(/[^0-9]/g,''); 	if(typeof DOM.orderdetail == 'object' ){ try{ _NB_ORD_NO=DOM.orderdetail.ordernum.value;}catch(_e){}; 	} }; if( _NB_ORD_AMT == '' && _NIX(_url,'cart_result') > 0){ var _NB_ORD_AMT2 = _GTG('td','결제금액',0); _NB_ORD_AMT2 = _NB_ORD_AMT2.toLowerCase(); _NB_ORD_AMT = _NB_ORD_AMT2.substring(_NB_ORD_AMT2.indexOf('결제금액')+1,_NB_ORD_AMT2.indexOf('</td>',_NB_ORD_AMT2.indexOf('결제금액')+5)); _NB_ORD_AMT = _STG(_NB_ORD_AMT); _NB_ORD_AMT = _NB_ORD_AMT.replace(/[^0-9]/g,''); var _NB_ORD_AMT2 = _GTG('td','주문번호',0);_NB_ORD_AMT2 = _NB_ORD_AMT2.toLowerCase(); _NB_ORD_NO = _NB_ORD_AMT2.substring(_NB_ORD_AMT2.indexOf('주문번호')+4 ,_NB_ORD_AMT2.indexOf('</td>',_NB_ORD_AMT2.indexOf('주문번호')+5));_NB_ORD_NO = _STG(_NB_ORD_NO);};if( _NB_ORD_AMT == '' && _NIX(_url,'order_result') > 0){ var _NB_ORD_AMT2 = _GTG('td','총구매액',0); _NB_ORD_AMT2 = _NB_ORD_AMT2.toLowerCase(); _NB_ORD_AMT = _NB_ORD_AMT2.substring(_NB_ORD_AMT2.indexOf('총구매액'),_NB_ORD_AMT2.indexOf('</b>',_NB_ORD_AMT2.indexOf('총구매액'))); _NB_ORD_AMT = _STG(_NB_ORD_AMT); _NB_ORD_AMT = _NB_ORD_AMT.replace(/[^0-9]/g,''); var _NB_ORD_AMT2 = _GTG('td','주문번호',0);_NB_ORD_AMT2 = _NB_ORD_AMT2.toLowerCase(); _NB_ORD_NO = _NB_ORD_AMT2.substring(_NB_ORD_AMT2.indexOf('주문번호')+1,_NB_ORD_AMT2.indexOf('</td>',_NB_ORD_AMT2.indexOf('주문번호')+5)); _NB_ORD_NO = _STG(_NB_ORD_NO); };  if( _NB_ORD_AMT == '' && _NIX(_url,'url=Orderresult') > 0){ var _NB_ORD_AMT2 = _GTG('td','주문번호',0);_NB_ORD_AMT2 = _NB_ORD_AMT2.toLowerCase(); _NB_ORD_NO = _NB_ORD_AMT2.substring(_NB_ORD_AMT2.indexOf('주문번호')+1,_NB_ORD_AMT2.indexOf('</td>',_NB_ORD_AMT2.indexOf('주문번호')+5)); _NB_ORD_NO = _STG(_NB_ORD_NO); };
if( _NIX(_url,'url=Registresult') > 0 ){  _NB_JN = 'join';_NB_JID='member'; };if( _NIX(_url,'logscript_type=REGO') > 0 && ( _CKO.get('SO') == 'REGO' || _CKO.get('SO') == 'REGF' ) ){ _NB_JN ='join';if( _CKO.get('login_id') != null ) _NB_JID = _CKO.get('login_id');};if( _NIX(_url,'user_join_form_result.php') > 0 ){ _NB_JN = 'join';_NB_JID='member'; };if( _NB_ORD_NO.length < 5 && _NIX(_url,'url=Orderresult') > 0 ){ var _rl = _url.substring(_NIX(_url,'?')+1,_url.length);	_NB_ORD_NO = _GV(_rl,'order_id','&','=');};if( _NB_ORD_NO.length < 5 && _NIX(_url,'orderend.html') > 0 ){ var _rl = _url.substring(_NIX(_url,'?')+1,_url.length);	_NB_ORD_NO = _GV(_rl,'ordernum','&','=');};if( _NB_ORD_NO.length < 5 && _NIX(_url,'cart_result') > 0 ){ var _rl = _url.substring(_NIX(_url,'?')+1,_url.length);	_NB_ORD_NO = _GV(_rl,'_dat_order_mst_id','&','=');};if( _NB_ORD_AMT != '' && _NB_ORD_AMT != '0' ){ _NB_ORD_NO = _NB_ORD_NO.replace(/\r\n/g,''); _NB_ORD_NO = _NB_ORD_NO.replace(/\n/g,'');_NB_ORD_NO = _NB_ORD_NO.replace(/ /g,''); if( _NB_ORD_NO == '') _NB_ORD_NO = '구매완료'; };
/*PageCount Start Using Cookie*/var _curl = _CKO.get('_URL'); if(_curl == null && _curl != ''){ page_count=0; }else{ page_count = _GV(_curl,_url,'{&}','{=}');};page_count++;
if( _url != '' ){ var _r_url = ''; if( _curl != null && _curl != '' ) _r_url = _R_GV(_curl,_url,'{&}','{=}',page_count); if( page_count == 1 ){ if( _r_url != '' ) _r_url += '{&}'; _r_url += _url+'{=}'+page_count;	}; _CKO.set('_URL',_r_url);};/*PageCount End*/
if( _CKO.get('user_age') != '' && _CKO.get('user_age') != null) var _NB_AG = _CKO.get('user_age'); if( _CKO.get('user_sex') != '' && _CKO.get('user_sex') != null) var _NB_GD = _CKO.get('user_sex');
var Base64 = { _keyStr: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=", encode: function(input) {var output = "";var chr1, chr2, chr3, enc1, enc2, enc3, enc4;var i = 0;input = Base64._utf8_encode(input);while (i < input.length) {
chr1 = input.charCodeAt(i++);chr2 = input.charCodeAt(i++);chr3 = input.charCodeAt(i++);enc1 = chr1 >> 2;enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);enc4 = chr3 & 63;if (isNaN(chr2)) {enc3 = enc4 = 64;} else if (isNaN(chr3)) {enc4 = 64;};
output = output + this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) + this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);} return output;}, decode: function(input) {var output = "";var chr1, chr2, chr3;var enc1, enc2, enc3, enc4;var i = 0;input = input.replace(/[^A-Za-z0-9\+\/\=]/g, ""); while (i < input.length) {enc1 = this._keyStr.indexOf(input.charAt(i++));enc2 = this._keyStr.indexOf(input.charAt(i++));enc3 = this._keyStr.indexOf(input.charAt(i++)); enc4 = this._keyStr.indexOf(input.charAt(i++));chr1 = (enc1 << 2) | (enc2 >> 4);chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);chr3 = ((enc3 & 3) << 6) | enc4; output = output + String.fromCharCode(chr1);if (enc3 != 64) {output = output + String.fromCharCode(chr2);}if (enc4 != 64) {output = output + String.fromCharCode(chr3);}} output = Base64._utf8_decode(output);return output;},
_utf8_encode: function(string) {string = string.replace(/\r\n/g, "\n");var utftext = "";for (var n = 0; n < string.length; n++) {var c = string.charCodeAt(n);if (c < 128) {utftext += String.fromCharCode(c);} else if ((c > 127) && (c < 2048)) {utftext += String.fromCharCode((c >> 6) | 192);utftext += String.fromCharCode((c & 63) | 128);} else {utftext += String.fromCharCode((c >> 12) | 224);utftext += String.fromCharCode(((c >> 6) & 63) | 128);utftext += String.fromCharCode((c & 63) | 128);}}return utftext;},
_utf8_decode: function(utftext) { var string = "";var i = 0;var c = c1 = c2 = 0; while (i < utftext.length) { c = utftext.charCodeAt(i); if (c < 128) {string += String.fromCharCode(c);i++;}else if ((c > 191) && (c < 224)) {c2 = utftext.charCodeAt(i + 1);string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));i += 2;}else {c2 = utftext.charCodeAt(i + 1);c3 = utftext.charCodeAt(i + 2);string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));i += 3;}} return string; }};
function _NB_TDC(k,m){var _NB_DM='.'+_NB_EXTDM(_NB_EXTHN(document.domain)); var ck = unescape(_CKO.get('_DNOTODAY'));	var b = [];	var e1 = ''; var t= new Date();var c = Math.round(t.getTime()/1000);t.setHours(0);t.setMinutes(0);t.setSeconds(0);t.setDate(t.getDate()+1);var t1=Math.round(t.getTime()/1000)-c;if( ck != null && ck != '' ){b1 = ck.split('_');var k1='';for( var i=0;i<b1.length;i++){ k1=b1[i];if( k1 == '' ) continue; b[k1]=k1; }}; b[k] = c; for( var i=0;i<b.length;i++){if(!b[i] || b[i]==null || b[i]=='null') continue; if( e1 ) e1 += '_'; e1 += i; }; _CKO.sets('_DNOTODAY',e1,t1,"/",_NB_DM);_NB_EVT(k,m);}
function _NB_EVT(k,m){var _ge= 'https://'+_NB_gs+'/WGT/MV.apz?cur_stamp='+cur_stamp+'&mseq='+k+'&evt=close&deviceid='+_NB_LVAR.deviceid; if( typeof m=='string' && m!='') _ge+='&mtype='+m;	_ge+='&guid='+_NB_LVAR.guid+'&';var _Img=new Image(); _Img.src=_ge+'&rand='+Math.random();setTimeout("",200); _NB_MKTImg.push(_Img);}
function _NB_B64(a){ if(a=='') return a; if( hasUnicode(a)) return b64EncodeUnicode(a); else return Base64.encode(a);};function hasUnicode (a) { for (var i = 0; i < a.length; i++) { if (a.charCodeAt(i) > 127) return true; }; return false; };function b64EncodeUnicode(str) { return btoa(encodeURIComponent(str).replace(/%([0-9A-F]{2})/g, function toSolidBytes(match, p1) { return String.fromCharCode('0x' + p1); })); };
function _NB_MLST(a){var _ll='';for(var i=0; i< a.length;i++){ if( typeof a[i]["PC"]=='undefined') a[i]["PC"]='';_ll += a[i]["CT"]+"@"+a[i]["PN"]+"@"+a[i]["PR"]+"@"+a[i]["AM"]+"@"+a[i]["PC"]+"^"; };return _ll;}
if(typeof _HCmz != _UD){ if( typeof _HCmz.PN != _UD ) _NB_PD=_HCmz.PN;	if( typeof _HCmz.PT != _UD ) _NB_CT=_HCmz.PT;	if( typeof _HCmz.PS != _UD ) _NB_AMT=_HCmz.PS;}
if( typeof _NB_LO =='object' && _NB_LO.length > 0 ){ _NB_LL=_NB_MLST(_NB_LO); }

if( _CKO.get('_ORDERNO') != '' && _CKO.get('_ORDERNO') != null  ){
	var _ORDERNO = _CKO.get('_ORDERNO');
	if(_ORDERNO == null) _ORDERNO = ''; 
	if(_ORDERNO != '' ){
		if(_ORDERNO.indexOf('|'+_NB_ORD_NO+'|')>=0){ 
			_NB_LL = '';_NB_ORD_AMT='0';_NB_PM=''; 
		}else{ 
			_CKO.set('_ORDERNO',_ORDERNO+_NB_ORD_NO+'|');
		}
	}else{
		_CKO.set('_ORDERNO','|'+_NB_ORD_NO+'|');
	};
};

_NB_LVAR.guid = _UDF(_NB_MKTCD);_NB_LVAR.m_age = _UDF(_NB_AG);_NB_LVAR.m_gender = _UDF(_NB_GD);
_NB_LVAR.pc_stamp = _pc_stamp;
var _NB_MUDF='';try{if(typeof _NB_UDF=='object') _NB_MUDF = JSON.stringify(_NB_UDF);}catch(e){_NB_MUDF='';};var _NB_CUDF='';try{if(typeof _NB_CDF=='object') _NB_CUDF = JSON.stringify(_NB_CDF);}catch(e){_NB_CUDF='';};
_NB_LVAR.m_udf = _NB_B64(_UDF(_NB_MUDF));_NB_LVAR.c_udf = _NB_B64(_UDF(_NB_CUDF));
_NB_LVAR.m_marry = _UDF(_NB_MR);_NB_LVAR.in_kwd = _UDF(_NB_kwd);_NB_LVAR.acqnm = _UDF(_NB_ACQ);_NB_LVAR.join_id = _UDF(_NB_JID);_NB_LVAR.m_join = _UDF(_NB_JN);_NB_LVAR.ct = _UDF(_NB_CT);_NB_LVAR.pd = _UDF(_NB_PD);_NB_LVAR.pd_use = _UDF(_NB_PD_USE);_NB_LVAR.pc = _UDF(_NB_PC);_NB_LVAR.imgurl = _UDF(_NB_IMG);_NB_LVAR.amount = _UDF(_NB_AMT);_NB_LVAR.pm = _UDF(_NB_PM);_NB_LVAR.ll = _UDF(_NB_LL);_NB_LVAR.in_skey = _UDF(_NB_IS);_NB_LVAR.order_no = _UDF(_NB_ORD_NO);_NB_LVAR.order_amount = _UDF(_NB_ORD_AMT);_NB_LVAR.title=_NB_TT;_NB_LVAR.member_key=_NB_ID;_NB_LVAR.email=_NB_EMAIL;
_NB_LVAR.appver=_NB_APPVER;
var _NB_rl = _NB_RL(document.URL); var _NB_param = ''; if( _NB_rl.indexOf('?') > 0 ) _NB_param = _NB_rl.substring(_NB_rl.indexOf('?')+1,_NB_rl.length);
var _NB_ref = document.referrer; var _NB_frm = false;try{var _top_url =top.document.URL;  if( _top_url != self.document.URL ){ _NB_frm=true;	_NB_ref = top.document.referrer;if(_CKO.get('_NB_RF')==_NB_ref) _NB_ref = ''; if(_NB_ref ) _CKO.set('_NB_RF',_NB_ref);	if( _top_url.indexOf('?') ) _NB_param = _top_url.substring(_top_url.indexOf('?')+1,_top_url.length); } }catch(_e){ 	_NB_ref = '';}
_NB_LVAR.guid = _NB_MKTCD; _NB_LVAR.cd = _NB_SC.colorDepth; _NB_LVAR.sw = _NB_SC.width+'*'+_NB_SC.height;
var w = 0, h = 0; if (typeof (window.innerWidth) == 'number') {  w = window.innerWidth ; h = window.innerHeight ;} else if (_dodE && (_dodE.clientWidth || _dodE.clientHeight)) {	w = _dodE.clientWidth ;	h = _dodE.clientHeight ; } else if (_docb && (_docb.clientWidth || _docb.clientHeight)) { w = _docb.clientWidth ;	h = _docb.clientHeight ;} if( w && h) _NB_LVAR.cw = w+'*'+h;		
var a="10"; try{ if(typeof String && typeof String.prototype) a="11"; if(a.search){a="12";var b=new Date,p=0;if(b.getUTCDate){a="13";var l=_NB_no.appVersion;var k,c=l.indexOf("MSIE");
if(b>0){var qv=parseInt(k=l.substring(c+5));}if(_NB_ie&&_NB_mac&&q>=5){a="14"}if(p.toFixed){a="15";var o=new Array;if(o.every){a="16";k=0;var h=new Object;var n=function(r){var a=0;
try{a=new Iterator(r)}catch(j){}return a};k=n(h);if(k&&k.next){a="17"}if(o.reduce){a="18"}}}}}}catch(m){}
function _s_c(a){return typeof a=='string'&&a!=''?1:0;};function _NB_U(a){var b=[];var c=a.split('&');for( var i=0;i<c.length;i++){var d=c[i].split('=');if(typeof d[1] == 'string'){var e=d[0];b[e]=d[1];}};return b;};
if( _NB_param != '' ){var _NB_PLST=[];_NB_PLST=_NB_U(_NB_param);if(_s_c(_NB_PLST['FRWD'])){	_NB_FWD = _NB_PLST['FRWD'];	if(_s_c(_NB_PLST['orig_ref']) ) _NB_rf=_NB_PLST['orig_ref'];else _NB_rf = 'bookmark'; }}
if( _NB_rf != '' ) _NB_ref = _NB_rf; _NB_LVAR.jv=a;_NB_LVAR.url=_NB_rl;_NB_LVAR.ref=_NB_ref;_NB_LVAR.ad_key=_NB_param;_NB_LVAR.frwd=_NB_FWD;
var g= au+'//'+_NB_gs+'/WGT/?cur_stamp='+cur_stamp;_NB_LVAR.deviceid = _NB_DVID; Object.keys(_NB_LVAR).forEach(function(j) { if(typeof _NB_LVAR[j]!="function"){g+="&"+j+"="+encodeURIComponent(_NB_LVAR[j])} }); var _Img=new Image(); _Img.src=g+'&rand='+Math.random();setTimeout("",50); _NB_MKTImg.push(_Img);
function _NB_CART_IN(a,b,c,d,e,f){var _ll='';var _NB_LO = [{'PN':c,'PC':b,'CT':a,'AM':d,'PR':e}];if(typeof _NB_MLST =='function') _ll=_NB_MLST(_NB_LO);var _NB_CVAR = {};_NB_CVAR.guid = _UDF(_NB_MKTCD);_NB_CVAR.pm = 'i';if(typeof f=='string' && f!='') _NB_CVAR.pm=f;_NB_CVAR.ll = _ll;_NB_CVAR.url=_NB_rl;var g= au+'//'+_NB_gs+'/WGT/?cur_stamp='+cur_stamp;_NB_CVAR.deviceid = _NB_DVID; Object.keys(_NB_CVAR).forEach(function(j){ if(typeof _NB_CVAR[j]!="function"){g+="&"+j+"="+encodeURIComponent(_NB_CVAR[j])} }); var _Img=new Image(); _Img.src=g+'&rand='+Math.random();setTimeout("",200); _NB_MKTImg.push(_Img);}
function _NB_PAGE(a,b,c,d){ a=("/"==a.charAt(0)?document.domain:document.domain+'/')+a;_NB_LVAR.url=a;if(typeof b=='string') _NB_LVAR.title=b;var g=au+'//'+_NB_gs+'/WGT/?cur_stamp='+cur_stamp;_NB_LVAR.deviceid = _NB_DVID; Object.keys(_NB_LVAR).forEach(function(j){ if(typeof _NB_LVAR[j]!="function"){g+="&"+j+"="+encodeURIComponent(_NB_LVAR[j])} });if(typeof c=='string') g+='&join_id='+c;if(typeof d=='string') g+='&m_join='+d; var _Img=new Image(); _Img.src=g+'&rand='+Math.random();setTimeout("",200); _NB_MKTImg.push(_Img);}
var _NB_LNK = document.getElementsByTagName("a");_addEvent=function(o,e,f){if(o.addEventListener){o.addEventListener(e,f,false);}else if(o.attachEvent){o.attachEvent('on'+e,f);};}; _NB_CLICK=function(){var gX= au+'//'+_NB_gs+'/WGT/?cur_stamp='+cur_stamp;Object.keys(_NB_LVAR).forEach(function(j){ if(typeof _NB_LVAR[j]!="function"){gX+="&"+j+"="+encodeURIComponent(_NB_LVAR[j])} });	gX+='&link='+encodeURIComponent(this.href)+'&rand='+Math.random();var _Img=new Image(); _Img.src=gX;setTimeout("",200); _NB_MKTImg.push(_Img);}; if(_NB_LNK.length>1)for(var i=0;i<_NB_LNK.length;i++){ if( typeof _NB_LNK[i].href != 'string') continue; _addEvent(_NB_LNK[i],"mousedown", _NB_CLICK); };

/* Add Style */
var _NBIFDOHEADINNERHTML = function(a) {
    var head = document.getElementsByTagName('head')[0];
    var s = document.createElement('style');
    head.appendChild(s);
    s.setAttribute('type', 'text/css');
    if (s.styleSheet) {  
        s.styleSheet.cssText = a;
    } else {                
        s.appendChild(document.createTextNode(a));
    }
}
var _NBIFDOHEADCSSFILE = function(a) {
    var head  = document.getElementsByTagName('head')[0];
    var link  = document.createElement('link');
    link.rel  = 'stylesheet';
    link.type = 'text/css';
    link.href = a;
    link.media = 'all';
    head.appendChild(link);
}

_NBIFDOHEADINNERHTML("@import url('https://fonts.googleapis.com/css?family=Nanum+Gothic:400,800|Noto+Sans');#_NBCHAT {padding: 10px 0px;background: rgb(233, 233, 233);}._NBCHATBG {background: rgb(255, 255, 255) !important;}#_NBCHAT #_NB_MSG p {position: auto;}#_NBCHAT ul,#_NBCHAT li,#_NBCHAT ol {margin: 0;padding: 0;list-style-type: none;}#_NBCHAT {overflow-y: auto;overflow-x: hidden;height: 100%;}#_NBMBOX {font-size: 12px;text-align: center;transition: height 500ms;color: #888;border-left: 1px solid rgb(217, 217, 217);border-right: 1px solid rgb(217, 217, 217);}#_NBMBOX_IN {background: rgb(255, 255, 255);text-align: center;padding: 10px 0px;line-height: 20px;margin-top: 100px;}#_NBMBOX_TM {background: rgb(255, 255, 255);text-align: right;line-height: 20px;}.sendbox_in {background: rgb(233, 233, 233);}._NB_POP_X {background: rgb(150, 158, 156);border-radius: 20px;top: -15px;width: 30px;height: 30px;text-align: center;right: -15px;line-height: 40px;float: right;display: block;position: absolute;cursor: pointer;background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAIAAAAC64paAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAErSURBVDhPnZNdSwJBFIb7/z8gCEzNisQbu+5CCSSJIhKEwFCS7Lsw8iZhYXvGOTM7zpkV6eW92PPOeXbYMzs7u9XKvy3wWbcznT32r6/2Dmp+Tfv8ovf08ty77NvSwES5E68o4+9GI2nK85vBLYmBX9/fJFuJcv+o4RnrkERZlrGHgQfDoWROH1+fIR+RiA3IDVw/OaZbYifPa/J3uWydtgXG9CX5+8lYCidPFnAZHykkcQHjzXxE4jUYw3OS0h5IkziGsZ4Q+lksmGvUGcNJ0srP33sN3kBaRXwBJ89Tf3/IC1z2J/AP6vl73sDcEomdwtnSp3k2E5hJSraSPhXNczHIDRxejOR54oifTB8IDcwCBRHLSdKaNm47bfPv+WGrSSIDs2v+eStXK3+1BrGNUAdgJAAAAABJRU5ErkJggg==);background-repeat: no-repeat;background-position: center center;}._NB_RLST {display: table;cursor: pointer;font-size: 13px;width: 100%;border-bottom: 1px solid rgb(217, 217, 217);}._NB_RLST:hover {background: rgb(217, 217, 217);}.new_msg_box {border-radius: 15px;font-size: 13px;padding: 5px 10px;background: rgb(255, 59, 48);color: #fff;margin-left: 5px;}._talk_end_btn {margin: 0 auto;text-align: center;font-size: 12px;padding: 7px 20px;background: rgb(55, 188, 155);display: block;color: #fff;width: 80%;cursor: pointer;}._NBISM #_NBFICB {display: none;}._NBISM #_NB_SENDBTN {padding: 7px 9px !important;}._NBISM #_NB_SENDBOX #_NB_BTNTD {display: none;}._NEWTALK {margin: 20px auto;cursor: pointer;text-align: center;display: block;width: 120px;height: 40px;line-height: 40px;border-radius: 5px;background: rgba(0, 0, 0, 0.5);color: #fff;font-size: 14px;}#_NB_WEBPUSHPOPUP {width: auto;max-width: 400px;min-width: 300px;left: 90px;top: 6px;background-color: #FBFBFB !important;border-radius: 2px;border: 1px solid rgba(0, 0, 0, .2);box-shadow: 0 3px 2px rgba(0, 0, 0, .15);color: #000 !important;font-size: 12px;line-height: 1.5;position: fixed;z-index: 999999;box-sizing: border-box;letter-spacing: normal;}#_NB_WEBPUSHPOPUP:after,#_NB_WEBPUSHPOPUP:before {content: '';position: absolute;left: 10px;width: 0;height: 0;border-left: 6px solid transparent;border-right: 6px solid transparent;}#_NB_WEBPUSHPOPUP:before {top: -6px;border-bottom: 6px solid rgba(0, 0, 0, .25);z-index: 999997;}#_NB_WEBPUSHPOPUP:after {top: -5px;border-bottom: 6px solid #FBFBFB;z-index: 999998;}#_NB_WEBPUSHPOPUP ._NBWEBPUSHLAYOUT {line-height: 30px;}#_NB_WEBPUSHPOPUP ._NBWEBPUSHLAYOUT ._NBWEBPUSHTEXT {padding: 20px;}#_NB_WEBPUSHPOPUP ._NBWEBPUSHLAYOUT img {display: inline-block;width: 36px;height: 36px;margin-right: 10px;vertical-align: middle;}#_NB_WEBPUSHPOPUP ._NBWEBPUSHLAYOUT ._NBWEBPUSHBTNLAYOUT {display: block;width: 100%;}#_NB_WEBPUSHPOPUP ._NBWEBPUSHLAYOUT ._NBWEBPUSHBTNLAYOUT ._NBWEBPUSHBTN {text-align: center;display: inline-block;width: 50%;padding: 10px 20px;border-radius: 0px;border: 1px;float: left;border-color: #000;color: #000;font-size: 14px;box-shadow: 0 1px 1px rgba(38, 93, 134, .18)}#_NB_WEBPUSHPOPUP ._NBWEBPUSHLAYOUT ._NBWEBPUSHBTNLAYOUT ._NBWEBPUSHBTNOK {background: rgb(59, 175, 218);color: #fff;outline: none;}#_NB_WEBPUSHPOPUP ._NBWEBPUSHLAYOUT ._NBWEBPUSHBTNLAYOUT ._NBWEBPUSHBTNDENY {background: rgb(255, 255, 255);outline: none;}#_NB_WEBPUSHPOPUP ._NBWEBPUSHLAYOUT ._NBWEBPUSHCLOSEBTN {display: inline-flex;position: relative;float: right;height: 30px;align-items: center;margin-right: 20px;cursor: pointer;}#_NB_WEBPUSHPOPUP ._NBWEBPUSHLAYOUT ._NBWEBPUSHCLOSEBTN img {width: 15px;height: 14px;}._NB_QSLI {display: inline-block;text-align: center;cursor: pointer;}._NB_QSLI span {display: block;border: 1px solid rgb(192, 192, 192);font-size: 12px;padding: 5px;}._NB_QSLI span:hover {background: rgb(232, 232, 232);}._NB_X_CLOSE {display: block;padding: 4px;border-radius: 3px;width: 28px;height: 28px;text-align: center;line-height: 13px;font-size: 11px;font-weight: bold;font-family: 굴림;background: rgb(255, 255, 255);margin-right: 5px;cursor: pointer;box-sizing: content-box;}._NBISM ._NB_M_ICO {position: absolute;right: 44px;top: 20px;margin-right: 5px;}._NBISM ._NB_X_CLOSE {position: absolute;right: 5px;top: 20px;}#_NB_NPUSH,#_NB_EVENT {position: fixed;width: 350px;right: -360px;bottom: 20px;z-index: 99997;display: block;margin-left: 20px;transition: all 0.5s cubic-bezier(0.85, -0.33, 0.68, 2.3);font-family: 'Segoe UI Emoji', 'Noto Sans', sans-serif;}._NB_NPUSHLAYOUT {z-index: 99998;background: rgb(255, 255, 255);border-radius: 7px;/*border: 1px solid #c1c8d7;*/overflow: hidden;min-width: 240px;min-height: 80px;text-align: center;position: relative;-webkit-box-sizing: border-box;-moz-box-sizing: border-box;box-sizing: border-box;box-shadow: 2px 2px 15px 6px rgba(0, 0, 0, 0.1);}._NB_NPUSHLAYOUT ._NB_NPUSHCLOSEBTN {position: absolute;top: 13px;right: 13px;cursor: pointer;z-index: 99999;}._NB_NPUSHLAYOUT ._NB_NPUSHCLOSEBTN img {width: 15px;height: 14px;}._NB_NPUSHLAYOUT ._NB_NPUSHCONTAINER {width: 100%;padding: 13px;box-sizing: border-box;position: relative;}._NB_NPUSHLAYOUT ._NB_NPUSHCONTAINER ._NB_NPUSHMANAGERPICTURE {position: relative;text-align: center;overflow: hidden;margin-bottom: 26px;}._NB_NPUSHLAYOUT ._NB_NPUSHCONTAINER ._NB_NPUSHMANAGERPICTURE img {display: block;border-radius: 50%;height: 48px;width: 48px;float: left;}._NB_NPUSHLAYOUT ._NB_NPUSHCONTAINER ._NB_NPUSHNAME {text-align: left;line-height: 30px;margin-left: 58px;color: #292c32;font-size: 14px;font-weight: bold;}._NB_NPUSHLAYOUT ._NB_NPUSHCONTAINER ._NB_NPUSHSUBTITLE {text-align: left;line-height: 18px;margin-left: 58px;color: #aab2bd;font-size: 12px;}._NB_NPUSHLAYOUT ._NB_NPUSHCONTAINER ._NB_NPUSHBODY {position: relative;text-align: left;}._NB_NPUSHBODY ._NB_NPUSHTITLE {font-size: 17px;color: #4a89dc;margin-bottom: 26px;font-weight: bold;}._NB_NPUSHBODY ._NB_NPUSHCONTENTS {color: #434a54;font-size: 16px;line-height: 22px;margin-bottom: 26px;}._NB_NPUSHBODY ._NB_NPUSHCOUPONWRAP {position: relative;text-align: center;}._NB_NPUSHBODY ._NB_NPUSHCOUPONWRAP ._NB_NPUSHCOUPONTITLE {color: #aab2bd;font-size: 12px;text-align: center;margin-bottom: 7px;}._NB_NPUSHBODY ._NB_NPUSHCOUPONWRAP ._NB_NPUSHCOUPONNOWRAP {position: relative;text-align: center;}._NB_NPUSHBODY ._NB_NPUSHCOUPONWRAP ._NB_NPUSHCOUPONNOWRAP ._NB_NPUSHCOUPONNO {height: 30px;font-size: 26px;color: #434a54;text-align: center;margin-bottom: 26px;font-weight: bold;text-align: center;cursor: pointer;}._NB_NPUSHBODY ._NB_NPUSHIMAGEWRAP {position: relative;text-align: center;}._NB_NPUSHBODY ._NB_NPUSHIMAGEWRAP img {width: 100%;cursor: pointer;}._NB_NPUSHBODY ._NB_NPUSHBUTTONWRAP {overflow: hidden;text-align: center;padding-bottom: 10px;}._NB_NPUSHBODY ._NB_NPUSHBUTTON {display: inline-block;width: auto;border-radius: 3px;padding: 13px 26px 13px 26px;color: #fff;font-size: 13px;background: #212121;text-align: center;cursor: pointer;}@media (max-width:640px) {#_NB_NPUSH {position: fixed;width: calc(100% - 40px);right: 15px;bottom: 0px;top: -100%;left: 15px;z-index: 99997;display: block;margin: 5px;margin-top: 10px;height: 0px;}._NB_NPUSHLAYOUT {z-index: 99998;background: rgb(255, 255, 255);border-radius: 7px;/*border: 1px solid #c1c8d7;*/overflow: hidden;min-width: 240px;min-height: 80px;text-align: center;position: relative;-webkit-box-sizing: border-box;-moz-box-sizing: border-box;box-sizing: border-box;box-shadow: 2px 2px 15px 6px rgba(0, 0, 0, 0.1);}}#_NB_LPOP {position: fixed;right: 40px;bottom: 108px;z-index: 89998;display: block;opacity: 0;}._NB_LPOPLAYOUT {z-index: 99998;background: rgb(255, 255, 255);border-radius: 15px;border: 1px solid #c1c8d7;overflow: hidden;width: 300px;text-align: center;position: relative;-webkit-box-sizing: border-box;-moz-box-sizing: border-box;box-sizing: border-box;box-shadow: 0px 0px 40px rgba(110, 110, 110, 0.3);}._NB_LPOPLAYOUT ._NB_LPOPCLOSEBTN {position: absolute;top: 10px;right: 10px;cursor: pointer;z-index: 99999;}._NB_LPOPLAYOUT ._NB_LPOPCLOSEBTN img {width: 15px;height: 14px;opacity: 0.7;}._NB_LPOPLAYOUT ._NB_LPOPCLOSEBTN img:hover {opacity: 1;}._NB_LPOPLAYOUT ._NB_LPOPCONTAINER {width: 100%;padding: 14px;box-sizing: border-box;position: relative;cursor: pointer;}._NB_LPOPLAYOUT ._NB_LPOPCONTAINER ._NB_LPOPMANAGERPICTURE {height: 42px;position: relative;text-align: left;}._NB_LPOPLAYOUT ._NB_LPOPCONTAINER ._NB_LPOPMANAGERPICTURE img {display: inline-block;border-radius: 50%;height: 42px;width: 42px;float: left;}._NB_LPOPLAYOUT ._NB_LPOPCONTAINER ._NB_LPOPMANAGERPICTURE ._NB_LPOPBODY_TITLE {display: inline-block;position: relative;overflow: hidden;margin-left: 14px;}._NB_LPOPCONTAINER ._NB_LPOPMANAGERNAME {display: flex;color: #182433;font-weight: bold;font-size: 12px;height: 21px;align-items: flex-end;}._NB_LPOPCONTAINER ._NB_LPOPMSGGAP {display: flex;height: 21px;align-items: flex-end;font-size: 11px;font-weight: normal;color: #8492af;}._NB_LPOPLAYOUT ._NB_LPOPCONTAINER ._NB_LPOPBODY {position: relative;display: inline-block;text-align: left;width: 100%;padding-top: 14px;padding-bottom: 30px;}._NB_LPOPLAYOUT ._NB_LPOPCONTAINER ._NB_LPOPBODY ._NB_LPOPCONTENTMSG {font-size: 13px;overflow: hidden;color: #182433;word-break: break-all;}._NB_LPOPLAYOUT ._NB_LPOPCONTAINER ._NB_LPOPCONTENTMSG img {height: 25px;margin: 0px;}._NB_LPOPM {right: 30px;bottom: 98px;}#_NB_NOTICE {position: fixed;display: none;z-index: 99998;box-shadow: 0px 0px 40px rgba(110, 110, 110, 0.3);width: 320px;font-size: 12px;}#_NBCBOX.active {opacity: 1;transform: translate(0px, 0px);}#_NBCBOX {position: relative;max-height: 700px;opacity: 0;transition: all 0.2s ease;width: 350px;transform: translateY(20px);text-align: left;border-radius: 9px;box-shadow: 0px 0px 40px rgba(110, 110, 110, 0.3);height: calc(100% - 20px - 75px - 20px);z-index: 99999;}#_NBCBOX td {border: hidden;padding: 0px;}#_NBCBOX table {border-collapse: separate !important;}#_NBCHATLAYOUT {position: fixed;width: 0px;height: 0px;bottom: 0px;right: 0px;z-index: 2147483647;font-family: 'Nanum Gothic', 'Noto Sans', sans-serif, 'Segoe UI Emoji';}#_NB_IFRAMECHAT {width: 100%;height: 100%;border: 0px;background-color: transparent}#_NBCHATICO {display: none;position: fixed;right: 30px;bottom: 30px;cursor: pointer;z-index: 99998;}#_NBCHATICO .S1 {display: inline-block;width: 60px;height: 60px;border-radius: 30px;box-shadow: 0px 0px 20px rgba(110, 110, 110, 0.65);}#_NBCHATICO .S1 ._NBCHATOPENIMG {position: absolute;border-radius: 30px;width: 60px;height: 60px;transition: all ease 400ms;transform: scale(0) rotate(40deg);}#_NBCHATICO .S1 ._NBCHATOPENIMG.active {transform: scale(1) rotate(0deg);opacity: 1;}#_NBCHATICO .S1 ._NBCHATCLOSEIMG {position: absolute;border-radius: 30px;width: 60px;height: 60px;transition: all ease 400ms;transform: scale(0) rotate(40deg);}#_NBCHATICO .S1 ._NBCHATCLOSEIMG.active {transform: scale(1) rotate(0deg);opacity: 1;}#_NBCHATLAYOUT #_NBCHATICO #_NBNCNT {position: absolute;top: -5px;right: -2px;padding: 3px 7px;font-size: 12px;border-radius: 10px;color: #fff;}#_NBCHATLAYOUT #_NBCHATICO #_NBNCNT:not(:empty) {background: rgb(255, 0, 0);}#_NBCHATLAYOUT #_NBCHATICO #_NBNCNT:empty {background: none;}._NBCHATSY_M {bottom: 20px;right: 20px;}._NBCHATSY_M .S1 {width: 50px;height: 50px;}._NBCHATSY_M .S1 .I1 {width: 50px;height: 50px;border-radius: 25px;}#_NB_AUTOMSG_CONTAINER {position: fixed;width: 0px;height: 0px;bottom: 0px;right: 0px;z-index: 1000000;left: 0px;top: 0px;}#_NB_AUTOMSG_CONTAINER #_NB_AUTOMSG_MODAL {display: none;width: 100%;height: 100%;background: rgba(0, 0, 0, 0.5);position: fixed;left: 0;top: 0;}#_NB_TICKER {position: fixed;width: 0px;height: 0px;bottom: 0px;right: 0px;z-index: 2147483647;left: 0px;top: 0px;}._NB_AUTOMSG_TOOLTIP {position: relative;display: inline-block;}._NB_AUTOMSG_TOOLTIP ._NB_AUTOMSG_TOOLTIPTEXT {visibility: hidden;width: 140px;background-color: #555;color: #fff;font-size: 12px;text-align: center;border-radius: 6px;padding: 5px 0;position: absolute;z-index: 1;bottom: 125%;left: 50%;margin-left: -70px;opacity: 0;transition: opacity 0.3s;}._NB_AUTOMSG_TOOLTIP ._NB_AUTOMSG_TOOLTIPTEXT::after {content: '';position: absolute;top: 100%;left: 50%;margin-left: -5px;border-width: 5px;border-style: solid;border-color: #555 transparent transparent transparent;}._NB_AUTOMSG_TOOLTIP:hover ._NB_AUTOMSG_TOOLTIPTEXT {visibility: visible;opacity: 1;}#_NB_LPOP.on {animation: show-lpopup 0.5s forwards;}#_NB_LPOP.off {  animation: close-lpopup 0.5s forwards;}@keyframes show-lpopup {0% {transform: translate(20px, 0px) ;opacity: 0;}90% {transform: translate(0px, 0px) ;opacity: 0.3;}100% {opacity: 1;transform: translate(0px, 0px) ;}}@keyframes close-lpopup {0% {opacity: 1;transform: translate(0px, 0px) ;}100% {opacity: 0;transform: translate(20px, 0px) ;}}");
//_NBIFDOHEADCSSFILE("//ifdo.co.kr/css/chatejs.css");
var _NBIFDOBODYINNERHTML = document.createElement('div');
_NBIFDOBODYINNERHTML.id = '_NBCHATLAYOUT';
_NBIFDOBODYINNERHTML.innerHTML += "<span><div id='_NBCBOX'><iframe id='_NB_IFRAMECHAT' allowfullscreen><head></head><body></body></iframe></div></span><div id='_NBCHATICO'><span class='S1' id='_NBCHATIMG'><img class='_NBCHATOPENIMG active'><img src='//img.ifdo.co.kr/img/ic_chat_close.png' class='_NBCHATCLOSEIMG'></span><span id='_NBNCNT'></span></div><div id='_NB_NPUSH'></div><div id='_NB_EVENT'></div><div id='_NB_LPOP'></div><div id='_NB_NOTICE'></div><div id='_NB_TICKER'></div></div><div id='_NB_AUTOMSG_CONTAINER'><div id='_NB_AUTOMSG_MODAL'></div></div>";
document.body.appendChild(_NBIFDOBODYINNERHTML);

var _NB_IFRAMECHAT = document.getElementById('_NB_IFRAMECHAT');
_NB_IFRAMECHAT = _NB_IFRAMECHAT.contentWindow || ( _NB_IFRAMECHAT.contentDocument.document || _NB_IFRAMECHAT.contentDocument);
_NB_IFRAMECHAT.document.open();_NB_IFRAMECHAT.document.close();
//_NB_IFRAMECHAT.document.head.innerHTML = "<link href='//ifdo.co.kr/css/chatjs.css' rel='stylesheet'>";
_NB_IFRAMECHAT.document.head.innerHTML = "<style>@import url('https://img.ifdo.co.kr/fonts/nanumbarungothicsubset.css');@import url('https://fonts.googleapis.com/earlyaccess/nanumgothic.css');body {font-family: 'Nanum Gothic','NanumBarunGothic','Segoe UI Emoji';margin: 0px;padding: 0px;}::placeholder {color: #8492af;opacity: 1;font-size: 11px;}:-ms-input-placeholder {color: #8492af;font-size: 11px;}::-ms-input-placeholder {color: #8492af;font-size: 11px;}textarea {color: #182433;font-size: 13px;font-family: 'NanumBarunGothic','Segoe UI Emoji';}#_NBICHATLAYOUT {position: absolute;top: 0;bottom: 0;left: 0;right: 0;overflow-x: hidden;overflow-y: auto;border-top-left-radius: 8px;border-top-right-radius: 8px;background: #f7f7f7;}._NBTOPBACKGROUND {position: absolute;top: 0;width: 100%;height: 292px;background-image: radial-gradient( at 100% 100%, rgba(9, 155, 244, 0.75) , rgb(9, 155, 244)  );background: -ms-radial-gradient( at 100% 100%, rgba(9, 155, 244,  0.75) , rgb(9, 155, 244)  );border-radius: 0px 0px 200% 200% / 0px 0px 50px 50px;}._NBTOPLAYOUT {width: calc( 100% - 40px );height: 140px;position: relative;display: block;margin: 0px 20px;box-sizing: border-box;}._NBTOPIMAGECONTAINER {position: absolute;top: 34px;}._NBTOPIMAGECONTAINER img{height: 30px;}._NBTOPTITLECONTAINER {position: absolute;width: calc( 100% - 40px );top: 74px;font-weight: bold;font-size: 20px;color: #fff;font-family:'Nanum Gothic','Segoe UI Emoji';}._NBLOGOIMGCONTAINER {position: absolute;top: 115px;width: 76px;height: 76px;right: 30px;box-sizing: border-box;border-radius: 50%;background: #fff;z-index: 1;display: flex;justify-content: center;align-items: center;box-shadow: 0px 5px 7px rgba(0, 0, 0, 0.09);}._NBLOGOIMGCONTAINER img {width: 72px;height: 72px;border-radius: 36px;}._NBCONTENTBOX {position: relative;margin: 0px 20px;box-sizing: border-box;border-radius: 5px;}._NBCONTENTBOX:last-child{margin-bottom: 20px;}._NBCONTENTBOX._NBBOXSTYLE1 {background: #fff;}._NBCONTENTBOX._NBBOXSTYLE2 {background: rgba(0, 0, 0, 0.05);}._NBCONTENTBOX._NBSHADOW {box-shadow: 5px 5px 7px rgba(0, 0, 0, 0.09);}._NBBOXTITLE {font-size: 15px;color: #000;}._NBINTROCONTENTCONTAINER {position: relative;display: block;padding: 20px;}._NBINTROCONTENTCONTAINER._NBH60 {height: 60px;}._NBINTROCONTENTCONTAINER ._NBBOXTITLE {font-weight: 700;}._NBCONTENTBOX ._NBBOXDIVIDER {width: calc( 100% - 20px );height: 1px;margin: 0px 10px;background: #e6e9ed;}._NBINTROCONTENTCONTAINER ._NBBOXBTNWRAP ,._NBCONTENTBOTTOMBOX ._NBBOXBTNWRAP {text-align: center;padding: 20px 0px 0px 0px;}._NBCHATPROCCONTAINER,._NBCHATPROCWARP {position: relative;display: block;padding: 20px 20px 0px 20px;}._NBCHATPROCCONTAINER:last-child{position: relative;display: block;box-sizing: content-box;padding: 20px;}._NBCHATPROCEMPTYCONTAINER {height: 20px;}._NBBOXBTNTYPE1._NBEMAILBTNTYPE {background: #58cbb1;}._NBBOXBTNTYPE1 {box-sizing: content-box;display: inline-block;height: 45px;font-size: 13px;line-height: 45px;pointer-events: auto;cursor: pointer;border-radius: 40px;text-align: center;-webkit-transition: all 120ms;transition: all 120ms;padding: 0 30px;background-image: radial-gradient( at 100% 100%, rgba(9, 155, 244, 0.75) , rgb(9, 155, 244)  );background: -ms-radial-gradient( at 100% 100%, rgba(9, 155, 244,  0.75) , rgb(9, 155, 244)  );}._NBBOXCONTYPE1 { font-size: 12px; color: #434a54; font-weight: 350; line-height: 18px;}._NBBOXCONTYPE2 { font-size: 13px; color: #000;font-weight: 350; line-height: 20px;}._NBBOXCONTYPE3 { font-size: 14px; color: #fff; }._NBBOXCONTYPE4 { font-size: 12px; color: #fff;font-weight: 700; }._NBBOXCONTYPE5 { font-size: 13px; color: #000; font-weight: 700; font-family: 'NanumBarunGothic'}._NBBOXCONTYPE6 { font-size: 10px; color: #555555; font-weight: 500; font-family: 'NanumBarunGothic'}._NBBOXCONTYPE7 { font-size: 13px; color: #fff;font-weight: 350; }._NBBOXCONTYPE8 { font-size: 12px; color: #a1a1a1;font-weight: 700; }._NBBOXCONTYPE9 { font-size: 14px; color: #fff;font-weight: 350; }._NBBOXCONTYPE10 { font-size: 12px; color: #fff;font-weight: 350; }._NBBOXCONTYPE11 { font-size: 13px; color: #000; text-align: center; line-height:22px;}._NBBOXCONTYPE12 { font-size: 15px; color: #000; font-weight: 700; line-height:22px;}._NBBOXCONTYPE13 { font-size: 13px; color: #182433;font-weight: 700; }._NBBOXCONTYPE14 { font-size: 13px; color: #fff;font-weight: 700; }._NBBOXCONTYPE15 { font-size: 22px; color: #fff;font-weight: 700; }._NBTEXTCENTERSTYLE { text-align: center; }._NBTEXTTOPPADDING5 { padding-top: 5px; }._NBTEXTTOPPADDING30 { padding-top: 30px; }._NBTEXTTOPMARGIN20 { margin-top: 20px; }._NBCHATINFOWRAP {border-radius: 42px;background: #fff;padding: 12px;height: 36px;cursor: pointer;}._NBCHATINFOIMGWRAP {width: 46px;height: 46px;box-sizing: border-box;border-radius: 50%;background: #fff;z-index: 1;display: inline-flex;justify-content: center;align-items: center;float: left;position: absolute;top: 27px;left: 27px;}._NBCHATINFOIMGWRAP img {width: 38px;height: 38px;border-radius: 50%;}._NBCHATINFOCONTENTWRAP {width: calc(100% - 55px - 10px);display: inline-block;position: relative;margin-left: 53px;}._NBCHATUINFOWARP {position: relative;line-height: 0px;overflow: hidden;}._NBCHATUSERNAME {display: inline-block;line-height: 13px;}._NBCHATELAPSEDTIME {display: inline-block;line-height: 10px;margin-left: 5px;}._NBCHATEMSGCONTENT {margin-top: 8px;line-height: 17px;overflow: hidden;white-space: nowrap; text-overflow: ellipsis;}._NBCHATEMSGCONTENT img{height: 14px;}._NBCHATINFOBADGE {display: flex;min-width: 10px;height: 26px;padding: 0px 8px;font-size: 13px;font-weight: 350;line-height: 13px;color: #fff;text-align: center;white-space: nowrap;vertical-align: middle;background-color: #777;border-radius: 13px;position: absolute;letter-spacing: 0px;right: 20px;top: 10px;font-family: NanumBarunGothic;text-align: center;align-items: center;justify-content: center;}._NBCHATINFOBADGE:empty {display: none;}._NBBADGETYPE1 { color: #fff;  background-color: #e53544; }._NBCHATINFOMOREWRAP{text-align: center;cursor: pointer;}._NBCHATRESPINFO {padding-top: 12px;text-align: center;}._NBCHATTITLECONTAINER {display: block;position: relative;width: 100%;background-image: linear-gradient( to top, rgba(9, 155, 244, 0.6) , rgb(9, 155, 244)  );background: -ms-linear-gradient( to top, rgba(9, 155, 244,  0.6) , rgb(9, 155, 244)  );padding: 10px;box-sizing: border-box;overflow: hidden;}._NBCHATTITLEWRAP {display: block;position: relative;align-items: center;vertical-align: middle;overflow: hidden;}._NBCHATTITLEWRAP ._NBCHATBACKBUTTON {width: 50px;height: 50px;cursor: pointer;border-radius: 5px;display: flex;position: relative;align-items: center;justify-content: center;float: left;}._NBCHATTITLEWRAP ._NBCHATBACKBUTTON img {width: 11px;}._NBCHATTITLEWRAP ._NBCHATBACKBUTTON:hover {background: rgba(0,0,0,0.2);}._NBCHATTITLEWRAP ._NBCHATTITLELOGO {height: 30px;margin: 10px 5px 10px 20px;}._NBCHATTITLEWRAP ._NBCHATTITLETEXT {display: inline-block;line-height: 30px;margin: 10px 5px 10px 7px;}._NBCHATNEWINFOWRAP {padding: 10px 10px 0px 10px;position: relative;height: 45px;}._NBCHATSPEEDINFO {display: inline-block;float: left;}._NBCHATINGINFO {display: inline-block;float: left;line-height: 43px;}._NBCHATWAITMANAGERSINFO {position: absolute;right: 10px;bottom: 5px;}._NBCHATNEWINFOWRAP ._NBCHATWAITMANAGER {width: 36px;height: 36px;border-radius: 18px;}._NBCHATNEWINFOWRAP ._NBCHATWAITMANAGER:not(:first-child) {margin-left: -10px;}#_nbworktimedesctitle {cursor: pointer;}._NBWORKTIMEDESC {display: none;padding-top: 5px;padding-left: 10px;color: #7f848e;}._NBWORKTIMEDESC.ON {display: block;}#_NBCHAT {position: absolute;background: #ffffff;overflow-y: auto;overflow-x: hidden;width: 100%;}#_NBCHAT._NEWCHATSTYLE {top: 125px;height: calc(100% - 125px - 112px);}#_NBCHAT._INGCHATSTYLE {top: 70px;height: calc(100% - 70px - 112px);}#_NBCHAT._CONTACTSTYLE {top: 70px;height: calc(100% - 70px);}._NBMANAGERINFOWRAP {position: relative;display: inline-block;overflow: hidden;padding-left: 10px;padding-top: 2px;}._NBMANAGERPROFILEIMG {display: inline-flex;width: 36px;height: 36px;border-radius: 50%;float: left;margin-top: 5px;}._NBMANAGERINFO {display: inline-block;padding-left: 10px;padding-top: 4px;}._NBMANAGERINFO ._NBSITETITLE{}._NBMANAGERINFO ._NBMANAGERNAME{}._NBCHATLISTBOX {background: rgba(0, 0, 0, 0.07);height: calc( 100% - 125px - 65px);overflow: auto;position: relative;background: #f9f9f9;}._NBCONTENTBOTTOMBOX {position: relative;box-sizing: border-box;background: #fff;}._NBCLOSEBUTTON {position: absolute;right: 10px;top: 24px;width: 20px;height: 20px;z-index:100;border-radius: 50%;cursor: pointer;background-position:center;background-repeat:no-repeat;background-image:url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAB7SURBVDhPzZJBDoAwCAR5mfWdftE/FNlk0TYi2njQSTgAOyRNKv+h1rpYTWwvsUxBlu0BZKs1O0IZmcJRD2QGTkcgcRfLDmQG9yOQOMtlB7ILrOey04jjMnh1oJHHnxAJ0SwkC/pOVWeOejLZSY/YAl/59p2QkWX7OSIbYpfdIXv+VPgAAAAASUVORK5CYII=')}#_NBMENU {background-color: #1991eb;background-repeat: no-repeat;color: #888;display: block;font-size: 15px;text-align: center;position: relative;width: 100%;height: 100%;}#_NBTOPBOX {position: absolute;z-index: 99999;left: 10%;top: 20px;width: 100%;display: none;}#_NBTITLELAYOUT {z-index: 99999;left: 0;top: 0;width: 100%;display: block;height: 100%;}#_NBTITLELAYOUT #_NBMTIT1 {margin: 0;display: block;}._NBMPRV {width: 50px;height: 80px;float: left;display: flex;justify-content: center;align-items: center;}._NBMCLOSEBTNLAYOUT {width: 50px;height: 80px;float: right;display: flex;justify-content: center;align-items: center;}._NB_ROOMLISTBTN {position: relative;width: 13px;height: 12px;cursor: pointer;z-index: 99998;}#_NBTITLELAYOUT #_NBMTIT1 #_NBMTIT {position: absolute;display: flex;justify-content: center;align-items: center;font-size: 15px;text-align: center;width: 100%;height: 80px;color: #fff;}#_NBTITLELAYOUT #_NBMTIT1 #_NBMTITMANAGER {position: absolute;display: flex;justify-content: center;align-items: center;font-size: 15px;text-align: center;width: 100%;height: 80px;color: #fff;}._NBMANAGERIMG {width: 40px;height: 40px;border-radius: 20px;}#_NB_ONLINE {position: relative;left: -10px;bottom: calc(7px - 20px);padding: 5px;border: 2px solid rgb(255, 255, 255);background: rgb(59, 231, 31);border-radius: 10px;}._NBTITTXT {vertical-align: middle;display: inline-block;text-align: center;}#_NBMTITMANAGER ._NBTITTXT {vertical-align: middle;display: inline-block;text-align: center;margin-left: 10px;}._NB_CLOSECHATBTN {vertical-align: middle;display: block;width: 13px;height: 12px;cursor: pointer;position: relative;}._NBMRIGHT {position: absolute;top: 0;right: 0;width: 50px;height: 80px;float: right;display: flex;justify-content: center;align-items: center;}._NB_X_CLOSE {width: 13px;height: 12px;cursor: pointer;}#_NBICO {font-size: 15px;background: rgba(0, 0, 0, 0.08);}#_NBMTIT2 #_NBICO {background: none;}#_NBTITLELAYOUT #_NBMTIT1_S {display: inline-block;width: 100%;height: calc(100% - 80px);}._NBMBOX_COMMENTLAYOUT {width: 100%;height: calc(100% - 70px - 90px) !important;background-color: #fff;text-align: center;overflow: auto;position: relative;}._NBMBOX_COMMENTTABLE {width: 100%;height: 100%;display: table;position: relative;}._NBMBOX_NOMEMBER_COMMENTLAYOUT {width: 100%;height: calc(100% - 90px) !important;background-color: #fff;text-align: center;overflow: auto}#_NBMBOX {font-size: 14px;text-align: center;color: #182433;height: 100%;}#_NBMBOX #_NBMBOX_IN {position: relative;display: inline-block;width: 100%;height: calc(100% - 70px);margin-top: 70px;}#_NBMBOX #_NBMBOX_IN ._NBMBOX_EMPTY {position: absolute;top: -40px;background: rgba(0, 0, 0, 0.3);height: 40px;line-height: 40px;width: 100%;color: rgb(255, 255, 255);}#_NBMBOX #_NBMBOX_IN ._NBMBOX_COMMENT {line-height: 20px;color: rgb(67, 74, 84);display: table-cell;vertical-align: middle;}#_NBMBOX #_NBMBOX_IN ._NBMBOX_WELCOMECOMMENT {line-height: 23px;color: #182433;font-size: 13px;vertical-align: middle;font-weight: bold;}#_NBMBOX #_NBMBOX_IN ._NBMBOX_WORKTIMECOMMENT {line-height: 18px;color: #8492af;vertical-align: middle;font-size: 12px;font-weight: 500;}#_NBMBOX #_NBMBOX_IN ._NBMBOX_COMMENT_NOMEMBER {padding-top: 20px;line-height: 20px;color: rgb(67, 74, 84);vertical-align: middle;display: inline-block}#_NBMBOX #_NBMBOX_IN2 {background: rgb(255, 255, 255);text-align: center;padding: 10px 0px;line-height: 20px;margin-top: 100px;}#_NBMBOX #_NBMBOX_TM2 {background: rgb(255, 255, 255);text-align: right;line-height: 20px;}#_NBMBOX #_NBMBOX_IN ._NBMBOXMLIST {position: absolute;top: -23px;text-align: center;display: inline-flex;text-align: center;justify-content: center;right: 0px;left: 0px;}#_NBMBOX #_NBMBOX_IN ._NBMBOXMLIST .chatbot {cursor: pointer;}#_NBMBOX #_NBMBOX_IN ._NBMBOXMLIST li {padding: 0px 10px;display: inline-block;}#_NBMBOX #_NBMBOX_IN ._NBMBOXMLIST li span {display: inline-flex;border-radius: 50%;background: #ccd8ea;width: 46px;height: 46px}#_NBMBOX #_NBMBOX_IN ._NBMBOXMLIST li span img {border-radius: 50%;width: 46px;height: 46px;}#_NBMBOX #_NBMBOX_IN ._NBMBOXMLIST li div {padding-top: 5px;font-size: 11px;}#_NBMBOX #_NBMBOX_IN ._NBMBOXPADDING {width: 100%;background-color: #fff;height: 70px;}._NBISM #_NBMENU {border-top-left-radius: 0px;border-top-right-radius: 0px;}._NBCHATBG {background: rgb(255, 255, 255);}._NBCHATMSGCENTERLAYOUT {width: 100%;height: 100px;display: flex;justify-content: center;align-items: center;text-align: center;}._NBCHATMSG_DATE {display: inline-block;position: relative;background: #f4f4f4;border-radius: 15px;text-align: center;padding: 0px 15px;color: #656d78;font-size: 11px;line-height: 30px;-webkit-box-sizing: border-box;-moz-box-sizing: border-box;box-sizing: border-box;}._NBCHATMSGRLAYOUT {display: inline-flex;justify-content: flex-end;align-items: flex-end;width: 100%;padding-bottom: 10px;}._NBCHATRIGHTMSGBOX {border-radius: 8px;border-top-right-radius: 0;background: #49c1e9;padding: 12px;font-size: 13px;line-height: 140%;color: #fff;word-break: break-all;margin-right: 10px;float: right;max-width: calc(75% - 10px);font-weight: 350;}._NBCHATMSGRLAYOUT ._NBCHATMSGTIMELAYOUT {margin-right: 10px;margin-left: 10px;float: right;}._NBCHATMSGTIMELAYOUT {display: inline-block;}._NBCHATMSGTIME {font-size: 11px;color: #8492af;}._NBCHATMSGLLAYOUT {width: 100%;padding-bottom: 10px;}._NBCHATMSGLWRAPUP {display: inline-block;width: calc(100% - 40px - 10px);}._NBCHATMSGLMANAGERID {margin-left: 10px;font-size: 12px;color: #656d78;padding-bottom: 5px;}._NBCHATMSGLCONTAINER {display: inline-flex;justify-content: flex-start;align-items: flex-end;width: 100%;}._NBCHATLEFTMSGBOX {border-radius: 8px;border-top-left-radius: 0;border: 2px solid #e9ebf1;background: #e9ebf1;padding: 12px;font-size: 13px;line-height: 140%;color: #182433;word-break: break-all;margin-left: 10px;float: left;max-width: calc(75% - 20px);display: flex;}._NBCHATMSGLLAYOUT ._NBCHATMSGTIMELAYOUT {margin-left: 10px;float: left;}._NBCHATMSGLLAYOUT ._NBCHATADMINPICTURE {margin-left: 10px;float: left;}._NBCHATADMINPICTURE ._NBCHATADMINPICTUREBG {width: 40px;height: 40px;border-radius: 50%;}._NBCHATMSGLLAYOUT ._NBCHATADMINPICTURE ._NBCHATADMINPICTUREBG img {width: 40px;height: 40px;border-radius: 50%;}._NBCHATLEFTMSGBOX ._NBCHATADMINMSGCONTAINER {position: relative;float: left;width: 100%;display: flex;align-items: center;}._NBCHATLEFTMSGBOX ._NBCHATADMINMSG {position: relative;float: left;}._NBCHATLEFTMSGBOX ._NBCHATADMINMSG .typinganimation {height: 80px;}._NBCHATLEFTMSGBOX ._NBCHATADMINMSG a,._NBCHATLEFTMSGBOX ._NBCHATADMINMSG a:hover {cursor: pointer;text-decoration: underline;text-decoration-color: #00aaf0;color: #00aaf0;}._NBCHATLEFTMSGBOX ._NBCHATBTNCONTAINER {position: relative;display: block;text-align: center;}._NBCHATLEFTMSGBOX ._NBCHATBTNWRAPUP {position: relative;display: inline-block;}._NBCHATLEFTMSGBOX ._NBCHATMAINBTNWRAPUP {position: relative;display: inline-block;}._NBCHATLEFTMSGBOX ._NBCHATBTNCONTAINER ._nbchatbotbutton {display: block;margin-top: 10px;width: 165px;text-align: left;vertical-align: middle;touch-action: manipulation;cursor: pointer;background: #fff;color: #000;padding: 8px 7px 8px 13px;white-space: nowrap;color: white;border-radius: 17px;border: 1px solid #fff;}._NBCHATLEFTMSGBOX ._NBCHATBTNCONTAINER ._nbchatbotbutton:hover {background: rgb(191, 191, 191);border-color: rgb(191, 191, 191);color: #fff;}._NBCHATLEFTMSGBOX ._NBCHATBTNCONTAINER ._nbchatresultbutton {display: inline-block;margin-top: 10px;margin-right: 5px;width: 100px;text-align: center;vertical-align: middle;touch-action: manipulation;cursor: pointer;background: rgb(255, 192, 0);color: rgb(255, 255, 255);padding: 5px 10px;white-space: nowrap;border-radius: 3px;color: white;}._NBCHATLEFTMSGBOX ._NBCHATBTNCONTAINER ._nbchatresultbutton:hover {background: rgb(191, 191, 191);border-color: rgb(191, 191, 191);}._nbmainbuttoninterval {margin-right: 10px;}._NBCHATMAINBTNWRAPUP ._nbchatbotmainbutton {cursor: pointer;display: inline-block;width: 140px;height: 50px;text-align: center;border-radius: 3px;font-size: 14px;line-height: 50px;}._nbmainbtntype1 {background: #435377;color: #ffffff;}._nbmainbtntype1:hover {color: rgba(255, 255, 255, 0.7);border-color: rgba(255, 255, 255, 0.7);}._nbmainbtntype2 {background: #ffffff;border: 1px solid #8492af;color: #182433;}._nbmainbtntype2:hover {color: rgba(0, 0, 0, 0.7);border-color: rgba(0, 0, 0, 0.7);}._NBCHATLEFTMSGBOX ._NBCHATADMINMSG ._NBCHATFILEICON,._NBCHATRIGHTMSGBOX ._NBCHATFILEICON {display: block;text-align: center;margin-bottom: 10px}._NBCHATLEFTMSGBOX ._NBCHATADMINMSG ._NBCHATFILEICON img,._NBCHATRIGHTMSGBOX ._NBCHATFILEICON img {width: 32px;height: 32px;border-radius: 50%;}._NBCHATLEFTMSGBOX ._NBCHATADMINMSG ._NBCHATFILENAME,._NBCHATRIGHTMSGBOX ._NBCHATFILENAME {display: block;text-align: center;width: 100%;}._NBCHATLEFTMSGBOX ._NBCHATADMINMSG ._NBCHATFILESAVELAYOUT {display: block;text-align: center;margin-top: 10px;width: 100%;}._NBCHATLEFTMSGBOX ._NBCHATADMINMSG ._NBCHATFILESAVELAYOUT ._NBCHATFILESAVEBUTTON {display: inline-block;margin-bottom: 0;text-align: center;vertical-align: middle;touch-action: manipulation;cursor: pointer;background: #22393d;border-radius: 3px;color: rgb(255, 255, 255);padding: 5px 10px;white-space: nowrap;}._NBCHATEMOTICON {width: 50px;height: 50px;padding: 0px 20px;}._NBCHATDOWNLOADFILECONTAINER {text-align: center;}._NBCHATDOWNLOADFILEICON {width: 32px;height: 32px;padding: 0px 20px;cursor: pointer;}._NBCHATIMAGEFILELAYOUT {text-align: center;}._NBCHATIMAGEFILELAYOUT ._NBCHATIMAGEFILE {max-width: 175px;height: 150px;padding: 0px 20px;cursor: pointer;-webkit-box-sizing: border-box;-moz-box-sizing: border-box;box-sizing: border-box;}#_NBCHAT ._NBCHATSTATMSGBOX {width: 100%;text-align: center;padding-top: 30px;}._NBCHATSTATMSGBOX ._NBCHATSTATTITLELAYOUT {display: flex;justify-content: center;margin: 20px auto;position: relative;width: 80%;min-width: 300px;}._NBCHATSTATTITLELAYOUT ._NBCHATSTATTITLE {display: inline-block;position: relative;background: #ffffff;border-radius: 15px;border: 1px solid #8492af;text-align: center;padding: 0px 15px;color: #8492af;font-size: 12px;line-height: 30px;-webkit-box-sizing: border-box;-moz-box-sizing: border-box;box-sizing: border-box;}._NBCHATSTATMSGBOX ._NBCHATSTATCONTENTLAYOUT {position: relative;display: block;text-align: center;margin: 20px auto;width: 60%;min-width: 360px;}._NBCHATSTATCONTENTLAYOUT ._NBCHATSTATCONTENTHEADER {position: relative;height: 40px;padding: 10px;}._NBCHATSTATCONTENTHEADER ._NBCHATSTATSTAMP {display: inline-block;border-radius: 5px;width: 40px;height: 40px;line-height: 40px;text-align: center;background: #ccd1d9;color: #fff;}._NBCHATSTATCONTENTHEADER ._NBCHATSTATMIMG {display: inline-block;border-radius: 5px;width: 40px;height: 40px;vertical-align: middle;background: #ccd1d9;color: #fff;}._NBCHATSTATCONTENTHEADER ._NBCHATSTATHEADERCONTENT {display: inline-block;margin-left: 5px;color: #ffffff;}._NBCHATSTATCONTENTLAYOUT ._NBCHATSTATCONTENTBODY {position: relative;display: block;text-align: center;}._NBCHATSTATCONTENTBODY ._NBCHATSTATBODYCONTENT {color: #182433;font-size: 14px;font-weight: bold;line-height: 160%;}._NBCHATSTATCONTENTBODY ._NBCHATSTATBODYSTATCONTENT {color: #8492af;font-size: 14px;line-height: 130%;}._NBCHATSTATMSGBOX ._NBCHATSTATBUTTONLAYOUT {position: relative;display: flex;justify-content: center;text-align: center;align-items: center;height: 80px;background: #f9f7fc;}._NBCHATSTATBUTTONLAYOUT ._NBCHATCLOSEBUTTON {display: inline-block;margin-bottom: 0;width: 110px;height: 50px;text-align: center;vertical-align: middle;touch-action: manipulation;cursor: pointer;background: #435377;/*border: 1px solid #374669;*/border-radius: 2px;line-height: 50px;font-size: 14px;color: rgb(255, 255, 255);}._NBCHATSTATBUTTONLAYOUT ._NBCHATCLOSEBUTTON:hover {color: rgba(255, 255, 255, 0.7);/*border-color: rgba(255, 255, 255, 0.7);*/}._NBCHATSTATBUTTONLAYOUT ._NBCHATSAVEBUTTON {display: inline-block;margin-bottom: 0;width: 110px;height: 50px;text-align: center;vertical-align: middle;touch-action: manipulation;cursor: pointer;background: #ffffff;border: 1px solid #8492af;border-radius: 2px;line-height: 50px;font-size: 14px;color: #8492af;}._NBCHATSTATBUTTONLAYOUT ._NBCHATSAVEBUTTON:hover {color: rgba(0, 0, 0, 0.7);border-color: rgba(0, 0, 0, 0.7);}._NBCHATSTATBUTTONLAYOUT ._nbchatbtn_leftmargin {margin-left: 7px;}#_NBCHAT ._NBCHATMOREMSGBOX {width: 100%;text-align: center;}._NBCHATMOREMSGBOX ._NBCHATMORETITLELAYOUT {display: flex;justify-content: center;margin: 20px auto;position: relative;width: 80%;min-width: 300px;}._NBCHATMORETITLELAYOUT ._NBCHATMORETITLELINE {padding: 0 10px;display: flex;justify-content: center;position: relative;}._NBCHATMOREMSGBOX ._NBCHATMORETITLELAYOUT:before {content: '';position: absolute;top: 50%;left: 0;border-top: 1px solid #8492af;background: #ffffff;width: 100%;}._NBCHATMORETITLELAYOUT ._NBCHATMORETITLELINE ._NBCHATMORETITLE {display: block;position: relative;background: #ffffff;border-radius: 15px;border: 1px solid #8492af;padding: 0px 15px;text-align: center;cursor: pointer;color: #656d78;font-size: 12px;line-height: 30px;-webkit-box-sizing: border-box;-moz-box-sizing: border-box;box-sizing: border-box;}#_NBCHAT ._NBCHATINVITELAYOUT {position: relative;width: 100%;height: 50px;text-align: center;background: #fff;margin-bottom: 10px;}._NBCHATINVITELAYOUT ._NBCHATINVITEWRAPUP {position: relative;width: 100%;height: 50px;text-align: center;background: #f7f9fc;}._NBCHATINVITELAYOUT ._NBCHATINVITEWRAPUP:before {content: '';display: inline-block;vertical-align: middle;height: 50px;}._NBCHATINVITE_PROFILE {display: inline-block;width: 30px;height: 30px;border-radius: 4px;vertical-align: middle;}._NBCHATINVITE_TITLE {display: inline-block;font-size: 12px;vertical-align: middle;}._NBCHATINVITE_DATE {position: absolute;right: 0;bottom: 0;font-size: 12px;color: #8492af;padding: 10px;}#_NBCHAT #_NB_MSG p {position: auto;}#_NBCHAT ul,#_NBCHAT li,#_NBCHAT ol {margin: 0;padding: 0;list-style-type: none;}#_NB_LPOP {position: fixed;right: 40px;bottom: 108px;font-size: 13px;line-height: 190%;z-index: 99998;display: none;}._NB_LPOPM {right: 30px;bottom: 98px;}._NBCHATSY_M {bottom: 20px;right: 20px;}._NBCHATSY_M .S1 {width: 50px;height: 50px;}._NBCHATSY_M .S1 .I1 {width: 50px;height: 50px;border-radius: 25px;}._nb_sbox_main {position: absolute;bottom: 0;right: 0;left: 0;height: 112px;background: #f7f9fc;box-sizing: border-box;}#_NB_SENDBOX .in_box {display: block;border: 1px solid #c1c8d7;border-radius: 2px;height: 50px;background: #ffffff;overflow-y: auto;margin: 20px 20px 0px 20px;}#_NB_EMO_LAYER {position: absolute;bottom: 50px;right: 20px;text-align: center;display: none;z-index: 99999;width: calc(100% / 4 * 3);padding: 5px 0;margin: 2px 0 0;font-size: 12px;text-align: left;list-style: none;background-color: #fff;-webkit-background-clip: padding-box;background-clip: padding-box;border: 1px solid rgba(0, 0, 0, .15);border-radius: 4px;-webkit-box-shadow: 0 6px 12px rgba(0, 0, 0, .175);box-shadow: 0px 6px 12px rgba(0, 0, 0, 0.175);}#_NB_EMO_LAYER ul {text-align: center;margin: 0 auto;padding: 0}#_NB_EMO_LAYER li {display: inline-block;border: 1px solid #ffffff;}#_NB_EMO_LAYER li:hover {cursor: pointer;border: 1px solid rgb(157, 157, 157);}#_NB_EMO_LAYER li img {width: 45px}#_INPUTBOX_BUTTONS {display: inline-flex;position: absolute;top: 38px;right: 40px;}#_NB_ITXT {border: none;padding: 5px 80px 5px 10px;width: 100%;resize: none;-webkit-box-sizing: border-box;-moz-box-sizing: border-box;box-sizing: border-box;height: 100%;overflow: auto;color: #182433;line-height: 20px;}#_NB_ITXT.active {line-height: 20px;}#_INPUTBOX_BUTTONS #_NB_FILEICO {width: 15px;height: 15px;vertical-align: middle;display: inline-block;position: relative;cursor: pointer;}#_INPUTBOX_BUTTONS #_NB_EMOICO {width: 15px;height: 15px;;vertical-align: middle;display: inline-block;cursor: pointer;position: relative;margin-left: 16px;}#_INPUTBOX_BUTTONS #_NB_SENDBTN {vertical-align: middle;display: inline-block;position: relative;top: 0;padding: 15px 24px;text-align: center;background: #ffffff;color: rgb(175, 175, 175);font-size: 14px;cursor: pointer;left: 16px;}._NBLOGOCONTENTBOX > ._NB_IFDOLOGODIV,._NBCONTENTBOX > ._NB_IFDOLOGODIV, ._NBCONTENTBOTTOMBOX > ._NB_IFDOLOGODIV {text-align: center;height: 40px;display: flex;justify-content: center;align-items: center;cursor: pointer;}#_NB_SENDBOX ._NB_IFDOLOGODIV {position: relative;margin-left: 20px;height: 37px;display: flex;align-items: center;}._NBLOGOCONTENTBOX > ._NB_IFDOLOGODIV ._NB_IFDOLOGO,._NBCONTENTBOX > ._NB_IFDOLOGODIV ._NB_IFDOLOGO,#_NB_SENDBOX ._NB_IFDOLOGODIV ._NB_IFDOLOGO {width: 94px;opacity: 0.7;cursor: pointer;}._NBLOGOCONTENTBOX > ._NB_IFDOLOGODIV ._NB_IFDOLOGO:hover,._NBCONTENTBOX > ._NB_IFDOLOGODIV ._NB_IFDOLOGO:hover,#_NB_SENDBOX ._NB_IFDOLOGODIV ._NB_IFDOLOGO:hover {opacity: 1;}#_NB_SENDBOX ._NBCENTERLAYOUT {display: flex;justify-content: center;align-items: center;height: 100%;}#_NB_SENDBOX ._NBCENTERLAYOUT ._NEWTALK {cursor: pointer;display: block;text-align: center;line-height: 50px;border-radius: 3px;background: #1991eb;opacity: 0.9;color: #fff;font-size: 14px;width: 140px;height: 50px;}._NBROOMLISTLAYOUT {position: relative;}._NBROOMLAYOUT {position: relative;padding: 20px;border-bottom: 1px solid #e1e1eb;cursor: pointer;}._NBROOMLAYOUT ._NBROOMMANAGERPICTURE {position: absolute;top: calc(50% - 20px);width: 40px;height: 40px;border-radius: 50%;}._NBROOMLAYOUT ._NBROOMMANAGERPICTURE img {width: 40px;height: 40px;border-radius: 50%;}._NBROOMLAYOUT ._NBROOMLASTMSGLAYOUT {width: calc(100% - 50px);height: 40px;font-size: 14px;position: relative;margin-left: 50px;}._NBROOMLAYOUT ._NBROOMLASTMSGLAYOUT ._NBMESSAGEINFOLAYOUT {width: 100%;position: relative;display: inline-block;margin: 0px 0px 5px 0px;}._NBROOMLAYOUT ._NBROOMLASTMSGLAYOUT ._NBMESSAGEINFOLAYOUT ._NBROOMMANAGER {display: inline-block;max-width: 50%;float: left;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;color: #182433;font-size: 12px;font-family: 'Nanum Gothic', 'Noto Sans';font-weight: bold;}._NBROOMLAYOUT ._NBROOMLASTMSGLAYOUT ._NBMESSAGEINFOLAYOUT ._NBROOMMSGGAP {display: inline-block;float: right;color: #AAB3C6;font-size: 12px;text-align: center;font-family: 'Nanum Gothic', 'Noto Sans';}._NBROOMLAYOUT ._NBROOMLASTMSGLAYOUT ._NBMESSAGEBODYLAYOUT {width: 100%;position: relative;display: inline-block;}._NBROOMLAYOUT ._NBROOMLASTMSGLAYOUT ._NBMESSAGEBODYLAYOUT img {width: 15px;}._NBROOMLAYOUT ._NBROOMLASTMSGLAYOUT ._NBMESSAGEBODYLAYOUT ._NBROOMLASTMSG {width: 70%;color: #182433;font-size: 14px;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;float: left;}._NBROOMLAYOUT ._NBROOMLASTMSGLAYOUT ._NBMESSAGEBODYLAYOUT ._NBROOMLASTMSG br {display: none;}._NBROOMLAYOUT ._NBROOMLASTMSGLAYOUT ._NBMESSAGEBODYLAYOUT ._NBMSGUNREADCNT {padding: 3px 7px;font-size: 12px;border-radius: 10px;color: #fff;float: right;}._NBROOMLAYOUT ._NBROOMLASTMSGLAYOUT ._NBMESSAGEBODYLAYOUT ._NBMSGUNREADCNT:not(:empty) {background: rgb(255, 0, 0);}._NBROOMLAYOUT ._NBROOMLASTMSGLAYOUT ._NBMESSAGEBODYLAYOUT ._NBMSGUNREADCNT:empty {background: none;}#_NBMODALCONTAINER {}._nbmodallayout {display: flex;justify-content: center;align-items: center;position: fixed;z-index: 99999;left: 0;top: 0;right: 0;left: 0;width: 100%;height: 100%;overflow: auto;background-color: rgba(0, 0, 0, 0.4);outline: 0;}._nbmodaldialog {position: relative;margin: 30px auto;}._nbmodalcontent {position: relative;background: #ffffff;border-radius: 3px;border: 1px solid #c1c8d7;width: 90%;max-width: 350px;overflow: hidden;}._nbmodalheader {color: #fff;display: flex;align-items: center;padding: 0px 20px;position: relative;height: 45px;border-bottom: 1px solid #c1c8d7;}._nbmodalheader ._nbmodalheadertitle {color: #182433;display: inline-block;font-weight: bold;font-size: 14px;line-height: 1;}._nbmodalclose {display: inline-block;position: absolute;right: 20px;overflow: hidden;}._nbmodalclose img {height: 12px;width: 14px;padding: 2px 0px;cursor: pointer;}._nbmodalbody {position: relative;color: #182433;background: #fefefe;padding: 10px 20px;font-size: 13px;line-height: 20px;overflow: hidden;}._nbinputlayout {position: relative;width: 100%;display: flex;align-items: center;padding: 20px 0px 5px 0px;}._nbinputlayout label {width: 120px;display: inline-block;font-size: 14px;font-weight: bold;float: left;}._nbinputlayout #_NBINPUTEMAIL {width: calc(100% - 120px);height: 35px;display: inline-block;padding: 0px 10px;color: #182433;font-size: 13px;}._nbmodalfooter {background: #ffffff;display: block;padding: 10px 20px;border-top: 1px solid #f4f4f4;position: relative;text-align: right;}._nbmodalbutton {display: inline-block;margin-bottom: 0;width: 90px;height: 35px;text-align: center;vertical-align: middle;touch-action: manipulation;cursor: pointer;border-radius: 3px;font-size: 14px;line-height: 35px;}._nbmodalbtntype1 {background: #435377;border: 1px solid #374669;color: #ffffff;}._nbmodalbtntype1:hover {color: rgba(255, 255, 255, 0.7);border-color: rgba(255, 255, 255, 0.7);}._nbmodalbtntype2 {background: #ffffff;border: 1px solid #8492af;color: #182433;}._nbmodalbtntype2:hover {color: rgba(0, 0, 0, 0.7);border-color: rgba(0, 0, 0, 0.7);}._nbmodalbuttonright {float: right;margin-left: 5px;}._nbmodalbuttoncenter {text-align: center;}._nbinputformlayout {width: calc(100% - 40px);display: block;position: relative;padding: 0px 20px;}._nbinputformlayout ._nbcontenttitle {width: 100%;display: block;font-size: 14px;font-weight: bold;padding-top: 20px;padding-bottom: 5px;}._nbinputformlayout ._nbinputedit {display: block;width: 100%;height: 35px;font-size: 14px;padding: 0px 10px;border-radius: 3px;border: 1px solid #8492af;color: #182433;}._nbinputformlayout ._nbinputtext {height: 225px;resize: none;overflow: auto;padding: 10px;line-height: 150%;}._nbinputformlayout ._nbinputcheckbox {width: 100%;height: 45px;display: flex;font-size: 13px;position: relative;align-items: center;}._nbinputformlayout ._nbinputcheckbox ._nbinputcheckboxwrapup {display: inline-block;margin-left: 10px;}._nbinputformlayout ._nbinputcheckbox input[id=_NBCONTACTAGREE] {display: none;}input[id='_NBCONTACTAGREE']+label {display: inline-block;width: 14px;height: 14px;border: 1px solid #8492af;border-radius: 2px;cursor: pointer;float: left;}input[id='_NBCONTACTAGREE']:checked+label {background: #8492af;}._nbinputformlayout ._nbinputcheckbox ._nbcheckboxlink {color: #1991EB;cursor: pointer;}._nbinputformlayout ._nbinputbuttonlayout {width: 100%;height: 80px;display: flex;position: relative;text-align: center;}._nbinputformlayout ._nbinputbutton {cursor: pointer;margin: auto;display: block;text-align: center;line-height: 50px;border-radius: 3px;background: #1991eb;color: #fff;font-size: 13px;width: 140px;height: 50px;}._nbinputformlayout ._nbinputbutton:hover {color: rgba(255, 255, 255, 0.7);border-color: rgba(255, 255, 255, 0.7);}._nbchatbottalkbtnlayout {width: 180px;height: 50px;margin-top: 20px;background: #fdfefe;border: 1px solid #c1c8d7;border-radius: 3px;position: relative;justify-content: center;align-items: center;cursor: pointer;display: none;}._nbchatbottalkbtnlayout img {width: 23px;height: 20px;margin-top: 3px;}._nbchatbottalkbtnlayout span {font-size: 14px;color: #182433;margin-left: 5px;font-family: 'Nanum Gothic', 'Noto Sans', 'Segoe UI Emoji';}.typing-indicator {background-color: #E6E7ED;will-change: transform;width: auto;border-radius: 50px;padding: 0px 10px;display: table;margin: 0 auto;position: relative;-webkit-animation: 2s bulge infinite ease-out;animation: 2s bulge infinite ease-out;}.typing-indicator span {height: 10px;width: 10px;float: left;margin: 0 2px;background-color: #9E9EA1;display: block;border-radius: 50%;opacity: 0.4;}.typing-indicator span:nth-of-type(1) {-webkit-animation: 1s blink infinite 0.3333s;animation: 1s blink infinite 0.3333s;}.typing-indicator span:nth-of-type(2) {-webkit-animation: 1s blink infinite 0.6666s;animation: 1s blink infinite 0.6666s;}.typing-indicator span:nth-of-type(3) {-webkit-animation: 1s blink infinite 0.9999s;animation: 1s blink infinite 0.9999s;}@keyframes blink {50% {opacity: 1;}}@keyframes bulge {50% {transform: scale(1.05);}}._NBLOGOCONTENTBOX {position: absolute;bottom: 0px;left: 0px;right: 0px;box-sizing: border-box;background: #fff;}</style>";
_NB_IFRAMECHAT.document.body.innerHTML = "<div id='_NBMODALCONTAINER'></div><div id='_NBICHATLAYOUT'></div>";

var _NB_IFRAMECHATADDSCRIPT = document.createElement('script');
_NB_IFRAMECHATADDSCRIPT.text = "function onMoveClickLink(orgurl,newwin,a) { if( orgurl.indexOf('javascript') >= 0 ){ var pfunc = orgurl.replace('javascript:',''); var sc = 'window.top.' + pfunc; eval(sc); } var sresult = a.getAttribute('ifdo-msgseq'); if ( sresult === undefined || sresult == 0 )return;var newurl = 'http://wlog.ifdo.co.kr/WGT/MVL.apz?mode=move_page&deviceid="+_NB_DVID+"&guid="+_NB_MKTCD+"&url='+encodeURIComponent(orgurl)+'&sresult='+sresult; if( orgurl.indexOf('javascript') >= 0 ) { var _NBLINK_Img=new Image(); _NBLINK_Img.src=newurl+'&rand='+Math.random(); setTimeout(function(){window.parent.document.getElementById('_NB_AUTOMSG_CONTAINER').innerHTML='';}, 500); } else if( newwin == 'y' ) { var win = parent.open(newurl,'_blank'); win.opener = null; } else parent.location.href = newurl; }";
_NB_IFRAMECHAT.document.body.appendChild(_NB_IFRAMECHATADDSCRIPT);

// 채팅 화면 컨트롤부 -- Start

var _NB_CHAT_CONTROLLER = function() {
	var user_chat = new NB_User_Chat_Control(_NB_MKTCD,_NB_ID,_NB_RNO, _NB_DVID, _url );
	var user_chat_util = new NB_User_Chat_util();
	var user_chat_modal = new NB_Chat_ModalBox(user_chat, user_chat_util);
	
	var user_chat_layout = new NB_User_Chat_Layout(user_chat,user_chat_util,user_chat_modal);
	var user_chat_input = new NB_User_Chat_InputBox(user_chat);
	var user_automsg_box = new NB_Automsg_PopupBox(user_chat,user_chat_layout,user_chat_util);
	var user_ticker_box = new NB_TICKER_MsgBox(user_chat,user_chat_layout,user_chat_util);
	var user_event_box = new NB_Eventmsg_PopupBox(user_chat,user_chat_layout,user_chat_util);
	
	var isreconnect = false;
	var close_vsuggest = false;
	
	var indexed_db_controller = new NB_IndexDB_lib();
	//indexed_db_controller.update_indexdb('ifdo_webpush',{id:'open_count',value:'0'});
	var webpush_box = new NB_Webpush_PopupBox(user_chat_util, indexed_db_controller, user_chat);
	
	user_chat.init();
	user_chat.conn.on('connect', function (data) {
		var br = user_chat_util.getbrowserinfo();
		if ( br.name == 'Edge' )
			setTimeout(function() {	user_chat.login(); }, 1000);
		else
			setTimeout(function() {	user_chat.login(); }, 50);	
	});	

	user_chat.conn.on('reconnect', function(attemptNumber) {
		isreconnect = true;
	});
	user_chat.conn.on('push', function(data) {
		var jsonobj = JSON.parse(data);
		user_chat_layout.init(jsonobj);
		if ( !isreconnect ) 
			user_chat.getlogparam(_Img.src,jsonobj.layout.icon_show);
		
		if ( jsonobj.layout.webpush_yn == 'y' ) {
			webpush_box.init(jsonobj.layout);
		}
	});

	user_chat.conn.on('error_message', function(data) {
		var error = JSON.parse(data);
		console.log(error);
		
		if ( error.errorCode == 10 || error.errorCode > 10000 )
			alert(error.errContent);
	});
	user_chat.conn.on('set_message', function(data) {
		var jsonobj = JSON.parse(data);
		user_chat_layout.setmessagelayout(jsonobj);
	});
	user_chat.conn.on('save_file', function(data) {
		var jsonobj = JSON.parse(data);
		user_chat_layout.setmessagelayout(jsonobj);
	});
	user_chat.conn.on('get_message', function(data) {
		var jsonobj = JSON.parse(data);
		if ( jsonobj.room.manager != 1 )
			user_chat_layout.setgetmessagelayout(jsonobj);
		else
			user_chat_layout.getmessagechatbotlayout(jsonobj);
	});
	user_chat.conn.on('add_room', function(data) {
		var jsonobj = JSON.parse(data);
		user_chat_layout.addroomlayout(jsonobj);
	});
	user_chat.conn.on('get_room', function(data) {
		var jsonobj = JSON.parse(data);
		user_chat_layout.setroomlistlayout(jsonobj);
	});		
	user_chat.conn.on('recv_message', function(data) {
		var jsonobj = JSON.parse(data);
		if ( typeof jsonobj.isfirst !== 'undefined' && jsonobj.isfirst == 'y' ) {
			user_chat.recvnewchatroom(jsonobj.room);
		}
		user_chat_layout.recvmessagelayout(jsonobj);
	});		
	user_chat.conn.on('set_manager', function(data) {
		var jsonobj = JSON.parse(data);
		user_chat_layout.setmanagerlayout(jsonobj);
	});		
	user_chat.conn.on('close_room', function(data) {
		var jsonobj = JSON.parse(data);
		user_chat_modal.confirmmodal('상담 종료','상담이 종료되었습니다.<br>');
		user_chat.get_room();
	});			
	user_chat.conn.on('recv_close_room', function(data) {
		var jsonobj = JSON.parse(data);
		if( user_chat.room_no == jsonobj.cstatus.room_no && _NB_CHAT_PSTATUS =='chatting') {			
			user_chat_layout.hiddeninputbox();
			user_chat_layout.chatstatlayout(jsonobj);	
			user_chat_layout.movechatbottom();	
		} 		
	});	
	user_chat.conn.on('contact_msg', function(data) {
		var jsonobj = JSON.parse(data);
		user_chat_modal.confirmmodal('문의하기','문의가 접수되었습니다.');
		user_chat.get_room();
	});		
	user_chat.conn.on('get_moremessage', function(data) {
		var jsonobj = JSON.parse(data);
		user_chat_layout.setmoremessagelayout(jsonobj);
	});	
	user_chat.conn.on('recv_invitedmanager', function(data) {
		var jsonobj = JSON.parse(data);
		user_chat_layout.recvinvitelayout(jsonobj);
	});			
	user_chat.conn.on('recv_close_inviteroom', function(data) {
		var jsonobj = JSON.parse(data);
		user_chat_layout.recvinvitelayout(jsonobj);
	});		
	user_chat.conn.on('get_logparam', function(data) {
		var jsonobj = JSON.parse(data);
		if ( jsonobj.automsg != null ) {
			if ( jsonobj.automsg.anal_type == 'page' && jsonobj.automsg.states_json!== 'undefined' && jsonobj.automsg.states_json != '' ) {
				var states_json = JSON.parse(jsonobj.automsg.states_json);
				if ( states_json.V3 !== 'undefined' && states_json.V3 > 0 )
					setTimeout(function(){ user_automsg_box.init(jsonobj) }, states_json.V3 * 1000);
				else
					user_automsg_box.init(jsonobj);
			} else {
				user_automsg_box.init(jsonobj);
			}
		}
		
		if ( jsonobj.ticker ){
			user_ticker_box.init(jsonobj.ticker);
		}
		if ( jsonobj.event && jsonobj.event.length >= 1 ){
			user_event_box.init(jsonobj.event[0]);
		}
	});
	user_chat.conn.on('get_downloadfile', function(data) {
		var jsonobj = JSON.parse(data);
		user_chat_layout.savedownloadfile(jsonobj);
	});						
	user_chat.conn.on('add_botroom', function(data) {
		var jsonobj = JSON.parse(data);
		user_chat_layout.addbotmessagelayout(jsonobj);		
	});						
	
	var _addEvent = function (evnt, func) {
		if (window.addEventListener)  // W3C DOM
			window.addEventListener(evnt,func,false);
		else if (window.attachEvent) { // IE DOM
			window.attachEvent("on"+evnt, func);
		} else { // No much to do
			window[evnt] = func;
		}
	}
	
	// onload event
	//_addEvent('load', user_chat_onloadEvent);
	_addEvent('resize', user_chat_resizeEvent);
	_addEvent('message', function (e) {
		if ( ~e.origin.indexOf("mstat.ifdo.co.kr")) {
			stat_show_iframe(e);
		} 
	});
	
	user_chat_util.de('_NBCHATIMG').addEventListener('click',function() { user_chat_layout.clickchaticon(); });
	
	function user_chat_onloadEvent() {
		user_chat_util.de('_NBCHATIMG').addEventListener('click',function() { user_chat_layout.clickchaticon(); });
	}

	function user_chat_resizeEvent() {
		user_chat_layout.resizelayout();
	}
	
	function external_ShowChatFrame() {
		user_chat_layout.clickchaticon();
		
		return false;
	}
	function external_ShowEventFrame() {
		user_event_box.showEventMsg();
		
		return false;
	}
	
	function stat_show_iframe(e) {
		var datajson = JSON.parse(e.data);
		if ( datajson.type == "showdata" ) {
			var srcdiv = makeExternalIFrame(datajson);
		} else if ( datajson.type == "showvdata" ) {	
			var srcdiv = makeExternalIFrame(datajson);
			
			if ( datajson.scroll_per === undefined || datajson.scroll_per === "0" ) {
				if ( close_vsuggest ) return;
				srcdiv.style.left = "10px";
			} else {			
				_addEvent("scroll", function() {
					if ( close_vsuggest ) return;
					var y_pos = window.scrollY || window.pageYOffset || document.documentElement.scrollTop;
					var d_height = Math.max( document.body.scrollHeight, document.body.offsetHeight, 
							document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight );
					var w_height = window.innerHeight;
					var scroll_per = (d_height - w_height)* parseInt(datajson.scroll_per) / 100;
					if(y_pos >= scroll_per) srcdiv.style.left = "10px";
					else srcdiv.style.left = "-" + datajson.width;
				});
			}
		} else if ( datajson.type == "closesuggest" ) {
			var srcdiv = user_chat_util.ii(document, datajson.src);
			srcdiv.style.left = "-" + datajson.width;
			close_vsuggest = true;
		} else if ( datajson.type == "showticker" ) {
			var srcdiv = makeExternalIFrame(datajson);
			setTimeout(function() {
				if ( datajson.imp_type == "1" ) {
					srcdiv.style.top = "0px";
				} else {
					srcdiv.style.bottom = "0px";
				}
				
				if ( datajson.imptime != 0 ) {
					setTimeout( function() {
						if ( datajson.imp_type == "1" ) {
							srcdiv.style.top = "-" + datajson.height;
						} else {
							srcdiv.style.bottom = "-" + datajson.height;
						}
					}, datajson.imptime* 1000);
					
					setTimeout( function() {
						srcdiv.display = "none";
					}, datajson.imptime* 1000 + 4000);
				}								
			}, datajson.waittime * 1000);	
		} else if ( datajson.type == "showiframe" ) {
			if ( datajson.stype == "ipop") {
				var srcdiv = makeExternalIFrame(datajson);
				
				if ( datajson.position == 'fixed' && ( datajson.popup_bguse === undefined || datajson.popup_bguse != 'n' ) ) {
					var modal = user_chat_util.ii(document,'_NB_AUTOMSG_MODAL');
					if ( datajson.popup_bgop !== undefined ) {
						modal.style.opacity = datajson.popup_bgop; 
					}
					modal.style.display = 'block';
				}
			} else if ( datajson.stype == "ipopm" ) {
				var srcdiv = makeExternalIFrame(datajson);

				if ( datajson.position == 'fixed' && ( datajson.popup_bguse === undefined || datajson.popup_bguse != 'n' ) ) {
					var modal = user_chat_util.ii(document,'_NB_AUTOMSG_MODAL');
					if ( datajson.popup_bgop !== undefined ) {
						modal.style.opacity = datajson.popup_bgop; 
					}
					modal.style.display = 'block';
				}
				setTimeout(function() {
					srcdiv.style.bottom = "0px";
					if ( datajson.boxshadow !== undefined && datajson.boxshadow == 'y' )
						srcdiv.style.boxShadow ='0px -1px 18px 4px grey';
				}, 500);
			}
		} else if ( datajson.type == "closeiframe" ) {
			if ( datajson.stype == "ipop" ) {
				var conntaindiv = user_chat_util.ii(document, "_NB_AUTOMSG_CONTAINER");
				conntaindiv.innerHTML = '';
			} else if ( datajson.stype == "ipopm" ) {
				var srcdiv = user_chat_util.ii(document, datajson.src);
				srcdiv.style.bottom = "-" + datajson.height;
				
				setTimeout(function() {
					var conntaindiv = user_chat_util.ii(document, "_NB_AUTOMSG_CONTAINER");
					conntaindiv.innerHTML = '';
				}, 500);
			}
		} else if ( datajson.type == "showfloat" ) {
			var srcdiv = makeExternalIFrame(datajson);

			setTimeout(function() {
				if ( datajson.position == "1" ) {
					srcdiv.style.top = "0px";
				} else {
					srcdiv.style.bottom = "0px";
				}
			}, 500);			
		} else if ( datajson.type == "showwhistle" ) {
			var srcdiv = makeExternalIFrame(datajson);

			setTimeout(function() {
				srcdiv.style.right = "0px";
				if ( datajson.position == "1" ) 
					srcdiv.style.top = "0px";
				else
					srcdiv.style.bottom = "0px";
					
			}, 500);
		} else if ( datajson.type == "closewhistle" || datajson.type == "closepopcorn" || datajson.type == "closefloat" || datajson.type == "closeticker") {
			var srcdiv = user_chat_util.ii(document, datajson.src);
			if ( datajson.type == "closewhistle" ) 
				srcdiv.style.right = "-" + datajson.width;
			else if ( datajson.type == "closepopcorn" )
				srcdiv.style.bottom = "-" + datajson.height;
			else if ( ( datajson.type == "closefloat" && datajson.position == "1" ) || (datajson.type == "closeticker" && datajson.imp_type == "1") ) 
				srcdiv.style.top = "-" + datajson.height;
			else ( ( datajson.type == "closefloat" && datajson.position == "2" ) || (datajson.type == "closeticker" && datajson.imp_type == "2") )
				srcdiv.style.bottom = "-" + datajson.height;
			
			if ( datajson.type != "closeticker" ) {
				setTimeout(function() {
					let conntaindiv = user_chat_util.ii(document, "_NB_AUTOMSG_CONTAINER");				
					conntaindiv.innerHTML = '';
				}, 500);
			} else {
				setTimeout(function() {
					let conntaindiv = user_chat_util.ii(document, "_NB_TICKER");				
					conntaindiv.innerHTML = '';
					conntaindiv.style.display = 'none';
				}, 500);				
			}
		} else if ( datajson.type == "showpopcorn" ) {
			var srcdiv = makeExternalIFrame(datajson);

			setTimeout(function() {
				srcdiv.style.bottom = "0px";
			}, 500);	
		} 
	}
	
	function makeExternalIFrame(datajson) {
		var srcdiv = user_chat_util.ii(document, datajson.src);
		srcdiv.style.height = datajson.height;
		srcdiv.style.width = datajson.width;
		srcdiv.style.zIndex = 100000;
		
		// set Animation
		if ( datajson.type == "showfloat"
			|| datajson.type == "showticker" 
			|| ( datajson.type == 'showiframe' && datajson.stype == "ipopm" ) 
			|| datajson.type == "showvdata"
			|| datajson.type == "showpopcorn"
			|| datajson.type == "showwhistle") {			
			srcdiv.style.position = "fixed";
			srcdiv.style.transition = "0.5s ease-in";
			srcdiv.style.boxSizing="border-box";		
		}		

		var iframe_width = "";
		switch (datajson.type) {
			case "showfloat" :
				srcdiv.style.width = "100%"; // datajson.width;
				iframe_width = "100%";
				
				if ( datajson.position == "1" ) {
					srcdiv.style.top = "-" + datajson.height;
				} else {
					srcdiv.style.bottom = "-" + datajson.height;				
				}				
				break;
			case "showticker" :
				srcdiv.style.width = "100%"; // datajson.width;
				iframe_width = "100%";
				
				if ( datajson.imp_type == "1" ) {
					srcdiv.style.top = "-" + datajson.height;
				} else {
					srcdiv.style.bottom = "-" + datajson.height;				
				}				
				break;
			case "showiframe" :
				if ( datajson.stype == "ipopm" ) {
					srcdiv.style.bottom = "-" + datajson.height;
					iframe_width = srcdiv.offsetWidth + "px";
				}								
				break;
			case "showvdata" :
				srcdiv.style.left = "-" + datajson.width;
				srcdiv.style.background = "rgba(255, 255, 255, 0.85)";
				srcdiv.style.bottom = "10px";
				srcdiv.style.border="1px solid rgba(0, 0, 0, 0.45)";		
				break;
			case "showdata" :
				srcdiv.style.position = "relative";
				
                if( window._NB_isMobile && datajson.stype == "1" ) 
                    iframe_width = srcdiv.offsetWidth + "px";
				break;
			case "showwhistle" :
				srcdiv.style.right = "-" + datajson.width;
				if( window._NB_isMobile ) {
					srcdiv.style.width = "100%"; // datajson.width;
					iframe_width = "100%";					
				} else {
					srcdiv.style.maxWidth = "400px";
				}
				break;
			case "showpopcorn" :
				srcdiv.style.bottom = "-" + datajson.height;
				srcdiv.style.right = "0px";
				if( window._NB_isMobile ) {
					srcdiv.style.width = "100%"; // datajson.width;
					iframe_width = "100%";					
				} else {
					srcdiv.style.maxWidth = "400px";					
				}
				break;				
		}
		
		if ( srcdiv.getElementsByTagName("iframe").length >= 1 ) {
            srcdiv.getElementsByTagName("iframe")[0].style.width = ( iframe_width == "" ? datajson.width : iframe_width ) ;
			srcdiv.getElementsByTagName("iframe")[0].style.height = datajson.height;
			
			if ( datajson.type == "showdata" )
				srcdiv.getElementsByTagName("iframe")[0].style.position = "relative";
		}	
		
		return srcdiv;
	}
	
	// Statistics Frame 처리
	window._NBSTATISTICS && (function() {
		var stat = new NB_Statistics_ListBox(user_chat, user_chat_util, _NBSTATISTICS);
		setTimeout(function() {
			stat.init();
		}, 500);
		user_chat.conn.on('get_statframe', function(data) {
			var jsonobj = JSON.parse(data);
			var srcdiv = user_chat_util.ii(document, jsonobj.ifid);
			srcdiv.style.height = "0px";
			srcdiv.innerHTML = jsonobj.iframe;
			
			delete jsonobj.iframe;
			delete jsonobj.setting;
			
			var f = document.createElement("form");
			f.setAttribute('method',"post");
			f.setAttribute('action',jsonobj.src);
			f.setAttribute('target',jsonobj.name);
			f.setAttribute('id',jsonobj.name);
			
			Object.keys(jsonobj).forEach(function(key) {
				var i = document.createElement("input"); //input element, text
				i.setAttribute('type',"hidden");
				i.setAttribute('name',key);
				i.setAttribute('value',jsonobj[key]);
				
				f.appendChild(i);
			});
			
			document.getElementsByTagName('body')[0].appendChild(f);	
			var bf = document.getElementById(jsonobj.name);
			bf.submit();
			bf.parentNode.removeChild(bf);
		});			
	})();

	// Public 처리
	return {
		showChatFrame:external_ShowChatFrame,
		showEventFrame:external_ShowEventFrame
	}
}();


// 채팅 화면 컨트롤부 -- End
//var _NB_LAST_SEC=0;
_NB_TSTP=-1; 
var _NB_CHAT_PSTATUS='mainlist';
var _NB_CHAT_PRESTATUS='mainlist';
}


// BBQ 메인페이지에서 동작할 스크립트
if( _bdm.indexOf('bbq.co.kr') == 0 && _durl[0].indexOf('/main.asp') > 0 ){
	var _PIMG_OBJ=Array();
	_NB_PAGE_CUSTOM_LOAD=function(a,b,_pd, _ct, _amt, _pc ){
		if( typeof _PIMG_OBJ[a] != 'undefined' ) return;
		_PIMG_OBJ[a] = a;
		 a=("/"==a.charAt(0)?document.domain:document.domain+'/')+a;_NB_LVAR.url=a;if(typeof b=='string') _NB_LVAR.title=b;var g=au+'//'+_NB_gs+'/WGT/?cur_stamp='+cur_stamp;_NB_LVAR.deviceid = _NB_DVID; 
		_NB_LVAR.pd=_UDF(_pd);_NB_LVAR.ct=_UDF(_ct);_NB_LVAR.amount=_UDF(_amt);_NB_LVAR.pc=_UDF(_pc);
		Object.keys(_NB_LVAR).forEach(function(j){ if(typeof _NB_LVAR[j]!="function"){g+="&"+j+"="+encodeURIComponent(_NB_LVAR[j])} });
		if(typeof c=='string') g+='&join_id='+c;if(typeof d=='string') g+='&m_join='+d; var _Img=new Image(); _Img.src=g+'&rand='+Math.random();setTimeout("",200); _NB_MKTImg.push(_Img);
		_NB_LVAR.pd='';_NB_LVAR.ct='';_NB_LVAR.amount='';_NB_LVAR.pc='';
	}
	_NB_PAGE_CUSTOM=function(a,b,_pd, _ct, _amt, _pc ){
		 a=("/"==a.charAt(0)?document.domain:document.domain+'/')+a;_NB_LVAR.url=a;if(typeof b=='string') _NB_LVAR.title=b;var g=au+'//'+_NB_gs+'/WGT/?cur_stamp='+cur_stamp;_NB_LVAR.deviceid = _NB_DVID; 
		_NB_LVAR.pd=_UDF(_pd);_NB_LVAR.ct=_UDF(_ct);_NB_LVAR.amount=_UDF(_amt);_NB_LVAR.pc=_UDF(_pc);
		Object.keys(_NB_LVAR).forEach(function(j){ if(typeof _NB_LVAR[j]!="function"){g+="&"+j+"="+encodeURIComponent(_NB_LVAR[j])} });
		if(typeof c=='string') g+='&join_id='+c;if(typeof d=='string') g+='&m_join='+d; var _Img=new Image(); _Img.src=g+'&rand='+Math.random();setTimeout("",200); _NB_MKTImg.push(_Img);
		_NB_LVAR.pd='';_NB_LVAR.ct='';_NB_LVAR.amount='';_NB_LVAR.pc='';
	}
	_NB_PROD_LOAD=function(){
			var obj = $('.section_menu .tab-content.on .tab-slider .item'); 
			var _pd = '',_amt='';
			var _burl = 'menu/menuView.asp';
			for( i=0; i < obj.length; i ++ ){ 
				if($(obj[i]).css('display')!='none'){
					_pd = $(obj[i]).find('.info-wrap .tit').html();
					_amt = $(obj[i]).find('.info-wrap .price em').html();					
					var _btn = $(obj[i]).find('.info-wrap .btn-wrap').html();					
					var _btn2= _btn.split('menu/menuView.asp');
					if( _btn2.length == 2){
						var _btn3 = _btn2[1].split('\';');
						_burl += _btn3[0];
					}
				};
			};
			_NB_PAGE_CUSTOM_LOAD(_burl,_pd,_pd,'',_amt,'');
	};
	_NB_PROD_VIEW=function(){
		var obj = $('.section_menu .tab-content.on .tab-slider .item'); 
		var _pd = '',_amt='';
		var _burl = 'menu/menuView.asp';
		for( i=0; i < obj.length; i ++ ){ 
			if($(obj[i]).css('display')!='none'){
				_pd = $(obj[i]).find('.info-wrap .tit').html();
				_amt = $(obj[i]).find('.info-wrap .price em').html();				
				var _btn = $(obj[i]).find('.info-wrap .btn-wrap').html();				
				var _btn2= _btn.split('menu/menuView.asp');
				if( _btn2.length == 2){
					var _btn3 = _btn2[1].split('\';');
					_burl += _btn3[0];
				}
			};
		};
		_NB_PAGE_CUSTOM(_burl,_pd,_pd,'',_amt,'');		
	}

	$(function(){
		_delay_prod_view = function(){ setTimeout(function() { _NB_PROD_VIEW(); }, 1000); };
		$('.bx-controls-direction .bx-prev').unbind('click',_delay_prod_view);
		$('.bx-controls-direction .bx-prev').bind('click',_delay_prod_view);
			
		$('.bx-controls-direction .bx-next').unbind('click',_delay_prod_view);
		$('.bx-controls-direction .bx-next').bind('click',_delay_prod_view);
			
		$('.tab-content').bind('DOMNodeInserted',function(){
			//console.log('변경됨');
			$('.bx-controls-direction .bx-prev').unbind('click',_delay_prod_view);
			$('.bx-controls-direction .bx-prev').bind('click',_delay_prod_view);
				
			$('.bx-controls-direction .bx-next').unbind('click',_delay_prod_view);
			$('.bx-controls-direction .bx-next').bind('click',_delay_prod_view);			
		});		
		$('.section_menu .tab-layer .tab li a').bind('click',_delay_prod_view);
		
		$(window).on('scroll', function (e) {
			var w_h = $(window).height();
			var _info_h = ($('.section_info').offset().top+($('.section_info').height()/2));
			var _menu_h = ($('.section_menu').offset().top+($('.section_menu').height()/2));
			var _cf_h = ($('.section_cf').offset().top+($('.section_cf').height()/2));
			var _store_h = ($('.section_store').offset().top+($('.section_store').height()/2));
			var _bestQuality_h = ($('.section_bestQuality').offset().top+($('.section_bestQuality').height()/2));
			
			if( ($(window).scrollTop()+w_h) > _info_h ){
				_NB_PAGE_CUSTOM_LOAD('main/intro.asp','황금올리브치킨');
			}
			if( ($(window).scrollTop()+w_h) > _cf_h ){
				_NB_PAGE_CUSTOM_LOAD('main/cf.asp','BBQ CF');
			}
			if( ($(window).scrollTop()+w_h) > _store_h ){
				_NB_PAGE_CUSTOM_LOAD('main/store.asp','BBQ STORE');
			}
			if( ($(window).scrollTop()+w_h) > _bestQuality_h ){
				_NB_PAGE_CUSTOM_LOAD('main/bestQuality.asp','BBQ bestQuality');
			}		
			if( ($(window).scrollTop()+w_h) > _menu_h ){
				_NB_PROD_LOAD();
			}
		});		
		
	});
}
