package clapboardCode.sdObject
{
	import flash.geom.Point;

	public class PartitionArea
	{
		private  var _areaVector:Array = [
											[new Point(1100,0),new Point(1100,1100),new Point(2200,1100),new Point(2200,0)],
											[new Point(3300,0),new Point(3300,1100),new Point(4000,1100),new Point(4000,0)],
											,
										];
		public function PartitionArea()
		{
		}
		public function set areaVector(obj:Array):void
		{
			_areaVector =obj;	
		}
		public function get areaVector():Array
		{
			return _areaVector;	
		}
		//按顺序得到每一个的原点
		public function getPartOrigPoint(obj:Array):Array
		{
			if(obj.length ==0) return null;
			var origpoint:Array = new Array();
			for(var i:int =0;i<obj.length;i++)
			{
				origpoint.push(obj[i][0]);
			}
			return origpoint;
		}
		//判断选中的点是否处于某个区域
		public function getAreaByMouse(mousex:Number,mousey:Number):int
		{
			if(_areaVector.length ==0)
				return 0;
			for(var i:int =0;i<_areaVector.length;i++)
			{
				var a:Array = _areaVector[i] as Array;
				if(a == null ||　a.length < 3)return 100;
				if(mousex > a[0].x&&mousex < a[1].x)
				{
					if(mousey > a[1].y&&mousex < a[3].y)
					{
						return i;
					}						
				}
			}
			return 100;
		}
	}
}