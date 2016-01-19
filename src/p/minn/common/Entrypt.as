package p.minn.common
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	import mx.modules.ModuleLoader;
	import mx.modules.ModuleManager;

	public class Entrypt
	{
		private static var newByte:ByteArray = new ByteArray();
		public function Entrypt()
		{
		}
		
		public static function uncompress(byte:ByteArray,key:String):ByteArray{
			var flag:int = 0;
			newByte.clear();
			for(var i:int = 0; i<byte.length ; i++ ,flag++){	
				if(flag >= key.length){
					flag = 0;
				}
				newByte.writeByte(byte[i] - key.charCodeAt(flag));
			} 				
			return newByte;
		}
		
		public static function loadswfObject(url:String,dualfunction:Function):void{
			try{
				var urlLoader:URLLoader=new URLLoader();
				urlLoader.dataFormat=URLLoaderDataFormat.BINARY;
				if(!urlLoader.hasEventListener(Event.COMPLETE))
					urlLoader.addEventListener(Event.COMPLETE,dualfunction);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusEvent);
				urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityError);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR,ioerrorEvent);
				urlLoader.load(new URLRequest(url));
			}catch (e:Error){
				dualfunction(null);
			}
			
		}
		
		private static function httpStatusEvent(evt:HTTPStatusEvent):void{
						//Alert.show(evt.type,"HTTPStatusEvent");
		}
		private static function securityError(evt:SecurityErrorEvent):void{
			//Alert.show(evt.type,"SecurityErrorEvent");
		}
		private static function ioerrorEvent(evt:IOErrorEvent):void{
			//Alert.show(evt.type,"IOErrorEvent");
		}
	}
}