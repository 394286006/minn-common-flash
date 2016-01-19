package p.minn.common
{
	import mx.controls.dataGridClasses.DataGridItemRenderer;
	import mx.controls.Alert;
	public class MinnLabel extends DataGridItemRenderer
	{
		public function MinnLabel()
		{
			super();
		}
		override public function set data(value:Object):void 
		{ 
			super.data = value; 
			switch(value._color){
				case '1':
					this.setStyle("color","#FC0303"); 
					break;
				case '2':
					this.setStyle("color","#0C07DF"); 
					break;
				default:
					;
			}
			
			
		}
	}
}