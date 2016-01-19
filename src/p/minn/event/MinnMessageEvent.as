package p.minn.event
{
	import flash.events.Event;
	
	public class MinnMessageEvent extends Event
	{
		public static const MESSAGE:String = "message";
		
	
		public static const CREATIONCOMPLETE_MESSAGE:String = "CREATIONCOMPLETE_MESSAGE";
		
		
		private var _data:Object;
		
		public function MinnMessageEvent(type:String, data:Object=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data=data;
		}
		
		public function set data(data:Object):void{
			this._data=data;
		}
		
		public function get data():Object{
			return _data;
		}
	}
}