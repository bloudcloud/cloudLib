package
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	/**
	 * http://www.ionsden.com/content/pngdecoder
	 * @author ionsden
	 * @author katopz
	 * 
	 * var png:PNGDecoder = new PNGDecoder();
	 * var bd:BitmapData = png.decode(myByteArray);
	 * 
	 */
	public class PNGDecoder
	{
		private var fileIn:ByteArray = null;
		
		/*******************************
		 imageInfo values (index: value)
		 
		 0: width
		 1: height
		 2: bit depth
		 3: colour type
		 4: compression method
		 5: filter method
		 6: interlace method
		 7: samples
		 *******************************/
		private var imageInfo:Array = new Array(7);
		
		private var buffer:ByteArray = null;
		private var scanline:int = 0;
		private var samples:int = 4;
		
		//**************************************************************************************************************
		
		public function getText(ba:ByteArray):String
		{
			fileIn = ba;
			fileIn.position = 0;
			
			if (!readSignature())
				return null;
			
			var chunks:Array = getChunks();
			
			for each(var chunk:Object in chunks)
			{
				fileIn.position = chunk.position;
				if (chunk.type == "tEXt")
					return fileIn.readUTF();
			}
			
			return null;
		}
		
		public function decode(ba:ByteArray):BitmapData
		{
		buffer = new ByteArray();
		fileIn = ba;
		fileIn.position = 0;
		
		if (!readSignature())
		return null;
		
		var chunks:Array = getChunks();
		var countIHDR:int = 0;
		var countPLTE:int = 0;
		
		for (var i:int = 0; i < chunks.length; ++i)
		{
		fileIn.position = chunks[i].position;
		var validChunk:Boolean = true;
		
		if (i == 0)
		{
		if (chunks[i].type == "IHDR")
		validChunk = processIHDR(chunks[i].length);
		}
		else
		{
		if (chunks[i].type == "PLTE")
		validChunk = processPLTE(chunks[i].length);
		else if (chunks[i].type == "IDAT")
		buffer.writeBytes(fileIn, fileIn.position, chunks[i].length);
		}
		
		if (chunks[i].type == "IHDR")
		++countIHDR;
		if (chunks[i].type == "PLTE")
		++countPLTE;
		
		if (!validChunk || countIHDR > 1 || countPLTE > 1)
		return null;
		}
		
		buffer.uncompress();
		
		return processIDAT();
		}
		
		//**************************************************************************************************************
		
		private function readSignature():Boolean
		{
			if (fileIn.readUnsignedInt() != 0x89504e47)
				return false;
			if (fileIn.readUnsignedInt() != 0x0D0A1A0A)
				return false;
			
			return true;
		}
		
		private function getChunks():Array
		{
			var chunks:Array = [];
			var length:int = 0;
			var type:String = "";
			
			do
			{
				length = fileIn.readUnsignedInt();
				type = fileIn.readUTFBytes(4);
				
				chunks.push({type: type, position: fileIn.position, length: length});
				fileIn.position += length + 4; //data length + CRC (4 bytes)
			} while (type != "IEND");
			
			return chunks;
		}
		
		//**************************************************************************************************************
		
		
		private function processIHDR(cLength:int):Boolean
		{
		if (cLength != 13)
		return false;
		
		imageInfo[0] = fileIn.readUnsignedInt(); //width
		imageInfo[1] = fileIn.readUnsignedInt(); //height
		imageInfo[2] = fileIn.readUnsignedByte(); //bit depth
		imageInfo[3] = fileIn.readUnsignedByte(); //colour type
		imageInfo[4] = fileIn.readUnsignedByte(); //compression method
		imageInfo[5] = fileIn.readUnsignedByte(); //filter method
		imageInfo[6] = fileIn.readUnsignedByte(); //interlace method
		
		if (imageInfo[0] <= 0 || imageInfo[1] <= 0)
		return false;
		
		switch (imageInfo[2])
		{
		case 1:
		case 2:
		case 4:
		case 8:
		case 16:
		break;
		default:
		return false;
		}
		
		switch (imageInfo[3])
		{
		case 0:
		if (imageInfo[2] != 1 && imageInfo[2] != 2 && imageInfo[2] != 4 && imageInfo[2] != 8 && imageInfo[2] != 16)
		return false;
		break;
		case 2:
		if (imageInfo[2] != 8 && imageInfo[2] != 16)
		return false;
		break;
		case 3:
		if (imageInfo[2] != 1 && imageInfo[2] != 2 && imageInfo[2] != 4 && imageInfo[2] != 8)
		return false;
		break;
		case 4:
		if (imageInfo[2] != 8 && imageInfo[2] != 16)
		return false;
		break;
		case 6:
		if (imageInfo[2] != 8 && imageInfo[2] != 16)
		return false;
		break;
		default:
		return false;
		}
		
		if (imageInfo[4] != 0 || imageInfo[5] != 0)
		return false;
		if (imageInfo[6] != 0 && imageInfo[6] != 1)
		return false;
		
		return true;
		}
		
		private function processPLTE(cLength:int):Boolean
		{
		if (cLength % 3 != 0)
		return false;
		if (imageInfo[3] == 0 || imageInfo[3] == 4)
		return false;
		
	//	print("falta processPLTE");
		
		return true;
		}
		
		private function processIDAT():BitmapData
		{
		var bd:BitmapData = new BitmapData(imageInfo[0], imageInfo[1]);
		scanline = 0;
		
		while (buffer.position < buffer.length)
		{
		var filter:int = buffer.readUnsignedByte();
		
		//print(scanline, filter)
		
		for (var i:int = 0; i < imageInfo[0]; ++i)
		{
		switch (filter)
		{
		case 0:
		bd.setPixel32(i, scanline, noFilter());
		break;
		case 1:
		bd.setPixel32(i, scanline, subFilter());
		break;
		case 2:
		bd.setPixel32(i, scanline, upFilter());
		break;
		case 3:
		bd.setPixel32(i, scanline, averageFilter());
		break;
		case 4:
		bd.setPixel32(i, scanline, paethFilter());
		break;
		
		default:
		buffer.position += samples * imageInfo[0];
		i = imageInfo[0];
		}
		}
		
		++scanline;
		}
		
		return bd;
		}
		
		//**************************************************************************************************************
		
		private function noFilter():uint
		{
		var r:uint = 0;
		var g:uint = 0;
		var b:uint = 0;
		var a:uint = 0;
		
		if (samples == 4)
		{
		r = noSample();
		g = noSample();
		b = noSample();
		a = noSample();
		}
		else if (samples == 3)
		{
		r = noSample();
		g = noSample();
		b = noSample();
		a = 0xff;
		}
		else if (samples == 2)
		{
		r = noSample();
		g = r;
		b = r;
		a = noSample();
		}
		else
		{
		r = noSample();
		g = r;
		b = r;
		a = 0xff;
		}
		
		a <<= 24;
		r <<= 16;
		g <<= 8;
		
		return (a + r + g + b);
		}
		
		private function subFilter():uint
		{
		var r:uint = 0;
		var g:uint = 0;
		var b:uint = 0;
		var a:uint = 0;
		
		if (samples == 4)
		{
		r = subSample();
		g = subSample();
		b = subSample();
		a = subSample();
		}
		
		//if (scanline == 2) print(r, g, b, a);
		
		a <<= 24;
		r <<= 16;
		g <<= 8;
		
		return (a + r + g + b);
		}
		
		private function upFilter():uint
		{
		var r:uint = 0;
		var g:uint = 0;
		var b:uint = 0;
		var a:uint = 0;
		
		if (samples == 4)
		{
		r = upSample();
		g = upSample();
		b = upSample();
		a = upSample();
		}
		
		a <<= 24;
		r <<= 16;
		g <<= 8;
		
		return (a + r + g + b);
		}
		
		private function averageFilter():uint
		{
		var r:uint = 0;
		var g:uint = 0;
		var b:uint = 0;
		var a:uint = 0;
		
		if (samples == 4)
		{
		r = averageSample();
		g = averageSample();
		b = averageSample();
		a = averageSample();
		}
		
		a <<= 24;
		r <<= 16;
		g <<= 8;
		
		return (a + r + g + b);
		}
		
		private function paethFilter():uint
		{
		var r:uint = 0;
		var g:uint = 0;
		var b:uint = 0;
		var a:uint = 0;
		
		if (samples == 4)
		{
		r = paethSample();
		g = paethSample();
		b = paethSample();
		a = paethSample();
		}
		
		//if (scanline == 3) print(r, g, b, a);
		
		a <<= 24;
		r <<= 16;
		g <<= 8;
		
		return (a + r + g + b);
		}
		
		//**************************************************************************************************************
		
		private function noSample():int
		{
		var ret:uint = buffer[buffer.position++];
		
		return ret;
		}
		
		private function subSample():int
		{
		var recon:int = byteA();
		var filt:int = buffer[buffer.position];
		var ret:int = recon + filt;
		
		ret &= 0xff;
		buffer[buffer.position++] = ret;
		
		return ret;
		}
		
		private function upSample():int
		{
		var recon:int = byteB();
		var filt:int = buffer[buffer.position];
		var ret:int = recon + filt;
		
		ret &= 0xff;
		buffer[buffer.position++] = ret;
		
		return ret;
		}
		
		private function averageSample():int
		{
		var recon:int = Math.floor((byteA() + byteB()) / 2);
		var filt:int = buffer[buffer.position];
		var ret:int = recon + filt;
		
		ret &= 0xff;
		buffer[buffer.position++] = ret;
		
		return ret;
		}
		
		private function paethSample():int
		{
		var recon:int = paethPredictor();
		var filt:int = buffer[buffer.position];
		var ret:int = recon + filt;
		
		ret &= 0xff;
		buffer[buffer.position++] = ret;
		
		return ret;
		}
		
		//**************************************************************************************************************
		
		private function paethPredictor():uint
		{
		var a:uint = byteA();
		var b:uint = byteB();
		var c:uint = byteC();
		
		var p:uint = 0;
		var pa:uint = 0;
		var pb:uint = 0;
		var pc:uint = 0;
		var Pr:uint = 0;
		
		p = a + b - c;
		
		pa = Math.abs(p - a);
		pb = Math.abs(p - b);
		pc = Math.abs(p - c);
		
		if (pa <= pb && pa <= pc)
		Pr = a;
		else if (pb <= pc)
		Pr = b;
		else
		Pr = c;
		
		return Pr;
		}
		
		private function byteA():int
		{
		var init:int = scanline * (imageInfo[0] * samples + 1);
		var priorIndex:int = buffer.position - samples;
		
		if (priorIndex <= init)
		return 0;
		
		return buffer[priorIndex];
		}
		
		private function byteB():int
		{
		var priorIndex:int = buffer.position - (imageInfo[0] * samples + 1);
		
		if (priorIndex < 0)
		return 0;
		
		return buffer[priorIndex];
		}
		
		private function byteC():int
		{
		var priorIndex:int = buffer.position - (imageInfo[0] * samples + 1);
		
		if (priorIndex < 0)
		return 0;
		
		var init:int = (scanline - 1) * (imageInfo[0] * samples + 1);
		priorIndex = priorIndex - samples;
		
		if (priorIndex <= init)
		return 0;
		
		return buffer[priorIndex];
		}
	}
}