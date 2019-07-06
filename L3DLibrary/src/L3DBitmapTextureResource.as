package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import L3DLibrary.L3DLibraryEvent;
	import L3DLibrary.L3DMaterialInformations;
	
	import alternativa.engine3d.materials.LightMapMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.objects.Mesh;
	
	import extension.cloud.a3d.resources.CBitmapTextureResource;
	import extension.cloud.a3d.resources.CTextureResource;

	public class L3DBitmapTextureResource extends CBitmapTextureResource
	{
		private var brand:String = "";
		private var family:String = "";
		private var url:String = "";
		private var readyUrl:String = "";
		private var width:Number = 1000;
		private var height:Number = 1000;
		private var price:Number = 0;
		private var unit:String = "";
		private var materialMode:int = 0;
		private var erpCode:String = "";
		private var ratio:Number = 0;
		private var vrmMode:int = 0;
		private var renderMode:int = 0;
		private var stage3D:Stage3D = null;
		/**
		 * 组ID
		 */		
		private var _groupID:String;
		public var userData:* = null;
		public var fullImage:BitmapData = null;
		public var bakeImage:BitmapData = null;
		private var texHighLightBakData:* = null;
		public var maxLength:int = 0;
		
		private static var defaultTextureBitmap:BitmapData = null;
		private static var globalLoadTextures:Vector.<L3DBitmapTextureResource> = new Vector.<L3DBitmapTextureResource>();
		private static var onGlobalLoading:Boolean = false;
		private static var endLoadingFunction:Function = null;
		public static var maxTextureLength:int = 1024;
		private static var highLightDatas:Array = [];
		private static var _LoadCount:int=0;
		private static var _UseLoadCount:int=0;
		
		public static function get UseLoadCount():int
		{
			return _UseLoadCount;
		}
		public static function get LoadCount():int
		{
			return _LoadCount;
		}
		
		public function get groupID():String
		{
			return _groupID;
		}
		public function set groupID(value:String):void
		{
			_groupID=value;
		}
		
		public function L3DBitmapTextureResource(data:BitmapData, buffer:ByteArray = null, stage3D:Stage3D = null, resizeForGPU:Boolean = false, maxLength:int = 0)
		{
			this.stage3D = stage3D;
		//	this.resizeForGPU = resizeForGPU;
			this.maxLength = maxLength;
			if(data == null && buffer != null && stage3D != null)
			{
				this.data = GetDefaultBitmapTexture();
				this.upload(stage3D.context3D);
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
				loader.loadBytes(buffer);
			}
			else if(data != null && data.width > 0 && data.height > 0)
			{
				var bmp:BitmapData = AutoAmendBitmapData(data);
			    super(bmp, resizeForGPU);
				if(stage3D != null)
				{
					this.upload(stage3D.context3D);
				}
			}
			else
			{
				this.resizeForGPU = resizeForGPU;
			}
		}
		
		public function AutoAmendBitmapData(data:BitmapData,isClearSource:Boolean=true):BitmapData
		{
			if(data == null)
			{
				return null;
			}
			
			return AmendTextureBitmap(data, maxLength,isClearSource);			
		}
		
		public function GetAmendTextureSize(bmp:BitmapData):Point
		{
			if(bmp == null || bmp.width == 0 || bmp.height == 0)
			{
				return new Point();
			}
			
			return GetAmendTextureSizeFromSizePoint(new Point(bmp.width, bmp.height));			
		}
		
		private function GetAmendTextureSizeFromSizePoint(size:Point):Point
		{
			if(size == null || size.x == 0 || size.y == 0)
			{
				return new Point();
			}
			
			var newSize:Point = new Point();

			if(size.x == 1 || size.x == 2)
			{
				newSize.x = size.x;
			}
			else if(size.x < 4)
			{
				newSize.x = 2;
			}
			else if(size.x < 8)
			{
				newSize.x = 4;
			}
			else if(size.x < 16)
			{
				newSize.x = 8;
			}
			else if(size.x < 32)
			{
				newSize.x = 16;
			}
			else if(size.x < 64)
			{
				newSize.x = 32;
			}
			else if(size.x < 128)
			{
				newSize.x = 64;
			}
			else if(size.x < 256)
			{
				newSize.x = 128;
			}
			else if(size.x < 512)
			{
				newSize.x = 256;
			}
			else if(size.x < 1024)
			{
				newSize.x = 512;
			}
			else if(size.x < 2048)
			{
				newSize.x = 1024;
			}
			else
			{
				newSize.x = 2048;
			}
			
			if(size.y == 1 || size.y == 2)
			{
				size.y = size.y;
			}
			else if(size.y < 4)
			{
				newSize.y = 2;
			}
			else if(size.y < 8)
			{
				newSize.y = 4;
			}
			else if(size.y < 16)
			{
				newSize.y = 8;
			}
			else if(size.y < 32)
			{
				newSize.y = 16;
			}
			else if(size.y < 64)
			{
				newSize.y = 32;
			}
			else if(size.y < 128)
			{
				newSize.y = 64;
			}
			else if(size.y < 256)
			{
				newSize.y = 128;
			}
			else if(size.y < 512)
			{
				newSize.y = 256;
			}
			else if(size.y < 1024)
			{
				newSize.y = 512;
			}
			else if(size.y < 2048)
			{
				newSize.y = 1024;
			}
			else
			{
				newSize.y = 2048;
			}
			
			return newSize;
		}
		
		private function LoadFromLibraryURL(url:String, stage3D:Stage3D):void
		{
			this.stage3D = stage3D;
			if(url == null || url.length == 0)
			{
				EndGlobalURLLoad();
				return;
			}
			
			this.url = url;
			
			var loadingMaterial:L3DMaterialInformations = new L3DMaterialInformations();
			loadingMaterial.addEventListener(L3DLibraryEvent.DownloadMaterialInfo, LoadMaterialInfoHandler);
			loadingMaterial.LoadMaterialInformation(url, 3);
		}
		
		private function LoadMaterialInfoHandler(event:L3DLibraryEvent):void
		{
			var lm:L3DMaterialInformations = event.target as L3DMaterialInformations;
			lm.removeEventListener(L3DLibraryEvent.DownloadMaterialInfo, LoadMaterialInfoHandler);
			
			if(event.MaterialInformation == null)
			{
				EndGlobalURLLoad();
				return;
			}
			
			LoadMaterialInfo(event.MaterialInformation);
		}
		
		private function LoadMaterialInfo(materialInfo:L3DMaterialInformations):void
		{
			if(materialInfo == null || materialInfo.type == 4)
			{
				EndGlobalURLLoad();
				return;
			}			
	
			Code = materialInfo.code;
			ERPCode = materialInfo.ERPCode;
			Name = materialInfo.name;
			VRMMode = materialInfo.vrmMode;
			RenderMode = materialInfo.renderMode;
			Brand = materialInfo.brand == null || materialInfo.brand.length == 0 ? materialInfo.className : materialInfo.brand;
			Family = materialInfo.family;
			var size:Vector3D = materialInfo.GetSizeVector();
			Width = size.x;
			Height = size.y;
			Url = materialInfo.url;
			materialInfo.addEventListener(L3DLibraryEvent.DownloadMaterial, LoadTextureBufferCompleteHandler);
			materialInfo.DownloadMaterial();
		}
		
		private function LoadTextureBufferCompleteHandler(event:L3DLibraryEvent):void
		{
			var lm:L3DMaterialInformations = event.target as L3DMaterialInformations;
			lm.removeEventListener(L3DLibraryEvent.DownloadMaterial, LoadTextureBufferCompleteHandler);
			if(event.MaterialBuffer == null)
			{
				EndGlobalURLLoad();
				return;
			}
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			loader.loadBytes(event.MaterialBuffer);
		}
		
		public function LoadFromCode(code:String, stage3D:Stage3D):void
		{
			this.stage3D = stage3D;
			if(code == null || code.length == 0)
			{
				GlobalURLLoad();
				return;
			}
			
			var loadingMaterial:L3DMaterialInformations = new L3DMaterialInformations();
			loadingMaterial.addEventListener(L3DLibraryEvent.DownloadMaterialInfo, SearchMaterialInfoHandler);
			loadingMaterial.SearchMaterialInformation(code, 3);
		}
		
		private function SearchMaterialInfoHandler(event:L3DLibraryEvent):void
		{
			var lm:L3DMaterialInformations = event.target as L3DMaterialInformations;
			lm.removeEventListener(L3DLibraryEvent.DownloadMaterialInfo,  SearchMaterialInfoHandler);
			
			if(event.MaterialInformation == null)
			{	
				GlobalURLLoad();
				return;
			}
			
			Load(event.MaterialInformation.url, stage3D);
		}
		
		public function Load(url:String, stage3D:Stage3D):void
		{
			_UseLoadCount++;
			this.stage3D = stage3D;
			if(url == null || url.length == 0)
			{
				GlobalURLLoad();
				return;
			}
			readyUrl = url;
			
			var i:int,len:int;
			var isSearched:Boolean;
			
			len=globalLoadTextures.length;
			for(i=0; i<len; i++)
			{
				if(globalLoadTextures[i].code==_code && _code != null)
				{
					isSearched=true;
					break;
				}
			}
			if(!isSearched)
			{
				globalLoadTextures.push(this);
				GlobalURLLoad();
				_LoadCount++;
			}
		}
		
		private function LoadReadyURL():void
		{
			onGlobalLoading = true;
			loadingCount = 0;
			
			if(readyUrl == null || readyUrl.length == 0)
			{
				EndGlobalURLLoad();
				return;
			}
			
			var url:String = readyUrl;
			readyUrl = "";
			
			if(url.toUpperCase().indexOf("LIBRARY") == 0)
			{
				LoadFromLibraryURL(url, stage3D);
			}
			else
			{
				if(url.indexOf("mub1.jpg") >= 0 || url.indexOf("mub2.jpg") >= 0 || url.indexOf("mub3.jpg") >= 0 || url.indexOf("mub4.jpg") >= 0 || url.indexOf("mub5.jpg") >= 0)
				{
					this.url = url;
				}
				else if(url.indexOf("mub6.jpg") >= 0 || url.indexOf("mub7.jpg") >= 0 || url.indexOf("mub8.jpg") >= 0 || url.indexOf("mub9.jpg") >= 0 || url.indexOf("mub10.jpg") >= 0)
				{
					this.url = url;
				}
				else
				{
					this.code=url;
					this.url=url;
				}
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.dataFormat=URLLoaderDataFormat.BINARY ;
				urlLoader.addEventListener (Event.COMPLETE , OnImageLoadedHandler);
				urlLoader.load(new URLRequest(url));
			}
		}
		
		public static function set EndLoadingFunction(v:Function):void
		{
			endLoadingFunction = v;
		}
		
		private function EndGlobalURLLoad():void
		{
			globalLoadTextures.shift();
			onGlobalLoading = false;
			loadingCount = 0;
			if(globalLoadTextures.length == 0)
			{
				if(endLoadingFunction != null)
				{
					if(this.url==this.code)
					{
						endLoadingFunction(this);
					}
					endLoadingFunction();
				}
			}
			GlobalURLLoad();
		}
		
		private var loadingCount:int = 0;
		
		private function GlobalURLLoad():void
		{
			if(onGlobalLoading || globalLoadTextures.length == 0)
			{
				loadingCount++;
				if(loadingCount > 500)
				{
					onGlobalLoading = false;
					loadingCount = 0;
				}
				return;
			}
			
			globalLoadTextures[0].LoadReadyURL();
		}
		
		private function OnImageLoadedHandler(e:Event):void
		{
			var buffer:ByteArray = e.target.data as ByteArray;
			if(buffer == null || buffer.length == 0)
			{
				EndGlobalURLLoad();
				return;
			}
			//cloud 2017.12.25
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			loader.loadBytes(buffer);
		}
		private function onIOError(evt:IOErrorEvent):void
		{
			//cloud 2017.12.25
			evt.currentTarget.removeEventListener(evt.type,onIOError);
//			CL3DModuleUtil.Instance.showDownloadResourceFaultMessage(evt.errorID.toString(),evt.toString());
			
			EndGlobalURLLoad();
		}
		
		public static function GetDefaultBitmapTexture():BitmapData
		{
			if(defaultTextureBitmap == null)
			{
				defaultTextureBitmap = new BitmapData(1, 1);
			}
			return defaultTextureBitmap.clone();
		}
		
		private function loaderComplete(event:Event):void
		{
			//cloud 2017.12.25
			event.currentTarget.removeEventListener(event.type,loaderComplete);
			var loaderInfo:LoaderInfo = LoaderInfo(event.target);
			var bitmapData:BitmapData=(loaderInfo.content as Bitmap).bitmapData;
//			var bitmapData:BitmapData = new BitmapData(loaderInfo.width, loaderInfo.height, false, 0xFFFFFF);
//			bitmapData.draw(loaderInfo.loader);
			if(this.data!=null)
			{
				this.data.dispose();
			}
			this.data = AmendTextureBitmap(bitmapData, maxLength);
			super.upload(stage3D.context3D);
//			trace(stage3D.context3D.toString());
			EndGlobalURLLoad();
			loaderInfo.loader.unloadAndStop();
		}
		
		public function LoadFromMaterialURL(url:String, stage3D:Stage3D):void
		{
			this.stage3D = stage3D;
			if(url == null || url.length == 0)
			{
				return;
			}
			var uloadingMaterial:L3DMaterialInformations = new L3DMaterialInformations();
			uloadingMaterial.addEventListener(L3DLibraryEvent.DownloadMaterialInfo, LoadMaterialInfoFromURL);
			uloadingMaterial.LoadMaterialInformation(url, 3);
		}
		
		private function LoadMaterialInfoFromURL(event:L3DLibraryEvent):void
		{
			if(event.MaterialInformation == null)
			{	
				return;
			}
			
			LoadFromMaterialInfo(event.MaterialInformation, stage3D);
		}
		
		public function LoadFromMaterialInfo(materialInfo:L3DMaterialInformations, stage3D:Stage3D):void
		{
			this.stage3D = stage3D;
			if(materialInfo == null || materialInfo.type == 4)
			{
				return;
			}
			
//			this._materialInfo = materialInfo;			
			materialInfo.addEventListener(L3DLibraryEvent.DownloadMaterial, LoadLibraryTextureBufferCompleteHandler);
			materialInfo.DownloadMaterial();
		}
		
		private function LoadLibraryTextureBufferCompleteHandler(event:L3DLibraryEvent):void
		{
			var curMaterialInfo:L3DMaterialInformations=event.currentTarget as L3DMaterialInformations;
			curMaterialInfo.removeEventListener(event.type, LoadLibraryTextureBufferCompleteHandler);
			if(event.MaterialBuffer == null)
			{
				return;
			}

			var sizeArr:Array = curMaterialInfo.spec.toUpperCase().split("X");
			if(sizeArr && sizeArr.length >=2)
			{
				Width = parseInt(sizeArr[1]);
				Height = parseInt(sizeArr[0]);
			}
			Code = curMaterialInfo.code;
			ERPCode = curMaterialInfo.ERPCode;
			Name = curMaterialInfo.name;
			VRMMode = curMaterialInfo.vrmMode;
			RenderMode = curMaterialInfo.renderMode;
			Brand = curMaterialInfo.brand == null || curMaterialInfo.brand.length == 0 ? curMaterialInfo.className : curMaterialInfo.brand;
			Family = curMaterialInfo.family;
			Url = curMaterialInfo.url;
			Price = curMaterialInfo.price;
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, LoadTextureBitmapCompleteHandler);
			loader.loadBytes(event.MaterialBuffer);
		}
		
		private function LoadTextureBitmapCompleteHandler(event:Event):void
		{
			event.target.removeEventListener(event.type,LoadTextureBitmapCompleteHandler);
			var loaderInfo:LoaderInfo = LoaderInfo(event.target);
			var imgData:BitmapData=(loaderInfo.content as Bitmap).bitmapData;
//			var imgData:BitmapData = new BitmapData(loaderInfo.width, loaderInfo.height, false, 0xFFFFFF);
//			imgData.draw(loaderInfo.loader);	
			if(width==0)
			{
				Width = imgData.width;
			}
			if(Height==0)
			{
				Height = imgData.height;
			}
			if(this.data)
			{
				this.data.dispose();
			}
			this.data = AmendTextureBitmap(imgData, maxLength);
			super.upload(stage3D.context3D);
			loaderInfo.loader.unloadAndStop();
		}
		
		public override function upload(context3D:Context3D):void
		{
			if(isUploaded || data == null)
			{
				return;
			}
			super.upload(context3D);
		}
		
		public function get Code():String
		{
			return code;
		}
		
		public function set Code(v:String):void
		{
			code = v;
		}
		
		public function get Name():String
		{
			return name;
		}
		
		public function set Name(v:String):void
		{
			name = v;
		}
		
		public function get Brand():String
		{
			return brand;
		}
		
		public function set Brand(v:String):void
		{
			brand = v;
		}
		
		public function get Family():String
		{
			return family;
		}
		
		public function set Family(v:String):void
		{
			family = v;
		}
		
		public function get Url():String
		{
			return url;
		}
		
		public function set Url(v:String):void
		{
			url = v;
		}
		
		public function get Width():Number
		{
			return width;
		}
		
		public function set Width(v:Number):void
		{
			width = v;
		}
		
		public function get Height():Number
		{
			return height;
		}
		
		public function set Height(v:Number):void
		{
			height = v;
		}
		
		public function get Price():Number
		{
			return price;
		}
		
		public function set Price(v:Number):void
		{
			price = v;
		}
		
		public function get Unit():String
		{
			return unit;
		}
		
		public function set Unit(v:String):void
		{
			unit = v;
		}
		
		public function get MaterialMode():int
		{
			return materialMode;
		}
		
		public function set MaterialMode(v:int):void
		{
			materialMode = v;
		}
		
		public function get ERPCode():String
		{
			return erpCode;
		}
		
		public function set ERPCode(v:String):void
		{
			erpCode = v;
		}
		
		public function get Ratio():Number
		{
			return ratio;
		}
		
		public function set Ratio(v:Number):void
		{
			ratio = v;
		}
		
		public function get VRMMode():int
		{
			return vrmMode;
		}
		
		public function set VRMMode(v:int):void
		{
			vrmMode = v;
		}
		
		public function get RenderMode():int
		{
			return renderMode;
		}
		
		public function set RenderMode(v:int):void
		{
			renderMode = v;
		}
		
		public static function get OnTexturesLoading():Boolean
		{
			if(globalLoadTextures.length == 0)
			{
				return false;
			}
			
			globalLoadTextures[0].GlobalURLLoad();
			return true;
		}

		public override function dispose():void
		{
			if(isSystemMode)
			{
				return;
			}
			if(fullImage != null)
			{
				fullImage.dispose();
				fullImage = null;
			}
			
			if(bakeImage != null)
			{
				bakeImage.dispose();
				bakeImage = null;
			}
			super.dispose();
		}
		override public function clear():void
		{
			if(isSystemMode)
			{
				return;
			}
			super.clear();
		}
		
		private function CheckTextureBitmapValidated(bmpData:BitmapData):Boolean
		{	
			if(bmpData == null)
			{
				return false;
			}
			
			if(bmpData.width != 1 && bmpData.width != 2 && bmpData.width != 4 && bmpData.width != 8 && bmpData.width != 16 && bmpData.width != 32)
			{
				if(bmpData.width != 64 && bmpData.width != 128 && bmpData.width != 256 && bmpData.width != 512 && bmpData.width != 1024 && bmpData.width != 2048)
				{
					return false;
				}
			}
			
			if(bmpData.width != 1 && bmpData.height != 2 && bmpData.height != 4 && bmpData.height != 8 && bmpData.height != 16 && bmpData.height != 32)
			{
				if(bmpData.height != 64 && bmpData.height != 128 && bmpData.height != 256 && bmpData.height != 512 && bmpData.height != 1024 && bmpData.height != 2048)
				{
					return false;
				}
			}
			
			return true;
		}
		
		private function AmendTextureBitmap(bmpData:BitmapData, maxLength:int = 0, clearOriginBitmap:Boolean = true):BitmapData
		{
			if(bmpData == null)
			{
				return null;
			}
			
			if(maxLength <= 0)
			{
				if(CheckTextureBitmapValidated(bmpData))
				{
					return bmpData;
				}
				else
				{
					var asize:Point = GetAmendTextureSize(bmpData);
					var bmp:BitmapData = BitmapSizeScale(bmpData,asize.x,asize.y);
					if(clearOriginBitmap)
					{
						bmpData.dispose();
					}
					return bmp;
				}
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
		
		private function BitmapSizeScale(bmpData:BitmapData, width:int, height:int):BitmapData
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
		
		private function BitmapScale(bmpData:BitmapData, maxLength:int):BitmapData
		{
			if(bmpData == null)
			{
				return null;
			}
			var bmpData_:BitmapData;
			var size:Point;
			var width:int = bmpData.width;
			var height:int = bmpData.height;
			
			if(bmpData.width <= maxLength && bmpData.height <= maxLength)
			{
				size = GetAmendTextureSizeFromSizePoint(new Point(Number(bmpData.width), Number(bmpData.height)));
				var maxSize:Number=Math.max(size.x,size.y);
				if(width > height)
				{
					height = maxSize * height / width;
					width = maxSize;
				}
				else
				{
					width = maxSize * width / height;
					height = maxSize;
				}
			}
			else
			{
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
			}
			var size:Point = GetAmendTextureSizeFromSizePoint(new Point(Number(width), Number(height)));
			var scaleX:Number = size.x / (bmpData.width as Number);
			var scaleY:Number = size.y / (bmpData.height as Number);
			bmpData_=BitmapFactorScale(bmpData, scaleX, scaleY, size);
			return bmpData_
		}
		
		private function BitmapFactorScale(bmpData:BitmapData, scaleX:Number, scaleY:Number, size:Point = null):BitmapData
		{
			if(bmpData == null)
			{
				return null;
			}
			var matrix:Matrix = new Matrix();
			matrix.scale(scaleX, scaleY);
			var bmpData_:BitmapData = size != null ? new BitmapData(int(size.x), int(size.y), true, 0) : new BitmapData(int(scaleX * bmpData.width), int(scaleY * bmpData.height), true, 0);
			bmpData_.draw(bmpData, matrix);
			return bmpData_;
		}
		
		public static function ClearHighLightDatas():void
		{
			highLightDatas.length = 0;
		}
		
		private static function ImportHighLightData(diffuse:CTextureResource, light:CTextureResource):void
		{
			if(diffuse == null)
			{
				return;
			}
			
			if(diffuse is L3DBitmapTextureResource)
			{
				(diffuse as L3DBitmapTextureResource).texHighLightBakData = light;
			}
			else
			{
				var obj:* = {};
				obj.diffuse = diffuse;
				obj.light = light;
				highLightDatas.push(obj);
			}
		}
		
		private static function ExportHighLightData(diffuse:CTextureResource):CTextureResource
		{
			if(diffuse == null)
			{
				return null;
			}
			
			if(diffuse is L3DBitmapTextureResource)
			{
				var light:CTextureResource = (diffuse as L3DBitmapTextureResource).texHighLightBakData as CTextureResource;
				(diffuse as L3DBitmapTextureResource).texHighLightBakData = null;
				return light;
			}
			
			for(var i:int = highLightDatas.length - 1; i>=0; i--)
			{
				var obj:* = highLightDatas[i];
				if(obj.diffuse == diffuse)
				{
					highLightDatas.removeAt(i);
					return obj.light;
				}
			}
			
			return null;
		}
		
		public static function ShowTexHighLight(mesh:Mesh, highLight:Boolean, highLightMap:L3DBitmapTextureResource, defaultLightMap:L3DBitmapTextureResource, stage3D:Stage3D):void
		{
			if(mesh == null || mesh is L3DMesh)
			{
				return;
			}
			
			if(mesh.geometry == null || mesh.numSurfaces == 0)
			{
				return;
			}
			
			var material:Material = mesh.getSurface(0).material;
			if(material == null)
			{
				return;
			}
			
			var texture:CTextureResource = null;
			var ltexture:CTextureResource = null;
			if(material is LightMapMaterial)
			{
				texture = (material as LightMapMaterial).diffuseMap as CTextureResource;
				ltexture = (material as LightMapMaterial).lightMap as CTextureResource;
			}
			else if(material is StandardMaterial)
			{
				texture = (material as StandardMaterial).diffuseMap as CTextureResource;
				ltexture = (material as StandardMaterial).lightMap as CTextureResource;
			}
			
		/*	if(texture == null)
			{
				return;
			} */
			
		//	var bakLightMap:TextureResource = texture == null ? defaultLightMap : ExportHighLightData(texture);
		//	var oriHighLight:Boolean = texture.texHighLightBakData != null;
			var oriHighLight:Boolean = highLightMap == ltexture;
			if((highLight && oriHighLight) || (!highLight && !oriHighLight))
			{
				return;
			}
			
			if(highLight && !oriHighLight)
			{
				if(stage3D == null)
				{
					return;
				}
				if(material is LightMapMaterial)
				{
				//	ImportHighLightData(texture, (material as LightMapMaterial).lightMap);
				//	texture.texHighLightBakData = (material as LightMapMaterial).lightMap;
					(material as LightMapMaterial).lightMap = highLightMap;
				}
				else if(material is StandardMaterial)
				{
				//	ImportHighLightData(texture, (material as StandardMaterial).lightMap);
				//	texture.texHighLightBakData = (material as StandardMaterial).lightMap;
					(material as StandardMaterial).lightMap = highLightMap;
				}
			}
			else
			{
				if(material is LightMapMaterial)
				{
				/*	if((material as LightMapMaterial).lightMap != null)
					{
						(material as LightMapMaterial).lightMap.dispose();
						(material as LightMapMaterial).lightMap = null;
					} */
					(material as LightMapMaterial).lightMap = defaultLightMap;
				}
				else if(material is StandardMaterial)
				{
				/*	if((material as StandardMaterial).lightMap != null)
					{
						(material as StandardMaterial).lightMap.dispose();
						(material as StandardMaterial).lightMap = null;
					} */
					(material as StandardMaterial).lightMap = defaultLightMap;
				}
			//	texture.texHighLightBakData = null;
			}
		}
	}
}