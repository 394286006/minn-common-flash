package p.minn.message
{
	/**
	 * @author minn
	 * @QQ 394286006
	 */
	public class Message
	{
		
		private var _sucess:Boolean;
		private var _messageType:String;
		private var _messageBody:*;
		private var _otherInfo:Object;
		private var _sid:String;
		private var _timestamp:int;
		private var _random:int;
		
		/**
		 * @param messageType 说明messageBody的类型
		 * @param messageBody 信息内容
		 * @param otherInfo 可附带的其它信息
		 */
		public function Message(messageBody:*,messageType:String='0',otherInfo:Object=null)
		{
			this._messageType=messageType;
			this._messageBody=messageBody;
			this._otherInfo=otherInfo;
		}
		
		public function setSecurityInfo(_sid:String,_random:int=0,_timestamp:int=0):void{
			this._random=_random;
			this._sid=_sid;
			this._timestamp=_timestamp;
		}
		
		public function get otherInfo():Object
		{
			return _otherInfo;
		}

		public function set otherInfo(value:Object):void
		{
			_otherInfo = value;
		}

		public function get messageBody():*
		{
			return _messageBody;
		}

		public function set messageBody(value:*):void
		{
			_messageBody = value;
		}

		public function get sucess():Boolean
		{
			return _sucess;
		}

		public function set sucess(value:Boolean):void
		{
			_sucess = value;
		}

		public function get messageType():String
		{
			return _messageType;
		}

		public function set messageType(value:String):void
		{
			_messageType = value;
		}
		
		public function get sid():String
		{
			return _sid;
		}
		
		public function set sid(value:String):void
		{
			_sid = value;
		}
		
		public function get timestamp():int
		{
			return _timestamp;
		}
		
		public function set timestamp(value:int):void
		{
			_timestamp = value;
		}

		public function get random():int
		{
			return _random;
		}
		
		public function set random(value:int):void
		{
			_random = value;
		}

	}
}