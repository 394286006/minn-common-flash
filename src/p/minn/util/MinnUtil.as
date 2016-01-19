package p.minn.util
{
	
	import com.adobe.serialization.json.JSON;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.Proxy;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.controls.ProgressBar;
	import mx.controls.ProgressBarMode;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.formatters.DateFormatter;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	import mx.managers.SystemManager;
	import mx.resources.ResourceManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.rpc.remoting.RemoteObject;
	import mx.skins.halo.BusyCursor;
	import mx.styles.StyleManager;
	import mx.utils.ArrayUtil;
	
	import p.minn.message.Message;
	

	/**
	 * @author minn
	 * @QQ 394286006
	 */
	public final class MinnUtil
	{
		[Bindable] 
		[Embed("assets/img/page/wait.gif")] 
		private static var c:Class; 
		//private  static var url:String;
		public static var BASEURL:String="";
		public static var SUBFFIX:String=".swf";
		private static var img:Image=null;
		private static var loader:URLLoader=null ;
		public function MinnUtil()
		{
			img=new Image();
			img.source=c;
		}
		//public static function set Url(urlStr:String):void
	//	{
			//url=urlStr;
		//}
		//public static function get Url():String
		//{
		//	return url;
		//}
		
		/**传入参数obj为数据库返回的对象，map为需要装配成的类 
		 * 返回装配数据完成的类
		 */
		public static function propertyMap(obj:Object,map:*,isj:Boolean=false):*{
			if(isj)
			 obj=com.adobe.serialization.json.JSON.decode(obj.toString());
			if((obj is XML)||obj is XMLList){
				for each(var kv:XML in obj.attributes()){
					var prp:String=kv.name();
					map[prp]=kv;
				}
			}else{
				for( prp in obj){
					if(map.hasOwnProperty(prp))
						map[prp]=obj[prp];
				}
			}
			return map;
		}
		
		public static function send(httpService:HTTPService,method:String,invoke:Function,param:*=null):void{
			httpService.method="POST";
			httpService.resultFormat="text";
            
			var uri:String=BASEURL+method;
			httpService.url=uri;
			
			var l:int=CursorManager.getInstance().setCursor(c);
			CursorManager.getInstance().setBusyCursor()
			httpService.addEventListener(FaultEvent.FAULT,function(evt:FaultEvent):void{
				CursorManager.getInstance().removeCursor(l);
				CursorManager.getInstance().removeBusyCursor();
				//Alert.show("request fail:"+evt.message,"Alert");
				var msg:Message=new Message(evt.message);
				msg.sucess=false;
				if(invoke!=null){
					invoke(msg);
				}
			});	
			httpService.addEventListener(ResultEvent.RESULT,function(evt:ResultEvent):void{
				CursorManager.getInstance().removeCursor(l);
				CursorManager.getInstance().removeBusyCursor();
				;
				var msg:Message=getMessage(evt.result);

				if(invoke!=null){
					invoke(msg);
				}
			});
			httpService.send(param);
			
			
		}
		
		public static function deleteFile(upurl:String,param:URLVariables,filearr:Array,dualfunction:Function):void{
//			if(loader==null)
				loader=new URLLoader();
			var request:URLRequest =  new URLRequest(upurl+"?date="+new Date());
			request.method = "post";
			param.photos=encodeURIComponent(com.adobe.serialization.json.JSON.encode(filearr));
//			Alert.show(JSON.encode(filearr));
			request.data=param;
			if(!loader.hasEventListener(Event.COMPLETE))
//				loader.removeEventListener(Event.COMPLETE,dualfunction);
			loader.addEventListener(Event.COMPLETE,dualfunction);
			loader.load(request);
		}
		
		public static function getMessage(message:Object):Message{
			var msg:Message=null;
			 message=com.adobe.serialization.json.JSON.decode(message.toString());
			var obj:Object=message.data;
			if(obj.hasOwnProperty('fix')){
				msg=new Message(obj.messageBody);
				msg.sid=obj.sid;
				msg.timestamp=obj.timestamp;
				msg.random=obj.random;
				msg.messageType=obj.messageType;
			}else{
				msg=new Message(obj);
			}
			msg.sucess=message.success;
			return msg;
		}
		
		public static function reverse(os:ArrayCollection,arr:Array=null):void{
			arr=os.source;
			arr.reverse();
			os.source=arr;
		}
		
		public static function copyProperty(ac:ArrayCollection,arr:Array):void{
			for(var i:int=0;i<arr.length;i++){
			      var op:*=ac.getItemAt(i);
				var o:Object=arr[i];
				for(var prp:String in o)
				{
					if(op.hasOwnProperty(prp))
						op[prp]=o[prp];
				}
				
			}
		}
		
		public static function getCurentDateAndTime(dateformat:String='YYYY-MM-DD HH:NN:SS'):String{
			var f:DateFormatter=new DateFormatter();
			 f.formatString=dateformat;
			var d:Date=new Date();
			return f.format(d);
		}
		
		public static function getTimeStamp():int{
			var d:Date=new Date();
			return d.milliseconds;
		}
		
		public static function getEncodeMessage(param:*):String{
			return com.adobe.serialization.json.JSON.encode(param);
		}
		
		
		/*
		
		*@param labelName 定义的xml变量格式 eg:var userInfo:XML=<userInfo/>;
		
		*@param labelArr xml标记数组 eg: var arr:Array=["operator","userName","password"];
		
		*@param dataArr xml值数组  eg:var item:Array=["login",user_id.text,password_id.text];
		
		*/
		public static function arr2xml(labelName:XML,labelArr:Array,dataArr:Array):XML
		{
			
			for(var i:int=0;i<labelArr.length;i++)
			{
				if(i<dataArr.length)
				{
					labelName.appendChild("<"+labelArr[i]+">"+dataArr[i]+"</"+labelArr[i]+">");
				}else
				{
					labelName.appendChild("<"+labelArr[i]+">0</"+labelArr[i]+">");
				}
			}
			return labelName;
		}  
		
		public static function sendUrl(url:String,invoke:Function,param:*=null):void{
			var urlLoader:URLLoader=new URLLoader();
			urlLoader.dataFormat=URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE,function(evt:Event):void{
				var msg:Message=getMessage(evt.target.data);
				
				if(invoke!=null){
					invoke(msg);
				}
			});
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusEvent);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,ioerrorEvent);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityError);
			var request:URLRequest=new URLRequest(url);
			if(param!=null){
				request.data=param;
			}
			request.method="post";
			urlLoader.load(request);
		}
		
		
		private static function httpStatusEvent(evt:HTTPStatusEvent):void{
			//				Alert.show(evt.type,"HTTPStatusEvent");
		}
		private static function securityError(evt:SecurityErrorEvent):void{
			//Alert.show(evt.type,"SecurityErrorEvent");
		}
		
		private static  function ioerrorEvent(evt:IOErrorEvent):void{
			//Alert.show(evt.type,"IOErrorEvent");
		}
		
		public static function getParamUrl(url:String):Object{
			var urls:Array= url.split("?");
			var param:Object=new Object();
			if(urls.length>1){
				var kvs:Array=String(urls[1]).split("&");
				for(var i:int=0;i<kvs.length;i++){
					var kv:Array=String(kvs[i]).split("=");
					param[kv[0]]=kv[1];
				}
			}
			if(urls.length>1){
				param.url=urls[0]+SUBFFIX+"?"+urls[1];
			}else{
				param.url=urls[0]+SUBFFIX;
			}
		
			return param;
		}

	}
}