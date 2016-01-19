package p.minn.tree
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.controls.Tree;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.controls.treeClasses.TreeListData;
	import mx.events.TreeEvent;

    /**
	 * @author minn
	 * @QQ     394286006
	 */ 
	public class TreeCheckBoxRender extends TreeItemRenderer   
	{   
		public function TreeCheckBoxRender()   
		{   
			super();   
		}   
		
		private var _selectedField:String = "selected";   
		
		protected var checkBox:CheckBox;   
		
		private var _myselectedItems:ArrayCollection=new ArrayCollection();
		
		override protected function createChildren():void  
		{   
			super.createChildren();   
			checkBox = new CheckBox();   
			addChild( checkBox );   
			checkBox.addEventListener(Event.CHANGE, changeHandler);   
			checkBox.addEventListener(MouseEvent.CLICK,updateCheck);
		}   
		
		protected function updateCheck(e:Event):void{
			this.dispatchEvent(new Event("updateTreeEvent",true));
		}
		
		
		protected function changeHandler( event:Event =null):void  
		{   
			if( data && data[_selectedField] != undefined )   
			{   
				data[_selectedField] = checkBox.selected;   
				if(checkBox.selected){
					_myselectedItems.addItem(data);
				}
			}   
			/*if(data.hasOwnProperty("children")){
				var arr:Array=data["children"];
				for(var i:int;i<arr.length;i++){
					var obj:Object=arr[i];
					obj[_selectedField]=checkBox.selected;
				}
			}*/
			
		}    
		
		public function get myselectedItems():ArrayCollection{
			return _myselectedItems;
		}
		
		override protected function commitProperties():void  
		{   
			super.commitProperties();   
			if( data && data[_selectedField] != undefined )   
			{   
				checkBox.selected = data[_selectedField];   
			}   
			else  
			{   
				checkBox.selected = false;   
			}   
		}   
		
		override protected function measure():void  
		{   
			super.measure();   
			measuredWidth += checkBox.getExplicitOrMeasuredWidth();   
		}   
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void  
		{   
			super.updateDisplayList(unscaledWidth, unscaledHeight);   
			var startx:Number = data ? TreeListData( listData ).indent : 0;   
			
			if (disclosureIcon)   
			{   
				disclosureIcon.x = startx;   
				
				startx = disclosureIcon.x + disclosureIcon.width;   
				
				disclosureIcon.setActualSize(disclosureIcon.width,   
					disclosureIcon.height);   
				
				disclosureIcon.visible = data ?   
					TreeListData( listData ).hasChildren :   
					false;   
			}   
			
			if (icon)   
			{   
				icon.x = startx;   
				startx = icon.x + icon.measuredWidth;   
				icon.setActualSize(icon.measuredWidth, icon.measuredHeight);   
			}   
			
			checkBox.move(startx, ( unscaledHeight - checkBox.height ) / 2 );   
			
			label.x = startx + checkBox.getExplicitOrMeasuredWidth();   
		}   
	}   

}