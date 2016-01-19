package p.minn.base
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import p.minn.event.DateSelectEvent;
	import flexmdi.managers.ProxyMessageManager;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	
	public class DrawDate extends UIComponent
	{
		
		private var bgColor:uint      = 0xF80A0A;
		private var borderColor:uint  = 0xF80A0A;
		private var borderSize:uint   = 1;

		public function DrawDate()
		{
			super();
			this.doubleClickEnabled=true
			ProxyMessageManager.getInstance().addEventListener(DateSelectEvent.DATE_SELECT_CHANGE,function(evt:DateSelectEvent):void{
				graphics.clear();
			});
			this.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent):void{
				dis(DateSelectEvent.DATE_SELECT_CHANGE);
				drawRect(0,0,18,18);
			});
			this.addEventListener(MouseEvent.DOUBLE_CLICK,function(evt:MouseEvent):void{
				dis(DateSelectEvent.DATE_DOUBLE_CLICK_SELECT,evt.target.text,false);
			});
		}
		private function dis(type:String,d:Object=null,isSelf:Boolean=true):void{
			if(isSelf){
			    ProxyMessageManager.getInstance().dispacher(new DateSelectEvent(type,d,true));
			}else{
				this.dispatchEvent(new DateSelectEvent(type,d,true));
			}
		}
		override protected function   createChildren():void{
			  super.createChildren();
//			  drawCircle(this.x,this.y,5);
		}
		public function drawCircle(x:Number,y:Number,r:Number=5):void{
//			var halfSize:uint = Math.round(size / 2);
//			graphics.beginFill(bgColor);
			graphics.lineStyle(borderSize, borderColor);
			graphics.drawCircle(x, y, r);
//			graphics.endFill();

		}
		
		public function drawRect(x:Number,y:Number,w:Number,h:Number,bgColor:uint=0xffffff):void{
//			var child:Shape = new Shape();
//			child.graphics.beginFill(bgColor);
			graphics.lineStyle(borderSize, borderColor);
			graphics.drawRoundRect(x, y, w, h, 0);
//			child.graphics.endFill();
//			this.addChild(child);
		}
		public function set text(text:String):void{
			var t:UITextField=new UITextField();
			
			t.text=text;
			this.addChild(t);
			t.x=0;
			t.y=0;
		}
	}
}