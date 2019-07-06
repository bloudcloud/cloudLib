package extension.cloud.datas
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import cloud.core.collections.CIterator;
	import cloud.core.collections.ICClosedArea;
	import cloud.core.interfaces.ICData;
	import cloud.core.interfaces.ICIterator;
	import cloud.core.interfaces.ICLine;
	import cloud.core.interfaces.ICNodeData;
	import cloud.core.utils.CGPCUtil;
	import cloud.core.utils.CMathUtilForAS;
	import cloud.core.utils.CUtil;

	/**
	 * 2D区域数据
	 * @author	cloud
	 * @date	2018-8-14
	 */
	public class CClosedLine3DArea implements ICClosedArea,ICNodeData
	{
		public static const NORMAL:int=0;
		public static const CREATE:int=1;
		public static const UPDATE:int=2;
		
		private var _uniqueID:String;
		private var _type:uint;
		private var _area:Number;
		private var _roundPoints:Vector.<Number>;
		private var _normal:Vector3D;
		private var _center:Vector3D;
		/**
		 * 是否负向旋转 
		 */		
		private var _isNegtive:Boolean;
		private var _stateType:int;
		/**
		 * 凹角索引 
		 */		
		private var _concaveIndice:Array;
		/**
		 * 凸角索引 
		 */		
		private var _convexIndice:Array;
		/**
		 * 耳尖索引 
		 */		
		private var _lobeIndice:Array;
		/**
		 * 顶点的数量 
		 */		
		private var _numVertices:int;
		/**
		 * 迭代器节点 
		 */		
		private var _iterator:ICIterator;
		
		public function get iterator():ICIterator
		{
			return _iterator;
		}

		public function get isExit():Boolean
		{
			return _roundPoints.length>9;
		}
		public function get concaveIndice():Array
		{
			return _concaveIndice;
		}
		public function get convexIndice():Array
		{
			return _convexIndice;
		}
		public function get lobeIndice():Array
		{
			return _lobeIndice;
		}
		public function get numVertices():int
		{
			return _numVertices;
		}
		public function get uniqueID():String
		{
			return _uniqueID;
		}
		public function get type():uint
		{
			return _type;
		}
		public function set type(value:uint):void
		{
			_type=value;
		}
		public function get area():Number
		{
			return _area;
		}

		public function get roundPoints():Vector.<Number>
		{
			return _roundPoints;
		}
		
		public function get normal():Vector3D
		{
			return _normal;
		}
		
		public function get isNegtive():Boolean
		{
			return _isNegtive;
		}
		
		public function get center():Vector3D
		{
			return _center;
		}
		public function get stateType():int
		{
			return _stateType;
		}
		public function set stateType(value:int):void
		{
			_stateType=value;
		}
		
		public function CClosedLine3DArea(lineDatas:Vector.<ICLine>,areaID:String=null)
		{
			_center=new Vector3D();
			if(areaID)
			{
				_uniqueID=areaID;
			}
			else
			{
				_uniqueID=CUtil.Instance.createUID();
			}
			_concaveIndice=[];
			_convexIndice=[];
			_lobeIndice=[];
			initArea(lineDatas);
		}
		private function doInitRoundPointsByLines(lineDatas:Vector.<ICLine>):void
		{
			var curIterator:ICIterator;
			
			_roundPoints.length=0;
			_numVertices=lineDatas.length;
			for(var i:int=0; i<_numVertices; i++)
			{
				if(curIterator)
				{
					curIterator.linkToNext(new CIterator(i));
					curIterator=curIterator.next;
				}
				else
				{
					curIterator=_iterator=new CIterator(i);
				}
				_roundPoints.push(lineDatas[i].start.x,lineDatas[i].start.y,lineDatas[i].start.z);
			}
			curIterator.linkToNext(_iterator);
		}
		private function doInitRoundPointsByValues(tmpPoints:Vector.<Number>):void
		{
			var i:int,len:int;
			var curIterator:ICIterator;
			
			_roundPoints.length=0;
			len=tmpPoints.length/3;
			_numVertices=len;
			for(i=0; i<_numVertices; i++)
			{
				if(curIterator)
				{
					curIterator.linkToNext(new CIterator(i));
					curIterator=curIterator.next;
				}
				else
				{
					curIterator=_iterator=new CIterator(i);
				}
				_roundPoints.push(tmpPoints[i*3],tmpPoints[i*3+1],tmpPoints[i*3+2]);
			}
			curIterator.linkToNext(_iterator);
		}
		private function doInitOthers():void
		{
			_center=CMathUtilForAS.Instance.getCenter3DByRoundPointsValue(_roundPoints);
			_area=CMathUtilForAS.Instance.calculateClosureGraph3DArea(_roundPoints,3);
			_normal=CMathUtilForAS.Instance.getPointsPlanNormalVec(_roundPoints,false);
			_normal.normalize();
			var matrix:Matrix3D=new Matrix3D();
			matrix.copyColumnFrom(0,CMathUtilForAS.XAXIS_POS);
			matrix.copyColumnFrom(1,CMathUtilForAS.YAXIS_POS);
			matrix.copyColumnFrom(2,_normal);
			var invertMatrix:Matrix3D=matrix.clone();
			invertMatrix.invert();
			_concaveIndice.length=0;
			_convexIndice.length=0;
			_lobeIndice.length=0;
			CGPCUtil.Instance.calculateGraphy3DPoints(_roundPoints,invertMatrix,_convexIndice,_concaveIndice,_lobeIndice);
			_isNegtive=_normal.z<0?true:false;
		}
		public function initArea(lineDatas:Vector.<ICLine>):void
		{
			_roundPoints||=new Vector.<Number>();
			doInitRoundPointsByLines(lineDatas);
			doInitOthers();
		}
		public function initAreaByRound3DPoints(tmpPoints:Vector.<Number>):void
		{
			doInitRoundPointsByValues(tmpPoints);
			doInitOthers();
		}
		/**
		 * 删除闭合区域结构
		 * 
		 */		
		public function dispose():void
		{
			_area=0;
			_normal=null;
			_roundPoints.length=0;
			_roundPoints=null;
			if(_iterator)
			{
				_iterator.unlink();
				_iterator=null;
			}
			_concaveIndice=null;
			_convexIndice=null;
			_lobeIndice=null;
		}
		/**
		 * 更新区域ID 
		 * @param value
		 * 
		 */		
		public function updateAreaID(value:String):void
		{
			if(value && value.length)
			{
				_uniqueID=value;
			}
		}
		public function clone():ICData
		{
			return null;
		}
		public function compare(source:ICData):Number
		{
			return 0;
		}
		public function toString():String
		{
			return null;
		}
	}
}
