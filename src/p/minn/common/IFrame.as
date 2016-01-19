package p.minn.common
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	import mx.events.MoveEvent;
	import mx.events.ResizeEvent;
	import mx.utils.UIDUtil;

	public class IFrame extends Canvas
	{
		private var __source: String;
		private var _uuid:String=null;
		
		public function get uuid():String{
			return _uuid;
		}
		public function IFrame()
		{
			super();

			this.addEventListener(MoveEvent.MOVE,move1);
			this.addEventListener(ResizeEvent.RESIZE,move1);
			this.addEventListener(MouseEvent.MOUSE_OVER,move1);
			
		}
		
		private function move1(e:Event):void{
//			Alert.show(e.type);
			if(_uuid)
			  if(e.type==MouseEvent.MOUSE_MOVE||e.type==ResizeEvent.RESIZE)
				callLater(moveIFrame);
			  else if(e.type==MouseEvent.MOUSE_OVER)
				  setLayer(15);
		}
	
	public function moveIFrame(): void
	{
		
		var localPt:Point = new Point(this.x, this.y);
		var globalPt:Point = this.localToGlobal(localPt);
		
		ExternalInterface.call("moveIFrame", _uuid,globalPt.x+"px",globalPt.y+2+"px",this.width+3+"px", this.height+2+"px");
	}
	
	/**
	 * The source URL for the IFrame.  When set, the URL is loaded through ExternalInterface.
	 **/
	public function set source(source: String): void
	{
		
		if (source)
		{
			if(_uuid==null){
			_uuid=UIDUtil.createUID();
//			var localPt:Point = new Point(this.x, this.y);
//			var globalPt:Point = this.localToGlobal(localPt);
			
			ExternalInterface.call("createIframeDiv",_uuid);
			}
			if (! ExternalInterface.available)
			{
				throw new Error("ExternalInterface is not available in this container. Internet Explorer ActiveX, Firefox, Mozilla 1.7.5 and greater, or other browsers that support NPRuntime are required.");
			}
//	
			ExternalInterface.call("loadIFrame", _uuid,source);
			moveIFrame();
		}
	}
	
	public function get source(): String
	{
		return __source;
	}
	
	/**
	 * Whether the IFrame is visible.  
	 **/
	override public function set visible(visible: Boolean): void
	{
//		if(visible==null)visible=true;
		super.visible=visible;
		
		if (visible)
		{
			ExternalInterface.call("showIFrame",_uuid);
		}
		else 
		{
			ExternalInterface.call("hideIFrame",_uuid);
		}
	}
	
	public function bring2Front():void{
//		Alert.show(_uuid);
		trace("bring2Front:"+_uuid);
		ExternalInterface.call("bring2Front",_uuid);
	}
	public function bring2End():void{
		//		Alert.show(_uuid);
		trace(_uuid);
		ExternalInterface.call("bring2End",_uuid);
	}
	
	public function setLayer(layer:int):void{
		ExternalInterface.call("setLayer",_uuid,layer);
	}
	public function sendData(data:Object):void{
		ExternalInterface.call("receiveData",_uuid,data);
	}
	public function removeIFrame():void{
//		Alert.show("removeIFrame");
		ExternalInterface.call("removeIFrame",_uuid);
		this.removeEventListener(MoveEvent.MOVE,move1);
		this.removeEventListener(ResizeEvent.RESIZE,move1);
		this.removeEventListener(MouseEvent.MOUSE_OVER,move1);
		 __source=null;
		_uuid=null;
		
	}
	}
}