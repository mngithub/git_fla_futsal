package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.globalization.DateTimeFormatter;
	import flash.utils.ByteArray;
	import flash.net.FileReference;
	
	public class Utils
	{
		
		// เอา tag xmlns ใน xml string ออก 
		// เอา tag soap: ออก 
		public static function removeNameSpace($xml:String):XML
		{
			var xmlnsPattern:RegExp = new RegExp("xmlns[^\"]*\"[^\"]*\"", "gi");
			var replaced:String = $xml.replace(xmlnsPattern, "");
			replaced = replaceAll(replaced,"soap:","");
			var xml:XML  = new XML(replaced);
			return xml;
		}
		public static function writeFileWithUTF8Bom(dat:String, fileName:String):void {
			var fileRef:FileReference = new FileReference();
			var b:ByteArray = new ByteArray();
			// Include the byte order mark for UTF-8
			b.writeByte(0xEF);
			b.writeByte(0xBB);
			b.writeByte(0xBF);
			b.writeUTFBytes(dat);
			fileRef.save(b, fileName);          
		}
		
		// เปลี่ยนจาก HHmmss เป็น HH:mm
		public static function formatDate(d:Object):String{
			var temp:String = d.toString();
			if(temp.length == 6){
				temp = temp.slice(0,2)+":"+temp.slice(2,4);
			}
			return temp;
		}
		
		// ใส่ comma ให้ตัวเลข
		public static function formatNumber(number:Number):String
		{
			var numString:String = number.toString()
			var result:String = ''
		
			while (numString.length > 3)
			{
				var chunk:String = numString.substr(-3)
				numString = numString.substr(0, numString.length - 3)
				result = ',' + chunk + result
			}
		
			if (numString.length > 0)
			{
				result = numString + result
			}
		
			return result
		}
		// แทนค่า string ทั้งหมด
		public static function replaceAll($str:String, $search:String, $replace:String):String
		{
			return $str.split($search).join($replace);
		}
		// -------------------------------------------------------------------
		// -------------------------------------------------------------------
		// -------------------------------------------------------------------
		
		// hhmmss
		public static function getTodayTime():String{
			
			//return "093001";
			var d:Date = new Date();
			var dtf:DateTimeFormatter = new DateTimeFormatter("en-US");
			dtf.setDateTimePattern("HHmmss");
			return dtf.format(d);
		}
		// yyyymmdd
		public static function getTodayDate():String{
			var d:Date = new Date();
			var dtf:DateTimeFormatter = new DateTimeFormatter("en-US");
			dtf.setDateTimePattern("yyyyMMdd");
			return dtf.format(d);
		}
		// เปลี่ยน hhmmss เป็นจำนวน second ใช้สำหรับเปรียบเทียบเวลา
		public static function getStringTimeToSecond(t:String):Number{
			var h:Number = Math.floor(parse(t)/10000);
			var m:Number = Math.floor((parse(t)% 10000)/100);
			var s:Number = (parse(t)% 100);
			return (h)*3600+(m)*60+(s);
		}
		
		// String วันที่ปัจจุบัน
		public static function todayString():String{
			var d:Date = new Date();
			var dtf:DateTimeFormatter = new DateTimeFormatter("en-US");
			dtf.setDateTimePattern("MM/dd/yyyy");
			return dtf.format(d);
		}
		// String วันที่เมื่อวาน
		public static function yesterdayString():String{
			var d:Date = new Date();
			d.date -= 1;
			var dtf:DateTimeFormatter = new DateTimeFormatter("en-US");
			dtf.setDateTimePattern("MM/dd/yyyy");
			return dtf.format(d);
		}
		
		// ลบ content ใน slot ออก
		public static function emptySlot(slot:MovieClip,includeBackground=true):void
		{
			var remainChild:Number = includeBackground ? 1 : 0;
			while (slot.numChildren > remainChild)
			{
				slot.removeChildAt(slot.numChildren - 1);
			}
		}
		// String เวลาปัจจุบัน
		public static function timeString():String{
			var d:Date = new Date();
			var dtf:DateTimeFormatter = new DateTimeFormatter("en-US");
			dtf.setDateTimePattern("HH mm");
			return dtf.format(d);
		}
		public static function timeInt():Number{
			var d:Date = new Date();
			var dtf:DateTimeFormatter = new DateTimeFormatter("en-US");
			dtf.setDateTimePattern("HHmm");
			return parse(dtf.format(d));
		}
		public static function thaiDateString():String{
			var d:Date = new Date();
			var dtf:DateTimeFormatter = new DateTimeFormatter("en-US");
			dtf.setDateTimePattern("yyyy");
		
			var year:String = (parse(dtf.format(d)) + 543).toString();
			
			dtf.setDateTimePattern("M");
			var month:String = dtf.format(d);
			if(month == "1") month = "มกราคม";
			else if(month == "2") month = "กุมภาพันธ์";
			else if(month == "3") month = "มีนาคม";
			else if(month == "4") month = "เมษายน";
			else if(month == "5") month = "พฤษภาคม";
			else if(month == "6") month = "มิถุนายน";
			else if(month == "7") month = "กรกฎาคม";
			else if(month == "8") month = "สิงหาคม";
			else if(month == "9") month = "กันยายน";
			else if(month == "10") month = "ตุลาคม";
			else if(month == "11") month = "พฤศจิกายน";
			else month = "ธันวาคม";
			
			dtf.setDateTimePattern("EEEE");
			var day:String = dtf.format(d);
			if(day == "Monday") day = "จันทร์";
			else if(day == "Tuesday") day = "อังคาร";
			else if(day == "Wednesday") day = "พุธ";
			else if(day == "Thursday") day = "พฤหัสบดี";
			else if(day == "Friday") day = "ศุกร์";
			else if(day == "Saturday") day = "เสาร์";
			else day = "อาทิตย์";
			
			dtf.setDateTimePattern("d");
			var date:String = dtf.format(d);
			
			return (date+" "+month+" "+year);
		}
		public static function thaiDateAbbrString(forwardDay:Number = 0):String{
			
			var d:Date = new Date();
			var dtf:DateTimeFormatter = new DateTimeFormatter("en-US");
			dtf.setDateTimePattern("EEEE");
			
			var day:String = dtf.format(d);
			var dayArray:Array	=	['จ.','อ.','พ.','พฤ.','ศ.','ส.','อา.'];
			var dayIndex:Number = 0;
			
			if(day == "Monday"){ 
				dayIndex = 0;
			}else if(day == "Tuesday"){ 
				dayIndex = 1;
			}else if(day == "Wednesday"){ 
				dayIndex = 2;
			}else if(day == "Thursday"){ 
				dayIndex = 3;
			}else if(day == "Friday"){ 
				dayIndex = 4;
			}else if(day == "Saturday"){ 
				dayIndex = 5;
			}else{ 
				dayIndex = 6;
			}
			
			return dayArray[(dayIndex+forwardDay)%7];
		}
		
		
		public static function getSavePath():String{
			var d:Date = new Date();
			var dtf:DateTimeFormatter = new DateTimeFormatter("en-US");
			dtf.setDateTimePattern("yyyyMMdd");
			return "save_" + dtf.format(d);
		}
		
		// return t1 - t2 (minutes)
		// HH:mm
		// -1 หาก error
		public static function compareTimeString(t1:String, t2:String):Number{
			try {
				var temp_1:Array = t1.split(":");
				var temp_2:Array = t2.split(":");
				//trace(temp1[0],temp1[1]);
				var n1:Number = (parse(temp_1[0])*60) +  parse(temp_1[1]);
				var n2:Number = (parse(temp_2[0])*60) +  parse(temp_2[1]);
				return n1-n2;
			}catch(error:Error){
				//here you process error
				//show it to user or make LOG
			}
			return -1;
		}
		
		// -------------------------------------------------------------------
		// -------------------------------------------------------------------
		// WEATHER
		// -------------------------------------------------------------------
		// -------------------------------------------------------------------
		
		public static function findWeatherServiceID(configWeatherCity:XMLList ,code:String):Number{

			if(configWeatherCity == null) return -1;
			for(var i = 0; i < configWeatherCity.airport.length(); i++){
				if(configWeatherCity.airport[i].airportCode == code)
					return parse(configWeatherCity.airport[i].airportServiceID.toString());
			}
			return -1;
		}
		public static function findWeatherYahooID(configWeatherCity:XMLList ,code:String):Number{

			if(configWeatherCity == null) return -1;
			for(var i = 0; i < configWeatherCity.airport.length(); i++){
				if(configWeatherCity.airport[i].airportCode == code)
					return parse(configWeatherCity.airport[i].airportYahooID.toString());
			}
			return -1;
		}
		
		// ---------------------------------------------
		// clear
		// rain
		// cloudy
		// overcast
		// fog || mist
		// ---------------------------------------------
		// ÍسËÀÙÁÔ 			-- อุณหภูมิ 
		// ÔȷҧÅÁ			 -- ทิศทางลม
		// ÅѡɳÐÍҡÒÈ 		-- ลักษณะอากาศ
		// ½¹ÊÐÊÁÇѹ¹Õé 		-- ฝนสะสมวันนี้
		// ---------------------------------------------
		// ·éͧ¿éÒâ»Ãè§		-- ท้องฟ้าโปร่ง 			(clear)
		// àÁ¦ºҧÊèǹ			-- เมฆบางส่วน			(cloudy)
		// àÁ¦				-- เมฆ				(cloudy)
		// ËÁ͡				-- หมอก				(fog)
		// ÁÕàÁ¦Áҡ			-- มีเมฆมาก			(overcast)
		// àÁ¦à»ç¹ÊèǹÁҡ		-- เมฆเป็นส่วนมาก		(overcast)
		// ÁÕàÁ¦àµçÁ		-- มีเมฆเต็ม			(overcast)
		// ½¹				-- ฝน					(rain)
		// ¾ÒÂØ				-- พายุ				(rain)
		// ¿éÒáź			-- ฟ้าแลบ 				(rain)
		// ¿éÒÃéͧ			-- ฟ้าร้อง 				(rain)
		public static function findTMDWeatherString(r:XML):String
		{
			var tmp:String = r.toXMLString();
			if(tmp.indexOf("ÍسËÀÙÁÔ") == -1 && tmp.indexOf("อุณหภูมิ") == -1) return "";
			
			if(tmp.indexOf("·éͧ¿éÒâ»Ãè§") != -1 || tmp.indexOf("ท้องฟ้าโปร่ง") != -1) return "clear";
			if(tmp.indexOf("ËÁ͡") != -1 || tmp.indexOf("หมอก") != -1) return "fog";
			if(tmp.indexOf("ÁÕàÁ¦Áҡ") != -1 || tmp.indexOf("มีเมฆมาก") != -1) return "overcast";
			if(tmp.indexOf("àÁ¦à»ç¹ÊèǹÁҡ") != -1 || tmp.indexOf("เมฆเป็นส่วนมาก") != -1) return "overcast";
			if(tmp.indexOf("ÁÕàÁ¦àµçÁ") != -1 || tmp.indexOf("มีเมฆเต็ม") != -1) return "overcast";
			if(tmp.indexOf("àÁ¦ºҧÊèǹ") != -1 || tmp.indexOf("เมฆบางส่วน") != -1) return "cloudy";
			if(tmp.indexOf("àÁ¦") != -1 || tmp.indexOf("เมฆ") != -1) return "cloudy";
			if(tmp.indexOf("½¹") != -1 || tmp.indexOf("ฝน") != -1) return "rain";
			if(tmp.indexOf("¾ÒÂØ") != -1 || tmp.indexOf("พายุ") != -1) return "rain";
			if(tmp.indexOf("¿éÒáź") != -1 || tmp.indexOf("ฟ้าแลบ") != -1) return "rain";
			if(tmp.indexOf("¿éÒÃéͧ") != -1 || tmp.indexOf("ฟ้าร้อง") != -1) return "rain";
			return "";
		}
		
		// clear
		// rain
		// cloudy
		// overcast
		// fog || mist
		// return yweather:condition ["code"]
		public static function findYahooWeatherCondition(r:XML):String
		{
		
			var tmp:String = r.toXMLString();
			var index:Number = tmp.indexOf("yweather:condition");
			if(index == -1){ 
				
				return "";
			}
			tmp = tmp.substring(index);
			
			try{
				var codeRegExp:RegExp = /code="([0-9]*)"/;
				var matches:Object = codeRegExp.exec(tmp);
				if(matches[1] == undefined) return "";
				var code:Number = parse(matches[1]);
				
				if(Main.DEBUG_TRACE) trace("findYahooWeatherCondition", code);
				
				if(code == 4 || code == 9 || code == 11 || code == 12) return "rain";
				
				if(code == 19 || code == 20 || code == 21 || code == 22) return "fog";
				
				if(code == 26) return "overcast";
				
				if(code == 27 || code == 29) return "cloudy_night";
				
				if(code == 28) return "mostly_cloudy";
				
				if(code == 30) return "cloudy";
				
				if(code == 31 || code == 33) return "night";
				
				if(code == 32 || code == 34) return "clear";
				
				if(code == 35) return "rain";
				
				if(code == 36) return "clear";
				
				if(code == 37 || code == 38 || code == 39 || code == 40) return "rain";
				
				if(code == 44) return "cloudy";
				
			}catch(e:Error){ if(Main.DEBUG_TRACE) trace(e.message);}
			
			return "";
		}
		
		// clear
		// rain
		// cloudy
		// overcast
		// fog || mist
		// return array of yweather:forecast ["text"]
		public static function findYahooWeatherConditionWithForcast(r:XML):Array
		{
			var weatherArray:Array = new Array();
			
			var tmp:String = r.toXMLString();
			var index:Number = tmp.indexOf("<yweather:forecast");
			if(index == -1){ 
				
				return weatherArray;
			}
			
			tmp = tmp.substring(index);
			//trace(tmp);
			try{
				
				var lineRegExp:RegExp = /<yweather:forecast (.*)\/>/g;
				
				var dayRegExp:RegExp = /day="(\w*)"/;
				var lowRegExp:RegExp = /low="([0-9]*)"/;
				var highRegExp:RegExp = /high="([0-9]*)"/;
				var codeRegExp:RegExp = /code="([0-9]*)"/;
				
				var match:Object;
				
				if(Main.DEBUG_TRACE) trace("--------------------------------");
				
				while((match = lineRegExp.exec(tmp)) != null)
				{
				  	//trace("Match at " + match.index + "\n" + "Matched substring is " + match[0]);
					//trace(match[0]);
					
					var tempObj:Object = new Object();
					var tempMatch:Object;
					
					tempMatch = dayRegExp.exec(match[0]);
					//trace(tempMatch[1]);
					if(tempMatch[1] != undefined) tempObj.day = tempMatch[1]; else tempObj.day = "";
					
					tempMatch = lowRegExp.exec(match[0]);
					if(tempMatch[1] != undefined) tempObj.low = tempMatch[1]; else tempObj.low = "";
					
					tempMatch = highRegExp.exec(match[0]);
					if(tempMatch[1] != undefined) tempObj.high = tempMatch[1]; else tempObj.high = "";
					
					tempMatch = codeRegExp.exec(match[0]);
					if(tempMatch[1] != undefined){
						
						var code:Number = parse(tempMatch[1]);
						
						if(code == 4 || code == 9 || code == 11 || code == 12) tempObj.code = "rain";
				
						else if(code == 19 || code == 20 || code == 21 || code == 22) tempObj.code = "fog";
						
						else if(code == 26) tempObj.code = "overcast";
						
						else if(code == 27 || code == 29) tempObj.code = "cloudy_night";
						
						else if(code == 28) tempObj.code = "mostly_cloudy";
						
						else if(code == 30) tempObj.code = "cloudy";
						
						else if(code == 31 || code == 33) tempObj.code = "night";
						
						else if(code == 32 || code == 34) tempObj.code = "clear";
						
						else if(code == 35) tempObj.code = "rain";
						
						else if(code == 36) tempObj.code = "clear";
						
						else if(code == 37 || code == 38 || code == 39 || code == 40) tempObj.code = "rain";
						
						else if(code == 44) tempObj.code = "cloudy";
						
						else tempObj.code = "";
					}
					
					weatherArray.push(tempObj);
					if(Main.DEBUG_TRACE) trace(tempObj.day, tempObj.low, tempObj.high, tempObj.code);
					
				}
				
				if(Main.DEBUG_TRACE) trace("--------------------------------");
				
			}catch(e:Error){ if(Main.DEBUG_TRACE) trace(e.message);}
			
			return weatherArray;
		}
		// -------------------------------------------------------------------
		// -------------------------------------------------------------------
		// -------------------------------------------------------------------
		
		// แปลง String เป็น Number
		public static function parse(str:String):Number{
			for(var i = 0; i < str.length; i++){
				var c:String = str.charAt(i);
				if(c != "0") break;
			}
			return Number(str.substr(i));
		}
		// คิดอุณหภูมิเฉลี่ย เป็นเซลเซียส
		public static function getTemperatureAverage(obj:Object):String{
			var low:Number = (parse(obj.low) - 32)*(5/9);
			var high:Number = (parse(obj.high) - 32)*(5/9);
			var average:Number = Math.round((low+high)/2);
			return average + "˚c";
		}
		public static function getTemperatureRange(obj:Object):String{
			var low:Number = Math.round((parse(obj.low) - 32)*(5/9));
			var high:Number = Math.round((parse(obj.high) - 32)*(5/9));
			
			return low + "-" + high + "˚c";
		}
		// -------------------------------------------------------------------
		// -------------------------------------------------------------------
		// -------------------------------------------------------------------
		
		// roomID: 1-9
		public static function getRoomIdFromName(n:String):String
		{
			if(n == null) return "-1";
			if(n.indexOf("สโมสร") != -1 || n.indexOf("club") != -1) return "1";
			if(n.indexOf("วิศว") != -1 || n.indexOf("Engineer") != -1) return "2";
			if(n.indexOf("สำนักงาน") != -1 || n.indexOf("office") != -1) return "3";
			if(n.indexOf("ผลิต") != -1 || n.indexOf("Prod") != -1) return "4";
			if(n.indexOf("จัดซื้อ") != -1 || n.indexOf("purchase") != -1) return "5";
			if(n.indexOf("ชมพู") != -1 || n.indexOf("Room_1") != -1) return "6";
			if(n.indexOf("3") != -1 || n.indexOf("Room_3") != -1) return "7";
			if(n.indexOf("4") != -1 || n.indexOf("Room_4") != -1) return "8";
			if(n.indexOf("ทูบี") != -1 || n.indexOf("Tobe") != -1) return "9";
			
			return "-1";
			
		}
		
		// -------------------------------------------------------------------
		
		
		
	}
}