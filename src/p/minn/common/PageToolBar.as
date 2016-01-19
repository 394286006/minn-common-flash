package p.minn.common
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import p.minn.event.PageEvent;
	
	import mx.containers.HBox;
	import mx.controls.Alert;
	import mx.controls.ComboBox;
	import mx.controls.LinkButton;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	
	import spark.components.BorderContainer;
	import spark.components.Label;
	import spark.layouts.HorizontalAlign;
	import spark.layouts.HorizontalLayout;
	
	
	[Event(name="pageChange", type="minn.event.PageEvent")]
	
	public class PageToolBar extends HBox
	{
		private var _recordCount:int = -1;
		private var _pageSize:int = 20;
		private var _pageIndex:int = 0;
		private var _pageCount:int = 0;    
		
		private var btnFirst:LinkButton;
		private var btnPrevious:LinkButton;
		private var btnNext:LinkButton;
		private var btnLast:LinkButton;
		private var createCompleted:Boolean = false;  	
		private var lblSkip:Label;
		private var txtPageIndex:ComboBox;
		
		[Embed(source='assets/img/page/page-first.gif')]
		private var firsticon:Class;
		[Embed(source='assets/img/page/page-first-disabled.gif')]
		private var firstdisicon:Class;
		[Embed(source='assets/img/page/page-prev.gif')]
		private var preicon:Class;
		[Embed(source='assets/img/page/page-prev-disabled.gif')]
		private var predisicon:Class;
		[Embed(source='assets/img/page/page-next.gif')]
		private var nexticon:Class;
		[Embed(source='assets/img/page/page-next-disabled.gif')]
		private var nextdisicon:Class;
		[Embed(source='assets/img/page/page-last.gif')]
		private var lasticon:Class;
		[Embed(source='assets/img/page/page-last-disabled.gif')]
		private var lastdisicon:Class;
		[Embed(source='assets/img/page/refresh.gif')]
		private var reficon:Class;
		[Embed(source='assets/img/page/refresh.gif')]
		private var refdisicon:Class;
		public function PageToolBar()
		{
			super();
			
//			this.layout=HorizontalAlign.RIGHT;
			this.setStyle("horizontalGap",1);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,completeHandler);
		}
		private function completeHandler(evt:FlexEvent):void{
			createCompleted=true;
			setState();
		}
		override protected function createChildren():void{
			super.createChildren();
			btnFirst=new LinkButton();
			btnFirst.enabled=false;
			btnFirst.setStyle("fontFamily","Georgia");
			btnFirst.width=22;
			btnFirst.height=22;
			btnFirst.toolTip=resourceManager.getString('resources','pagebar_firstpage');
			btnFirst.setStyle("icon",firsticon);
			btnFirst.setStyle("disabledIcon",firstdisicon);
			btnFirst.addEventListener(MouseEvent.CLICK,first_handler);
			this.addElement(btnFirst);
			
			btnPrevious=new LinkButton();
			btnPrevious.enabled=false;
			btnPrevious.setStyle("fontFamily","Georgia");
			btnPrevious.width=22;
			btnPrevious.height=22;
			btnPrevious.toolTip=resourceManager.getString('resources','pagebar_prepage');
			btnPrevious.setStyle("icon",preicon);
			btnPrevious.setStyle("disabledIcon",predisicon);
			btnPrevious.addEventListener(MouseEvent.CLICK,previous_handler);
			this.addElement(btnPrevious);
			
			btnNext=new LinkButton();
			btnNext.enabled=false;
			btnNext.setStyle("fontFamily","Georgia");
			btnNext.width=22;
			btnNext.height=22;
			btnNext.toolTip=resourceManager.getString('resources','pagebar_nextpage');
			btnNext.setStyle("icon",nexticon);
			btnNext.setStyle("disabledIcon",nextdisicon);
			btnNext.addEventListener(MouseEvent.CLICK,next_handler);
			this.addElement(btnNext);
			
			btnLast=new LinkButton();
			btnLast.enabled=false;
			btnLast.setStyle("fontFamily","Georgia");
			btnLast.width=22;
			btnLast.height=22;
			btnLast.toolTip=resourceManager.getString('resources','pagebar_lastpage');
			btnLast.setStyle("icon",lasticon);
			btnLast.setStyle("disabledIcon",lastdisicon);
			btnLast.addEventListener(MouseEvent.CLICK,last_handler);
			this.addElement(btnLast);
			
			lblSkip=new Label();
			lblSkip.text="n"+resourceManager.getString('resources','pagebar_row')+"/"+resourceManager.getString('resources','pagebar_row')+"n"+resourceManager.getString('resources','pagebar_page')+","+resourceManager.getString('resources','pagebar_go2pagein');
			lblSkip.setStyle("paddingTop",6);
			this.addElement(lblSkip);
			txtPageIndex=new ComboBox();
			txtPageIndex.width=60;
			txtPageIndex.height=22;
			txtPageIndex.addEventListener(ListEvent.CHANGE,pageSelect_handler);
			this.addElement(txtPageIndex);
			var sl:Label=new Label();
			sl.text=resourceManager.getString('resources','pagebar_page');
			sl.setStyle("paddingTop",6);
			this.addElement(sl);
			
			var ref:LinkButton=new LinkButton();
			ref.setStyle("fontFamily","Georgia");
			ref.width=22;
			ref.height=22;
			ref.toolTip=resourceManager.getString('resources','pagebar_go2pagein')+"{txtPageIndex.text}"+resourceManager.getString('resources','pagebar_page');
			ref.setStyle("icon",reficon);
			ref.setStyle("disabledIcon",refdisicon);
			ref.addEventListener(MouseEvent.CLICK,pageSelect_handler);
			this.addElement(ref);
		}
		/**
		 * 设置每页显示行数
		 */ 
		public function set pageSize(size:int):void {
			if(size<=0){
				throw new Error(resourceManager.getString('resources','pagebar_error_page_count'));
			}
			_pageSize= size;
			if(size >0){
				setState();
			}
		}
		
		/**
		 * 获取每页显示行数
		 */ 
		public function get pageSize():int{
			return _pageSize;
		}   
		
		/**
		 * 设置记录总数
		 */ 
		public function set recordCount(count:int):void {
			_recordCount = count;
			
			if(count >=0){       	
				setState();
			}
		}
		
		/**
		 * 获取记录总数
		 */ 
		public function get recordCount():int{
			return _recordCount;
		}         
		
		/**
		 * 页码
		 */ 
		public function set pageIndex(index:int):void{
			this._pageIndex=index;
			if(index >=0){       	
				setState();
			}
		}   
		
		/**
		 * 页码
		 */ 
		public function get pageIndex():int{
			return _pageIndex;
		}     
		
		/**
		 * 总页数
		 */ 
		public function set pageCount(count:int):void{
			//this._pageCount = count;
			throw new Error(resourceManager.getString('resources','pagebar_error_readonly'));
		} 
		
		/**
		 * 总页数
		 */ 
		public function get pageCount():int{
			return _pageCount;
		}
		
		private function first_handler(e:Event):void{
			_pageIndex =0;
			setState();
			dispatchPageChange();
		}
		
		private function previous_handler(e:Event):void{
			_pageIndex=_pageIndex-1;
			setState();
			dispatchPageChange();
		}
		
		private function next_handler(e:Event):void {
			_pageIndex=_pageIndex+1;
			setState();
			dispatchPageChange();
		}
		
		private function last_handler(e:Event):void {
			_pageIndex=_pageCount-1;
			setState();
			dispatchPageChange();
		}
		
		private function pageSelect_handler(e:Event):void {
			var index:int = parseInt( txtPageIndex.text );
			index -= 1;
			if(index<0){
				Alert.show(resourceManager.getString('resources','pagebar_error_input_num_min'));
				return;
			}
			
			if(index>=_pageCount){
				Alert.show(resourceManager.getString('resources','pagebar_error_input_num_max'));
				return;
			}
			
			_pageIndex = index;
			
			setState();
			dispatchPageChange();
		} 
		
		/**
		 * 刷新当前页面
		 */ 
		private function refresh_handler(e:Event):void {
			dispatchPageChange();
		}
		
		private function setState():void{
			if(!createCompleted){
				return;
			}
			if(_recordCount%_pageSize > 0){
				_pageCount = _recordCount/_pageSize+1;
			}else{
				_pageCount = _recordCount/_pageSize;
			}
			
			if(_pageCount>1){
				btnFirst.enabled=true;
				btnPrevious.enabled=true;
				btnNext.enabled=true;
				btnLast.enabled=true;
				if(_pageIndex==0){
					btnFirst.enabled=false;
					btnPrevious.enabled=false;
				}
				if(_pageIndex == _pageCount-1)  {
					btnNext.enabled=false;
					btnLast.enabled=false;
				}
			} else{
				btnFirst.enabled=false;
				btnPrevious.enabled=false;
				btnNext.enabled=false;
				btnLast.enabled=false;
			}
			
			//设置下拉列表框的长度
			if(_pageCount.toString().length > 1){
				txtPageIndex.width = 2+12*(_pageCount.toString().length-1);
			}
			//n条/页,共n页,跳转
			lblSkip.text ="" +pageSize+ resourceManager.getString('resources','pagebar_row')+"/"+resourceManager.getString('resources','pagebar_page')+","+resourceManager.getString('resources','pagebar_total')+(recordCount<0 ? 0:recordCount)+resourceManager.getString('resources','pagebar_row')+"," +resourceManager.getString('resources','pagebar_total') + _pageCount +resourceManager.getString('resources','pagebar_page') +","+resourceManager.getString('resources','pagebar_go2page') ;
			//		txtPageIndex.text = new String(pageIndex+1);
			var recs:Array=new Array();
			for(var i:int=1;i<=_pageCount;i++){
				recs.push(i);
			}
			txtPageIndex.dataProvider=recs;
			txtPageIndex.selectedIndex=pageIndex;
		}
		
		private function dispatchPageChange():void{
			var pe:PageEvent = new PageEvent(PageEvent.PAGE_CHANGE,_pageIndex,_pageSize,recordCount);
			dispatchEvent(pe);
		}
	}
}