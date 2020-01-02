#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
e=https://api.openweathermap.org/data/2.5/weather?q=istanbul&units=metric&appid=7c7a7ffddc05f418a64cb2e3eb28c9bf
hObject:=ComObjCreate("WinHttp.WinHttpRequest.5.1")         ;Create the Object
ComObjError(false)
hObject.Open("GET",e)                     ;Open communication
hObject.Send()                            ;Send the "get" request
obj = hObject.responseText               ;Set the "aad" variable to the response

;{"coord":{"lon":28.95,"lat":41.01},"weather":[{"id":802,"main":"Clouds","description":"scattered clouds","icon":"03n"}],"base":"stations","main":{"temp":4.43,"feels_like":1.76,"temp_min":3,"temp_max":6.67,"pressure":1022,"humidity":86},"visibility":10000,"wind":{"speed":1.5,"deg":280},"clouds":{"all":40},"dt":1577829334,"sys":{"type":1,"id":6970,"country":"TR","sunrise":1577856541,"sunset":1577889932},"timezone":10800,"id":745044,"name":"Istanbul","cod":200}

json := hObject.responseText, obj := CocoJson.Load( json )


;msgbox % UnixTimeConvert(1577889932 ,"HH:mm:ss")

;openweather sunseti 12 lik saat dilimine göre veriyor. Sunrise için sıkıntı yok. öğlenden önce 12/24 saat farketmez
;timezonu + olarak ekliyorum. saniye cinsinden zaman farkı oluyor. - olsa bile + ile eklemk doğru sonuca getiriyor.


 ;GEÇERLİ ZAMANI 12 SAATE GÖRE ALIR bununla geçerli zamanı alacağım ve gerekirse dönüştürüp öğlene doğru öğlenden sonrayta göre etki derecelerine göre uygulama yapacağım
;FormatTime, Clock12Hour,, % (hour < 10 ? " " : "") "hh:mm"
;FormatTime, ampm,, tt
;CurrentDateTime:=var Format("{:L}",ampm)



UnixTimeConvert(CurrentUnixTime,WhichTimes)
{
	UnixBegin := 19700101000000
	UnixBegin += CurrentUnixTime, Seconds
	FormatTime, ReadableTime, %UnixBegin%,%WhichTimes% ; WhichTimes HH:mm:ss
	return ReadableTime
}
SunriseArray := StrSplit(UnixTimeConvert(obj.sys.sunrise + obj.timezone, "hh:mm:ss"),":")
SunsetArray := StrSplit(UnixTimeConvert(obj.sys.sunset + obj.timezone , "hh:mm:ss"),":")
SunriseSec :=  (SunriseArray.1 * 3600 + (SunriseArray.2 * 60) + SunriseArray.3) 
SunsetSec :=    (SunsetArray.1 * 3600 + (SunsetArray.2 * 60) + SunsetArray.3) 
HalfDay :=  (SunsetSec + (12 * 3600) - SunriseSec) / 2   ; 12 * 3600 ile 12 saat daha eklemiş ooluyoruz. yarım günü bulduk , 60 bölerek gün ışığı zamanı dakikalarını ikiye bölerek yarım günü bulduk
;MsgBox % HalfDay  ;ceil(HalfDay / 100)
;msgbox % Floor((((SunsetArray.1 + 12) * 3600 + ((SunsetArray.2 * 60) /60)) - (sunriseArray.1 * 3600 + ((SunriseArray.2 * 60) /60)))  / 2)
;MsgBox % SunriseSec "  " SunsetSec

AMPM := A_Hour>11 ? "PM" : "AM"  ;pm öğleden sonra
CurTimeSec12 := ((A_Hour>11?A_Hour-12:A_Hour) * 3600) + (A_Min * 60) +  A_Sec ;12 lik saat verir
CurTimeSec24 := (A_Hour * 3600) + (A_Min * 60) +  A_Sec ;12 lik saat verir
;MsgBox % Clock12Hour "  " AMPM


;geçici alanlar
CurTimeSec := 13 * 3600   ;ssat 10
AMPM := "AM"		;saat öğleden önce

DayLightTol := 40 ;kullanıcının verdiği tölerans

Brightness := 50 ;o an denk gelen mevcut parlaklık


;MsgBox % CurTimeSec - SunriseSec  "  HalfDay"  HalfDay
   
 /*
	Ceil sadece yukarı yuvarlıyor. yakıan yuvala.   
*/

if (AMPM == "AM")
{	
	AddBright := ((CurTimeSec24 - SunriseSec) / HalfDay) * 100 ; " GEÇERLİ ZAMANIN YARIM GÜNÜN YÜZDE KAÇINA GELDİĞİNİ BULUYORUZ"
;YUKKARIDA BULUNAN SONUÇ AŞAĞIDA DAYLLİGHT TOOOLUN NE KADARINI ETKİLEYECEĞİNİ BULACAK. YÜZDE YÜZÜ OLUNCA DAYLİGHT TOLERANCANIN TAMAMI  ÖRNEĞİN 40 SA 40 ETKİSİ PARLAKLIĞA EKLENECEK
	ParlakkligaEklenecekSonDeger := % Ceil(DayLightTol / 100 * AddBright) ;YARIM GÜNÜN YÜZDESİNİN NE KADARINI KULLANACAĞIMIZI BULUYORUZ.  MSGBOX SİLİNECEK BU DEĞER ALINCAK
}
if (AMPM == "PM")
{
	AddBright := (CurTimeSec12 / HalfDay) * 100 ; " GEÇERLİ ZAMANIN YARIM GÜNÜN YÜZDE KAÇINA GELDİĞİNİ BULUYORUZ"
;YUKKARIDA BULUNAN SONUÇ AŞAĞIDA DAYLLİGHT TOOOLUN NE KADARINI ETKİLEYECEĞİNİ BULACAK. YÜZDE YÜZÜ OLUNCA DAYLİGHT TOLERANCANIN TAMAMI  ÖRNEĞİN 40 SA 40 ETKİSİ PARLAKLIĞA EKLENECEK
	ParlakkliktanCikarilacakDeger := % Ceil(DayLightTol / 100 * AddBright) ;YARIM GÜNÜN YÜZDESİNİN NE KADARINI KULLANACAĞIMIZI BULUYORUZ.  MSGBOX SİLİNECEK BU DEĞER ALINCAK	
}
;Nihayet
Brightness += ParlakkligaEklenecekSonDeger
Brightness += ParlakkliktanCikarilacakDeger

;MsgBox % "yarım günnü yüzdedele : "  gunyuzde "`r Ogledenonce Saat (10:30 örnek)  : "  rastgeleogledenoncesaat "`r Parlaklık ve günışığı tölenrası: " yeniParlaklıkEklemesi







return



MsgBox % (SunriseArray.1 * 3600) + (SunriseArray.2 * 60)      "  " UnixTimeConvert(obj.sys.sunrise + obj.timezone ,"HH:mm:ss") " "  SunriseArray.2 * 60

MsgBox, % "Sıcaklık: " obj.main.temp "  Bulutluluk: " obj.clouds.all "  Görüş mesafesi: " obj.visibility  "  Gündoğumu: " UnixTimeConvert(obj.sys.sunrise + obj.timezone ,"HH:mm:ss") "  Günbatımı: " UnixTimeConvert(obj.sys.sunset + obj.timezone ,"HH:mm:ss") "  Zaman Dilimi: " obj.timezone



/**
	* Lib: JSON.ahk
	*     JSON lib for AutoHotkey.
	* Version:
	*     v2.1.3 [updated 04/18/2016 (MM/DD/YYYY)]
	* License:
	*     WTFPL [http://wtfpl.net/]
	* Requirements:
	*     Latest version of AutoHotkey (v1.1+ or v2.0-a+)
	* Installation:
	*     Use #Include JSON.ahk or copy into a function library folder and then
	*     use #Include <JSON>
	* Links:
	*     GitHub:     - https://github.com/cocobelgica/AutoHotkey-JSON
	*     Forum Topic - http://goo.gl/r0zI8t
	*     Email:      - cocobelgica <at> gmail <dot> com
*/


/**
	* Class: JSON
	*     The JSON object contains methods for parsing JSON and converting values
	*     to JSON. Callable - NO; Instantiable - YES; Subclassable - YES;
	*     Nestable(via #Include) - NO.
	* Methods:
	*     Load() - see relevant documentation before method definition header
	*     Dump() - see relevant documentation before method definition header
*/
class CocoJson
{
	/**
		* Method: Load
		*     Parses a JSON string into an AHK value
		* Syntax:
		*     value := JSON.Load( text [, reviver ] )
		* Parameter(s):
		*     value      [retval] - parsed value
		*     text    [in, ByRef] - JSON formatted string
		*     reviver   [in, opt] - function object, similar to JavaScript's
		*                           JSON.parse() 'reviver' parameter
	*/
	class Load extends CocoJson.Functor
	{
		Call(self, ByRef text, reviver:="")
		{
			this.rev := IsObject(reviver) ? reviver : false
      ; Object keys(and array indices) are temporarily stored in arrays so that
      ; we can enumerate them in the order they appear in the document/text instead
      ; of alphabetically. Skip if no reviver function is specified.
			this.keys := this.rev ? {} : false
			
			static quot := Chr(34), bashq := "\" . quot
              , json_value := quot . "{[01234567890-tfn"
              , json_value_or_array_closing := quot . "{[]01234567890-tfn"
              , object_key_or_object_closing := quot . "}"
			
			key := ""
			is_key := false
			root := {}
			stack := [root]
			next := json_value
			pos := 0
			
			while ((ch := SubStr(text, ++pos, 1)) != "") {
				if InStr(" `t`r`n", ch)
					continue
				if !InStr(next, ch, 1)
					this.ParseError(next, text, pos)
				
				holder := stack[1]
				is_array := holder.IsArray
				
				if InStr(",:", ch) {
					next := (is_key := !is_array && ch == ",") ? quot : json_value
					
				} else if InStr("}]", ch) {
					ObjRemoveAt(stack, 1)
					next := stack[1]==root ? "" : stack[1].IsArray ? ",]" : ",}"
					
				} else {
					if InStr("{[", ch) {
               ; Check if Array() is overridden and if its return value has
               ; the 'IsArray' property. If so, Array() will be called normally,
               ; otherwise, use a custom base object for arrays
						static json_array := Func("Array").IsBuiltIn || ![].IsArray ? {IsArray: true} : 0
						
               ; sacrifice readability for minor(actually negligible) performance gain
						(ch == "{")
                     ? ( is_key := true
                       , value := {}
                       , next := object_key_or_object_closing )
                  ; ch == "["
                     : ( value := json_array ? new json_array : []
                       , next := json_value_or_array_closing )
						
						ObjInsertAt(stack, 1, value)
						
						if (this.keys)
							this.keys[value] := []
						
					} else {
						if (ch == quot) {
							i := pos
							while (i := InStr(text, quot,, i+1)) {
								value := StrReplace(SubStr(text, pos+1, i-pos-1), "\\", "\u005c")
								
								static tail := A_AhkVersion<"2" ? 0 : -1
								if (SubStr(value, tail) != "\")
									break
							}
							
							if (!i)
								this.ParseError("'", text, pos)
							
							value := StrReplace(value,  "\/",  "/")
                     , value := StrReplace(value, bashq, quot)
                     , value := StrReplace(value,  "\b", "`b")
                     , value := StrReplace(value,  "\f", "`f")
                     , value := StrReplace(value,  "\n", "`n")
                     , value := StrReplace(value,  "\r", "`r")
                     , value := StrReplace(value,  "\t", "`t")
							
							pos := i ; update pos
							
							i := 0
							while (i := InStr(value, "\",, i+1)) {
								if !(SubStr(value, i+1, 1) == "u")
									this.ParseError("\", text, pos - StrLen(SubStr(value, i+1)))
								
								uffff := Abs("0x" . SubStr(value, i+2, 4))
								if (A_IsUnicode || uffff < 0x100)
									value := SubStr(value, 1, i-1) . Chr(uffff) . SubStr(value, i+6)
							}
							
							if (is_key) {
								key := value, next := ":"
								continue
							}
							
						} else {
							value := SubStr(text, pos, i := RegExMatch(text, "[\]\},\s]|$",, pos)-pos)
							
							static number := "number", integer :="integer"
							if value is %number%
							{
								if value is %integer%
									value += 0
							}
							else if (value == "true" || value == "false")
								value := %value% + 0
							else if (value == "null")
								value := ""
							else
                     ; we can do more here to pinpoint the actual culprit
                     ; but that's just too much extra work.
								this.ParseError(next, text, pos, i)
							
							pos += i-1
						}
						
						next := holder==root ? "" : is_array ? ",]" : ",}"
					} ; If InStr("{[", ch) { ... } else
					
					is_array? key := ObjPush(holder, value) : holder[key] := value
					
					if (this.keys && this.keys.HasKey(holder))
						this.keys[holder].Push(key)
				}
				
			} ; while ( ... )
			
			return this.rev ? this.Walk(root, "") : root[""]
		}
		
		ParseError(expect, ByRef text, pos, len:=1)
		{
			static quot := Chr(34), qurly := quot . "}"
			
			line := StrSplit(SubStr(text, 1, pos), "`n", "`r").Length()
			col := pos - InStr(text, "`n",, -(StrLen(text)-pos+1))
			msg := Format("{1}`n`nLine:`t{2}`nCol:`t{3}`nChar:`t{4}"
         ,     (expect == "")     ? "Extra data"
             : (expect == "'")    ? "Unterminated string starting at"
             : (expect == "\")    ? "Invalid \escape"
             : (expect == ":")    ? "Expecting ':' delimiter"
             : (expect == quot)   ? "Expecting object key enclosed in double quotes"
             : (expect == qurly)  ? "Expecting object key enclosed in double quotes or object closing '}'"
             : (expect == ",}")   ? "Expecting ',' delimiter or object closing '}'"
             : (expect == ",]")   ? "Expecting ',' delimiter or array closing ']'"
             : InStr(expect, "]") ? "Expecting JSON value or array closing ']'"
             :                      "Expecting JSON value(string, number, true, false, null, object or array)"
         , line, col, pos)
			
			static offset := A_AhkVersion<"2" ? -3 : -4
			throw Exception(msg, offset, SubStr(text, pos, len))
		}
		
		Walk(holder, key)
		{
			value := holder[key]
			if IsObject(value) {
				for i, k in this.keys[value] {
               ; check if ObjHasKey(value, k) ??
					v := this.Walk(value, k)
					if (v != CocoJson.Undefined)
						value[k] := v
					else
						ObjDelete(value, k)
				}
			}
			
			return this.rev.Call(holder, key, value)
		}
	}
	
	/**
		* Method: Dump
		*     Converts an AHK value into a JSON string
		* Syntax:
		*     str := CocoJson.Dump( value [, replacer, space ] )
		* Parameter(s):
		*     str        [retval] - JSON representation of an AHK value
		*     value          [in] - any value(object, string, number)
		*     replacer  [in, opt] - function object, similar to JavaScript's
		*                           CocoJson.stringify() 'replacer' parameter
		*     space     [in, opt] - similar to JavaScript's CocoJson.stringify()
		*                           'space' parameter
	*/
	class Dump extends CocoJson.Functor
	{
		Call(self, value, replacer:="", space:="")
		{
			this.rep := IsObject(replacer) ? replacer : ""
			
			this.gap := ""
			if (space) {
				static integer := "integer"
				if space is %integer%
					Loop, % ((n := Abs(space))>10 ? 10 : n)
						this.gap .= " "
				else
					this.gap := SubStr(space, 1, 10)
				
				this.indent := "`n"
			}
			
			return this.Str({"": value}, "")
		}
		
		Str(holder, key)
		{
			value := holder[key]
			
			if (this.rep)
				value := this.rep.Call(holder, key, ObjHasKey(holder, key) ? value : CocoJson.Undefined)
			
			if IsObject(value) {
         ; Check object type, skip serialization for other object types such as
         ; ComObject, Func, BoundFunc, FileObject, RegExMatchObject, Property, etc.
				static type := A_AhkVersion<"2" ? "" : Func("Type")
				if (type ? type.Call(value) == "Object" : ObjGetCapacity(value) != "") {
					if (this.gap) {
						stepback := this.indent
						this.indent .= this.gap
					}
					
					is_array := value.IsArray
            ; Array() is not overridden, rollback to old method of
            ; identifying array-like objects. Due to the use of a for-loop
            ; sparse arrays such as '[1,,3]' are detected as objects({}). 
					if (!is_array) {
						for i in value
							is_array := i == A_Index
						until !is_array
					}
					
					str := ""
					if (is_array) {
						Loop, % value.Length() {
							if (this.gap)
								str .= this.indent
							
							v := this.Str(value, A_Index)
							str .= (v != "") ? v . "," : "null,"
						}
					} else {
						colon := this.gap ? ": " : ":"
						for k in value {
							v := this.Str(value, k)
							if (v != "") {
								if (this.gap)
									str .= this.indent
								
								str .= this.Quote(k) . colon . v . ","
							}
						}
					}
					
					if (str != "") {
						str := RTrim(str, ",")
						if (this.gap)
							str .= stepback
					}
					
					if (this.gap)
						this.indent := stepback
					
					return is_array ? "[" . str . "]" : "{" . str . "}"
				}
				
			} else ; is_number ? value : "value"
				return ObjGetCapacity([value], 1)=="" ? value : this.Quote(value)
		}
		
		Quote(string)
		{
			static quot := Chr(34), bashq := "\" . quot
			
			if (string != "") {
				string := StrReplace(string,  "\",  "\\")
            ; , string := StrReplace(string,  "/",  "\/") ; optional in ECMAScript
            , string := StrReplace(string, quot, bashq)
            , string := StrReplace(string, "`b",  "\b")
            , string := StrReplace(string, "`f",  "\f")
            , string := StrReplace(string, "`n",  "\n")
            , string := StrReplace(string, "`r",  "\r")
            , string := StrReplace(string, "`t",  "\t")
				
				static rx_escapable := A_AhkVersion<"2" ? "O)[^\x20-\x7e]" : "[^\x20-\x7e]"
				while RegExMatch(string, rx_escapable, m)
					string := StrReplace(string, m.Value, Format("\u{1:04x}", Ord(m.Value)))
			}
			
			return quot . string . quot
		}
	}
	
	/**
		* Property: Undefined
		*     Proxy for 'undefined' type
		* Syntax:
		*     undefined := CocoJson.Undefined
		* Remarks:
		*     For use with reviver and replacer functions since AutoHotkey does not
		*     have an 'undefined' type. Returning blank("") or 0 won't work since these
		*     can't be distnguished from actual JSON values. This leaves us with objects.
		*     Replacer() - the caller may return a non-serializable AHK objects such as
		*     ComObject, Func, BoundFunc, FileObject, RegExMatchObject, and Property to
		*     mimic the behavior of returning 'undefined' in JavaScript but for the sake
		*     of code readability and convenience, it's better to do 'return CocoJson.Undefined'.
		*     Internally, the property returns a ComObject with the variant type of VT_EMPTY.
	*/
	Undefined[]
	{
		get {
			static empty := {}, vt_empty := ComObject(0, &empty, 1)
			return vt_empty
		}
	}
	
	class Functor
	{
		__Call(method, ByRef arg, args*)
		{
      ; When casting to Call(), use a new instance of the "function object"
      ; so as to avoid directly storing the properties(used across sub-methods)
      ; into the "function object" itself.
			if IsObject(method)
				return (new this).Call(method, arg, args*)
			else if (method == "")
				return (new this).Call(arg, args*)
		}
	}
}