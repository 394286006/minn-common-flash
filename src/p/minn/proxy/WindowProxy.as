package p.minn.proxy
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.net.LocalConnection;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import flexmdi.containers.MDICanvas;
	import flexmdi.containers.MDIWindow;
	import flexmdi.managers.MDIManager;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.Image;
	import mx.controls.ProgressBar;
	import mx.controls.ProgressBarMode;
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.effects.Fade;
	import mx.effects.Move;
	import mx.effects.Zoom;
	import mx.events.CloseEvent;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	import mx.events.ModuleEvent;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	import mx.managers.SystemManager;
	import mx.modules.IModuleInfo;
	import mx.modules.Module;
	import mx.modules.ModuleLoader;
	import mx.modules.ModuleManager;
	import mx.styles.StyleManager;
	
	import p.minn.event.MinnMessageEvent;
	import p.minn.event.MinnMessageEventManager;
	import p.minn.message.Message;
	
	import spark.components.ButtonBar;
	import spark.components.TitleWindow;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.skins.spark.TitleWindowSkin;
	
	
	/**
	 * @author minn
	 * @QQ 394286006
	 */
	public class WindowProxy
	{
		private static const windows:ArrayCollection=new ArrayCollection();
		private static const persistentwindows:ArrayCollection=new ArrayCollection();
		
		private static var windowProxy:WindowProxy=null;
		[Embed(source="assets/assets.swf", symbol="firefox_close_up")]
		private static var DEFAULT_CLOSE_UP:Class;
		
		[Embed(source="assets/assets.swf", symbol="firefox_close_over")]
		private static var DEFAULT_CLOSE_OVER:Class;
		
		[Embed(source="assets/assets.swf", symbol="firefox_close_down")]
		private static var DEFAULT_CLOSE_DOWN:Class;
		
		[Embed(source="assets/assets.swf", symbol="firefox_close_disabled")]
		private static var DEFAULT_CLOSE_DISABLED:Class;
		
		[Embed(source="assets/assets.swf", symbol="left_arrow")]
		private static var DEFAULT_LEFT_BUTTON:Class;
		
		[Embed(source="assets/assets.swf", symbol="right_arrow")]
		private static var DEFAULT_RIGHT_BUTTON:Class;
		[Bindable] 
		[Embed("assets/img/page/wait.gif")] 
		private var c:Class; 
		
		
		[Bindable]   
		[Embed("assets/img/page/done.gif")] 
		private var c1:Class; 
		[Bindable] 
		[Embed("assets/loading.swf")] 
		private var c2:Class; 
		private var progressBar:Image
		
		private static var timer:Timer=new Timer(60000);
		
		private static var _mdi:MDICanvas=null;
		private var fade:Fade=new Fade();
		private var zoom:Zoom=new Zoom();
		private var move:Move=new Move();
		private var point:Point=new Point(0,0);
		public function WindowProxy()
		{
			
			progressBar=new Image();
			progressBar.source=c2;
		}
		
		public static function getInstance(mdi:MDICanvas=null):WindowProxy{
			
			if(windowProxy==null)
			{
				windowProxy=new WindowProxy();
				_mdi=mdi;
			}
			return windowProxy;
		}
		
		public  function getMdiWindow(url:String,bytes:ByteArray,data:Object=null,persistent:Boolean=false,w:Number=600,h:Number=400):flexmdi.containers.MDIWindow{
			var mw:MDIWindow=null;
			for(var i:int=0;i<persistentwindows.length;i++){
				if(persistentwindows[i].url==url){
					mw=persistentwindows[i].uid as MDIWindow;
				}
			}
		
			if(mw==null){
			 mw=new MDIWindow();
			mw.height=h;
			mw.width=w;
			mw.titleIcon=c;
			mw.setStyle("paddingTop",3);
			var ml:ModuleLoader=new ModuleLoader();
		
			PopUpManager.addPopUp(progressBar,FlexGlobals.topLevelApplication as DisplayObject,false);
			PopUpManager.centerPopUp(progressBar);
			mw.addEventListener(FlexEvent.CREATION_COMPLETE,function():void{
				timer.addEventListener(TimerEvent.TIMER,function():void{
					Alert.okLabel="稍后加载";
					Alert.cancelLabel="继续加载";
					Alert.show("由于网络问题，加载时间太长，\n请选择网络好的时候再加载！","提示",Alert.OK|Alert.CANCEL,null,function(e:CloseEvent):void{
						if(e.detail==Alert.OK){
							PopUpManager.removePopUp(progressBar);
							ml.removeEventListener(ModuleEvent.READY,function():void{});
							ml.unloadModule();
							mw.removeAllChildren();
//							mw.removeAllElements();
							try{
							_mdi.removeChild(mw);
							}catch(e:Error){
								
							}
							removeWinow(url);
							timer.removeEventListener(TimerEvent.TIMER,function():void{});
							
						 }else{
							timer.start();
						}
						
					});
				});
				timer.start();
				
					ml.percentHeight=100;
					ml.percentWidth=100;
					ml.x=50
					ml.addEventListener(ModuleEvent.READY,function(e:ModuleEvent):void{
						mw.title=ml.child.name;
//						mw.percentHeight=100;
//						mw.percentWidth=100;
//						mw.height=ml.height;
//						mw.width=ml.width;
						
						PopUpManager.removePopUp(progressBar);
						mw.titleIcon=c1;
						if(persistent){
							persistentwindows.addItem({url:url,uid:mw});
						}else
						    windows.addItem({url:url,uid:mw});
						timer.stop();
						timer.removeEventListener(TimerEvent.TIMER,function():void{});
						ml.child.addEventListener(FlexEvent.CREATION_COMPLETE,function():void{
						 if(data!=null)
							sendMessage(new MinnMessageEvent(mw.getChildAt(0).toString()+MinnMessageEvent.CREATIONCOMPLETE_MESSAGE,data,true));
						});
			              });
					mw.addChild(ml);
					ml.loadModule(url,bytes);
//					appFacade.startup(cmd,mw);
				
			});
			
			mw.addEventListener(CloseEvent.CLOSE,function():void{
				
//				PopUpManager.removePopUp(progressBar);
//				ml.removeEventListener(ModuleEvent.READY,function():void{});
				if(!persistent){
					ml.unloadModule();
	//				mw.removeAllChildren();
					mw.removeAllElements();
					MDIManager.global.remove(mw);
	//				_mdi.removeChild(mw);
					removeWinow(url);
				}else{
//					mw.visible=false;
					_mdi.windowManager.remove(mw);
				}
				
			});
			_mdi.windowManager.addCenter(mw);
			effectStart(mw,false);
			}else{
			
//				mw.visible=true;
				_mdi.windowManager.addCenter(mw);
//				_mdi.windowManager.bringToFront(mw);
			}
			
			return mw;
		}
		public  function getLoginTitleWindow(url:String,bytes:ByteArray,data:Object=null,parent:Object=null,showCloseButon:Boolean=false,w:Number=400,h:Number=300):mx.containers.TitleWindow{
			var tw:mx.containers.TitleWindow=new mx.containers.TitleWindow();
			//			tw.width=w;
			//			tw.height=h;
			tw.titleIcon=c;
			tw.showCloseButton=showCloseButon;
			var ml:ModuleLoader=new ModuleLoader();
			PopUpManager.addPopUp(progressBar,FlexGlobals.topLevelApplication as DisplayObject,false);
			PopUpManager.centerPopUp(progressBar);
			
			tw.addEventListener(FlexEvent.CREATION_COMPLETE,function():void{
				timer.addEventListener(TimerEvent.TIMER,function():void{
					Alert.okLabel="退出";
					Alert.cancelLabel="继续加载";
					Alert.show("由于网络问题，加载时间太长，\n请选择网络好的时候再加载！","提示",Alert.OK|Alert.CANCEL,null,function(e:CloseEvent):void{
						if(e.detail==Alert.OK){
							
							ml.removeEventListener(ModuleEvent.READY,function():void{});
							ml.unloadModule();
							tw.removeAllChildren();
							tw.removeAllElements();
							PopUpManager.removePopUp(tw);
							removeWinow(url);
							timer.removeEventListener(TimerEvent.TIMER,function():void{});
							PopUpManager.removePopUp(progressBar);
							ExternalInterface.call("window.close()");
						}else{
							timer.start();
						}
						
					});
				});
				
				timer.start();
				//				ml.percentHeight=100;
				//				ml.percentWidth=100;
				ml.addEventListener(ModuleEvent.READY,function():void{
				
					tw.title=ml.child.name;
					PopUpManager.removePopUp(progressBar);
					tw.titleIcon=c1;
					windows.addItem({url:url,uid:tw});
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER,function():void{});
					ml.child.addEventListener(FlexEvent.CONTENT_CREATION_COMPLETE,function():void{
						if(data!=null)
							sendMessage(new MinnMessageEvent(tw.getChildAt(0).toString()+MinnMessageEvent.CREATIONCOMPLETE_MESSAGE,data,true));
						move.xTo=(parent as DisplayObject).width/2-ml.child.width/2;//x+tw.width;
						move.yTo=(parent as DisplayObject).height/2-ml.child.height/2;//y-tw.width;
						move.play([tw]);
					});
				});
				
				tw.addElement(ml);
				
				ml.loadModule(url,bytes);
			});
			
			tw.addEventListener(CloseEvent.CLOSE,function():void{
				PopUpManager.removePopUp(progressBar);
				ml.removeEventListener(ModuleEvent.READY,function():void{});
				ml.unloadModule();
				tw.removeAllChildren();
				tw.removeAllElements();
				PopUpManager.removePopUp(tw);
				removeWinow(url);
			});
			
			if(parent==null)
				parent=FlexGlobals.topLevelApplication;
			//PopUpManager.addPopUp(tw,parent  as DisplayObject,true,null,parent.moduleFactory);
					//PopUpManager.centerPopUp(tw);
			
			
			effectStart(tw);
			
			return tw;
		}
		
		public  function getTitleWindow(url:String,bytes:ByteArray,data:Object=null,parent:Object=null,showCloseButon:Boolean=false,w:Number=400,h:Number=300):mx.containers.TitleWindow{
			var tw:mx.containers.TitleWindow=new mx.containers.TitleWindow();
//			tw.width=w;
//			tw.height=h;
			tw.titleIcon=c;
			tw.showCloseButton=showCloseButon;
			var ml:ModuleLoader=new ModuleLoader();
			
			PopUpManager.addPopUp(progressBar,FlexGlobals.topLevelApplication as DisplayObject,false);
			PopUpManager.centerPopUp(progressBar);
			tw.addEventListener(FlexEvent.CREATION_COMPLETE,function():void{
				timer.addEventListener(TimerEvent.TIMER,function():void{
					Alert.okLabel="稍后加载";
					Alert.cancelLabel="继续加载";
					Alert.show("由于网络问题，加载时间太长，\n请选择网络好的时候再加载！","提示",Alert.OK|Alert.CANCEL,null,function(e:CloseEvent):void{
						if(e.detail==Alert.OK){
							
							ml.removeEventListener(ModuleEvent.READY,function():void{});
							ml.unloadModule();
							tw.removeAllChildren();
							tw.removeAllElements();
							PopUpManager.removePopUp(tw);
							removeWinow(url);
							timer.removeEventListener(TimerEvent.TIMER,function():void{});
							PopUpManager.removePopUp(progressBar);
						}else{
							timer.start();
						}
						
					});
				});
				timer.start();
//				ml.percentHeight=100;
//				ml.percentWidth=100;
				ml.addEventListener(ModuleEvent.READY,function():void{
				tw.title=ml.child.name;
				PopUpManager.removePopUp(progressBar);
				tw.titleIcon=c1;
					windows.addItem({url:url,uid:tw});
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER,function():void{});
					ml.child.addEventListener(FlexEvent.CONTENT_CREATION_COMPLETE,function():void{
						if(data!=null)
						sendMessage(new MinnMessageEvent(tw.getChildAt(0).toString()+MinnMessageEvent.CREATIONCOMPLETE_MESSAGE,data,true));
						move.xTo=(parent as DisplayObject).width/2-ml.child.width/2;//x+tw.width;
						move.yTo=(parent as DisplayObject).height/2-ml.child.height/2;//y-tw.width;
						move.play([tw]);
					});
				});
				tw.addElement(ml);
				ml.loadModule(url,bytes);
			});
			
			tw.addEventListener(CloseEvent.CLOSE,function():void{
				PopUpManager.removePopUp(progressBar);
				ml.removeEventListener(ModuleEvent.READY,function():void{});
				ml.unloadModule();
				tw.removeAllChildren();
				tw.removeAllElements();
				PopUpManager.removePopUp(tw);
				removeWinow(url);
			});
			if(parent==null)
				parent=FlexGlobals.topLevelApplication;
			PopUpManager.addPopUp(tw,parent  as DisplayObject,true,null,parent.moduleFactory);
//			PopUpManager.centerPopUp(tw);
			
		
			effectStart(tw);
			
			return tw;
		}
		private function sendMessage(e:MinnMessageEvent):void{
			FlexGlobals.topLevelApplication.dispatchEvent(e);
		}
		public  function getSpTitleWindow(url:String,bytes:ByteArray,data:Object=null,parent:Object=null,iscenter:Boolean=true,x:Number=400,y:Number=300):spark.components.TitleWindow{
			var tw:spark.components.TitleWindow=new spark.components.TitleWindow();
//			tw.width=w;
//			tw.height=h;
			tw.alpha=0;
//			tw.setStyle("backgroundColor","#1ff2ff");
//			tw.setStyle("backgroundAlpha",0);
//			tw.setStyle("color","#f2f3ff");
			var ml:ModuleLoader=new ModuleLoader();
			PopUpManager.addPopUp(progressBar,FlexGlobals.topLevelApplication as DisplayObject,false);
			PopUpManager.centerPopUp(progressBar);
			tw.addEventListener(FlexEvent.CREATION_COMPLETE,function():void{
				timer.addEventListener(TimerEvent.TIMER,function():void{
					Alert.okLabel="稍后加载";
					Alert.cancelLabel="继续加载";
					Alert.show("由于网络问题，加载时间太长，\n请选择网络好的时候再加载！","提示",Alert.OK|Alert.CANCEL,null,function(e:CloseEvent):void{
						if(e.detail==Alert.OK){
							PopUpManager.removePopUp(progressBar);
							ml.removeEventListener(ModuleEvent.READY,function():void{});
							ml.unloadModule();
							tw.removeAllElements();
							PopUpManager.removePopUp(tw);
							removeWinow(url);
							timer.removeEventListener(TimerEvent.TIMER,function():void{});
						
						}else{
							timer.start();
						}
						
					});
				});
				timer.start();
//				ml.percentHeight=100;
//				ml.percentWidth=100;
				ml.addEventListener(ModuleEvent.READY,function(e:ModuleEvent):void{
					tw.title=ml.child.name;
//					tw.width=ml.child.width;
//					tw.height=ml.child.height;
//					tw.titleDisplay.width=ml.child.width;
//					tw.titleDisplay.height=ml.child.height;
					
					PopUpManager.removePopUp(progressBar);
					windows.addItem({url:url,uid:tw});
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER,function():void{});
					ml.child.addEventListener(FlexEvent.CONTENT_CREATION_COMPLETE,function():void{
//						Alert.show(tw.getChildAt(0).toString());
						                 if(data!=null)
											sendMessage(new MinnMessageEvent(tw.getChildAt(0).toString()+MinnMessageEvent.CREATIONCOMPLETE_MESSAGE,data,true));
										});
					 
					move.xTo=(parent as DisplayObject).width/2-ml.child.width/2;//x+tw.width;
					move.yTo=(parent as DisplayObject).height/2-ml.child.height/2;//y-tw.width;
					move.play([tw]);
				});
	
				tw.addElement(ml);
				ml.loadModule(url,bytes);
			});
			ml.addEventListener(ModuleEvent.UNLOAD,function():void{
				
			});
			tw.addEventListener(CloseEvent.CLOSE,function():void{
				PopUpManager.removePopUp(progressBar);
				ml.removeEventListener(ModuleEvent.READY,function():void{});
				ml.unloadModule();
				tw.removeAllElements();
				fade.stop();
				zoom.stop();
//				p=new Point(0,0);
				move.duration=500;
				
				move.xTo=point.x;//x+tw.width;
				move.yTo=point.y;//y-tw.width;
				move.play([tw]);
				
//				var zoom:Zoom=new Zoom();
				zoom.duration=500;
				zoom.zoomWidthTo=0.0;
				zoom.zoomHeightTo=0.0;
				zoom.play([tw]);
//				var fade:Fade=new Fade();
				fade.duration=500;
				fade.alphaFrom=1;
				fade.alphaTo=0;
				fade.play([tw]);
				move.addEventListener(EffectEvent.EFFECT_END,function():void{
					PopUpManager.removePopUp(tw);
					removeWinow(url);
					if(move!=null)
					   move.targets=[];
					if(fade!=null)
					fade.targets=[];
					if(zoom!=null)
					zoom.targets=[];
				});
			});
//			tw.addEventListener(FlexEvent.CREATION_COMPLETE
//			
//			var ml:IModuleInfo=ModuleManager.getModule(url);	
//			ml.addEventListener(ModuleEvent.SETUP,function(e:ModuleEvent):void{
////				Alert.show('start');
////				tw.width=e.module.
//			});
//			ml.addEventListener(ModuleEvent.READY,function(e:ModuleEvent):void{
////				Alert.show((ml.factory==null).toString());
//				var m:Module=ml.factory.create() as Module;
//				tw.width=m.width;
//				tw.height=m.height;
//				m.addEventListener(FlexEvent.CREATION_COMPLETE,function():void{
////					Alert.show(FlexGlobals.topLevelApplication.hasEventListener(OperatorEvent.OPERATOR_LOGIN_TT));
//					tw.dispatchEvent(new OperatorEvent(OperatorEvent.OPERATOR_LOGIN_TT,null,true));
//				})
//				tw.addElement(m);
//			});
////			
//			ml.load();
//			Alert.show((ml.factory==null).toString());
//		   
//			m.addEventListener(ModuleEvent.READY,function(e:ModuleEvent):void{
//			
//				tw.addChild(m);
//			});
	       //tw.visible=false;
			if(parent==null&&_mdi==null)
				parent=FlexGlobals.topLevelApplication;
//			FlexGlobals.topLevelApplication.hasEventListener(OperatorEvent.OPERATOR_LOGIN_TT)
			if(_mdi!=null)
				parent=_mdi;
			PopUpManager.addPopUp(tw,parent as DisplayObject,true,null,parent.moduleFactory);
			
			if(iscenter){
				PopUpManager.centerPopUp(tw);
			}else{
			
//			Alert.show((x-tw.width).toString()+":"+x.toString());
				if(x+tw.width>1024)
					tw.x=x-2*tw.width-10;
				else 
					tw.x=x;
				tw.y=y;
			}
			effectStart(tw);
//			var clazz:Class = getDefinitionByName("skip.TitleWindowSkinClass") as Class;
			
//			tw.setStyle("skinClass", clazz);
//			Alert.show(tw.getChildAt(0).toString());
			return tw;
		}
		
		public  function getModuleWindow(url:String,data:Object=null,parent:Object=null,mdu:Boolean=true,x:Number=400,y:Number=300):ModuleLoader{
//			var tw:spark.components.TitleWindow=new spark.components.TitleWindow();
			//			tw.width=w;
			//			tw.height=h;
//			tw.alpha=0;
			
			//			tw.setStyle("backgroundColor","#1ff2ff");
			//			tw.setStyle("backgroundAlpha",0);
			//			tw.setStyle("color","#f2f3ff");
			var ml:ModuleLoader=new ModuleLoader();
//			PopUpManager.addPopUp(progressBar,FlexGlobals.topLevelApplication as DisplayObject,false);
//			PopUpManager.centerPopUp(progressBar);
//			tw.addEventListener(FlexEvent.CREATION_COMPLETE,function():void{
//				timer.addEventListener(TimerEvent.TIMER,function():void{
//					Alert.okLabel="稍后加载";
//					Alert.cancelLabel="继续加载";
//					timer.stop();
//					Alert.show("由于网络问题，加载时间太长，\n请选择网络好的时候再加载！","提示",Alert.OK|Alert.CANCEL,null,function(e:CloseEvent):void{
//						if(e.detail==Alert.OK){
//							ml.removeEventListener(ModuleEvent.READY,function():void{});
//							ml.unloadModule();
//							tw.removeAllElements();
//							PopUpManager.removePopUp(tw);
//							removeWinow(url);
//							timer.removeEventListener(TimerEvent.TIMER,function():void{});
//							PopUpManager.removePopUp(progressBar);
//						}else{
//							timer.start();
//						}
//						
//					});
//				});
//				timer.start();
				//				ml.percentHeight=100;
				//				ml.percentWidth=100;
				ml.addEventListener(ModuleEvent.READY,function(e:ModuleEvent):void{
//					tw.title=ml.child.name;
					//					tw.width=ml.child.width;
//					tw.titleDisplay.width=ml.child.width;
//					tw.titleDisplay.height=ml.child.height;
					//					tw.height=ml.child.height;
//					PopUpManager.removePopUp(progressBar);
				  
					
					windows.addItem({url:url,uid:ml});
//					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER,function():void{});
					ml.child.addEventListener(FlexEvent.CONTENT_CREATION_COMPLETE,function():void{
						ml.x=(parent.screen.width-ml.child.loaderInfo.width)/2;
						ml.y=(parent.screen.height-ml.child.loaderInfo.height)/2;
						
//						Alert.show(ml.child.loaderInfo.width.toString());
//												Alert.show(ml.toString());
//												trace("winproxy:"+ml.toString());
						if(data!=null)
							sendMessage(new MinnMessageEvent(ml.toString()+MinnMessageEvent.CREATIONCOMPLETE_MESSAGE,data,true));
					});
				});
				
//				tw.addElement(ml);
				ml.loadModule(url);
				
//			});
			ml.addEventListener(ModuleEvent.UNLOAD,function():void{
				PopUpManager.removePopUp(ml);
			});
		
			ml.addEventListener(CloseEvent.CLOSE,function():void{
				PopUpManager.removePopUp(progressBar);
				ml.removeEventListener(ModuleEvent.READY,function():void{});
				ml.unloadModule();
//				tw.removeAllElements();
//				fade.stop();
//				zoom.stop();
//				//				p=new Point(0,0);
//				move.duration=500;
//				
//				move.xTo=p.x;//x+tw.width;
//				move.yTo=p.y;//y-tw.width;
//				move.play([tw]);
//				
//				//				var zoom:Zoom=new Zoom();
//				zoom.duration=500;
//				zoom.zoomWidthTo=0.0;
//				zoom.zoomHeightTo=0.0;
//				zoom.play([tw]);
//				//				var fade:Fade=new Fade();
//				fade.duration=500;
//				fade.alphaFrom=1;
//				fade.alphaTo=0;
//				fade.play([tw]);
//				move.addEventListener(EffectEvent.EFFECT_END,function():void{
					PopUpManager.removePopUp(ml);
//					MDIManager.global.remove(ml);
					removeWinow(url);
//					if(move!=null)
//						move.targets=[];
//					if(fade!=null)
//						fade.targets=[];
//					if(zoom!=null)
//						zoom.targets=[];
//				});
			});
			
			if(parent==null)
				parent=FlexGlobals.topLevelApplication;
			//			FlexGlobals.topLevelApplication.hasEventListener(OperatorEvent.OPERATOR_LOGIN_TT)
			
			PopUpManager.addPopUp(ml,parent as DisplayObject,mdu,null,parent.moduleFactory);
//						PopUpManager.centerPopUp(ml);
//			effectStart(tw);
			//			Alert.show((x-tw.width).toString()+":"+x.toString());
//			if(x+tw.width>1024)
//				tw.x=x-2*tw.width-10;
//			else 
//				tw.x=x;
//			tw.y=y;
			
			
		
			return ml;
		}
		
		private function effectStart(obj:*,iszoom:Boolean=false):void{
			fade.stop();
			zoom.stop();
			fade.targets=[];
			zoom.targets=[];
			fade.duration=2500;
			fade.alphaFrom=0;
			fade.alphaTo=1;
			fade.play([obj]);
			zoom.duration=2000;
			zoom.zoomWidthTo=1.1;
			zoom.zoomHeightTo=1.1;
			if(iszoom)
			zoom.play([obj]);
			
		}
		
		public function checkExistWindow(url:String):*{
			for(var i:int=0;i<windows.length;i++){
				var objw:Object=windows[i];
				if(objw.url==url)
					return objw.uid;
			}
			return null;
		}
		
		private function removeWinow(url:String=null):void{
			if(url!=null){
				for(var i:int=0;i<windows.length;i++){
					var objw:Object=windows.getItemAt(i);
					if(objw.url==url){
						windows.removeItemAt(i);
					}
				}
			}else{
				windows.removeAll();
			}
			try
			{
			if(windows.length%3==0||windows.length==0){
				var lc1:LocalConnection = new LocalConnection();
				var lc2:LocalConnection = new LocalConnection();
				lc1.connect( "gcConnection" );
				lc2.connect( "gcConnection" );
			}
			}
			catch (e:Error)
			{
			}
		}
		
		public function showAllWindow():void{
			_mdi.windowManager.cascade();
		}
		public function bring2frong(mdi:MDIWindow):void{
			_mdi.windowManager.bringToFront(mdi);
		}
		public function removeAllWindow():void{
			for(var i:int=0;i<windows.length;i++){
				var objw:Object=windows.getItemAt(i);
				PopUpManager.removePopUp(objw.uid as IFlexDisplayObject);
			}
			_mdi.windowManager.removeAll();
			removeWinow();
		}
	}
}