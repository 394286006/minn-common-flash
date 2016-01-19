package p.minn.event
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	
	public class MinnMessageEventManager
	{
		private static var me:MinnMessageEventManager=null;
		
		private static var dispatcher:DisplayObjectContainer=null;
		public function MinnMessageEventManager()
		{
			dispatcher=FlexGlobals.topLevelApplication.parent;
		}
		
		public static function getInstance():MinnMessageEventManager{
			if(me==null)
				me=new MinnMessageEventManager();
//			dispatcher=FlexGlobals.topLevelApplication;
			if(dispatcher==null)
		     	dispatcher=getDisp();
			return me;
		}
		
		
	 	public function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ) : void 
		{
		 dispatcher.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		public function removeEventListener(type:String,listener:Function, useCapture:Boolean = false ) : void 
		{
			dispatcher.removeEventListener(type,listener,useCapture);
		}
     public function dispatchEvent( event:Event ) : Boolean 
		{
//		 Alert.show((dispatcher==null).toString());
			return dispatcher.dispatchEvent( event );
		}
	 
	 public static function getDisp():DisplayObjectContainer{
		 return FlexGlobals.topLevelApplication.parent;
	 }
	}
}