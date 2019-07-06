package extension.cloud.datas
{
	import flash.display.BitmapData;
	
	import extension.cloud.interfaces.ICOutputImageData;
	
	/**
	 * 出图数据类
	 * @author	cloud
	 * @date	2018-5-2
	 */
	public class COutputImageData implements ICOutputImageData
	{
		private var _type:uint;
		private var _code:String;
		private var _preview:BitmapData;
		private var _svg:XML;
		private var _point3Ds:Vector.<Number>;
		private var _indices:Vector.<int>;
		private var _uvs:Vector.<Number>;
		private var _children:Vector.<ICOutputImageData>;
		
		public function get point3Ds():Vector.<Number>
		{
			return _point3Ds;
		}

		public function get type():uint
		{
			return _type;
		}
		public function get code():String
		{
			return _code;
		}
		
		public function get preview():BitmapData
		{
			return _preview;
		}
		
		public function get svg():XML
		{
			return _svg;
		}
		
		public function get indices():Vector.<int>
		{
			return _indices;
		}
		
		public function get uvs():Vector.<Number>
		{
			return _uvs;
		}
		
		public function get children():Vector.<ICOutputImageData>
		{
			return _children;
		}
		
		public function COutputImageData(type:uint,code:String,point3Ds:Array,indices:Array,uvs:Array,preview:BitmapData,svg:XML)
		{
			_type=type;
			_code=code;
			_point3Ds=new Vector.<Number>();
			_indices=new Vector.<int>();
			_uvs=new Vector.<Number>();
			_children=new Vector.<ICOutputImageData>();
			_preview=preview;
			_svg=svg;
			var len:int=point3Ds.length;
			var count:int=0;
			for(var i:int=0; i<len; i++)
			{
				_point3Ds.push(point3Ds[i].x,point3Ds[i].y,point3Ds[i].z);
			}
			len=indices.length;
			for(i=0; i<len; i++)
			{
				_indices.push(indices[i]);
			}
			len=uvs.length;
			for(i=0; i<len; i++)
			{
				_uvs.push(uvs[i]);
			}
		}
		
		public function addChildData(child:ICOutputImageData):void
		{
			if(_children.indexOf(child)<0)
			{
				_children.push(child);
			}
		}
		public function removeChildData(child:ICOutputImageData):void
		{
			var idx:int=_children.indexOf(child);
			if(idx>=0)
			{
				_children.removeAt(idx);
			}
		}
	}
}