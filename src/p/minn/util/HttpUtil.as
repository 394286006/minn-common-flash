package p.minn.util
{
	import mx.rpc.http.HTTPService;
	public class HttpUtil
	{
		private  static var url:String;
		public function HttpUtil()
		{
		}
		
		public static function set Url(urlStr:String):void
		{
		  url=urlStr;
		}
		public static function get Url():String
		{
		  return url;
		}
	
		 public static function  send(httpService:HTTPService,actionUrl:String,param:XML):void
	        {
	         	httpService.method="POST";
	         	var uri:String=url+actionUrl;
	         	httpService.url=uri;
	            var o:Object=new Object();
	            o.requestinfo=param;
	         	httpService.send(o);
	         
	        }

	}
}