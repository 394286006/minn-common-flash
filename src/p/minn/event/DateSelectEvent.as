package p.minn.event
{
	import flash.events.Event;
	//create by minn qq:394286006 2010-12-11
	public class DateSelectEvent extends Event
	{
		public static var DATE_SELECT_CHANGE:String="dateSelectChange";
		public static var DATE_DOUBLE_CLICK_SELECT:String="dateDoubleClickSelect";
		public static var DATE_DOUBLE_CLICK_SHOW_SELECT:String="dateDoubleClickShowSelect";
		
		private var _data:Object;
		
		public function DateSelectEvent(type:String,_d:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this._data=_d;
		}
		
		public function set data(da:Object):void{
			this._data=da;
		}
		
		public function get data():Object{
			return this._data;
		}
	}
}