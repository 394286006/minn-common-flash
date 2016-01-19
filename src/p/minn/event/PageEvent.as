package p.minn.event
{
	import flash.events.Event;
	
	/**
	 */
	public class PageEvent extends Event{
		public static const PAGE_CHANGE:String = "pageChange"; 
		public static const PAGE_FIRST:String = "pageFirst";   
		public static const PAGE_LAST:String = "pageLast";     
		public static const PAGE_PREVIOUS:String = "pagePrevious"; 
		public static const PAGE_NEXT:String = "pageNext";         
		public static const PAGE_REFRESH:String = "pageRefresh";
		public static const PAGE_CUSTOM:String = "pageCustom";  
		
		public var pageIndex:int = 0;
		public var pageSize:int = 0;
		public var recordCount:int = 0;
		
		//public var target:Object;
		
		public function PageEvent(type:String, pageindex:int, pagesize:int, recordCount:int, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
			this.pageIndex= pageindex;
			this.pageSize = pagesize;
			this.recordCount = recordCount;
		}
		
	}

}