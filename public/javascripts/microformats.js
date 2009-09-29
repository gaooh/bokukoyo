/*
  $Id: microformats.js,v 1.2 2006/11/09 09:10:29 remy Exp $

  bugs:
	- http://www.multipack.co.uk/members/ doesn't load - think it may be a conflict between jQuery and prototype
	- Overloading the document.createElement and not returning the object causes bookmarklet to break
	
  Load by:
javascript:if (!document.getElementById('MF_jq')) {var q=document.createElement('script');q.setAttribute('id', 'MF_jq');q.setAttribute('src', 'http://leftlogic.com/js/jquery.js');document.getElementsByTagName('body')[0].appendChild(q);} var s=document.createElement('script');s.setAttribute('id','MF_loader'); s.setAttribute('src', 'http://leftlogic.com/js/microformats.js');document.getElementsByTagName('head')[0].appendChild(s);void(s);
*/ 

var run_once = 0;
var found = 0;
var nl = '%0D%0A'; // %0D%0A = nl! yay!

function loadCSS() {
	var mf_vcal_css = 'DIV.MF_vevent { background: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAfCAMAAADKrP1yAAAABGdBTUEAANbY1E9YMgAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAB7UExURff396E1N////8XFxcXGyczMzO/v74yMjJkzM7vAw7RdX729vebm5t7e3qysrNbW1ngpK4SEhJmZmbS0tOzn7l0jFbW1tdve4HRCQ6enp73BxKWlpWtra97j5/f4+e7v8sC3sujp7I5wccDAwMbGxvPz82Q7O/j4+P///6uVltcAAAApdFJOU/////////////////////////////////////////////////////8AUvQghwAAAOpJREFUeNp0z4mygyAMBdA0EaRFQNHuffvW///Ch4BakF7H6HgmJMLrdkl/Pn/cY6DaPEQI8VUEJ6fvImxE+2OegLybCDt/xYdo39HLuuOT6M8UOsTe5bdfdfiV2/b0toagW6g45wS+DMNw4UqpAzcsAVcu0DSN5MrkQBFUBRW5MHqMJCkdAACDpJC7AxAsJazRRMAM+AhszDxomuYAERnOZRoUh2N2HnDfESDVacYSP4jFGYXMAFlmuLqjrT6AsfolgQ5ZN37oKOvoUGv/IzfLM5A2vNU6A7xaLVHqWiWwXvfY14X0x38BBgAAgxMf/jRebAAAAABJRU5ErkJggg==) no-repeat top left }';
	
	var css = '<sty' + 'le id="MF_style"> #MF_overlay {position: absolute;z-index: 9998;width: 100%;height: 100%;top: 0;left: 0;min-height: 100%;background-color: #000;filter: alpha(opacity=60);-moz-opacity: 0.6;opacity: 0.6;}' + "\n" + ' #MF_box { padding: 0 10px; position: absolute;background: #ccc; background-image: url(http://leftlogic.com/images/shim.png); z-index: 9999;color:#000000;border: 4px solid #525252;text-align:left; } #MF_box P { font-family: \"Lucida Grande\",\"Lucida Sans Unicode\",geneva,verdana,sans-serif!important; } P.MF_heading { font-size: 1.4em!important; margin: 10px; margin-bottom: 0; } P.MF_path { margin-top: 5px; font-size: 1em!important } #MF_microformats { width:340px; clear: left; overflow: auto; height: 200px; margin: 20px 10px; background-color: #fff;} DIV.MF_card {margin: 5px; padding-bottom: 10px; border-bottom: 1px #ccc solid; padding-left: 25px; } P.MF_header { font-size: 1.2em!important; padding: 0 10px 4px 10px; margin: 0; } P.MF_detail { font-size: 9px!important; color: #666; padding-left: 10px; margin: 0 } IMG.MF_logo { height: 47px!important; width: 46px!important; float: left; margin: 10px }' + "\n#MF_btnClose { float: right; margin: 10px 7px 0 0; padding: 3px; border: 0; }\n";
	
	css += mf_vcard_css;
	css += mf_vcal_css;
	
	css += ' <' + '/style>';
	
	var mf_logo = 'iVBORw0KGgoAAAANSUhEUgAAAC8AAAAuCAMAAACPpbA7AAAABGdBTUEAANbY1E9YMgAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAADAUExURVaEBbPNcXWoBJjHAqfUCE56ArrMlZm4UczMyoWqNqnQJ4q7Asbgb7jkEZaybcXUoWOUBoK1BNDUxc3Qx2qdC2WYAsLJtmicA9HZunqiKMjTsHCiBn2vAWGSCHCeDKDOBV6UAo67CoW4AF2NBbPeEK7aDYKeTYm2A8HjM3+YS2mXB3OYKZ3CMWyaE5C/AuDjy2SGIKK7dmWbC3WdGrziIqnUFIWyDMrXl9PlipO/EHijF6bHTdjcyNbfr6LKFMzMzFKdLMcAAABAdFJOU////////////////////////////////////////////////////////////////////////////////////wDCe7FEAAAC3ElEQVR42oTWe0OqMBgG8HmflxTYcIZ4A9RCXVLWyY617/+tzruN4VDzPGB//d6nVyANiXs5vUBOBHKCny9ECHRHk8+nIofD01On51177J1GkO+TEN+HB50kSZbLen1Zr5BLT5rbIz8ej4uKEJ82X76/12eH4MJ7W867MtFfLHpaP0gt++uzzqjscWUBnitPjE9yXZ9dee/Y1fWmPynxmu0xFiLgfFHysEtidOExHjSzLGtiMeBd5SPtk6Jc6Zr2JHvbpSn1H4kY6PJ1d637ZTtcRsNrPx4SuMUYZfSVgf+T82jtSn/eXHMO/aTvvwKmr37u17BO7pPzLtJz3gnQYCfbmc/8R9g/kjiKXDeE+9Wrm3ZZXjtyviUoSyllqfLE8qr/Pdd6Ga58K2XMB+3r/kjzj7AC/lzO4VzwrvQ+gwGW+vPCu8oPRW9m3qgsl1cafJvJ+JZ3lW9B/+zHtHP1WK2lV9tbXnI3DOX+taLceCz7U9/ymrvVLRGjjlkFqMxHE/pT3/JupNshIyFGvYo8igREoDZg3/FTR/mw4GHLu/zLgwey8E7hwzzV1gCXooZQe+6Ah8TaGw35aLfskNxr7sw3cH/DIlWdsQxlY5a+DU2/40zg0P1GKz82A9MppZafgJ/Edn/1K6ye8XQ6Zmxq/ET2x5P5puiv6nrNYQBOavsJtE/iHRYjaxmp1QQdU0p36VfuZb3ycSDwVlbDNudl4LWDCZb28+uj8TyOUQYfEI/FLvk2FE4Kz8zGE5aH9jjew28ctM8W3iejKWXwaTBtE5H7WO0iB9AKOrygeSNBzqVXVgWthuI/kd5oOPcZvpVfPBwIbVZFnuUhQ648ki+VBmpcZXjp824rpTHbI7O7TdHv/eiivXFjwvKrq2Wu622f6f4rbY/szxcUBRfL3GhvrCyP++j+LqV6+L4mq7u7lLZX/w+QbI9u3COT59IzhfSXej/r/5IhLj1v/wQYAIHf7hGSop1QAAAAAElFTkSuQmCC';

	var btnUp = 'http://bokukoyo.drecom.jp/bookmarklet/regist?';

	$('head').append(css);
	
	removeOverlay();
	$('body').append('<div style="display: none" id="MF_box"><img class="MF_logo" src="data:image/png;base64,' + mf_logo + '" height="47" width="46" /><img title="Close window" id="MF_btnClose" onclick="removeOverlay()" style="cursor: pointer;" alt=" " src="' + btnUp + '" height="14" width="14" /><p class="MF_heading">Microformats found at:</' + 'p><p class="MF_path">' + location.protocol + '//' + location.hostname + '</' + 'p><div id="MF_microformats"></' + 'div></' + 'div>');
	$('body').append('<div id="MF_overlay"></div>');
	
	try {
		$(window).scroll(positionMicroformatBox);
	} catch (e) {
		// move window on scroll disabled
	}
	
	overlaySize();
	$('#MF_overlay').click(removeOverlay);
	$('#MF_btnClose').hover(function(){$(this).attr('src', btnDn)}, function(){$(this).attr('src', btnUp)})
};

// Special mention to Cody Lindley (http://codylindley.com/Javascript/257/thickbox-one-box-to-rule-them-all)
// as the overlay code is mostly taken from his ThickBox 2.0 for jQuery.
function overlaySize() {
	if (window.innerHeight&&window.scrollMaxY) {	
		yScroll = window.innerHeight + window.scrollMaxY;
	} else if (document.body.scrollHeight > document.body.offsetHeight) {
		yScroll = document.body.scrollHeight;
	} else {
		yScroll = document.body.offsetHeight;
  	};
	$('#MF_overlay').css('height',yScroll +'px');
};			

function removeOverlay() {
	$('#MF_box').remove();
	$('#MF_overlay').remove();
};

function showOverlay() {
	$('#MF_overlay').show();
}

function getPageScrollTop() {
	var yScrolltop;
	if (self.pageYOffset) {
		yScrolltop = self.pageYOffset;
	} else if (document.documentElement&&document.documentElement.scrollTop) {
		yScrolltop = document.documentElement.scrollTop;
	} else if (document.body) {
		yScrolltop = document.body.scrollTop;
	};
	arrayPageScroll = new Array('',yScrolltop);
	return arrayPageScroll;
};

function getPageSize() {
	var de = document.documentElement;
	var w = window.innerWidth || self.innerWidth || (de&&de.clientWidth) || document.body.clientWidth;
	var h = window.innerHeight || self.innerHeight || (de&&de.clientHeight) || document.body.clientHeight;

	arrayPageSize = new Array(w,h);
	return arrayPageSize;
};	

function positionMicroformatBox() {
	var pagesize = getPageSize();	
	var arrayPageScroll = getPageScrollTop();

	$('#MF_box').css({width:'360px',left: ((pagesize[0] - 360)/2)+'px', top: (arrayPageScroll[1] + 25)+'px'});
	overlaySize();
};


hCalendar = function(ve) {
	found = 1;
	var hCal = {};
	var keys = ['summary', 'location', 'description', 'attendee', 'contact', 'organizer'] ;
	for (var i = 0; i < keys.length; i++) {
		if ($('.' + keys[i], ve).length) hCal[keys[i]] = cleanString($('.' + keys[i], ve).text());
	}
	
	// collect adr manually
	if ($('.adr', ve).length) {
		var keys = ['post-office-box', 'extended-address', 'street-address', 'locality', 'region', 'postal-code', 'country-name'];

		for (var i = 0; i < keys.length; i++) {
			if ($('.' + keys[i], ve).length) hCal[keys[i]] = cleanString($('.' + keys[i], ve).text());
			hCal.adr = 1;
		}
	}
	
	keys = ['dtstart', 'dtend', 'duration'];
	for (var i = 0; i < keys.length; i++) {
		if ($('.' + keys[i], ve).length) hCal[keys[i]] = $('.' + keys[i], ve).attr('title');
	}

	// how wasteful am I?!
	if (hCal.dtstart) hCal.dtstart_raw = cleanDateTime(hCal.dtstart);
	if (hCal.dtstart) hCal.dtstart = hCal.dtstart_raw.formatted();
	if (hCal.dtstart) hCal.dtstart_str = hCal.dtstart_raw.toString();
	if (hCal.dtend) hCal.dtend_raw = cleanDateTime(hCal.dtend);
	if (hCal.dtend) hCal.dtend = hCal.dtend_raw.formatted();
	if (hCal.dtend) hCal.dtend_str = hCal.dtend_raw.toString();
	
	if ($('.url', ve).length) hCal.url = $('.url', ve).attr('href');
	if (hCal.url) hCal.url = cleanURL(hCal.url);
	
	if (hCal.description) hCal.description = hCal.description.replace(/\n/g, '\n');
	
	var note = 'Source: ' + location.hostname;
	if (hCal.description) hCal.description += '\n' + note;
	else hCal.description = note;

	this.show = function() {
		var html = '<div class="MF_card MF_vevent">';
		html += '<p class="MF_header"><a href="' + this.vCalendar() + '" title="Add to calendar">' + hCal.summary + '</a></p>';
		if (hCal.location) html += '<p class="MF_detail">' + hCal.location + '</p>';
		if (hCal.dtstart) html += '<p class="MF_detail">' + hCal.dtstart_str + '</p>';

		html += '</div>';
		$('#MF_microformats').append(html);
	};
	
	this.vCalendar = function() {
		vcal = 'data:text/calendar;utf-8,';
		vcal += 'BEGIN:VCALENDAR' + nl + 'VERSION:2.0' + nl + 'BEGIN:VEVENT' + nl;
			
		if (hCal.adr) {
			var keys = ['post-office-box', 'extended-address', 'street-address', 'locality', 'region', 'postal-code', 'country-name'];
			hCal.location = '';
			for (var i = 0; i < keys.length; i++) {
				if (hCal[keys[i]]) { 
					if (keys[i] == 'locality') hCal.location += '\n';
					hCal.location += hCal[keys[i]] + ' ';
				}
			}
		}
		
		var keys = ['summary', 'location', 'description', 'attendee', 'contact', 'organizer', 'dtstart', 'dtend', 'duration', 'note'];

		for (var i = 0; i < keys.length; i++) {
			if (hCal[keys[i]]) vcal += keys[i].toUpperCase() + ':' + encodeURIComponent(hCal[keys[i]]) + nl;
		}
		
		vcal += 'END:VEVENT' + nl + 'END:VCALENDAR';
		return vcal;
	}
	
	return this;
}


function cleanEmail(e) {
	e = e.replace('mailto:', '');
	return e.replace(/\?.*$/, '');
}

function cleanURL(u) {
	if (!u.match(/^http/)) {
		if (u.match(/^\//))	u = location.protocol + '//' + location.hostname + u;
		else {
			var parts = location.pathname.split('/');
			parts.pop();
			var p = parts.join('/');
			u = location.protocol + '//' + location.hostname + p + '/' + u;
		}
	}
	return u;		
}

function cleanString(s) {
	s = s.replace(/^\s+/, '');
	s = s.replace(/\s+$/, '');
	s = s.replace(/( )+/g, ' ');
	return s.replace(/\n/g, '\n'); // plain text!
}

function emptyCheck() {
	if (!found) {
		var html = '<div class="MF_card">';
		html += '<p class="MF_header">No microformats could be found.</p>';
		html += '</div>';
		$('#MF_microformats').append(html);
	}
}

cleanDateTime = function(t) {
	// 20060913T1400-0700
	// 2006-09-13T14:00-07:00
	
	pad = function(s) {
		if (s.length == 1) s = '0' + s;
		return s;
	}
	
	num = function(str, s, e) {
		return parseInt(str.substr(s, e), 10);
	}
	
	// strip formatting - currently doesn't support 2006-W05
	var endpos = t.indexOf('T');
	if (endpos == -1) endpos = t.length;
	
	var dstr = t.substr(0, endpos).replace(/\-/g, '');
	var tstr;
	
	if (endpos != t.length) tstr = t.substr(endpos+1).replace(/:/g, '');
	else tstr = '1200';
	
	t = dstr + 'T' + tstr;
	
	var d = new Date();
	d.setFullYear(num(dstr, 0, 4), num(dstr, 4, 2) - 1, num(dstr, 6, 2));
	d.setHours(num(t, 9, 2), num(t, 11, 2), 0); //  + offset
	var m = d.getMilliseconds();
	
	var offset = num(t, 14, 2) * 60 + num(t, 16, 2); // damn this is noddy.
	if (isNaN(offset) == false) {
		if (t.substr(13, 1) != '-') offset *= -1;
		m = m + (offset * 60 * 1000);
	}
	
	d.setMilliseconds(m);
	
	formatted = function(){
		var s = d.getFullYear().toString();
		s += pad((d.getMonth()+1).toString());
		s += pad(d.getDate().toString()) + 'T';
		s += pad(d.getHours().toString());
		s += pad(d.getMinutes().toString());
		s += pad(d.getSeconds().toString());
		if (offset) s += 'Z';
		return s;
	}
	
	toString = function() {
		return d.toString();
	}
	
	return this;
}

loadCSS();
$('.vevent').each(function(){ hCalendar(this).show() });
emptyCheck();
positionMicroformatBox();
$('#MF_box').fadeIn(600);
