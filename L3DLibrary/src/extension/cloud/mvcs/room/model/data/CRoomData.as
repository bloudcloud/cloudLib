package extension.cloud.mvcs.room.model.data
{
	import extension.cloud.dict.CL3DConstDict;
	import extension.cloud.mvcs.base.model.CBaseL3DData;

	/**
	 * 房间数据类
	 * @author	cloud
	 * @date	2018-5-19
	 */
	public class CRoomData extends CBaseL3DData
	{
		private var _roomPoint3DValues:Vector.<Number>;
		private var _offGround:Number;
		private var _roomHeight:Number;
		private var _area:Number;

		public function get roomPoint3DValues():Vector.<Number>
		{
			return _roomPoint3DValues;
		}
		public function set roomPoint3DValues(value:Vector.<Number>):void
		{
			_roomPoint3DValues=value;
		}
		public function get offGround():Number
		{
			return _offGround;
		}
		public function set offGround(value:Number):void
		{
			_offGround=value;
		}
		public function get roomHeight():Number
		{
			return _roomHeight;
		}
		public function set roomHeight(value:Number):void
		{
			_roomHeight=value;
		}
		public function get area():Number
		{
			return _area;
		}
		public function set area(value:Number):void
		{
			_area=value;
		}
		/**
		 * 获取房间内墙面的数量 
		 * @return int
		 * 
		 */		
		public function get wallNum():int
		{
			return _roomPoint3DValues?_roomPoint3DValues.length/3:0;
		}
		
		public function CRoomData(clsName:String,uniqueID:String)
		{
			super(clsName,uniqueID)
			_offGround=0;
			_area=0;
			_roomHeight=CL3DConstDict.DEFAULT_WALL_HEIGHT;
		}
		override public function updateByData(data:CBaseL3DData):void
		{
			super.updateByData(data);
			if(data is CRoomData)
			{
				var roomData:CRoomData=data as CRoomData;
				this.offGround=roomData.offGround;
				this.roomHeight=roomData.roomHeight;
				this.area=roomData.area;
				this.roomPoint3DValues=roomData.roomPoint3DValues;
			}
		}
	}
}