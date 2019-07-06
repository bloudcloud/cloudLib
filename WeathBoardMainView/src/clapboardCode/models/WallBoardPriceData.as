package clapboardCode.models
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	

	public class WallBoardPriceData
	{
		private var _code:String;
		private var _type:String;
		private var _name:String;
		private var _material:String;
		private var _length:Number;
		private var _width:Number;
		private var _height:Number;
		private var _price:Number;
		private var _previewBuffer:ByteArray;
		private var _size:Vector3D;

		public function get material():String
		{
			return _material;
		}

		public function set material(value:String):void
		{
			_material = value;
		}

		public function get code():String
		{
			return _code;
		}

		public function set code(value:String):void
		{
			_code = value;
		}

		public function get size():Vector3D
		{
			return _size;
		}

		public function set size(value:Vector3D):void
		{
			if(value!=null)
				_size.copyFrom(value)
			else
				_size.setTo(0,0,0);
		}

		public function get previewBuffer():ByteArray
		{
			return _previewBuffer;
		}

		public function set previewBuffer(value:ByteArray):void
		{
			_previewBuffer = value;
		}

		public function get price():Number
		{
			return _price;
		}

		public function set price(value:Number):void
		{
			_price = value;
		}

		public function get height():Number
		{
			return _height;
		}

		public function set height(value:Number):void
		{
			_height = value;
		}

		public function get width():Number
		{
			return _width;
		}

		public function set width(value:Number):void
		{
			_width = value;
		}

		public function get length():Number
		{
			return _length;
		}

		public function set length(value:Number):void
		{
			_length = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}
		
		public function WallBoardPriceData()
		{
			_size=new Vector3D();
		}
	}
}