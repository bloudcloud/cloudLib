package
{
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.PNGEncoderOptions;
	import flash.display.Stage3D;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.JPEGEncoder;
	
	import L3DLibrary.LivelyLibrary;
	
	import alternativa.engine3d.materials.StandardMaterial;
	
	import extension.cloud.a3d.resources.CBitmapTextureResource;
	import extension.cloud.dict.CL3DConstDict;
	import extension.cloud.singles.CL3DModuleUtil;
	
	public class L3DMaterial extends StandardMaterial
	{		
		private var previewBuffer:ByteArray;
		private var length:int = 0;
		private var width:int = 0;
		private var materialName:String;
		private var code:String;
		private var brand:String;
		private var series:String;
		private var place:String;
		private var price:Number = 0;
		private var unit:String;
		private var mirror:Number = 0;
		private var version:int = 0;
		private var diffuseBuffer:ByteArray;
		private var normalBuffer:ByteArray;
		private var shininessBuffer:ByteArray;
		private var specularBuffer:ByteArray;
		private var emissionBuffer:ByteArray;
		private var transparentBuffer:ByteArray;
		public static var jpegQuality:int = 100;
		public static var loadFileBufferFun:Function = null;
		
	//	[Embed(source="environment/left.jpg")] private static const EmbedLeft:Class;
	//	[Embed(source="environment/right.jpg")] private static const EmbedRight:Class;
	//	[Embed(source="environment/back.jpg")] private static const EmbedBack:Class;
	//	[Embed(source="environment/front.jpg")] private static const EmbedFront:Class;
	//	[Embed(source="environment/bottom.jpg")] private static const EmbedBottom:Class;
	//	[Embed(source="environment/top.jpg")] private static const EmbedTop:Class;
	//	private static var environmentMap:BitmapCubeTextureResource = null;
		
		public function L3DMaterial(stage3D:Stage3D = null)
		{
			super();
			if(stage3D != null)
			{
			    BuildColoredMaterial(0xFFFFFF, stage3D); 		
			}
		}
		
		private function ClearBuffers():void
		{
			diffuseBuffer = null;
			normalBuffer = null;
			shininessBuffer = null;
			specularBuffer = null;
			emissionBuffer = null;
			transparentBuffer = null;
		}
		
		public function get Length():int
		{
			return length;
		}
		
		public function get Width():int
		{
			return width;
		}

		public function get Name():String
		{
			return materialName;
		}
		
		public function get Code():String
		{
			return name;
		}
		
		public function get Brand():String
		{
			return brand;
		}
		
		public function get Series():String
		{
			return series;
		}
		
		public function get Place():String
		{
			return place;
		}
		
		public function get Price():Number
		{
			return price;
		}
		
		public function get Unit():String
		{
			return unit;
		}
		
		public function get Preview():BitmapData
		{
			return LoadBitmapData(previewBuffer);
		}
		
		private function BuildColoredMaterial(color:uint, stage3D:Stage3D):void
		{
			var colorDiffuseTexture:CBitmapTextureResource = createColorTexture(color,CL3DConstDict.SUFFIX_DIFFUSE);
			var colorNormalTexture:CBitmapTextureResource = createColorTexture(0x7F7FFF,CL3DConstDict.SUFFIX_NORMAL);
			colorDiffuseTexture.upload(stage3D.context3D);
			colorNormalTexture.upload(stage3D.context3D);
			diffuseMap = colorDiffuseTexture;
			normalMap = colorNormalTexture;
		}
		
		public static function createColorTexture(color:uint,typeSuffix:String,width:int=1,height:int=1,alpha:Boolean = false):CBitmapTextureResource
		{
			return CL3DModuleUtil.Instance.getBitmapTextureResourceInstance(color,typeSuffix,alpha?CL3DConstDict.PREFIX_TRANSPARENT_FILL:CL3DConstDict.PREFIX_FILL,1,1,alpha);
		}
		
		public function get Transparency():int
		{
		    return (int)(alpha * 100);
		}
		
		public function SetTransparency(factor:int, stage3D:Stage3D):void
		{		
			if(factor < 1)
			{
				factor = 1;
			}
			else if(factor > 100)
			{
				factor = 100;
			}
			
			if(factor == 100)
			{
				alpha = 1.0;
				opaquePass = true;							
				transparentPass = true;
			}
			else
			{
				if(opacityMap == null)
				{
					var color:uint=Math.random() * 0xFFFFFF;
					var colorOpacity:CBitmapTextureResource =createColorTexture(color,CL3DConstDict.SUFFIX_OPACITY);
					colorOpacity.upload(stage3D.context3D);
					opacityMap = colorOpacity;
				}
				alpha = (factor as Number)*0.01;
				opaquePass = true;							
				transparentPass = true;
			}
		}
		
		public function get SpecularPower():int
		{
			return (int)(specularPower * 100);
		}
		
		public function set SpecularPower(factor:int):void
		{
			if(factor < 0)
			{
				factor = 0;
			}
			else if(factor > 100)
			{
				factor = 100;
			}
			specularPower = (factor as Number)*0.01;
		}
		
		public function get Mirror():int
		{
			return (int)(mirror * 100);
		}
		
		public function set Mirror(factor:int):void
		{
			if(factor < 0)
			{
				factor = 0;
			}
			else if(factor > 100)
			{
				factor = 100;
			}
			mirror = (factor as Number)*0.01;
		}
		
		public static function FromBuffer(buffer:ByteArray, stage3D:Stage3D):L3DMaterial
		{
			if(buffer == null || buffer.length == 0)
			{
				return null;
			}
			
			var diffuse:L3DBitmapTextureResource;
			var shininess:L3DBitmapTextureResource;
			var normal:CBitmapTextureResource;
			var specular:L3DBitmapTextureResource;
			var transparent:L3DBitmapTextureResource;
			
			var material:L3DMaterial = new L3DMaterial();
			
			material.version = buffer.readInt();
			var l:int = buffer.readInt();
			if(l > 0)
			{
				material.previewBuffer = new ByteArray();
				buffer.readBytes(material.previewBuffer, 0, l);
			}
			material.length = buffer.readInt();
			material.width = buffer.readInt();
			material.materialName = ReadString(buffer);
			material.code = ReadString(buffer);
			material.brand = ReadString(buffer);
			material.series = ReadString(buffer);
			material.place = ReadString(buffer);
			material.price = buffer.readFloat();
			material.unit = ReadString(buffer);
			material.alpha = buffer.readFloat();
			material.alphaThreshold = buffer.readFloat();
			material.glossiness = buffer.readFloat();
			material.specularPower = buffer.readFloat();
			material.mirror = buffer.readFloat();
			
			l = buffer.readInt();
			//cloud 2017.12.25	����GetL3DBitmapTextureResourceInstance����
			if(l > 0)
			{
				material.diffuseBuffer = new ByteArray();
				buffer.readBytes(material.diffuseBuffer,0,l);
				diffuse=CL3DModuleUtil.Instance.getL3DBitmapTextureResourceInstance(material.code,null,stage3D,LivelyLibrary.TextureForceMode,LivelyLibrary.RuntimeMode,CL3DConstDict.SUFFIX_DIFFUSE,null,null,material.diffuseBuffer);
				diffuse.upload(stage3D.context3D);
				material.diffuseMap = diffuse;
			}
			l = buffer.readInt();
			if(l > 0)
			{
				material.normalBuffer = new ByteArray();
				buffer.readBytes(material.normalBuffer,0,l);
				normal = CL3DModuleUtil.Instance.getL3DBitmapTextureResourceInstance(material.code,null,stage3D,LivelyLibrary.TextureForceMode,LivelyLibrary.RuntimeMode,CL3DConstDict.SUFFIX_NORMAL,CL3DConstDict.PREFIX_FILL,null,material.normalBuffer);
			}
			else
			{
				normal = CL3DModuleUtil.Instance.getBitmapTextureResourceInstance(0x7F7FFF,CL3DConstDict.SUFFIX_NORMAL,CL3DConstDict.PREFIX_FILL);
			}
			normal.upload(stage3D.context3D);
			material.normalMap = normal;
			l = buffer.readInt();
			if(l > 0)
			{
				material.shininessBuffer = new ByteArray();
				buffer.readBytes(material.shininessBuffer,0,l);
				if(material.shininessBuffer != null && material.shininessBuffer.length > 0)
				{
					CL3DModuleUtil.Instance.getL3DBitmapTextureResourceInstance(material.code,null,stage3D,LivelyLibrary.TextureForceMode,LivelyLibrary.RuntimeMode,CL3DConstDict.SUFFIX_GLOSS,null,null,material.shininessBuffer);
//					shininess = new L3DBitmapTextureResource(null, material.shininessBuffer, stage3D);
					shininess.upload(stage3D.context3D);
					material.glossinessMap = shininess;
				}
			}
			l = buffer.readInt();
			if(l > 0)
			{
				material.specularBuffer = new ByteArray();
				buffer.readBytes(material.specularBuffer,0,l);
				if(material.specularBuffer != null && material.specularBuffer.length > 0)
				{
					specular=CL3DModuleUtil.Instance.getL3DBitmapTextureResourceInstance(material.code,null,stage3D,LivelyLibrary.TextureForceMode,LivelyLibrary.RuntimeMode,CL3DConstDict.SUFFIX_SPECULAR,null,null,material.specularBuffer);
//					specular = new L3DBitmapTextureResource(null, material.specularBuffer, stage3D);
					specular.upload(stage3D.context3D);
					material.specularMap = specular;
				}
			}
			l = buffer.readInt();
			if(l > 0)
			{
				material.transparentBuffer = new ByteArray();
				buffer.readBytes(material.transparentBuffer,0,l);
				if(material.transparentBuffer != null && material.transparentBuffer.length > 0)
				{
					transparent=CL3DModuleUtil.Instance.getL3DBitmapTextureResourceInstance(material.code,null,stage3D,LivelyLibrary.TextureForceMode,LivelyLibrary.RuntimeMode,CL3DConstDict.SUFFIX_OPACITY,null,null,material.transparentBuffer);
//					transparent = new L3DBitmapTextureResource(null, material.transparentBuffer, stage3D);
					transparent.upload(stage3D.context3D);
					material.opacityMap = transparent;
				}
			}
			
			material.ClearBuffers();
			
			return material;
		}
		
	/*	public static function GetEnvironmentMap(stage3D:Stage3D = null):BitmapCubeTextureResource
		{
			if(environmentMap == null && stage3D != null)
			{
				environmentMap = new BitmapCubeTextureResource(new EmbedLeft().bitmapData, new EmbedRight().bitmapData, new EmbedBack().bitmapData, new EmbedFront().bitmapData, new EmbedBottom().bitmapData, new EmbedTop().bitmapData)
				environmentMap.upload(stage3D.context3D);
			}
			
			return environmentMap;
		} */
		
		private static function ReadString(buffer:ByteArray):String
		{
			if(buffer == null)
			{
				return "";
			}
			
			var l:int = buffer.readInt();
			if(l == 0)
			{
				return "";
			}
			
			var textBuffer:ByteArray = new ByteArray();
			buffer.readBytes(textBuffer,0,l);
			textBuffer.position = 0;
			
			return textBuffer.readUTFBytes(textBuffer.length);
		}
		
		public static function CheckExternTextureBitmapValidated(url:String):Boolean
		{
			if(url == null || url.length == 0)
			{
				return false;
			}
			
			var bmpData:BitmapData = LoadFileBitmapData(url);
			
			if(bmpData == null)
			{
				return false;
			}
			
			if(bmpData.width != 2 && bmpData.width != 4 && bmpData.width != 8 && bmpData.width != 16 && bmpData.width != 32)
			{
				if(bmpData.width != 64 && bmpData.width != 128 && bmpData.width != 256 && bmpData.width != 512 && bmpData.width != 1024)
				{
					return false;
				}
			}
			
			if(bmpData.height != 2 && bmpData.height != 4 && bmpData.height != 8 && bmpData.height != 16 && bmpData.height != 32)
			{
				if(bmpData.height != 64 && bmpData.height != 128 && bmpData.height != 256 && bmpData.height != 512 && bmpData.height != 1024)
				{
					return false;
				}
			}
			
			return true;
		}
		
		public static function CheckTextureBitmapValidated(bmpData:BitmapData):Boolean
		{	
			if(bmpData == null)
			{
				return false;
			}
			
			if(bmpData.width != 2 && bmpData.width != 4 && bmpData.width != 8 && bmpData.width != 16 && bmpData.width != 32)
			{
				if(bmpData.width != 64 && bmpData.width != 128 && bmpData.width != 256 && bmpData.width != 512 && bmpData.width != 1024 && bmpData.width != 2048)
				{
					return false;
				}
			}
			
			if(bmpData.height != 2 && bmpData.height != 4 && bmpData.height != 8 && bmpData.height != 16 && bmpData.height != 32)
			{
				if(bmpData.height != 64 && bmpData.height != 128 && bmpData.height != 256 && bmpData.height != 512 && bmpData.height != 1024 && bmpData.height != 2048)
				{
					return false;
				}
			}
			
			return true;
		}
		
		public static function AmendTextureBitmap(bmpData:BitmapData, maxLength:int = 256, clearOriginBitmap:Boolean = true):BitmapData
		{
			if(bmpData == null)
			{
				return null;
			}
			
			var needAmend:Boolean = false;
			if(!CheckTextureBitmapValidated(bmpData))
			{
				needAmend = true;
			}
			
			if(bmpData.width > maxLength || bmpData.height > maxLength)
			{
				needAmend = true;
			}
			
			if(!needAmend)
			{
				return bmpData;
			}
			
			var newBmpData:BitmapData = BitmapScale(bmpData, maxLength);
			if(clearOriginBitmap)
			{
				bmpData.dispose();
			}
			return newBmpData;
		}
		
		private static function LoadFileBitmapData(url:String):BitmapData
		{
			if(url == null || url.length == 0)
			{
				return null;
			}
			
			var buffer:ByteArray = LoadFileBuffer(url);
			if(buffer == null || buffer.length == 0)
			{
				return null;
			}
			
			return LoadBitmapData(buffer);
		}
		
		public static function LoadFileBuffer(url:String):ByteArray
		{
			if(url == null || loadFileBufferFun == null)
			{
				return null;
			}			
			
            return loadFileBufferFun(url);
		}
		
		public static function LoadFileEncodingBuffer(url:String):ByteArray
		{
			if(url == null)
			{
				return null;
			}	
			
			var fileBuffer:ByteArray = LoadFileBuffer(url);
			if(fileBuffer == null || fileBuffer.length == 0)
			{
				return null;
			}
			
			var bmpData:BitmapData = LoadBitmapData(fileBuffer);
			if(bmpData == null)
			{
				return fileBuffer;
			}
			
			var encoder:JPEGEncoder = new JPEGEncoder(jpegQuality);
			return encoder.encode(bmpData);
		}
		
		public static function BitmapDataToBuffer(bitmapData:BitmapData, quanlity:int = 100):ByteArray
		{
			if(bitmapData == null)
			{
				return null;
			}	
			
			var jpegEncoderOptions:JPEGEncoderOptions = new JPEGEncoderOptions(quanlity);
			return bitmapData.encode(bitmapData.rect,jpegEncoderOptions);
	//		var encoder:JPGEncoder = new JPGEncoder(jpegQuality);
	//		return encoder.encode(bitmapData);		
		}
		
		public static function BitmapDataToBuffer32(bitmapData:BitmapData, quanlity:int = 100):ByteArray
		{
			if(bitmapData == null)
			{
				return null;
			}	
			
			var pngEncoderOptions:PNGEncoderOptions = new PNGEncoderOptions();
			return bitmapData.encode(bitmapData.rect,pngEncoderOptions);
			//		var encoder:JPGEncoder = new JPGEncoder(jpegQuality);
			//		return encoder.encode(bitmapData);		
		}
		
		public static function LoadBitmapData(buffer:ByteArray):BitmapData
		{
			if(buffer == null || buffer.length == 0)
			{
				return null;
			}
		
			var bmpData:BitmapData = null;
			var decoder:JPEGDecoder = null;
			try
			{
			    decoder = new JPEGDecoder(buffer);
			    bmpData = new BitmapData(decoder.width, decoder.height);
			    bmpData.setVector(new Rectangle(0,0,decoder.width, decoder.height), decoder.pixels);
			    decoder = null;
			}
			catch(error:Error)
			{
				bmpData = null;
				decoder = null;
			}
			
			if(bmpData == null)
			{
				var pngdecoder:PNGDecoder = null;
				try
				{
					pngdecoder = new PNGDecoder();
					bmpData = pngdecoder.decode(buffer);
					pngdecoder = null;
				}
				catch(error:Error)
				{
					bmpData = null;
					pngdecoder = null;
				}
			}
			
			return bmpData;		//	return null;
		}		

		private static function BitmapFactorScale(bmpData:BitmapData, scaleX:Number, scaleY:Number):BitmapData
		{
			if(bmpData == null)
			{
				return null;
			}
			var matrix:Matrix = new Matrix();
			matrix.scale(scaleX, scaleY);
			var bmpData_:BitmapData = new BitmapData(scaleX * bmpData.width, scaleY * bmpData.height, true, 0);
			bmpData_.draw(bmpData, matrix);
			return bmpData_;
		}
		
		public static function BitmapScale(bmpData:BitmapData, maxLength:int):BitmapData
		{
			if(bmpData == null)
			{
				return null;
			}
			
			if(bmpData.width <= maxLength && bmpData.height <= maxLength)
			{
				var bmpData_:BitmapData = new BitmapData(bmpData.width, bmpData.height, true, 0);
				bmpData_.draw(bmpData);
				return bmpData_;
			}
			
			var width:int = bmpData.width;
			var height:int = bmpData.height;
			if(width > height)
			{
				height = maxLength * height / width;
				width = maxLength;
			}
			else
			{
				width = maxLength * width / height;
				height = maxLength;
			}
			var scaleX:Number = (width as Number) / (bmpData.width as Number);
			var scaleY:Number = (height as Number) / (bmpData.height as Number);
			return BitmapFactorScale(bmpData, scaleX, scaleY);
		}
		
		public static function BitmapSizeScale(bmpData:BitmapData, width:int, height:int):BitmapData
		{
			if(bmpData == null || width < 2 || height < 2)
			{
				return null;
			}
			
			var scaleX:Number = (width as Number) / (bmpData.width as Number);
			var scaleY:Number = (height as Number) / (bmpData.height as Number);
			var matrix:Matrix = new Matrix();
			matrix.scale(scaleX, scaleY);
			var bmpData_:BitmapData = new BitmapData(width, height, true, 0);
			bmpData_.draw(bmpData, matrix);
			return bmpData_;
		}
	}
}