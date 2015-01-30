package 
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLRequestHeader;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.utils.Dictionary;
	import com.adobe.serialization.json.JSON;
	import flash.net.URLVariables;
	
	

	public class HTTPService
	{
		var successCallback: Function;
		var failedCallback: Function;

		public function HTTPService(sc:Function = null, fc:Function = null)
		{
			
			this.successCallback = sc;
			this.failedCallback = fc;
			
			var loader:URLLoader = new URLLoader();
			
			var urlRequest : URLRequest = new URLRequest(Main.CONFIG_SERVER_URL + "?"+ (new Date().getTime()));  
			urlRequest.method = URLRequestMethod.POST;  
			
			var postVar : URLVariables = new URLVariables();  
			postVar.auth = Main.CONFIG_AUTH;
			
			urlRequest.data = postVar;  
			
			loader.addEventListener(Event.COMPLETE, processResponse);
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event) {
				if(failedCallback != null){
					failedCallback();
				}
				if(Main.DEBUG_TRACE) trace("Error - IO_ERROR");
			});
			
			loader.load(urlRequest);
									
			function processResponse(e:Event):void
			{
				try{
					var rData:String = e.target.data;
					if(Main.DEBUG_TRACE){
						//trace("-----------------");
						//trace(rData);
						//trace("-----------------");
					}
					var rArray:Array = com.adobe.serialization.json.JSON.decode(rData) as Array;
					
					if(successCallback != null){
						successCallback(rArray);
					}
					
				}catch(err:Error){
					if(failedCallback != null){
						failedCallback();
					}
					if(Main.DEBUG_TRACE) trace("Error - parse JSON");
				}
				
			}
		}
	}
}