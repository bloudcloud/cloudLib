package core.datas
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import mx.containers.Canvas;
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.UIDUtil;
	
	import core.L3DLibraryWebService;
	import core.events.L3DLibraryEvent;
	
	import resources.manager.GlobalManager;
	
	public class L3DMaterialInformations extends EventDispatcher
	{
		private var _name:String;
		private var _type:uint;
		
		public var code:String = "";
		public var brand:String = "";
		public var mode:String = "";
		public var unit:String = "";
		public var style:String = "";
		public var series:String = "";
		public var subSeries:String = "";
		public var classCode:String = "";
		public var className:String = "";
		public var price:Number = 0.0;
		public var cost:Number = 0.0;
		public var catalog:int = 0;
		public var spec:String = "";
		public var combo:String = "";
		public var remark:String = "";
		public var description:String = "";
		public var previewBuffer:ByteArray = null;
		public var url:String = "";
		public var offGround:Number = 0;
		public var offBoard:Number = 0;
		public var orgCode:String = "";
		public var orgName:String = "";
		public var parentCode:String = "";
		public var materialMode:int = 0;
		public var renderMode:int = 0;
		public var userData:Object;
		public var userData2:Object;
		public var userData3:Object;
		public var userData4:Object;
		public var userData5:Object;
		public var userData6:Object;
		public var userData7:Object;
		public var userData8:Object;
		public var linkedID:String;
		public var favouriteData:*;
		public var linkedDataUrl:String = "";
		public var linkVRDataUrl:String = "";
		public var linkCDDataUrl:String = "";
		public var family:String = "";
		public var vrmMode:int = 0;
		public var isPolyMode:Boolean = false;
		//liuxin20171111
		public var xml:XML;
		//cloud 2017.11.20
		public var meshBuffer:ByteArray;
		
		private var topviewBitmap:BitmapData = null;
		private var topviewClipBitmap:BitmapData = null;
		private var topviewPoints:Vector.<Point> = new Vector.<Point>();
		private var topviewUVs:Vector.<Point> = new Vector.<Point>();
		private var topviewIndices:Vector.<uint> = new Vector.<uint>();
		private var loadingUrl:String = "";
		private var _loadingBuffer:ByteArray = null;
		private var searchCode:String = "";
		private var searchType:int = 3;
		private var searchMode:int = 0;
		private var searchCatalog:int = 0;
		private var searchText:String = "";
		private var searchPid:String = "";
		private var _preview:BitmapData;
		
		public const SearchCodeMode:int = 0;
		public const SearchNameMode:int = 1;
		public const SearchBrandMode:int = 2;
		public const SearchPriceMode:int = 3;
		public const SearchMaterialResult:String = "SearchMaterialResult";
		public static const DownloadLinkedData:String = "DownloadLinkedData";
		public static const DownloadShapeData:String = "DownloadShapeData";
		public static const DownloadMaterialInfo:String = "DownloadMaterialInfo";
		public static var EnableLocalPreview:Boolean = false;
		
		public function get name():String
		{
			return _name;
		}
		public function set name(value:String):void
		{
			_name=value;
		}
		public function get type():uint
		{
			return _type;
		}
		public function set type(value:uint):void
		{
			_type=value;
		}
		public function get loadingBuffer():ByteArray
		{
			return _loadingBuffer;
		}
		
		public function L3DMaterialInformations(buffer:ByteArray = null, url:String = null)
		{
			this.url = url;
			Load(buffer);			
		}
		
		public function Exist():Boolean
		{
			return code != null && code.length > 0 && name != null && name.length > 0;
		}

		public function get ERPCode():String
		{
			if(classCode != null && classCode.length > 0)
			{
				return classCode;
			}
			
			return code;
		}
		
		public static function BuildColumnMaterialInformations(length:Number, width:Number, height:Number):L3DMaterialInformations
		{
			if(length < 5 || width < 5 || height < 5)
			{
				return null;
			}
			
			var m:L3DMaterialInformations = new L3DMaterialInformations();
			m.code = "LJ-Column";
			m.name = "柱";
			m.type = 4;
			m.catalog = 19;
			m.spec = length.toString() + "X" + width.toString() + "X" + height.toString();
			return m;
		}
		
		public static function BuildBeamMaterialInformations(length:Number, width:Number, height:Number):L3DMaterialInformations
		{
			if(length < 5 || width < 5 || height < 5)
			{
				return null;
			}
			
			var m:L3DMaterialInformations = new L3DMaterialInformations();
			m.code = "LJ-Beam";
			m.name = "梁";
			m.type = 4;
			m.catalog = 18;
			m.spec = length.toString() + "X" + width.toString() + "X" + height.toString();
			return m;
		}
		
		public static function BuildParamsCeilingMaterialInformations(length:Number, width:Number, height:Number):L3DMaterialInformations
		{
			if(length < 5 || width < 5 || height < 5)
			{
				return null;
			}
			
			var m:L3DMaterialInformations = new L3DMaterialInformations();
			m.code = "LJ-Ceiling";
			m.name = "自定义吊顶";
			m.type = 4;
			m.catalog = 32;
			m.spec = length.toString() + "X" + width.toString() + "X" + height.toString();
			return m;
		}
		
		public static function BuildRectLightMaterialInformations(length:Number, width:Number, height:Number):L3DMaterialInformations
		{
			if(length < 5 || width < 5 || height < 5)
			{
				return null;
			}
			
			var m:L3DMaterialInformations = new L3DMaterialInformations();
			m.code = "LJ-RectLight";
			m.name = "矩形面光";
			m.type = 4;
			m.catalog = 47;
			m.spec = length.toString() + "X" + width.toString() + "X" + height.toString();
			return m;
		}
		
//		public static function FromMesh(mesh:L3DMesh):L3DMaterialInformations
//		{
//			if(mesh == null)
//			{
//				return null;
//			}
//			
//			if(mesh.Code == null || mesh.Code.length == 0)
//			{
//				mesh.Code = GenerateUUID();
//			}
//			
//			if(mesh.Name == null || mesh.Name.length == 0)
//			{
//				mesh.Name = "mesh";
//			}
//			
//			if(mesh.boundBox == null)
//			{
//				mesh.boundBox = Object3DUtils.calculateHierarchyBoundBox(mesh);
//			}
//			
//			var materialInfo:L3DMaterialInformations = new L3DMaterialInformations();
//			materialInfo.code = mesh.Code;
//			materialInfo.classCode = mesh.ERPCode;
//			materialInfo.name = mesh.Name;
//			materialInfo.type = 4;
//			materialInfo.catalog = mesh.Mode;
//			materialInfo.family = mesh.family;
//			materialInfo.spec = int(mesh.boundBox.maxX - mesh.boundBox.minX).toString() + "X" + int(mesh.boundBox.maxY - mesh.boundBox.minY).toString() + "X" + int(mesh.boundBox.maxZ - mesh.boundBox.minZ).toString();
//			materialInfo.isPolyMode = mesh.isPolyMode;
//			
//			if(mesh.PreviewBuffer == null || mesh.PreviewBuffer.length == 0)
//			{
//				var bmp:BitmapData = new BitmapData(2,2,true, 0xffffff);
//				materialInfo.previewBuffer = L3DMaterial.BitmapDataToBuffer(bmp);
//				bmp.dispose();
//			}
//			else
//			{
//				materialInfo.previewBuffer = new ByteArray();
//				materialInfo.previewBuffer.writeBytes(mesh.PreviewBuffer, 0, mesh.PreviewBuffer.length);
//			}
//			materialInfo.offGround = mesh.OffGround;
//			materialInfo.offBoard = mesh.OffBoard;
//			
//			return materialInfo;
//		}
		
		private function Load(buffer:ByteArray):Boolean
		{
			if(buffer == null || buffer.length == 0)
			{
				return false;
			}
			
			code = ReadString(buffer);
			name = ReadString(buffer);
			classCode = ReadString(buffer);
			className = ReadString(buffer);
			type = buffer.readInt();
			price = buffer.readFloat();
			cost = buffer.readFloat();
			catalog = buffer.readInt();
			spec = ReadString(buffer);
			remark = ReadString(buffer);
			description = ReadString(buffer);
			var length:int = buffer.readInt();
			if(length > 0)
			{
				var previewBuffer:ByteArray = new ByteArray();
				buffer.readBytes(previewBuffer,0,length);
				this.previewBuffer = previewBuffer;
			}
			if(buffer.bytesAvailable > 0)
			{
			    offGround = buffer.readFloat();
				if(buffer.bytesAvailable > 0)
				{
					var u:String = ReadString(buffer);
					if(url == null || url.length == 0)
					{
			            url = u;
					}
					if(buffer.bytesAvailable > 0)
					{
						combo = ReadString(buffer);
						if(buffer.bytesAvailable > 0)
						{
							brand = ReadString(buffer);
							mode = ReadString(buffer);
							style = ReadString(buffer);
							series = ReadString(buffer);
							subSeries = ReadString(buffer);
							if(buffer.bytesAvailable > 0)
							{
								linkedDataUrl = ReadString(buffer);
								if(buffer.bytesAvailable > 0)
								{
									family = ReadString(buffer);
									if(buffer.bytesAvailable > 0)
									{
										vrmMode = buffer.readInt();
										if(buffer.bytesAvailable > 0)
										{
											isPolyMode = buffer.readInt() > 0;
											if(buffer.bytesAvailable > 0)
											{
												offBoard = buffer.readFloat();
												if(buffer.bytesAvailable > 0)
												{
													orgCode = ReadString(buffer);
													orgName = ReadString(buffer);
													if(buffer.bytesAvailable > 0)
													{
														linkVRDataUrl = ReadString(buffer);
														if(buffer.bytesAvailable > 0)
														{
															parentCode = ReadString(buffer);
															if(buffer.bytesAvailable > 0)
															{
																renderMode = buffer.readInt();
																if(buffer.bytesAvailable > 0)
																{
																	linkCDDataUrl = ReadString(buffer);
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
 						}
					}
				}
			}
			
			return true;
		}		
		
		public function set Preview(value:BitmapData):void{
			_preview = value;
		}
		
		public function get Preview():BitmapData
		{
			if(_preview != null)
			{
				return _preview;
			}
//			else if(EnableLocalPreview)
//			{
//				return LoadBitmapData(previewBuffer);
//			}
			else
			{
				return null;
			}
		}
		
		public function VRDataExist():Boolean
		{
			if(linkVRDataUrl != null && linkVRDataUrl.length > 0)
			{
				return true;
			}
			
			return false;
		}
		
		public function CDDataExist():Boolean
		{
			if(linkCDDataUrl != null && linkCDDataUrl.length > 0)
			{
				return true;
			}
			
			return false;
		}
		
		public function DownloadMaterial():void
		{
			if(!L3DLibraryWebService.WebServiceEnable)
			{
				return;
			}
			
			if(url == null || url.length == 0)
			{
				if(code != null && code.length > 0)
				{
					addEventListener(L3DLibraryEvent.DownloadMaterialInfo, SearchMaterialInfoFromCode);
					SearchMaterialInformation(code, 3);
				}
				else
				{
					return;
				}
			}
			
//			var atObj:AsyncToken = L3DLibraryWebService.LibraryService.DownloadMaterial(url);
//			var rpObj:mx.rpc.Responder = new mx.rpc.Responder(LoadMaterialDataResult, LoadMaterialDataFault);
//			atObj.addResponder(rpObj);

			//lrj 2017/12/8 
			GlobalManager.Instance.serviceMGR.downloadMaterial(LoadMaterialDataResult, LoadMaterialDataFault, url);
		}
		
		private function SearchMaterialInfoFromCode(event:L3DLibraryEvent):void
		{
			removeEventListener(L3DLibraryEvent.DownloadMaterialInfo, SearchMaterialInfoFromCode);
			if(event.MaterialInformation == null || event.MaterialInformation.url == null || event.MaterialInformation.url.length == 0)
			{	
				return;
			}
			
			url = event.MaterialInformation.url;
//			var atObj:AsyncToken = L3DLibraryWebService.LibraryService.DownloadMaterial(url);
//			var rpObj:mx.rpc.Responder = new mx.rpc.Responder(LoadMaterialDataResult, LoadMaterialDataFault);
//			atObj.addResponder(rpObj);

			//lrj 2017/12/7 
			GlobalManager.Instance.serviceMGR.downloadMaterial(LoadMaterialDataResult, LoadMaterialDataFault, url);
		}
		
		private function LoadMaterialDataResult(reObj:ResultEvent):void
		{
			var buffer:ByteArray = reObj.result as ByteArray;
			if(buffer == null || buffer.length == 0)
			{
				return;
			}
			buffer.position = 0;
			var event:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.DownloadMaterial);
			event.MaterialBuffer = buffer;
			event.MaterialType = type;
			this.dispatchEvent(event);
		}
		
		private function LoadMaterialDataFault(feObj:FaultEvent):void
		{
			var event:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.DownloadMaterial);
			event.MaterialBuffer = null;
			event.MaterialType = type;
			this.dispatchEvent(event);
		}
		
		public function DownloadMaterialData(code:String, url:String):void
		{
			if((code == null || code.length == 0) && (url == null || url.length == 0))
			{
				var event:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.DownloadMaterial);
				event.data = null;
				this.dispatchEvent(event);
				return;
			}
			
			searchCode = code;
			var atObj:AsyncToken;
			var rpObj:mx.rpc.Responder;
			if(url != null && url.length > 0)
			{
				atObj = L3DLibraryWebService.LibraryService.DownloadMaterial(url);
				rpObj = new mx.rpc.Responder(DownLoadMaterialDataResult, DownLoadMaterialDataFault);
				atObj.addResponder(rpObj);

				// 2017/12/8 lrj--
				//GlobalManager.Instance.serviceMGR.downloadMaterial(DownLoadMaterialDataResult, DownLoadMaterialDataFault, url);
			}
			else
			{
//				atObj = L3DLibraryWebService.LibraryService.GetViewDetailBufferFromCode(searchCode, 3);
//				rpObj = new mx.rpc.Responder(SearchMaterialDataResult, SearchMaterialDataFault);
//				atObj.addResponder(rpObj);

				//lrj 2017/12/8 
				GlobalManager.Instance.serviceMGR.getViewDetailBufferFromCode(SearchMaterialDataResult, SearchMaterialDataFault, searchCode, 3);
			}
		}
		
		private function DownLoadMaterialDataResult(reObj:ResultEvent):void
		{
			var buffer:ByteArray = reObj.result as ByteArray;
			if(buffer == null || buffer.length == 0)
			{
				if(searchCode != null && searchCode.length > 0)
				{
//					var atObj:AsyncToken = L3DLibraryWebService.LibraryService.GetViewDetailBufferFromCode(searchCode, 3);
//					var rpObj:mx.rpc.Responder = new mx.rpc.Responder(SearchMaterialDataResult, SearchMaterialDataFault);
//					atObj.addResponder(rpObj);

					//lrj 2017/12/8 
					GlobalManager.Instance.serviceMGR.getViewDetailBufferFromCode(SearchMaterialDataResult, SearchMaterialDataFault, searchCode, 3);
				}
				else
				{
					var event1:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.DownloadMaterial);
					event1.data = null;
					this.dispatchEvent(event1);
				}
			}
			else
			{
				buffer.position = 0;
			    var event:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.DownloadMaterial);
			    event.data = buffer;
			    this.dispatchEvent(event);
			}
		}
		
		private function DownLoadMaterialDataFault(feObj:FaultEvent):void
		{
			if(searchCode != null && searchCode.length > 0)
			{
//				var atObj:AsyncToken = L3DLibraryWebService.LibraryService.GetViewDetailBufferFromCode(searchCode, 3);
//				var rpObj:mx.rpc.Responder = new mx.rpc.Responder(SearchMaterialDataResult, SearchMaterialDataFault);
//				atObj.addResponder(rpObj);

				//lrj 2017/12/8 
				GlobalManager.Instance.serviceMGR.getViewDetailBufferFromCode(SearchMaterialDataResult, SearchMaterialDataFault, searchCode, 3);
			}
			else
			{
				var event1:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.DownloadMaterial);
				event1.data = null;
				this.dispatchEvent(event1);
			}
		}
		
		private function SearchMaterialDataResult(reObj:ResultEvent):void
		{
			searchCode = "";
			var buffer:ByteArray = reObj.result as ByteArray;
			if(buffer != null && buffer.length > 0)
			{
				var information:L3DMaterialInformations = new L3DMaterialInformations(buffer, "");				
				if(information.url != null && information.url.length > 0)
				{
//					var atObj:AsyncToken = L3DLibraryWebService.LibraryService.DownloadMaterial(information.url);
//					var rpObj:mx.rpc.Responder = new mx.rpc.Responder(DownLoadMaterialDataResult, DownLoadMaterialDataFault);
//					atObj.addResponder(rpObj);

					//lrj 2017/12/8 
					GlobalManager.Instance.serviceMGR.downloadMaterial(DownLoadMaterialDataResult, DownLoadMaterialDataFault, information.url);
				}
				else
				{
					var event1:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.DownloadMaterial);
					event1.data = null;
					this.dispatchEvent(event1);
				}
			}
			else
			{
				var event:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.DownloadMaterial);
				event.data = null;
				this.dispatchEvent(event);
			}
		}			
		
		private function SearchMaterialDataFault(feObj:FaultEvent):void
		{
			searchCode = "";
			var event:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.DownloadMaterial);
			event.data = null;
			this.dispatchEvent(event);
		}
		
		public function DownloadMaterialLinkedData(code:String, url:String):void
		{
			if((code == null || code.length == 0) && (url == null || url.length == 0))
			{
				var event:L3DLibraryEvent = new L3DLibraryEvent(DownloadLinkedData);
				event.data = null;
				this.dispatchEvent(event);
				return;
			}
			
			searchCode = code;
			var atObj:AsyncToken;
			var rpObj:mx.rpc.Responder;
			if(url != null && url.length > 0)
			{
//				atObj = L3DLibraryWebService.LibraryService.DownloadMaterialDetailBuffer(url, 3);
//				rpObj = new mx.rpc.Responder(LoadMaterialLinkedDataResult, LoadMaterialLinkedDataFault);
//				atObj.addResponder(rpObj);

				//lrj 2017/12/10
				GlobalManager.Instance.serviceMGR.downloadMaterialDetailBuffer(LoadMaterialLinkedDataResult, LoadMaterialLinkedDataFault, url, 3);
			}
			else
			{
//				atObj = L3DLibraryWebService.LibraryService.GetViewDetailBufferFromCode(searchCode, 3);
//				rpObj = new mx.rpc.Responder(SearchMaterialLinkedDataResult, SearchMaterialLinkedDataFault);
//				atObj.addResponder(rpObj);

				//lrj 2017/12/8 
				GlobalManager.Instance.serviceMGR.getViewDetailBufferFromCode(SearchMaterialLinkedDataResult, SearchMaterialLinkedDataFault, searchCode, 3);
			}
		}
		
		private function LoadMaterialLinkedDataResult(reObj:ResultEvent):void
		{
			var buffer:ByteArray = reObj.result as ByteArray;
			var atObj:AsyncToken;
			var rpObj:mx.rpc.Responder;
			if(buffer == null || buffer.length == 0)
			{
				if(searchCode != null && searchCode.length > 0)
				{
//					atObj = L3DLibraryWebService.LibraryService.GetViewDetailBufferFromCode(searchCode, 3);
//					rpObj = new mx.rpc.Responder(SearchMaterialLinkedDataResult, SearchMaterialLinkedDataFault);
//					atObj.addResponder(rpObj);

					//lrj 2017/12/8 
					GlobalManager.Instance.serviceMGR.getViewDetailBufferFromCode(SearchMaterialLinkedDataResult, SearchMaterialLinkedDataFault, searchCode, 3);
				}
				else
				{
					var event1:L3DLibraryEvent = new L3DLibraryEvent(DownloadLinkedData);
					event1.data = null;
					this.dispatchEvent(event1);
				}
			}
			else
			{
				var information:L3DMaterialInformations = new L3DMaterialInformations(buffer);
			//	information.DownloadLinkedDataBuffer();
				if(information.linkedDataUrl == null || information.linkedDataUrl.length == 0)
				{
					var event2:L3DLibraryEvent = new L3DLibraryEvent(DownloadLinkedData);
					event2.data = null;
					this.dispatchEvent(event2);
				}
				else
				{
//					atObj = L3DLibraryWebService.LibraryService.Download(information.linkedDataUrl);
//					rpObj = new mx.rpc.Responder(DownloadLinkedDataResult, DownloadLinkedDataFault);
//					atObj.addResponder(rpObj);

					//2017/12/8 lrj
					GlobalManager.Instance.serviceMGR.download(DownloadLinkedDataResult, DownloadLinkedDataFault, information.linkedDataUrl);
				}
			}
		}
		
		private function LoadMaterialLinkedDataFault(feObj:FaultEvent):void
		{
			if(searchCode != null && searchCode.length > 0)
			{
//				var atObj:AsyncToken = L3DLibraryWebService.LibraryService.GetViewDetailBufferFromCode(searchCode, 3);
//				var rpObj:mx.rpc.Responder = new mx.rpc.Responder(SearchMaterialLinkedDataResult, SearchMaterialLinkedDataFault);
//				atObj.addResponder(rpObj);

				//lrj 2017/12/8 
				GlobalManager.Instance.serviceMGR.getViewDetailBufferFromCode(SearchMaterialLinkedDataResult, SearchMaterialLinkedDataFault, searchCode, 3);
			}
			else
			{
				var event1:L3DLibraryEvent = new L3DLibraryEvent(DownloadLinkedData);
				event1.data = null;
				this.dispatchEvent(event1);
			}
		}
		
		private function SearchMaterialLinkedDataResult(reObj:ResultEvent):void
		{
			searchCode = "";
			var buffer:ByteArray = reObj.result as ByteArray;
			if(buffer != null && buffer.length > 0)
			{
				var information:L3DMaterialInformations = new L3DMaterialInformations(buffer, "");
		//		information.DownloadLinkedDataBuffer();
				if(information.linkedDataUrl == null || information.linkedDataUrl.length == 0)
				{
					var event1:L3DLibraryEvent = new L3DLibraryEvent(DownloadLinkedData);
					event1.data = null;
					this.dispatchEvent(event1);
				}
				else
				{
//				    var atObj:AsyncToken = L3DLibraryWebService.LibraryService.Download(information.linkedDataUrl);
//				    var rpObj:mx.rpc.Responder = new mx.rpc.Responder(DownloadLinkedDataResult, DownloadLinkedDataFault);
//				    atObj.addResponder(rpObj);

				    //2017/12/8 lrj
				    GlobalManager.Instance.serviceMGR.download(DownloadLinkedDataResult, DownloadLinkedDataFault, information.linkedDataUrl);
				}
			}
			else
			{
				var event:L3DLibraryEvent = new L3DLibraryEvent(DownloadLinkedData);
				event.data = null;
				this.dispatchEvent(event);
			}
		}			
		
		private function SearchMaterialLinkedDataFault(feObj:FaultEvent):void
		{
			searchCode = "";
			var event:L3DLibraryEvent = new L3DLibraryEvent(DownloadLinkedData);
			event.data = null;
			this.dispatchEvent(event);
		}
		
		public function DownloadMaterialInformationData(code:String, url:String, type:int = 0):void
		{
			if((code == null || code.length == 0) && (url == null || url.length == 0))
			{
				var event:L3DLibraryEvent = new L3DLibraryEvent(DownloadMaterialInfo);
				event.data = null;
				this.dispatchEvent(event);
				return;
			}
			
			searchCode = code;
			searchType = type;
			var atObj:AsyncToken;
			var rpObj:mx.rpc.Responder;
			if(url != null && url.length > 0)
			{
				//cloud 2017.12.26
				GlobalManager.Instance.serviceMGR.downloadMaterialDetailBuffer(LoadMaterialInformationDataResult, LoadMaterialInformationDataFault, url, searchType);
			}
			else
			{
				//lrj 2017/12/8 
				GlobalManager.Instance.serviceMGR.getViewDetailBufferFromCode(SearchMaterialInformationDataResult, SearchMaterialInformationDataFault, searchCode, searchType);
			}
		}
		
		private function LoadMaterialInformationDataResult(reObj:ResultEvent):void
		{
			var buffer:ByteArray = reObj.result as ByteArray;
			if(buffer == null || buffer.length == 0)
			{
				if(searchCode != null && searchCode.length > 0)
				{
//					var atObj:AsyncToken = L3DLibraryWebService.LibraryService.GetViewDetailBufferFromCode(searchCode, searchType);
//					var rpObj:mx.rpc.Responder = new mx.rpc.Responder(SearchMaterialInformationDataResult, SearchMaterialInformationDataFault);
//					atObj.addResponder(rpObj);

					//lrj 2017/12/8 
					GlobalManager.Instance.serviceMGR.getViewDetailBufferFromCode(SearchMaterialInformationDataResult, SearchMaterialInformationDataFault, searchCode, searchType);
				}
				else
				{
					var event1:L3DLibraryEvent = new L3DLibraryEvent(DownloadMaterialInfo);
					event1.data = null;
					this.dispatchEvent(event1);
				}
			}
			else
			{
				var information:L3DMaterialInformations = new L3DMaterialInformations(buffer);
				var event2:L3DLibraryEvent = new L3DLibraryEvent(DownloadMaterialInfo);
				event2.data = information;
				this.dispatchEvent(event2);
			}
		}
		
		private function LoadMaterialInformationDataFault(feObj:FaultEvent):void
		{
			if(searchCode != null && searchCode.length > 0)
			{
//				var atObj:AsyncToken = L3DLibraryWebService.LibraryService.GetViewDetailBufferFromCode(searchCode, searchType);
//				var rpObj:mx.rpc.Responder = new mx.rpc.Responder(SearchMaterialInformationDataResult, SearchMaterialInformationDataFault);
//				atObj.addResponder(rpObj);

				//lrj 2017/12/8 
				GlobalManager.Instance.serviceMGR.getViewDetailBufferFromCode(SearchMaterialInformationDataResult, SearchMaterialInformationDataFault, searchCode, searchType);
			}
			else
			{
				var event1:L3DLibraryEvent = new L3DLibraryEvent(DownloadMaterialInfo);
				event1.data = null;
				this.dispatchEvent(event1);
			}
		}
		
		private function SearchMaterialInformationDataResult(reObj:ResultEvent):void
		{
			searchCode = "";
			var buffer:ByteArray = reObj.result as ByteArray;
			if(buffer != null && buffer.length > 0)
			{
				var information:L3DMaterialInformations = new L3DMaterialInformations(buffer, "");
				var event1:L3DLibraryEvent = new L3DLibraryEvent(DownloadMaterialInfo);
				event1.data = information;
				this.dispatchEvent(event1);
			}
			else
			{
				var event:L3DLibraryEvent = new L3DLibraryEvent(DownloadLinkedData);
				event.data = null;
				this.dispatchEvent(event);
			}
		}			
		
		private function SearchMaterialInformationDataFault(feObj:FaultEvent):void
		{
			searchCode = "";
			var event:L3DLibraryEvent = new L3DLibraryEvent(DownloadMaterialInfo);
			event.data = null;
			this.dispatchEvent(event);
		}
		
		public function LoadPreview():void
		{
			if(previewBuffer == null || previewBuffer.length == 0)
			{
				var evt:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.LoadPreview);
				evt.PreviewBitmap = new BitmapData(8,8,false,0xffffff);
				this.dispatchEvent(evt);
				return;
			}
			
			var loader:Loader = new Loader();
			loader.loadBytes(previewBuffer);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderPreviewBitmapComplete);	
		}
		
		private function loaderPreviewBitmapComplete(event:Event):void
		{
			event.currentTarget.removeEventListener(event.type,arguments.callee);
			var loaderInfo:LoaderInfo = LoaderInfo(event.target);
			var checkBitmap:BitmapData=(loaderInfo.loader.content as Bitmap).bitmapData.clone();
			if(checkBitmap == null)
			{
				return;
			}
			var evt:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.LoadPreview);
			evt.PreviewBitmap = checkBitmap;
			this.Preview=checkBitmap;
			this.dispatchEvent(evt);
			loaderInfo.loader.unloadAndStop();
		}
		
//		public function DownloadTopview():void
//		{
//			if(!L3DLibraryWebService.WebServiceEnable || url == null || url.length == 0)
//			{
//				return;
//			}
//			//2017/12/8 lrj--
//			GlobalManager.Instance.serviceMGR.downloadMaterialTopviewBuffer(LoadTopviewDataResult, LoadTopviewDataFault, url);
//		}
		
//		private function LoadTopviewDataResult(reObj:ResultEvent):void
//		{
//			var buffer:ByteArray = reObj.result as ByteArray;
//			if(buffer == null || buffer.length == 0)
//			{
//				return;
//			}
//			_loadingBuffer = buffer;
//			_loadingBuffer.position = 0;			
//
//			var length:int = buffer.readInt();
//			if(length > 0)
//			{
//				var bmpBuffer:ByteArray = new ByteArray();
//				_loadingBuffer.readBytes(bmpBuffer,0,length);
//				var loader:Loader = new Loader();
//				loader.loadBytes(bmpBuffer);
//				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCheckBitmapComplete);	
//			}			
//		}
		
//		private function loaderCheckBitmapComplete(event:Event):void
//		{
//			var loaderInfo:LoaderInfo = LoaderInfo(event.target);
//			event.currentTarget.removeEventListener(event.type,arguments.callee);
//			var checkBitmap:BitmapData=(loaderInfo.loader.content as Bitmap).bitmapData;
////			var checkBitmap:BitmapData = new BitmapData(loaderInfo.width, loaderInfo.height, false, 0xFFFFFF);
////			checkBitmap.draw(loaderInfo.loader);
//
//			if(checkBitmap == null)
//			{
//				return;
//			}
//			
//			topviewBitmap = L3DUtils.BitmapMirror(checkBitmap, false, false);
//			loaderInfo.loader.unloadAndStop();
//			checkBitmap = null;
//			
//			var length:int = _loadingBuffer.readInt();
//			if(length > 0)
//			{
//				//cloud 2018.1.17 去掉tryCatch
//				var clipBuffer:ByteArray = new ByteArray();
//				_loadingBuffer.readBytes(clipBuffer,0,length);
//				var loader:Loader = new Loader();
//				loader.loadBytes(clipBuffer);
//				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderClipBitmapComplete);	
////				try
////				{
////					var clipBuffer:ByteArray = new ByteArray();
////					_loadingBuffer.readBytes(clipBuffer,0,length);
////					var loader:Loader = new Loader();
////					loader.loadBytes(clipBuffer);
////					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderClipBitmapComplete);	
////				} 
////				catch(error:Error) 
////				{
////					
////				}
//			}
//		}
		
		private function loaderClipBitmapComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = LoaderInfo(event.target);
			event.currentTarget.removeEventListener(event.type,arguments.callee);
			topviewClipBitmap=(loaderInfo.loader.content as Bitmap).bitmapData.clone();
//			topviewClipBitmap = new BitmapData(loaderInfo.width, loaderInfo.height, false, 0xFFFFFF);
//			topviewClipBitmap.draw(loaderInfo.loader);
			loaderInfo.loader.unloadAndStop();
			if(topviewClipBitmap == null)
			{
				return;
			}
			
			var length:int = 0;
			try
			{
				length = _loadingBuffer.readInt();
			}
			catch(error:Error)
			{
				length = 0;
				var evt:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.DownloadTopview);
				evt.PreviewBitmap = null;
				this.dispatchEvent(event);
			}

			if(length > 0)
			{
				for(var i:int = 0; i<length; i++)
				{
					var point:Point = new Point(_loadingBuffer.readFloat(), _loadingBuffer.readFloat());
					topviewPoints.push(point);
				}
			}
			length = _loadingBuffer.readInt();
			if(length > 0)
			{
				for(var m:int = 0; m<length; m++)
				{
					var uv:Point = new Point(_loadingBuffer.readFloat(), _loadingBuffer.readFloat());
					topviewUVs.push(point);
				}
			}
			length = _loadingBuffer.readInt();
			if(length > 0)
			{
				for(var n:int = 0; n<length; n++)
				{
					var index:uint = _loadingBuffer.readUnsignedInt();
					topviewIndices.push(index);
				}
			}
			
			BuildFullTopview();
		}
		
		private function BuildFullTopview():void
		{
			var event:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.DownloadTopview);
			if(topviewBitmap != null)
			{
				if(topviewClipBitmap != null)
				{
					var clipBmp:BitmapData = BitmapSizeScale(topviewClipBitmap, topviewBitmap.width, topviewBitmap.height);
					if(clipBmp != null)
					{
						for(var x:int=0;x<topviewBitmap.width;x++)
						{
							for(var y:int=0;y<topviewBitmap.height;y++)
							{								
								if(x >= clipBmp.width || y >= clipBmp.height)
								{
									topviewBitmap.setPixel32(x, y, 0x00000000);
								}
								else
								{
								    var color:uint = clipBmp.getPixel(x,y);
								    if(color < 0xDDDDDD)
								    {
									    topviewBitmap.setPixel32(x, y, 0x00000000);
								    }
									else if(catalog == 7)
									{
										topviewBitmap.setPixel32(x, y, 0xAA000000 + topviewBitmap.getPixel(x,y));
									}
								}
							}
						}
						clipBmp.dispose();
						clipBmp = null;
					}
					topviewClipBitmap.dispose();
					topviewClipBitmap = null;
				}
				event.PreviewBitmap = topviewBitmap;
			}	
			this.dispatchEvent(event);
		}
		
		private function LoadTopviewDataFault(feObj:FaultEvent):void
		{
		//	Alert.show(feObj.fault.toString());
		}
		
		public function DownloadLinkedDataBuffer():void
		{
			if(!L3DLibraryWebService.WebServiceEnable || linkedDataUrl == null || linkedDataUrl.length == 0)
			{
				var event:L3DLibraryEvent = new L3DLibraryEvent(DownloadLinkedData);
				event.data = null;
				this.dispatchEvent(event);
				return;
			}
			
			var atObj:AsyncToken = L3DLibraryWebService.LibraryService.Download(linkedDataUrl);
			var rpObj:mx.rpc.Responder = new mx.rpc.Responder(DownloadLinkedDataResult, DownloadLinkedDataFault);
			atObj.addResponder(rpObj);
		}
		
		private function DownloadLinkedDataResult(reObj:ResultEvent):void
		{			
			var buffer:ByteArray = reObj.result as ByteArray;
			if(buffer == null || buffer.length == 0)
			{
				var event1:L3DLibraryEvent = new L3DLibraryEvent(DownloadLinkedData);
				event1.data = null;
				this.dispatchEvent(event1);
				return;
			}
			
			var event:L3DLibraryEvent = new L3DLibraryEvent(DownloadLinkedData);
			event.data = buffer;
			this.dispatchEvent(event);
		}
		
		private function DownloadLinkedDataFault(feObj:FaultEvent):void
		{
			var event:L3DLibraryEvent = new L3DLibraryEvent(DownloadLinkedData);
			event.data = null;
			this.dispatchEvent(event);
		}
		
		public function DownloadLinkedRoomXML():void
		{
			if(!L3DLibraryWebService.WebServiceEnable || linkedDataUrl == null || linkedDataUrl.length == 0)
			{
				return;
			}
			
//			var atObj:AsyncToken = L3DLibraryWebService.LibraryService.DownloadUserFileContentsXML(linkedDataUrl);
//			var rpObj:mx.rpc.Responder = new mx.rpc.Responder(DownloadLinkedRoomXMLResult, DownloadLinkedRoomXMLFault);
//			atObj.addResponder(rpObj);

			//lrj 2017/12/7 
			GlobalManager.Instance.serviceMGR.downloadUserFileContentsXML(DownloadLinkedRoomXMLResult, DownloadLinkedRoomXMLFault, linkedDataUrl);
		}
		
		private function DownloadLinkedRoomXMLResult(reObj:ResultEvent):void
		{			
			var xml:XML = XML(reObj.result);
			if(xml == null)
			{
				return;
			}
			
			var event:L3DLibraryEvent = new L3DLibraryEvent(DownloadLinkedData);
			event.data = xml;
			this.dispatchEvent(event);
		}
		
		private function DownloadLinkedRoomXMLFault(feObj:FaultEvent):void
		{
//			L3DLibrary.L3DLibrary.ShowMessage(feObj.fault.toString(), 1);
		}
		
		public function DownloadShapeBitmap():void
		{
			if(!L3DLibraryWebService.WebServiceEnable || linkedDataUrl == null || linkedDataUrl.length == 0)
			{
				return;
			}
			
			if(linkedDataUrl.toUpperCase().indexOf(".XML") <= 0)
			{
			    return;	
			}
			
			var atObj:AsyncToken = L3DLibraryWebService.LibraryService.Download(linkedDataUrl);
			var rpObj:mx.rpc.Responder = new mx.rpc.Responder(DownloadShapeBitmapResult, DownloadShapeBitmapFault);
			atObj.addResponder(rpObj);
		}
		
		private function DownloadShapeBitmapResult(reObj:ResultEvent):void
		{			
			var buffer:ByteArray = reObj.result as ByteArray;
			if(buffer == null || buffer.length == 0)
			{
				return;
			}
			
			var xmlStr:String = String(buffer);
			if(xmlStr == null || xmlStr.length == 0)
			{
				return;
			}
			
			var xml:XML = XML(xmlStr);
			
			var max:Point = new Point();
			var min:Point = new Point();
			var points:Array = [];
			var numPoints:int = xml.point.length();
			if(numPoints <= 0)
			{
				return;
			}
			var i:int;
			for(i = 0; i<numPoints; i++)
			{
				var point:Point = new Point();
				point.x = xml.point[i].@x;
				point.y = xml.point[i].@y;
				if(i == 0)
				{
					max.x = point.x;
					max.y = point.y;
					min.x = point.x;
					min.y = point.y;
				}
				else
				{
					max.x = Math.max(point.x, max.x);
					max.y = Math.max(point.y, max.y);
					min.x = Math.min(point.x, min.x);
					min.y = Math.min(point.y, min.y);
				}
				points.push(point);
			}
			
			if(points.length < 3)
			{
				return;
			}
			
			var width:Number = int(Math.abs(max.x - min.x));
			var height:Number = int(Math.abs(max.y - min.y));
			
			if(width <= 0 || height <= 0)
			{
				return;
			}
			
			var scaleRatio:Number = Math.min(150 / width, 150 / height);
			var deltaX:int = 25;
			var deltaY:int = 25;
			if(width > height)
			{
				deltaY += (width - height) * scaleRatio * 0.5;
			}
			else
			{
				deltaX += (height - width) * scaleRatio * 0.5;
			}
			
			var drawCanvas:Canvas = new Canvas();
			drawCanvas.width = 200;
			drawCanvas.height = 200;
			drawCanvas.graphics.clear();
			drawCanvas.graphics.beginFill(0xFFFFFF, 1);
			drawCanvas.graphics.drawRect(0,0,drawCanvas.width, drawCanvas.height);
			drawCanvas.graphics.endFill();
			
			drawCanvas.graphics.lineStyle(1, 0x000000);
			drawCanvas.graphics.beginFill(0x666666, 1);
			for(i=0; i<points.length; i++)
			{
				var drawPoint:Point = new Point((points[i].x - min.x) * scaleRatio, (points[i].y - min.y) * scaleRatio);
                if(i == 0)
				{
					drawCanvas.graphics.moveTo(drawPoint.x + deltaX, 200 - drawPoint.y - deltaY);
				}
				else
				{
					drawCanvas.graphics.lineTo(drawPoint.x + deltaX, 200 - drawPoint.y - deltaY);
				}
			}
			drawCanvas.graphics.endFill();
			
			var bitmap:BitmapData = new BitmapData(drawCanvas.width, drawCanvas.height);
			bitmap.draw(drawCanvas);
			
			var event:L3DLibraryEvent = new L3DLibraryEvent(DownloadShapeData);
			var obj:*= {};
			obj.width = width;
			obj.height = height;
			obj.bitmap = bitmap;
			event.data = obj;
			this.dispatchEvent(event);
		}
		
		private function DownloadShapeBitmapFault(feObj:FaultEvent):void
		{
		//	L3DLibrary.L3DLibrary.ShowMessage(feObj.fault.toString(), 1);
		}
		
		//type： 0：全图 1：100 2：200 3：None
		public function LoadMaterialInformation(url:String, type:int = 0):void
		{
			if(url == null || url.length == 0 || !L3DLibraryWebService.WebServiceEnable)
			{	
				var event:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.DownloadMaterialInfo);
				event.MaterialInformation = null;
				dispatchEvent(event);
				return;
			}
			
			loadingUrl = url;
			var atObj:AsyncToken = L3DLibraryWebService.LibraryService.DownloadMaterialDetailBuffer(url, type);
			var rpObj:mx.rpc.Responder = new mx.rpc.Responder(LoadMaterialInformationResult, LoadMaterialInformationFault);
			atObj.addResponder(rpObj);
		}
		
		private function LoadMaterialInformationResult(reObj:ResultEvent):void
		{
			var buffer:ByteArray = reObj.result as ByteArray;
			var event:L3DLibraryEvent = null;
			if(buffer != null && buffer.length > 0)
			{
			    var information:L3DMaterialInformations = new L3DMaterialInformations(buffer, loadingUrl);
                event = new L3DLibraryEvent(L3DLibraryEvent.DownloadMaterialInfo);
				event.MaterialInformation = information;
				dispatchEvent(event);
			}
			else
			{
				event = new L3DLibraryEvent(L3DLibraryEvent.DownloadMaterialInfo);
				event.MaterialInformation = null;
				dispatchEvent(event);
			}
		}	
		
		private function LoadMaterialInformationFault(feObj:FaultEvent):void
		{
			var event:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.DownloadMaterialInfo);
			event.MaterialInformation = null;
			dispatchEvent(event);
		}
		
		// type： 0：全图 1：100 2：200 3：None
		public function SearchMaterialInformation(code:String, type:int = 0):void
		{
			if(code == null || code.length == 0 || !L3DLibraryWebService.WebServiceEnable)
			{	
				return;
			}
			searchCode = code;
			searchType = type;
//			var atObj:AsyncToken = L3DLibraryWebService.LibraryService.GetViewDetailBufferFromCode(code, type);
//			var rpObj:mx.rpc.Responder = new mx.rpc.Responder(SearchMaterialInformationResult, SearchMaterialInformationFault);
//			atObj.addResponder(rpObj);

			//lrj 2017/12/8 
			GlobalManager.Instance.serviceMGR.getViewDetailBufferFromCode(SearchMaterialInformationResult, SearchMaterialInformationFault, code, type);
		}
		
		private function SearchMaterialInformationResult(reObj:ResultEvent):void
		{
			var buffer:ByteArray = reObj.result as ByteArray;
			var event:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.DownloadMaterialInfo);
			if(buffer != null && buffer.length > 0)
			{
				var information:L3DMaterialInformations = new L3DMaterialInformations(buffer, "");				
				event.MaterialInformation = information;
				dispatchEvent(event);
			}
			else
			{
			//	event.MaterialInformation = null;
//				var atObj:AsyncToken = L3DLibraryWebService.LibraryService.GetUserSpaceViewDetailBufferFromCode(L3DLibrary.L3DLibrary.sceneUserCode, searchCode, searchType);
//				var rpObj:mx.rpc.Responder = new mx.rpc.Responder(SearchUserSpaceMaterialInformationResult, SearchUserSpaceMaterialInformationFault);
//				atObj.addResponder(rpObj);

				//lrj 2017/12/8 
//				GlobalManager.Instance.serviceMGR.getUserSpaceViewDetailBufferFromCode(SearchUserSpaceMaterialInformationResult, SearchUserSpaceMaterialInformationFault, L3DLibrary.L3DLibrary.sceneUserCode, searchCode, searchType);
			}			
		}			
		
		private function SearchMaterialInformationFault(feObj:FaultEvent):void
		{
//			var atObj:AsyncToken = L3DLibraryWebService.LibraryService.GetUserSpaceViewDetailBufferFromCode(L3DLibrary.L3DLibrary.sceneUserCode, searchCode, searchType);
//			var rpObj:mx.rpc.Responder = new mx.rpc.Responder(SearchUserSpaceMaterialInformationResult, SearchUserSpaceMaterialInformationFault);
//			atObj.addResponder(rpObj);

			//lrj 2017/12/8 
//			GlobalManager.Instance.serviceMGR.getUserSpaceViewDetailBufferFromCode(SearchUserSpaceMaterialInformationResult, SearchUserSpaceMaterialInformationFault, L3DLibrary.L3DLibrary.sceneUserCode, searchCode, searchType);

		//	var event:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.DownloadMaterialInfo);
		//	event.MaterialInformation = null;
		//	dispatchEvent(event);
		}
		
		private function SearchUserSpaceMaterialInformationResult(reObj:ResultEvent):void
		{
			var buffer:ByteArray = reObj.result as ByteArray;
			var event:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.DownloadMaterialInfo);
			if(buffer != null && buffer.length > 0)
			{
				var information:L3DMaterialInformations = new L3DMaterialInformations(buffer, "");				
				event.MaterialInformation = information;				
			}
			else
			{
				event.MaterialInformation = null;
			}
			dispatchEvent(event);
		}			
		
		private function SearchUserSpaceMaterialInformationFault(feObj:FaultEvent):void
		{
			var event:L3DLibraryEvent = new L3DLibraryEvent(L3DLibraryEvent.DownloadMaterialInfo);
			event.MaterialInformation = null;
			dispatchEvent(event);
		}
		
		public function GetSize():Array
		{
			if(spec == null || spec.length == 0)
			{
				return new Array([0,0,0]);
			}
			
			var v:String = spec.toLowerCase();
			var t:Array = v.split("x");
			if(t == null || t.length < 2)
			{
				return [[0,0,0]];
			}
			
			var e:Array = [];
			e.push(parseInt(t[0]));
			e.push(parseInt(t[1]));
			if(t.length > 2)
			{
				e.push(parseInt(t[2]));
			}
			
			return e;
		}
		
		public function GetSizeVector():Vector3D
		{
			if(spec == null || spec.length == 0)
			{
				return new Vector3D();
			}
			
			var size:Vector3D = new Vector3D();
			var sizeArray:Array = spec.toUpperCase().split("X");
			if(sizeArray == null || sizeArray.length < 2)
			{
				return size;
			}
			else if(sizeArray.length == 2)
			{
				size.x = parseInt(sizeArray[0]);
				size.y = parseInt(sizeArray[1]);
			}
			else
			{				
				size.x = parseInt(sizeArray[0]);
				size.y = parseInt(sizeArray[1]);
				size.z = parseInt(sizeArray[2]);
			}
			
			return size;
		}
		/**
		 * 销毁商品信息数据对象 
		 * 
		 */		
		public function Dispose(isAllDispose:Boolean=false):void
		{
			//cloud 2018.1.25 完善商品信息数据的释放
			favouriteData=null;
			userData=null;
			userData2=null;
			userData3=null;
			userData4=null;
			userData5=null;
			userData6=null;
			userData7=null;
			userData8=null;
			if(topviewPoints)
			{
				topviewPoints.length=0;
			}
			if(topviewUVs)
			{
				topviewUVs.length=0;
			}
			if(topviewIndices)
			{
				topviewIndices.length=0;
			}
			if(topviewBitmap != null)
			{
				topviewBitmap.dispose();
				topviewBitmap = null;
			}
			if(topviewClipBitmap != null)
			{
				topviewClipBitmap.dispose();
				topviewClipBitmap = null;
			}
			//buffser是保存起来的，所有的商品信息都是引用一份buffer,所以不能clear,只能置空
			if(isAllDispose)
			{
				if(previewBuffer)
				{
					previewBuffer.clear();
					previewBuffer = null;
				}
				if(meshBuffer)
				{
					meshBuffer.clear();
					meshBuffer=null;
				}
				if(_loadingBuffer)
				{
					_loadingBuffer.clear();
					_loadingBuffer=null;
				}
				if(_preview)
				{
					_preview.dispose();
					_preview=null;
				}
			}
			else
			{
				previewBuffer = null;
				meshBuffer=null;
				_loadingBuffer=null;
				_preview=null;
			}
		}
		
		public function Clone():L3DMaterialInformations
		{
			var m:L3DMaterialInformations = new L3DMaterialInformations();
			m.code = code;
			m.name = name;
			m.family = family;
			m.classCode = classCode;
			m.className = className;
			m.type = type;
			m.price = price;
			m.cost = cost;
			m.catalog = catalog;
			m.spec = spec;			
			m.brand = brand;
			m.mode = mode;
			m.unit = unit;
			m.style = style;
			m.series = series;
			m.subSeries = subSeries;
			m.combo = combo;			
			m.remark = remark;
			m.description = description;
			if(previewBuffer != null)
			{
				m.previewBuffer = new ByteArray();
				m.previewBuffer.writeBytes(previewBuffer, 0, previewBuffer.length);				
			}
			m.url = url;
			m.linkedDataUrl = linkedDataUrl;
			m.linkedID = linkedID;
			m.linkVRDataUrl = linkVRDataUrl;
			m.linkCDDataUrl = linkCDDataUrl;
			m.family = family;
			m.parentCode = parentCode;
			m.orgCode = orgCode;
			m.orgName = orgName;
			m.offGround = offGround;
			m.isPolyMode = isPolyMode;
			m.meshBuffer = meshBuffer;
			m.Preview = Preview==null ? null : Preview.clone();
			m.topviewBitmap = topviewBitmap == null ? null : topviewBitmap.clone();
			m.topviewClipBitmap = topviewClipBitmap == null ? null : topviewClipBitmap.clone();
			m.vrmMode = vrmMode;
			m.renderMode = renderMode;
			if(topviewPoints != null && topviewPoints.length > 0)
			{
				for each(var point1:Point in topviewPoints)
				{
					m.topviewPoints.push(point1.clone());
				}
			}
			if(topviewUVs != null && topviewUVs.length > 0)
			{
				for each(var point2:Point in topviewUVs)
				{
					m.topviewUVs.push(point2.clone());
				}
			}
			if(topviewIndices != null && topviewIndices.length > 0)
			{
				for each(var index:uint in topviewIndices)
				{
					m.topviewIndices.push(index);
				}
			}

			return m;
		}
		
		public function Update():void
		{
			if(!Exist())
			{
				return;
			}
			
			if(!L3DLibraryWebService.WebServiceEnable)
			{
				return;
			}
			
//			var atObj:AsyncToken = L3DLibraryWebService.LibraryService.SearchMaterialViewDetailBufferPro(code, 0, 3, 0, "");
//			var rpObj:mx.rpc.Responder = new mx.rpc.Responder(UpdateMaterialViewDetailResult, UpdateMaterialViewDetailFault);
//			atObj.addResponder(rpObj);		

			//lrj 2017/12/8 
			GlobalManager.Instance.serviceMGR.searchMaterialViewDetailBufferPro(UpdateMaterialViewDetailResult, UpdateMaterialViewDetailFault, code, 0, 3, 0, "");	
		}
		
		private function UpdateMaterialViewDetailResult(reObj:ResultEvent):void
		{
			var buffer:ByteArray = reObj.result as ByteArray;
			if(buffer == null || buffer.length == 0)
			{
				return;
			}
			
			var materials:Vector.<L3DMaterialInformations> = new Vector.<L3DMaterialInformations>();
			buffer.position = 0;
			var count:int = buffer.readInt();
			if(count <= 0)
			{
				return;
			}	
			for(var i:int = 0; i<count; i++)
			{
				var length:int = buffer.readInt();
				if(length > 0)
				{
					var mBuffer:ByteArray = new ByteArray();
					buffer.readBytes(mBuffer, 0, length);
					var material:L3DMaterialInformations = new L3DMaterialInformations(mBuffer);
					if(material != null && material.Exist())
					{
						materials.push(material);
					}
				}
			}
			
			for(i = 0; i<2; i++)
			{
				for(var j:int = 0; j<materials.length; j++)
				{
					material = materials[j];
					var canImportData:Boolean = false;
					switch(i)
					{
						case 0:
						{
							canImportData = material.linkCDDataUrl != null && material.linkCDDataUrl.length > 0;
						}
							break;
						case 1:
						{
							canImportData = true;
						}
							break;
					}
					if(canImportData)
					{
						//	code = material.code;
						name = material.name != null && material.name.length > 0 ? material.name : name;
						classCode = material.classCode != null && material.classCode.length > 0 ? material.classCode : classCode;
						className = material.className != null && material.className.length > 0 ? material.className : className;
						brand = material.brand != null && material.brand.length > 0 ? material.brand : brand;
						mode = material.mode != null && material.mode.length > 0 ? material.mode : mode;
						unit = material.unit != null && material.unit.length > 0 ? material.unit : unit;
						style = material.style != null && material.style.length > 0 ? material.style : style;
						series = material.series != null && material.series.length > 0 ? material.series : series;
						subSeries = material.subSeries != null && material.subSeries.length > 0 ? material.subSeries : subSeries;
						combo = material.combo != null && material.combo.length > 0 ? material.combo : combo;	
						remark = material.remark != null && material.remark.length > 0 ? material.remark : remark;
						description = material.description != null && material.description.length > 0 ? material.description : description;
						family = material.family != null && material.family.length > 0 ? material.family : family;
						parentCode = material.parentCode != null && material.parentCode.length > 0 ? material.parentCode : parentCode;
						vrmMode = material.vrmMode;
						renderMode = material.renderMode;
						break;
					}
				}
			}
		}
		
		private function UpdateMaterialViewDetailFault(feObj:FaultEvent):void
		{

		}
		
//		private var searchType:int = 0;
		
		//mode： 0:检索编号 1:检索名称 2:检索品牌 3:检索价格 4:检索归类
		//type： 0：全图 1：100 2：200 3：None
		//catalog：0：全部 1：材质 2：模型 3:户型
		public function Search(text:String, mode:int=0, type:int = 0, catalog:int = 0, pid:String = ""):void
		{
			if(text == null || text.length == 0 || mode < 0)
			{
				return;
			}
			
			if(!L3DLibraryWebService.WebServiceEnable)
			{
				return;
			}			
			
			searchText = text;
			searchMode = mode;
			searchType = type;
			searchCatalog = catalog;
			searchPid = pid;
			
			// 2017/12/8 lrj--
			GlobalManager.Instance.serviceMGR.searchMaterialViewDetailBufferPro(SearchMaterialViewDetailResult, SearchMaterialViewDetailFault, text, mode, type, catalog, pid);
		}
		
		private function SearchMaterialViewDetailResult(reObj:ResultEvent):void
		{
			var buffer:ByteArray = reObj.result as ByteArray;
			
			var event:Event = new Event(SearchMaterialResult);
			if(buffer == null || buffer.length == 0)
			{
				if(searchMode == 0)
				{
					//lrj 2017/12/8 
//					GlobalManager.Instance.serviceMGR.searchUserSpaceMaterialViewDetailBuffer(SearchUserSpaceMaterialViewDetailResult, SearchUserSpaceMaterialViewDetailFault, L3DLibrary.L3DLibrary.sceneUserCode, searchText, searchType);
				}
				else
				{
				    userData = null;
				    this.dispatchEvent(event);
				}
				return;
			}
			
			buffer.position = 0;
			var count:int = buffer.readInt();
			if(count <= 0)
			{
				userData = null;
				this.dispatchEvent(event);
				return;
			}
			
			var materials:Vector.<L3DMaterialInformations> = new Vector.<L3DMaterialInformations>();
			
			for(var i:int = 0; i<count; i++)
			{
				var length:int = buffer.readInt();
				if(length > 0)
				{
					var mBuffer:ByteArray = new ByteArray();
					buffer.readBytes(mBuffer, 0, length);
					var material:L3DMaterialInformations = new L3DMaterialInformations(mBuffer);
					if(material == null && !material.Exist())
					{
						continue;
					}
					var canImport:Boolean = true;
					if(materials.length > 0)
					{
						for(var j:int = 0; j<materials.length; j++)
						{
							//cloud 2018.1.15 只需要判断code相等就可以
							if(materials[j].code.toUpperCase() == material.code.toUpperCase())
							{
								canImport = false;
								continue;
							}
						}
					}
					if(canImport)
					{
					    materials.push(material);
					}
				}
			}

			userData = materials.length == 0 ? null : materials;
			this.dispatchEvent(event);
		}
		
		private function SearchMaterialViewDetailFault(feObj:FaultEvent):void
		{
			if(searchMode == 0)
			{
//			    var atObj:AsyncToken = L3DLibraryWebService.LibraryService.SearchUserSpaceMaterialViewDetailBuffer(L3DLibrary.L3DLibrary.sceneUserCode, searchText, searchType);
//			    var rpObj:mx.rpc.Responder = new mx.rpc.Responder(SearchUserSpaceMaterialViewDetailResult, SearchUserSpaceMaterialViewDetailFault);
//			    atObj.addResponder(rpObj);

			    //lrj 2017/12/8 
//			    GlobalManager.Instance.serviceMGR.searchUserSpaceMaterialViewDetailBuffer(SearchUserSpaceMaterialViewDetailResult, SearchUserSpaceMaterialViewDetailFault, L3DLibrary.L3DLibrary.sceneUserCode, searchText, searchType);
			}
			else
			{
				userData = null;
				var event:Event = new Event(SearchMaterialResult);
				this.dispatchEvent(event);
			}
		}
		
		private function SearchUserSpaceMaterialViewDetailResult(reObj:ResultEvent):void
		{
			var buffer:ByteArray = reObj.result as ByteArray;
			
			var event:Event = new Event(SearchMaterialResult);
			if(buffer == null || buffer.length == 0)
			{
				if(searchMode == 0)
				{
					Search(searchText, 1, searchType, searchCatalog, searchPid);
				}
				else
				{
				    userData = null;
			    	this.dispatchEvent(event);
				}
				return;
			}
			
			buffer.position = 0;

			var material:L3DMaterialInformations = new L3DMaterialInformations(buffer);
			
			var materials:Vector.<L3DMaterialInformations> = new Vector.<L3DMaterialInformations>();
			materials.push(material);
			
			userData = materials.length == 0 ? null : materials;
			this.dispatchEvent(event);
		}		
		
		private function SearchUserSpaceMaterialViewDetailFault(feObj:FaultEvent):void
		{
			userData = null;
			var event:Event = new Event(SearchMaterialResult);
			this.dispatchEvent(event);
		}
		
//		private static function LoadBitmapData(buffer:ByteArray):BitmapData
//		{
//			if(buffer == null || buffer.length == 0)
//			{
//				return null;
//			} 
//			
//			var bmpData:BitmapData = null;
//			var decoder:JPEGDecoder = null;
//			try
//			{
//				decoder = new JPEGDecoder(buffer);
//				bmpData = new BitmapData(decoder.width, decoder.height);
//				bmpData.setVector(new Rectangle(0,0,decoder.width, decoder.height), decoder.pixels);
//				decoder = null;
//			}
//			catch(error:Error)
//			{
//				bmpData = null;
//				decoder = null;
//			}
//			
//			if(bmpData == null)
//			{
//				var pngdecoder:PNGDecoder = null;
//				try
//				{
//					pngdecoder = new PNGDecoder();
//					bmpData = pngdecoder.decode(buffer);
//					pngdecoder = null;
//				}
//				catch(error:Error)
//				{
//					bmpData = null;
//					pngdecoder = null;
//				}
//			}
//			
//			L3DUtils.GCClearance();
//			return bmpData;
//		}
		
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
		
		private static function BitmapScale(bmpData:BitmapData, maxLength:int):BitmapData
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
		
		private static function BitmapSizeScale(bmpData:BitmapData, width:int, height:int):BitmapData
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
				
		private static function WriteString(buffer:ByteArray, text:String):Boolean
		{
			if(buffer == null)
			{
				return false;
			}
			
			if(text == null || text.length == 0)
			{
				buffer.writeInt(0);
				return true;
			}
			
			var textBuffer:ByteArray = new ByteArray();
			textBuffer.writeUTFBytes(text);
			buffer.writeInt(textBuffer.length);
			buffer.writeBytes(textBuffer,0,textBuffer.length);
			
			return true;
		}
		
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
		
		private static function GenerateUUID():String
		{
			var str:String = UIDUtil.createUID();
			var arr1:Array =str.split("-");			
			return arr1[0]+arr1[1]+arr1[2]+arr1[3]+arr1[4];						
		}
	}
}