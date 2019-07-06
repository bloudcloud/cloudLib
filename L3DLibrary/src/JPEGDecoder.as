package
{
	import cmodule.jpegdecoder.CLibInit;	
	import flash.utils.ByteArray; 
	
	public final class JPEGDecoder
	{
		private var loader:CLibInit;
		private var lib:Object;
		private var ns:Namespace;
		private var memory:ByteArray;
		private var infos:Array;
		private var position:uint;
		private var length:uint;
		private var buffer:ByteArray = new ByteArray();
		
		private var _pixels:Vector.<uint>;
		private var _width:uint;
		private var _height:uint;
		private var _numComponents:uint;
		private var _colorComponents:uint;
		
		public static const HEADER:int = 0xFFD8;
		
		public function JPEGDecoder ( stream:ByteArray=null )
		{
			if ( stream != null ) parse( stream );
		}
		
		/**
		 * Allows you to inject a JPEG stream to decode it. 
		 * @param stream
		 * @return 
		 */		
		public function parse ( stream:ByteArray ):Vector.<uint>
		{
			stream.position = 0;
			if ( stream.readUnsignedShort() != JPEGDecoder.HEADER )
				throw new Error ("Not a valid JPEG file.");
			loader = new CLibInit();
			loader.supplyFile("stream", stream);
			lib = loader.init();
			
			ns = new Namespace("cmodule.jpegdecoder");
			memory = (ns::gstate).ds;
			infos = lib.parseJPG ("stream");
			
			_width = infos[0];
			_height = infos[1];
			_numComponents = infos[2];
			_colorComponents = infos[3];
			position = infos[4];
			length = width*height*3;
			
			buffer.length = 0;
			buffer.writeBytes(memory, position, length);
			buffer.position = 0;
			
			var lng:uint = buffer.length;
			_pixels = new Vector.<uint>(lng/3, true);
			var count:int;
			
			for ( var i:int = 0; i< lng; i+=3 )
			{
				pixels[int(count++)] = (255 << 24 | buffer[i] << 16 | buffer[int(i+1)] << 8 | buffer[int(i+2)]);
			}
			
			memory = null;
			
			return pixels;
		}

		public function get pixels():Vector.<uint>
		{
			return _pixels;
		}

		public function get colorComponents():uint
		{
			return _colorComponents;
		}

		public function get numComponents():uint
		{
			return _numComponents;
		}

		public function get height():uint
		{
			return _height;
		}

		public function get width():uint
		{
			return _width;
		}
	}
}