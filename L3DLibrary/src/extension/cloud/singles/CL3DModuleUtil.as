package extension.cloud.singles
{
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	
	import L3DLibrary.Brand;
	import L3DLibrary.L3DMaterialInformations;
	import L3DLibrary.LivelyLibrary;
	
	import alternativa.engine3d.core.BoundBox;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.materials.LightMapMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.resources.Geometry;
	import alternativa.engine3d.resources.TextureResource;
	import alternativa.engine3d.utils.Object3DUtils;
	
	import cloud.core.collections.CIterator;
	import cloud.core.collections.CTreeNode;
	import cloud.core.collections.ICDoubleNode;
	import cloud.core.datas.base.CTransform3D;
	import cloud.core.datas.maps.CHashMap;
	import cloud.core.interfaces.ICIterator;
	import cloud.core.utils.CGPCUtil;
	import cloud.core.utils.CMathUtil;
	import cloud.core.utils.CMathUtilForAS;
	import cloud.core.utils.CUtil;
	
	import extension.cloud.a3d.resources.CBitmapTextureResource;
	import extension.cloud.datas.CClosedLine3DArea;
	import extension.cloud.datas.COutputImageData;
	import extension.cloud.datas.CWallLineData;
	import extension.cloud.dict.CL3DConstDict;
	import extension.cloud.dict.CL3DEventTypeDict;
	import extension.cloud.interfaces.ICEntity3DData;
	import extension.cloud.interfaces.ICL2DSceneExtension;
	import extension.cloud.interfaces.ICL3DFloorExtension;
	import extension.cloud.interfaces.ICL3DFurnitureExtension;
	import extension.cloud.interfaces.ICL3DSceneExtension;
	import extension.cloud.interfaces.ICL3DWallExtension;
	import extension.cloud.interfaces.ICNameResource;
	import extension.cloud.mvcs.base.model.CBaseL3DData;
	
	import pl.bmnet.gpcas.geometry.Poly;
	
	import utils.DatasEvent;
	import utils.lx.LoadType;
	import utils.lx.managers.GlobalManager;
	import utils.poly2tri.PPoint;
	import utils.poly2tri.VisiblePolygon;

	/**
	 * 业务模块功能方法类
	 * @author	cloud
	 * @date	2018-5-16
	 */
	public class CL3DModuleUtil
	{
		private static var _Instance:CL3DModuleUtil;
		
		public static function get Instance():CL3DModuleUtil
		{
			return _Instance||=new CL3DModuleUtil(new SingletonEnforce());
		}
		/**
		 * 业务模块工具类专用派发器 
		 */		
		private var _dispatcher:EventDispatcher;
		
		public function CL3DModuleUtil(enforcer:SingletonEnforce)
		{
			_dispatcher=new EventDispatcher();
		}
		
		public function get isNewSystem():Boolean
		{
			return LivelyLibrary.IsNewWallModule && (LivelyLibrary.SceneBrand==Brand.LeJiaDesign);
//			return LivelyLibrary.IsNewWallModule;
		}
		/**
		 * 获取护墙板出图测试数据 
		 * @param startPostion
		 * @param endPosition
		 * @return Vector.<COutputImageData>
		 * 
		 */		
		public function getTestClapboardOutputImageData(startPostion:Vector3D=null,endPosition:Vector3D=null):Vector.<COutputImageData>
		{
			var datas:Vector.<COutputImageData>=new Vector.<COutputImageData>();
			var parent:COutputImageData=new COutputImageData(1,"mub6",[new Vector3D(0,0,0),new Vector3D(1000,0,0),new Vector3D(1000,600,0),new Vector3D(0,600,0)],[0,1,2,2,3,0],[0,0,1,0,1,1,0,1],new BitmapData(600,600,false,0xcccccc),null);
			parent.addChildData(new COutputImageData(2,"mub5",[new Vector3D(200,50,0),new Vector3D(800,50,0),new Vector3D(750,100,0),new Vector3D(250,100,0)],[0,1,2,2,3,0],[0,0,1,0,1,1,0,1],new BitmapData(600,300,false,0xffcc00),null));
			parent.addChildData(new COutputImageData(2,"mub5",[new Vector3D(800,50,0),new Vector3D(800,550,0),new Vector3D(750,500,0),new Vector3D(750,100,0)],[0,1,2,2,3,0],[0,0,1,0,1,1,0,1],new BitmapData(600,300,false,0xffcc00),null));
			parent.addChildData(new COutputImageData(2,"mub5",[new Vector3D(800,550,0),new Vector3D(200,550,0),new Vector3D(250,500,0),new Vector3D(750,500,0)],[0,1,2,2,3,0],[0,0,1,0,1,1,0,1],new BitmapData(600,300,false,0xffcc00),null));
			parent.addChildData(new COutputImageData(2,"mub5",[new Vector3D(200,550,0),new Vector3D(200,50,0),new Vector3D(250,100,0),new Vector3D(250,500,0)],[0,1,2,2,3,0],[0,0,1,0,1,1,0,1],new BitmapData(600,300,false,0xffcc00),null));
			datas.push(parent);
			return datas;
		}
		/**
		 * 清理模型表面的纹理材质(不包含子模型)
		 * @param surface
		 * 
		 */
		public function disposeMeshSurfaceMaterials(surface:Surface):void
		{
			var material:Material;
			//清理模型材质
			material=surface.material;
			//只有纹理材质需要清理
			if(material==null || !(material is TextureMaterial))
			{
				return;
			}
			//普通纹理材质
			if((material as TextureMaterial).diffuseMap!=null)
			{
				clearTextureResource((material as TextureMaterial).diffuseMap);
				(material as TextureMaterial).diffuseMap=null;
			}
			if((material as TextureMaterial).opacityMap != null)
			{
				clearTextureResource((material as TextureMaterial).opacityMap);
				(material as TextureMaterial).opacityMap = null;
			}
			//灯光纹理材质
			if(material is LightMapMaterial)
			{
				if((material as LightMapMaterial).lightMap != null)
				{
					clearTextureResource((material as LightMapMaterial).lightMap);
					(material as LightMapMaterial).lightMap = null;
				}
			}
			//标准纹理材质
			if(material is StandardMaterial)
			{
				if((material as StandardMaterial).lightMap != null)
				{
					clearTextureResource((material as StandardMaterial).lightMap);
					(material as StandardMaterial).lightMap = null;
				}
				if((material as StandardMaterial).glossinessMap != null)
				{
					clearTextureResource((material as StandardMaterial).glossinessMap);
					(material as StandardMaterial).glossinessMap = null;
				}
				if((material as StandardMaterial).lightMap != null)
				{
					clearTextureResource((material as StandardMaterial).lightMap);
					(material as StandardMaterial).lightMap = null;
				}
				if((material as StandardMaterial).normalMap != null)
				{
					clearTextureResource((material as StandardMaterial).normalMap);
					(material as StandardMaterial).normalMap = null;
				}
				if((material as StandardMaterial).specularMap != null)
				{
					clearTextureResource((material as StandardMaterial).specularMap);
					(material as StandardMaterial).specularMap = null;
				}
			}
		}
		/**
		 * 清理模型的网格数据 
		 * @param geometry
		 * 
		 */		
		public function disposeMeshGeometry(geometry:Geometry):void
		{
			if(geometry==null) return;
			geometry.dispose();
		}
		/**
		 * 根据父容器清理模型  
		 * @param mesh	模型对象
		 * @param parent		模型的父容器
		 * 
		 */		
		public function disposeMeshFromParent(mesh:Mesh,parent:Object3D,isClearMaterial:Boolean=true):void
		{
			if(mesh==null) return;
			var i:int;
			//从父容器移除模型
			if(parent && parent.contains(mesh))
			{
				parent.removeChild(mesh);
			}
			//清理模型网格
			disposeMeshGeometry(mesh.geometry);
			mesh.geometry=null;
			//清理模型所有表面材质
			if(isClearMaterial)
			{
				for(i=0;i<mesh.numSurfaces;i++)
				{
					disposeMeshSurfaceMaterials(mesh.getSurface(i));
				}
			}
		}
		/**
		 * 清理模型及其所有子模型 
		 * @param mesh	模型对象
		 * @param parent		模型对象的父容器
		 * @param isClearMaterial	是否清理材质，默认为true
		 * 
		 */		
		public function disposeMeshAndChildren(mesh:Mesh,parent:Object3D,isClearMaterial:Boolean=true):void
		{
			if(mesh==null) return;
			var i:int;
			i=mesh.numChildren-1;
			disposeMeshFromParent(mesh,parent,isClearMaterial);
			for(;i>=0;i--)
			{
				disposeMeshAndChildren(mesh.getChildAt(i) as Mesh,mesh,isClearMaterial);
			}
		}
		/**
		 * 清理纹理资源对象 
		 * @param source
		 * 
		 */		
		public function clearTextureResource(source:TextureResource):void
		{
			if(source==null) return;
			if(source is ICNameResource)
			{
				(source as ICNameResource).clear();
			}
			else
			{
				source.dispose();
			}
		}
		/**
		 * 当前运行模式是否使用默认的场景渲染灯光纹理
		 * @return Boolean
		 * 
		 */		
		public function get useSceneDefaultBakeLightTexture():Boolean
		{
			return LivelyLibrary.RuntimeMode == CL3DConstDict.RUNTIME_EXTREME;
		}
		/**
		 * 显示错误消息
		 * @param resourceID	资源ID
		 * @param message	错误消息
		 * 
		 */	
		public function showDownloadResourceFaultMessage(resourceID:String,message:String):void
		{
			LivelyLibrary.ShowMessage(resourceID+" error: "+message,2,3000);
		}
		public function showSaveSuccessMessage():void
		{
			LivelyLibrary.ShowMessage("保存成功!",0,3000);
		}
		/**
		 * 判断是否是RPC的地址 
		 * @param url	地址
		 * @return Boolean
		 * 
		 */		
		public function isRPCUrl(url:String):Boolean
		{
			var str:String=url.slice(0,1);
			return str=="L" || str=="U";
		}
		/**
		 * 获取纹理图的最大尺寸 
		 * @param forceMode	强制模式类型(参考CL3DConstDict中的FORCE系列类型)
		 * @param renderMode	渲染模式类型
		 * @return int
		 * 
		 */		
		private function getTextureMaxSize(forceMode:int,renderMode:int):int
		{
			var bitmapSize:int;
			switch(renderMode)
			{
				case 0:
					bitmapSize = forceMode == 0 ? 512 : 256;
					break;
				case 1:
					bitmapSize = forceMode == 0 ? 256 : 128;
					break;
				case 2:
					bitmapSize = 128;
					break;
				case 3:
					bitmapSize = 1024;
					break;
				default:
					bitmapSize = 32;
					break;
			}
			return bitmapSize;
		}
		/**
		 * 获取资源唯一索引ID
		 * @param code
		 * @param url
		 * @return String
		 * 
		 */		
		public function getResourceUniqueID(code:String,url:String=null):String
		{
			return url&&url.length?url:code;
		}
		/**
		 * 获取L3DMaterialInformations资源对象，如果获取不到自动执行下载功能，successCallback与faultCallback是回调函数，参数至少是两个，默认第一个参数是资源库的key，第二个参数是对应的下载对象
		 * 回调函数可以传null，作用是开启广播事件模式，这时如果要接收下载结果，请添加对应的广播监听事件，参考LibraryLoaderMGR的广播事件类型
		 * @param code	资源对象的唯一code
		 * @param url	资源对象的唯一url
		 * @param successCallback	资源需要下载时，下载成功后执行该回调函数
		 * @param faultCallback	资源需要下载时，下载失败后执行该回调函数
		 * @param rpcType	rpc异步下载类型
		 * @return L3DMaterialInformations
		 * 
		 */		
		public function getL3DMaterialInfoResource(code:String,url:String,successCallback:Function=null,faultCallback:Function=null,rpcType:int=0):L3DMaterialInformations
		{
			//cloud 2017.12.25 调整下载结构，code资源库和url资源库都要检测是否有目标资源
			var result:L3DMaterialInformations;
			var key:String;
			var addFunc:Function;
			
			if(url && url.length>0)
			{
				result=GlobalManager.Instance.resourceMGR.getInformation(url);
				if(!result)
				{
					result=GlobalManager.Instance.resourceMGR.getInformation(code);
					if(!result)
					{
						if(isRPCUrl(url))
						{
							GlobalManager.Instance.loaderMGR.addInfomationByUrl(url,successCallback,faultCallback,rpcType);
						}
						else if(code && code.length>0 && isNaN(Number(code)))
						{
							GlobalManager.Instance.loaderMGR.addInformationByCode(code,successCallback,faultCallback,rpcType);
						}
					}
				}
			}
			else if(code && code.length>0)
			{
				result=GlobalManager.Instance.resourceMGR.getInformation(code);
				if(!result)
				{
					GlobalManager.Instance.loaderMGR.addInformationByCode(code,successCallback,faultCallback,rpcType);
				}
			}
			if(rpcType==0 && result && !result.textureBuffer)
			{
				if(url && url.length>0)
				{
					if(isRPCUrl(url))
					{
						result=null;
						GlobalManager.Instance.loaderMGR.addInfomationByUrl(url,successCallback,faultCallback,rpcType);
						return null;
					}
					else if(code && code.length>0 && isNaN(Number(code)))
					{
						result=null;
						GlobalManager.Instance.loaderMGR.addInformationByCode(code,successCallback,faultCallback,rpcType);
						return null;
					}
				}
				if(code && code.length>0)
				{
					result=null;
					GlobalManager.Instance.loaderMGR.addInformationByCode(code,successCallback,faultCallback,rpcType);
					return null;
				}
			}
			return result;
		}
		/**
		 * 保存商品数据对象
		 * @param resourceID
		 * @param materialInfo
		 * 
		 */		
		public function saveL3DMateiralInfo(resourceID:String,materialInfo:L3DMaterialInformations):void
		{
			GlobalManager.Instance.resourceMGR.addInformation(resourceID,materialInfo);
		}
		
		/**
		 * 保存位图资源 
		 * @param key
		 * @param resource	
		 * 
		 */		
		public function saveL3DBitmapResource(code:String,resource:L3DBitmapTextureResource,typeSuffix:String=null,typePrefix:String=null,groupID:String=null):void
		{
			var key:String=typeSuffix?code+typeSuffix:code;
			key=typePrefix?typePrefix+key:key;
			key=groupID?groupID+"_"+key:key;
			CResourceManager.Instance.addResource(key,resource);
		}
		/**
		 * 获取商品数据对象 
		 * @param resourceID
		 * @return L3DMaterialInformations
		 * 
		 */		
		public function getL3DMaterialInfo(resourceID:String):L3DMaterialInformations
		{
			return GlobalManager.Instance.resourceMGR.getInformation(resourceID);
		}
		/**
		 * 添加商品信息的下载任务 
		 * @param code
		 * @param url
		 * @param successCallback
		 * @param faultCallback
		 * @param rpcType
		 * @return L3DMaterialInformations
		 * 
		 */		
		public function addLoadL3DMaterialInfoByQueue(code:String,url:String,successCallback:Function=null,faultCallback:Function=null,rpcType:int=0):L3DMaterialInformations
		{
			var info:L3DMaterialInformations;
			if(url && url.length>0)
			{
				info=GlobalManager.Instance.resourceMGR.getInformation(url);
				if(info==null && code && code.length>0)
				{
					info=GlobalManager.Instance.resourceMGR.getInformation(code);
				}
				if(info==null)
				{
					if(isRPCUrl(url))
					{
						GlobalManager.Instance.loaderMGR.createRPCLoadTask(url,LoadType.RPCLOADDATA_URL,successCallback,faultCallback,rpcType);
					}
					else if(code && code.length>0 && isNaN(Number(code)))
					{
						GlobalManager.Instance.loaderMGR.createRPCLoadTask(code,LoadType.RPCLOADDATA_CODE,successCallback,faultCallback,rpcType);
					}
				}
			}
			else if(code && code.length>0)
			{
				info=GlobalManager.Instance.resourceMGR.getInformation(code);
				if(info==null)
				{
					GlobalManager.Instance.loaderMGR.createRPCLoadTask(code,LoadType.RPCLOADDATA_CODE,successCallback,faultCallback,rpcType);
				}
			}
			return info;
		}
		/**
		 * 执行商品信息的下载队列的处理，返回当前队列下载任务ID
		 * @return String
		 * 
		 */		
		public function excuteLoadL3DMaterialInfoQueue(onLoadAllComplete:Function=null):String
		{
			var queueID:String=GlobalManager.Instance.loaderMGR.excuteRPCLoad();
			if(queueID==null)
			{
				if(GlobalManager.Instance.hasEventListener(CL3DEventTypeDict.LOAD_L3DMATERIALINFO_QUEUE_COMPLETE))
				{
					GlobalManager.Instance.dispatchEvent(new DatasEvent(CL3DEventTypeDict.LOAD_L3DMATERIALINFO_QUEUE_COMPLETE));
				}
			}
			else
			{
				GlobalManager.Instance.loaderMGR.addEventListener("LibraryLoader_LoadAllComplete",onLoadQueueComplete);
			}
			return queueID;
		}
		private function onLoadQueueComplete(evt:DatasEvent):void
		{
			evt.currentTarget.removeEventListener(evt.type,onLoadQueueComplete);
			if(GlobalManager.Instance.hasEventListener(CL3DEventTypeDict.LOAD_L3DMATERIALINFO_QUEUE_COMPLETE))
			{
				GlobalManager.Instance.dispatchEvent(new DatasEvent(CL3DEventTypeDict.LOAD_L3DMATERIALINFO_QUEUE_COMPLETE,evt.data));
			}
		}
		/**
		 * 更新商品信息对象的数据
		 * @param targetInfo	目标商品信息对象
		 * @param sourceInfo	源商品信息对象
		 * 
		 */		
		public function updateL3DMaterialInfomation(targetInfo:L3DMaterialInformations,sourceInfo:L3DMaterialInformations):Boolean
		{
			targetInfo.code = sourceInfo.code;
			targetInfo.name = sourceInfo.name;
			targetInfo.family = sourceInfo.family;
			targetInfo.classCode = sourceInfo.classCode;
			targetInfo.className = sourceInfo.className;
			targetInfo.type = sourceInfo.type;
			targetInfo.price = sourceInfo.price;
			targetInfo.cost = sourceInfo.cost;
			targetInfo.catalog = sourceInfo.catalog;
			targetInfo.spec = sourceInfo.spec;			
			targetInfo.brand = sourceInfo.brand;
			targetInfo.mode = sourceInfo.mode;
			targetInfo.unit = sourceInfo.unit;
			targetInfo.style = sourceInfo.style;
			targetInfo.series = sourceInfo.series;
			targetInfo.subSeries = sourceInfo.subSeries;
			targetInfo.combo = sourceInfo.combo;			
			targetInfo.remark = sourceInfo.remark;
			targetInfo.description = sourceInfo.description;
			targetInfo.url = sourceInfo.url;
			targetInfo.linkedDataUrl = sourceInfo.linkedDataUrl;
			targetInfo.linkedID = sourceInfo.linkedID;
			targetInfo.linkVRDataUrl = sourceInfo.linkVRDataUrl;
			targetInfo.linkCDDataUrl = sourceInfo.linkCDDataUrl;
			targetInfo.parentCode = sourceInfo.parentCode;
			targetInfo.orgCode = sourceInfo.orgCode;
			targetInfo.orgName = sourceInfo.orgName;
			targetInfo.offGround = sourceInfo.offGround;
			targetInfo.isPolyMode = sourceInfo.isPolyMode;
			targetInfo.vrmMode = sourceInfo.vrmMode;
			targetInfo.renderMode = sourceInfo.renderMode;
			return true;
		}
		/**
		 * 获取XML节点资源,如果不传对应的回调函数，下载完成后会派发广播事件，需要处理的话要对全局管理器对象添加对应的事件监听
		 * @param nodeID	节点ID
		 * @param successCallback	下载成功回调
		 * @param faultCallback	下载失败回调
		 * @param rpcType	rpc类型
		 * @return Array	返回的结果数组
		 * 
		 */		
		public function getXMLNodeResource(nodeID:String,successCallback:Function=null,faultCallback:Function=null,rpcType:int=0):Array
		{
			var result:Array;
			if(nodeID && nodeID.length>0)
			{
				result=GlobalManager.Instance.resourceMGR.getURLs(nodeID);
				if(!result)
				{
					GlobalManager.Instance.loaderMGR.downloadNodeXML(nodeID,successCallback,faultCallback,rpcType);
				}
			}
			return result;
		}
		/**
		 * * 获取位图材质资源对象的实例(创建位图材质资源对象时，不要用new，使用这个方法来创建实例)
		 * @param code	资源code
		 * @param bitmapData		位图对象
		 * @param stage3d	3d设备对象
		 * @param forceMode	强制模式：0 不强制	1 256强制成128
		 * @param renderMode	渲染模式 
		 * @param typeSuffix	资源类型前缀
		 * @param typePrefix	资源类型后缀
		 * @param groupID	组ID
		 * @param buffer	位图字节流数据
		 * @return L3DBitmapTextureResource
		 * 
		 */			
		public function getL3DBitmapTextureResourceInstance(code:String,bitmapData:BitmapData,stage3d:Stage3D,forceMode:int=0,renderMode:int=-1,typeSuffix:String=null,typePrefix:String=null,groupID:String=null,buffer:ByteArray=null):L3DBitmapTextureResource
		{
			var instance:L3DBitmapTextureResource;
			var bitmapSize:int;
			var mark:String;
			
			mark=typeSuffix?code+typeSuffix:code;
			mark=typePrefix?typePrefix+mark:mark;
			//			//cloud 2017.12.25	增加groupID参数
			mark=groupID?groupID+"_"+mark:mark;
			bitmapSize=getTextureMaxSize(forceMode,renderMode);
			
			if(!code || !code.length)
			{
				instance=new L3DBitmapTextureResource(bitmapData?bitmapData.clone():null, buffer, stage3d, false, bitmapSize);
				instance.groupID=groupID;
				instance.mark=mark;
				if(stage3d!=null)
				{
					instance.upload(stage3d.context3D);
				}
				return instance;
			}
			instance=CResourceManager.Instance.getResource(mark) as L3DBitmapTextureResource;
			if(!instance)
			{
				if(bitmapData==null && !isNaN(Number(code)))
				{
					instance=new L3DBitmapTextureResource(new BitmapData(1,1,false,Number(code)), buffer, stage3d, false, bitmapSize);
					instance.groupID=groupID;
				}
				else
				{
					instance=new L3DBitmapTextureResource(bitmapData?bitmapData.clone():null, buffer, stage3d, false, bitmapSize);
					instance.groupID=groupID;
				}
				instance.mark=mark;
				CResourceManager.Instance.addResource(mark,instance);
			}
			if(instance.isEmpty)
			{
				instance.data=new BitmapData(1,1,false,0xcccccc);
				instance.Load(code,stage3d);
			}
			if(stage3d!=null)
			{
				instance.upload(stage3d.context3D);
			}
			return instance;
		}
		/**
		 * 获取基础位图纹理资源对象的实例 
		 * @param code	资源对象标记
		 * @param bitmapData		位图对象
		 * @return CBaseBitmapTextureResource
		 * 
		 */		
		public function getBitmapTextureResourceInstance(color:uint,typeSuffix:String=null,typePrefix:String=null,width:Number=1,height:Number=1,transparent:Boolean=false):CBitmapTextureResource
		{
			var instance:CBitmapTextureResource;
			var mark:String;
			
			mark=typeSuffix?color.toString()+typeSuffix:color.toString();
			mark=typePrefix?typePrefix+mark:mark;
			instance=CResourceManager.Instance.getResource(mark) as CBitmapTextureResource;
			if(!instance)
			{
				instance=new CBitmapTextureResource(new BitmapData(width,height,transparent,color),false);
				instance.code=color.toString();
				instance.mark=mark;
				CResourceManager.Instance.addResource(mark,instance);
			}
			
			return instance;
		}
		
		/**
		 * 根据物体信息，更新3D纹理材质资源对象
		 * @param resource	3D纹理材质资源对象
		 * @param info		物体信息L3DMaterialInfomations对象
		 * 
		 */		
		public function updateL3DBitmapTextureResourceByInfo(resource:L3DBitmapTextureResource,info:L3DMaterialInformations):void
		{
			if(info==null) return;
			resource.Name = info.name;
			resource.Code=info.code;
			resource.ERPCode = info.ERPCode;
			resource.Url=info.url;
			resource.Brand=info.brand == null || info.brand.length == 0 ? info.className : info.brand;
			resource.Family=info.family;
			resource.RenderMode=info.renderMode;
			resource.VRMMode=info.vrmMode;
			resource.Price = info.price;
		}
		/**
		 * 更新位图纹理对象的位图数据 
		 * @param texture	位图纹理对象
		 * @param bmp	位图数据对象
		 * @param context3D	3D设备
		 * 
		 */		
		public function updateBitmapTextureData(texture:CBitmapTextureResource,bmp:BitmapData,context3D:Context3D=null):Boolean
		{
			clearTextureResource(texture);
			texture.data.dispose();
			texture.data=bmp.clone();
			if(context3D)
			{
				texture.upload(context3D);
			}
			return true;
		}
		/**
		 *  写入模型的渲染参数到渲染流数据中
		 * @param mesh	模型
		 * @param byteArray	渲染流数据对象
		 * 
		 */		
		public function writeMeshToBakeByteStream(mesh:L3DMesh,byteArray:ByteArray):void
		{
			if(!mesh.visible || !byteArray)
			{
				return;
			}
			var child:L3DMesh;
			var i:int,j:int,iIndex:int;
			var pos:Vector.<Number>,uvs:Vector.<Number>,normals:Vector.<Number>,ids:Vector.<uint>;
			var posLen:uint,idsLen:uint,uvLen:uint,normalLen:uint;
			var material:TextureMaterial;
			var strPath:String;
			var renderMode:int,vrMode:int;
			var bmpBuffer:ByteArray;
			
			for(i=mesh.numChildren-1; i>=0; i--)
			{
				child = mesh.getChildAt(i) as L3DMesh;							
				if(child != null && child.getSurface(0).material)
				{	
					pos = child.geometry.getAttributeValues(VertexAttributes.POSITION);
					normals=child.geometry.getAttributeValues(VertexAttributes.NORMAL);
					ids = child.geometry.indices;
					uvs = child.geometry.getAttributeValues(VertexAttributes.TEXCOORDS[0]);
					posLen = pos.length;
					normalLen=normals.length;
					idsLen = ids.length;
					uvLen = uvs.length;
					
					byteArray.writeInt(posLen);
					byteArray.writeInt(normalLen);
					byteArray.writeInt(idsLen);
					byteArray.writeInt(uvLen);
					
					var vlength:int = posLen / 3;
					for(iIndex= 0; iIndex < vlength; iIndex++ )
					{
						var vertex:Vector3D = new Vector3D(pos[iIndex * 3], pos[iIndex * 3 + 1], pos[iIndex * 3 + 2]);
						var gv:Vector3D = child.localToGlobal(vertex);
						byteArray.writeFloat(gv.x);
						byteArray.writeFloat(gv.y);
						byteArray.writeFloat(gv.z);
					}
					
					if(normalLen > 0)
					{
						for( iIndex = 0; iIndex <posLen; iIndex++ )
						{
							byteArray.writeFloat(normals[iIndex]);
						}
					}

					for(iIndex = 0; iIndex <idsLen; iIndex++ )
					{
						byteArray.writeUnsignedInt(ids[iIndex]);
					}
					
					for(iIndex = 0; iIndex < uvLen; iIndex++ )
					{
						var uvValue:Number = uvs[iIndex];
						if(iIndex % 2)
						{
							uvValue = 1 - uvValue;
						}
						byteArray.writeFloat(uvValue);			
					}
					material=child.getSurface(0).material as TextureMaterial;
					strPath = (material.diffuseMap as L3DBitmapTextureResource).Url;
					if(strPath != null)
					{
						var arrayTemp:Array = strPath.split("-");
						var strName:String = arrayTemp[0];
						for(j=1; i<arrayTemp.length; j++ )
						{
							strName += arrayTemp[j];
						}
						strPath = strName;
					}

					renderMode = (material.diffuseMap as L3DBitmapTextureResource).RenderMode;
					if(renderMode > 0)
					{
						vrMode=(material.diffuseMap as L3DBitmapTextureResource).VRMMode;
						byteArray.writeInt(5000+vrMode);
						bmpBuffer = L3DMaterial.BitmapDataToBuffer((material.diffuseMap as L3DBitmapTextureResource).data);

						if(bmpBuffer != null && bmpBuffer.length > 0)
						{
							byteArray.writeInt(bmpBuffer.length);
							byteArray.writeBytes(bmpBuffer, 0, bmpBuffer.length);
						}
					}
					else
					{
						if(strPath != null && strPath.length > 0)
						{
							strPath = strPath.replace("\\", "/");
							byteArray.writeInt(strPath.length);
							byteArray.writeMultiByte(strPath,"utf-8");
						}
						else
						{
							byteArray.writeInt(0);
							byteArray.writeFloat(1);
							byteArray.writeFloat(1);
							byteArray.writeFloat(1);
						}
					}
				}
			}
		}
		/**
		 * 转换坐标模式,获取新的围点3D坐标值集合
		 * @param pointValues		围点3D坐标值集合
		 * @param inMode	围点3D坐标值集合的坐标模式
		 * @param outMode		新的围点3D坐标值集合的坐标模式
		 * @return Vector.<Number>	新的围点3D坐标值集合
		 * 
		 */		
		public function getRoundPoints(pointValues:Vector.<Number>,inMode:int,outMode:int):Vector.<Number>
		{
			if(inMode==outMode)
			{
				return pointValues;
			}
			var result:Vector.<Number>;
			
			switch(outMode)
			{
				case CL3DConstDict.POSITIONMODE_SCREEN:
					result=doChange2ScreenPositionByValues(pointValues,inMode);
					break;
				case CL3DConstDict.POSITIONMODE_SCENE2D:
					result=doChange2Scene2DPositionByValues(pointValues,inMode);
					break;
				case CL3DConstDict.POSITIONMODE_SCENE3D:
					result=doChange2Scene3DPositionByValues(pointValues,inMode);
					break;
			}
			return result;
		}
		/**
		 * 根据坐标的原始模式和要输出的新模式，返回坐标对象的新的坐标值 
		 * @param position	坐标对象
		 * @param inMode	输入的坐标模式
		 * @param outMode		输出的坐标模式
		 * @param isNew	是否创建新的坐标对象
		 * @return Vector3D		返回的坐标对象
		 * 
		 */		
		public function amendPosition3DByVector3D(position:Vector3D,inMode:int,outMode:int,isNew:Boolean=true):Vector3D
		{
			var result:Vector3D;
			if(inMode==outMode)
			{
				return position;
			}
			switch(outMode)
			{
				case CL3DConstDict.POSITIONMODE_SCREEN:
					result=doAmend2ScenePositionByVector3D(position,inMode,isNew);
					break;
				case CL3DConstDict.POSITIONMODE_SCENE2D:
					result=doAmend2Scene2DPositionByVector3D(position,inMode,isNew);
					break;
				case CL3DConstDict.POSITIONMODE_SCENE3D:
					result=doAmend2Scene3DPositionByVector3D(position,inMode,isNew);
					break;
			}
			return result;
		}
		private function doChange2Scene3DPositionByValues(pointValues:Vector.<Number>,inMode:int):Vector.<Number>
		{
			var xstep:Number;
			var ystep:Number;
			var yNeg:Boolean;
			var result:Vector.<Number>;
			
			switch(inMode)
			{
				case CL3DConstDict.POSITIONMODE_SCREEN:
					xstep=CL3DGlobalCacheUtil.Instance.screenWidth*.5;
					ystep=CL3DGlobalCacheUtil.Instance.screenHeight*.5;
					yNeg=true;
					break;
				case CL3DConstDict.POSITIONMODE_SCENE2D:
					xstep=0;
					ystep=0;
					yNeg=true;
					break;
			}
			result=new Vector.<Number>(pointValues.length);
			for(var i:int=pointValues.length/3-1; i>=0; i--)
			{
				result[i*3]=pointValues[i*3]+xstep;
				result[i*3+1]=yNeg?-(pointValues[i*3+1]+ystep):pointValues[i*3+1]+ystep;
				result[i*3+2]=pointValues[i*3+2];
			}
			return result;
		}
		private function doChange2Scene2DPositionByValues(pointValues:Vector.<Number>,inMode:int):Vector.<Number>
		{
			var xstep:Number;
			var ystep:Number;
			var yNeg:Boolean;
			var result:Vector.<Number>;
			
			switch(inMode)
			{
				case CL3DConstDict.POSITIONMODE_SCREEN:
					xstep=CL3DGlobalCacheUtil.Instance.screenWidth*.5;
					ystep=CL3DGlobalCacheUtil.Instance.screenHeight*.5;
					yNeg=false;
					break;
				case CL3DConstDict.POSITIONMODE_SCENE3D:
					xstep=0;
					ystep=0;
					yNeg=true;
					break;
			}
			result=new Vector.<Number>(pointValues.length);
			for(var i:int=pointValues.length/3-1; i>=0; i--)
			{
				result[i*3]=pointValues[i*3]+xstep;
				result[i*3+1]=yNeg?-(pointValues[i*3+1]+ystep):pointValues[i*3+1]+ystep;
				result[i*3+2]=pointValues[i*3+2];
			}
			return result;
		}
		private function doChange2ScreenPositionByValues(pointValues:Vector.<Number>,inMode:int):Vector.<Number>
		{
			var xstep:Number;
			var ystep:Number;
			var yNeg:Boolean;
			var result:Vector.<Number>;
			
			switch(inMode)
			{
				case CL3DConstDict.POSITIONMODE_SCENE2D:
					xstep=-CL3DGlobalCacheUtil.Instance.screenWidth*.5;
					ystep=-CL3DGlobalCacheUtil.Instance.screenHeight*.5;
					yNeg=false;
					break;
				case CL3DConstDict.POSITIONMODE_SCENE3D:
					xstep=-CL3DGlobalCacheUtil.Instance.screenWidth*.5;
					ystep=-CL3DGlobalCacheUtil.Instance.screenHeight*.5;
					yNeg=true;
					break;
			}
			result=new Vector.<Number>(pointValues.length);
			for(var i:int=pointValues.length/3-1; i>=0; i--)
			{
				result[i*3]=pointValues[i*3]+xstep;
				result[i*3+1]=yNeg?-pointValues[i*3+1]+ystep:pointValues[i*3+1]+ystep;
				result[i*3+2]=pointValues[i*3+2];
			}
			return result;
		}
		
		private function doAmend2ScenePositionByVector3D(position:Vector3D,inMode:int,isNew:Boolean=true):Vector3D
		{
			var xstep:Number;
			var ystep:Number;
			var yNeg:Boolean;
			var result:Vector3D;
			
			switch(inMode)
			{
				case CL3DConstDict.POSITIONMODE_SCENE2D:
					xstep=CL3DGlobalCacheUtil.Instance.screenWidth;
					ystep=CL3DGlobalCacheUtil.Instance.screenHeight;
					yNeg=false;
					break;
				case CL3DConstDict.POSITIONMODE_SCENE3D:
					xstep=CL3DGlobalCacheUtil.Instance.screenWidth;
					ystep=CL3DGlobalCacheUtil.Instance.screenHeight;
					yNeg=true;
					break;
			}
			result=isNew?new Vector3D():position;
			result.x=position.x*CL3DGlobalCacheUtil.Instance.sceneScaleRatio+xstep;
			result.y=yNeg?-position.y*CL3DGlobalCacheUtil.Instance.sceneScaleRatio+ystep:position.y*CL3DGlobalCacheUtil.Instance.sceneScaleRatio+ystep;
			result.z=position.z*CL3DGlobalCacheUtil.Instance.sceneScaleRatio;
			return result;
		}
		private function doAmend2Scene2DPositionByVector3D(position:Vector3D,inMode:int,isNew:Boolean=true):Vector3D
		{
			var xstep:Number;
			var ystep:Number;
			var yNeg:Boolean;
			var result:Vector3D;
			
			switch(inMode)
			{
				case CL3DConstDict.POSITIONMODE_SCREEN:
					xstep=CL3DGlobalCacheUtil.Instance.screenWidth*.5;
					ystep=CL3DGlobalCacheUtil.Instance.screenHeight*.5;
					yNeg=false;
					break;
				case CL3DConstDict.POSITIONMODE_SCENE3D:
					xstep=0;
					ystep=0;
					yNeg=true;
					break;
			}
			result=isNew?new Vector3D():position;
			result.x=position.x+xstep;
			result.y=yNeg?-position.y+ystep:position.y+ystep;
			result.z=position.z;
			return result;
		}
		private function doAmend2Scene3DPositionByVector3D(position:Vector3D,inMode:int,isNew:Boolean=true):Vector3D
		{
			var xstep:Number;
			var ystep:Number;
			var yNeg:Boolean;
			var result:Vector3D;
			
			switch(inMode)
			{
				case CL3DConstDict.POSITIONMODE_SCREEN:
					xstep=CL3DGlobalCacheUtil.Instance.screenWidth*.5;
					ystep=CL3DGlobalCacheUtil.Instance.screenHeight*.5;
					yNeg=false;
					break;
				case CL3DConstDict.POSITIONMODE_SCENE2D:
					xstep=0;
					ystep=0;
					yNeg=true;
					break;
			}
			result=isNew?new Vector3D():position;
			result.x=position.x+xstep;
			result.y=yNeg?-position.y+ystep:position.y+ystep;
			result.z=position.z;
			return result;
		}
		/**
		 * 根据房间名称,获取房间类型名称 
		 * @param roomName
		 * @return String
		 * 
		 */		
		public function getRoomTypeName(roomName:String):String
		{
			var roomType:String = "";
			switch(roomName)
			{
				case "客厅":
				case "客餐厅":
				case "餐厅":
					roomType = "客餐厅";
					break;
				case "主卧":
				case "卧室":
				case "次卧":
				case "客卧":
				case "书房":
				case "小孩房":
				case "老人房":
				case "储物间":
				case "衣帽间":
					roomType = "卧室";
					break;
				case "厨房":
					roomType = "厨房";
					break;
				case "主卫":
				case "卫生间":
				case "次卫":
					roomType = "卫生间";
					break;
				case "阳台":
					roomType = "阳台";
					break;
				case "飘窗":
				default:
					roomType = "卧室";
					break;
			}
			return roomType;
		}
		/**
		 * 根据房间名称获取房间类型值
		 * @param roomName
		 * @return int
		 * 
		 */		
		public function getRoomType(roomName:String):int
		{
			var typeName:String=getRoomTypeName(roomName);
			var result:int;
			
			switch(typeName)
			{
				case "客餐厅":
					result=CL3DConstDict.ROOMTYPE_PARLOUR;
					break;
				case "卧室":
					result=CL3DConstDict.ROOMTYPE_BEDROOM;
					break;
				case "厨房":
					result=CL3DConstDict.ROOMTYPE_KITCHEN;
					break;
				case "卫生间":
					result=CL3DConstDict.ROOMTYPE_WASHROOM;
					break;
				case "阳台":
					result=CL3DConstDict.ROOMTYPE_BALCONY;
					break;
				case "参数化飘窗":
					result=CL3DConstDict.ROOMTYPE_SPECAIL_BALCONY;
					break;
				default:
					result=-1;
					break;
			}
			return result;
		}

		/**
		 *	通过模型创建家具对象 
		 * @param mesh	家具模型
		 * @param scene	模型所在场景
		 * @param furnitureClass	家具类
		 * @return IL3DFurnitureExtension
		 * 
		 */	
		public function buildFurniture3DByMesh(mesh:L3DMesh,scene:ICL3DSceneExtension,furnitureClass:Class,scale:Number=1):ICL3DFurnitureExtension
		{
			if(mesh == null)
			{
				return null;
			}
			var materialInfo:L3DMaterialInformations;
			var furniture:ICL3DFurnitureExtension;
			//cloud 2018.5.23 优化
			materialInfo = CL3DModuleUtil.Instance.getL3DMaterialInfoResource(mesh.Code,mesh.url);
			if(materialInfo == null)
			{
				materialInfo=L3DMaterialInformations.FromMesh(mesh);
			}
			furniture = new furnitureClass(scene) as ICL3DFurnitureExtension;
			furniture.MaterialInfo = materialInfo;
			switch(furniture.Catalog)
			{
					//IsParamWallBoard
				case 36:
					//IsParamRailing
				case 38:
					//IsParamSunRoom
				case 39:
					//isParamBayWindowCombine
				case 49:
					furniture.PositionX = CMathUtil.Instance.amendInt(mesh.x / CL3DGlobalCacheUtil.Instance.sceneScaleRatio);
					furniture.PositionY = CMathUtil.Instance.amendInt(mesh.y / CL3DGlobalCacheUtil.Instance.sceneScaleRatio);
					furniture.PositionZ = CMathUtil.Instance.amendInt(mesh.z / CL3DGlobalCacheUtil.Instance.sceneScaleRatio);
					furniture.Rotation = mesh.rotationZ * 180 / Math.PI;
					break;
				//lsm 7.31
				//isWindow
				case 4:
				case 10:
				case 11:
				case 30:
				case 33:
				case 34:
				case 35:
				case 45:
					//IsParamUserWindow
				case 42:
					//IsParamUserCornerWindow
				case 44:
					//IsParamWardrobe
				case 40:
					if(furniture.OffGround <= 0)
					{
						furniture.OffGround = 300;
					}
					break;
			}
			if(mesh.boundBox == null)
			{
				mesh.boundBox = Object3DUtils.calculateHierarchyBoundBox(mesh);
			}
			furniture.centerX =CMathUtil.Instance.amendInt((mesh.boundBox.maxX + mesh.boundBox.minX)*.5);
			furniture.centerY =CMathUtil.Instance.amendInt((mesh.boundBox.maxY + mesh.boundBox.minY)*.5);
			furniture.centerZ =CMathUtil.Instance.amendInt((mesh.boundBox.maxZ + mesh.boundBox.minZ)*.5);
			furniture.Length =CMathUtil.Instance.amendInt(mesh.boundBox.maxX - mesh.boundBox.minX);
			furniture.Width = CMathUtil.Instance.amendInt(mesh.boundBox.maxY - mesh.boundBox.minY);
			furniture.Height = CMathUtil.Instance.amendInt(mesh.boundBox.maxZ - mesh.boundBox.minZ);
			furniture.setOriginSize(furniture.Length,furniture.Width,furniture.Height);
			furniture.setSize2D(furniture.Length * CL3DGlobalCacheUtil.Instance.sceneScaleRatio,furniture.Width * CL3DGlobalCacheUtil.Instance.sceneScaleRatio);
			furniture.mesh=mesh;
			return furniture;
		}
		/**
		 * 通过墙体数据集合，计算建模围点坐标集合 
		 * @param start	起点
		 * @param end		终点
		 * @param roundPoints	画线的围点集合
		 * @param wallMap		墙体集合
		 * @return Vector.<ICL3DWallExtension>	相连的墙体对象集合
		 * 
		 */		
		public function getLinkedWalls(start:Vector3D,end:Vector3D,roundPoints:Vector.<Number>,wallMap:CHashMap,isInner:Boolean=false):Vector.<ICL3DWallExtension>
		{
			var keys:Array;
			var i:int,j:int,k:int,len:int;
			var matrix:Matrix3D;
			var wall:ICL3DWallExtension,searchedStartWall:ICL3DWallExtension,searchedEndWall:ICL3DWallExtension;
			var projectResult:Array;
			var result:Vector.<ICL3DWallExtension>,realResult:Vector.<ICL3DWallExtension>;
			var startWalls:Array,endWalls:Array;
			var pos:Vector3D;
			var normal:Vector3D;
			var bool:Boolean;
			var dis:Number;
			var startIsShared:Boolean,endIsShared:Boolean;
			var arr:Array,wallGroup:Array;
			var maxLen:int;
			//计算与起点终点可能相连的断墙集合
			startWalls=[];
			endWalls=[];
			pos=new Vector3D();
			normal=new Vector3D();
			matrix=getGlobalAxisMatrix3D();
			matrix.invert();
			keys=wallMap.keys;
			for(i=keys.length-1;i>=0;i--)
			{
				wallGroup=wallMap.get(keys[i]) as Array;
				for(j=wallGroup.length-1; j>=0; j--)
				{
					wall=wallGroup[j];
					//确定起始墙体
					projectResult=CMathUtilForAS.Instance.getProjectPoint3DAtSegment(wall.Thickness*.5,wall.innerRoundPoints[0],wall.innerRoundPoints[1],start);
					if(Math.abs(projectResult[0])<=wall.Thickness*.5 && projectResult[4])
					{
						pos.setTo(projectResult[1],projectResult[2],projectResult[3]);
						if(CMathUtilForAS.Instance.isEqualVector3D(pos,wall.innerRoundPoints[0]))
						{
							searchedStartWall=wall;
							break;
						}
						startWalls.push(wall);
					}
					else 
					{
						projectResult=CMathUtilForAS.Instance.getProjectPoint3DAtSegment(wall.Thickness*.5,wall.outterRoundPoints[0],wall.outterRoundPoints[1],start);
						if(Math.abs(projectResult[0])<=wall.Thickness*.5 && projectResult[4])
						{
							pos.setTo(projectResult[1],projectResult[2],projectResult[3]);
							if(CMathUtilForAS.Instance.isEqualVector3D(pos,wall.outterRoundPoints[0]))
							{
								searchedStartWall=wall;
								break;
							}
							startWalls.push(wall);
						}
					}
				}
			}
			if(searchedStartWall)
			{
				wall=searchedStartWall;
				result=new Vector.<ICL3DWallExtension>();
				result.push(searchedStartWall);
				projectResult=CMathUtilForAS.Instance.getProjectPoint3DAtSegment(wall.Thickness*.5,wall.innerRoundPoints[0],wall.innerRoundPoints[1],end);
				if(Math.abs(projectResult[0])<=wall.Thickness*.5 && projectResult[4])
				{
					realResult=result;
				}
				else
				{
					projectResult=CMathUtilForAS.Instance.getProjectPoint3DAtSegment(wall.Thickness*.5,wall.outterRoundPoints[0],wall.outterRoundPoints[1],end);
					if(Math.abs(projectResult[0])<=wall.Thickness*.5 && projectResult[4])
					{
						realResult=result;
					}
					else
					{
						wallGroup=wallMap.get(wall.end3D.toString()) as Array;
						if(CMathUtilForAS.Instance.isEqualVector3D(wall.start3D,wallGroup[0].end3D) && CMathUtilForAS.Instance.isEqualVector3D(wall.end3D,wallGroup[0].start3D))
						{
							doGetLinkedWallByMap(wallGroup,1,wall,end,wallMap,result);
						}
						else
						{
							doGetLinkedWallByMap(wallGroup,0,wall,end,wallMap,result);
						}
						realResult=result;
					}
				}
			}
			else
			{
				arr=[];
				for(i=startWalls.length-1;i>=0;i--)
				{
					wall=startWalls[i];
					result=new Vector.<ICL3DWallExtension>();
					result.push(wall);
					projectResult=CMathUtilForAS.Instance.getProjectPoint3DAtSegment(wall.Thickness*.5,wall.innerRoundPoints[0],wall.innerRoundPoints[1],end);
					if(Math.abs(projectResult[0])<=wall.Thickness*.5 && projectResult[4])
					{
						realResult=result;
						continue;
					}
					projectResult=CMathUtilForAS.Instance.getProjectPoint3DAtSegment(wall.Thickness*.5,wall.outterRoundPoints[0],wall.outterRoundPoints[1],end);
					if(Math.abs(projectResult[0])<=wall.Thickness*.5 && projectResult[4])
					{
						realResult=result;
						continue;
					}
					wallGroup=wallMap.get(startWalls[i].end3D.toString()) as Array;
					if(CMathUtilForAS.Instance.isEqualVector3D(wall.start3D,wallGroup[0].end3D) && CMathUtilForAS.Instance.isEqualVector3D(wall.end3D,wallGroup[0].start3D))
					{
						if(doGetLinkedWallByMap(wallGroup,1,startWalls[i],end,wallMap,result))
						{
							//完成搜索
							arr.push(result);
						}
					}
					else
					{
						if(doGetLinkedWallByMap(wallGroup,0,startWalls[i],end,wallMap,result))
						{
							//完成搜索
							arr.push(result);
						}
					}
				}
				for(i=arr.length-1;i>=0;i--)
				{
					if(maxLen<arr[i].length)
					{
						maxLen=arr[i].length;
						realResult=arr[i];
					}
				}
			}
			return !realResult || !realResult.length?null:realResult;
		}

		private function doSearchNextWall(wall:ICL3DWallExtension,endWalls:Array):ICL3DWallExtension
		{
			var result:ICL3DWallExtension;
			var index:int;
			
			if(wall==null)
			{
				return null;
			}
			index=endWalls.indexOf(wall);
			if(index<0)
			{
				result=doSearchNextWall(wall.nextWall,endWalls);
			}
			else  
			{
				result=wall;
			}
			return result;
		}
		private function doGetLinkedWallByMap(walls:Array,index:int,targetWall:ICL3DWallExtension,targetPos:Vector3D,wallMap:CHashMap,result:Vector.<ICL3DWallExtension>):Boolean
		{
			var projectResult:Array;
			var bool:Boolean;
			var i:int;
			var dis:Number;
			var wall:ICL3DWallExtension;
			var nextWalls:Array;
			var resultBool:Boolean;
			
			if(walls.length==index)
			{
				return false;
			}
			wall=walls[index];
			if(wall==null || wall==targetWall)
			{
				return false;
			}
			if(CMathUtilForAS.Instance.isEqualVector3D(wall.start3D,targetWall.end3D) && CMathUtilForAS.Instance.isEqualVector3D(wall.end3D,targetWall.start3D))
			{
				//当前墙体与目标墙体属于共享墙
				result.push(wall);
				return doGetLinkedWallByMap(walls,index+1,targetWall,targetPos,wallMap,result);
			}
			result.push(wall);
			projectResult=CMathUtilForAS.Instance.getProjectPoint3DAtSegment(wall.Thickness*.5,wall.innerRoundPoints[0],wall.innerRoundPoints[1],targetPos);
			if(Math.abs(projectResult[0])<=wall.Thickness*.5 && projectResult[4])
			{
				//找到目标关联墙体，结束查找
				return true;
			}
			projectResult=CMathUtilForAS.Instance.getProjectPoint3DAtSegment(wall.Thickness*.5,wall.outterRoundPoints[0],wall.outterRoundPoints[1],targetPos);
			if(Math.abs(projectResult[0])<=wall.Thickness*.5 && projectResult[4])
			{
				//找到目标关联墙体，结束查找
				return true;
			}
			nextWalls=wallMap.get(wall.end3D.toString()) as Array;
			if(nextWalls && nextWalls.length>0)
			{
				if(CMathUtilForAS.Instance.isEqualVector3D(wall.start3D,nextWalls[0].end3D) && CMathUtilForAS.Instance.isEqualVector3D(wall.end3D,nextWalls[0].start3D))
				{
					resultBool=doGetLinkedWallByMap(nextWalls,1,targetWall,targetPos,wallMap,result);
				}
				else
				{
					resultBool=doGetLinkedWallByMap(nextWalls,0,targetWall,targetPos,wallMap,result);
				}
				if(resultBool)
				{
					return true;
				}
			}
			return doGetLinkedWallByMap(walls,index+1,targetWall,targetPos,wallMap,result);
		}
		/**
		 * 根据关联墙体集合，计算需要补充的阳光房围点集合（供阳光房建模使用） 
		 * @param linkedWalls
		 * @param drawPoints
		 * @param start
		 * @param end
		 * @param outputInnerSharedValues
		 * @param outputOutterSharedValues
		 * 
		 */		
		private function doCalculateAddedRoundPointsByLinkedWalls(linkedWalls:Vector.<ICL3DWallExtension>,drawPoints:Vector.<Number>,start:Vector3D,end:Vector3D,outputInnerSharedValues:Vector.<Number>,outputOutterSharedValues:Vector.<Number>):void
		{
			var s1:Vector3D,e1:Vector3D,s2:Vector3D,e2:Vector3D;
			var ver1:Vector3D,ver2:Vector3D;
			var intersectResult:Array;
			var i:int,prev:int,len:int;
			var matrix:Matrix3D;
			var pos:Vector3D;
			var isInner:Boolean;
			
			matrix=getGlobalAxisMatrix3D();
			matrix.invert();
			s1=new Vector3D();
			e1=new Vector3D();
			s2=new Vector3D();
			e2=new Vector3D();
			ver1=new Vector3D();
			ver2=new Vector3D();
			pos=new Vector3D();
			len=linkedWalls.length;
			if(len>1)
			{
				for(i=0;i<len;i++)
				{
					prev=i==0?len-1:i-1;
					if(i!=0 && i!=len-1)
					{
						ver1.copyFrom(linkedWalls[prev].normal3D);
						ver1.scaleBy(linkedWalls[prev].Thickness*.5);
						ver2.copyFrom(linkedWalls[i].normal3D);
						ver2.scaleBy(linkedWalls[i].Thickness*.5);
						ver1.negate();
						ver2.negate();
						pos=CMathUtilForAS.Instance.getCornerPos(linkedWalls[prev].start3D,linkedWalls[prev].end3D,ver1,linkedWalls[i].start3D,linkedWalls[i].end3D,ver2);
						outputInnerSharedValues.push(pos.x,pos.y,pos.z);
						ver1.negate();
						ver2.negate();
						pos=CMathUtilForAS.Instance.getCornerPos(linkedWalls[prev].start3D,linkedWalls[prev].end3D,ver1,linkedWalls[i].start3D,linkedWalls[i].end3D,ver2);
						outputOutterSharedValues.push(pos.x,pos.y,pos.z);
//						if(isInner)
//						{
//							//如果新画围点属于链接墙体的内测
//							ver1.copyFrom(linkedWalls[prev].normal3D);
//							ver1.scaleBy(linkedWalls[prev].Thickness*.5);
//							ver2.copyFrom(linkedWalls[i].normal3D);
//							ver2.scaleBy(linkedWalls[i].Thickness*.5);
//							pos=CMathUtilForAS.Instance.getCornerPos(linkedWalls[prev].start3D,linkedWalls[prev].end3D,ver1,linkedWalls[i].start3D,linkedWalls[i].end3D,ver2);
//							outputInnerSharedValues.push(pos.x,pos.y,pos.z);
//							ver1.negate();
//							ver2.negate();
//							pos=CMathUtilForAS.Instance.getCornerPos(linkedWalls[prev].start3D,linkedWalls[prev].end3D,ver1,linkedWalls[i].start3D,linkedWalls[i].end3D,ver2);
//							outputOutterSharedValues.push(pos.x,pos.y,pos.z);
//						}
//						else
//						{
//							ver1.copyFrom(linkedWalls[prev].normal3D);
//							ver1.scaleBy(linkedWalls[prev].Thickness*.5);
//							ver2.copyFrom(linkedWalls[i].normal3D);
//							ver2.scaleBy(linkedWalls[i].Thickness*.5);
//							ver1.negate();
//							ver2.negate();
//							pos=CMathUtilForAS.Instance.getCornerPos(linkedWalls[prev].start3D,linkedWalls[prev].end3D,ver1,linkedWalls[i].start3D,linkedWalls[i].end3D,ver2);
//							outputInnerSharedValues.push(pos.x,pos.y,pos.z);
//							ver1.negate();
//							ver2.negate();
//							pos=CMathUtilForAS.Instance.getCornerPos(linkedWalls[prev].start3D,linkedWalls[prev].end3D,ver1,linkedWalls[i].start3D,linkedWalls[i].end3D,ver2);
//							outputOutterSharedValues.push(pos.x,pos.y,pos.z);
//						}
					}
					else if(i==0)
					{
						s1.setTo(start.x+linkedWalls[i].normal3D.x*int.MIN_VALUE,start.y+linkedWalls[i].normal3D.y*int.MIN_VALUE,start.z+linkedWalls[i].normal3D.z*int.MIN_VALUE);
						e1.setTo(start.x+linkedWalls[i].normal3D.x*int.MAX_VALUE,start.y+linkedWalls[i].normal3D.y*int.MAX_VALUE,start.z+linkedWalls[i].normal3D.z*int.MAX_VALUE);
						s2=linkedWalls[i].innerRoundPoints[0];
						e2=linkedWalls[i].innerRoundPoints[1];
						intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(s1,e1,s2,e2);
//						if(intersectResult!=null)
//						{
//							//相交，判断属于那一侧
//							isInner=CMathUtilForAS.Instance.judgePointInPolygonByNumber(drawPoints,intersectResult[1].x,intersectResult[1].y,intersectResult[1].z,matrix);
//						}
						if(intersectResult==null)
						{
							//与外墙线相交,添加起点
							outputInnerSharedValues.push(linkedWalls[i].outterRoundPoints[0].x,linkedWalls[i].outterRoundPoints[0].y,linkedWalls[i].outterRoundPoints[0].z);
							outputOutterSharedValues.push(linkedWalls[i].innerRoundPoints[0].x,linkedWalls[i].innerRoundPoints[0].y,linkedWalls[i].innerRoundPoints[0].z);
						}
						else
						{
							pos.copyFrom(intersectResult[1]);
							outputOutterSharedValues.push(pos.x,pos.y,pos.z);
							s2=linkedWalls[i].outterRoundPoints[0];
							e2=linkedWalls[i].outterRoundPoints[1];
							intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(s1,e1,s2,e2);
							outputInnerSharedValues.push(intersectResult[1].x,intersectResult[1].y,intersectResult[1].z);
						}
//						if(isInner)
//						{
//							outputInnerSharedValues.push(intersectResult[1].x,intersectResult[1].y,intersectResult[1].z);
//							s2=linkedWalls[i].outterRoundPoints[0];
//							e2=linkedWalls[i].outterRoundPoints[1];
//							intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(s1,e1,s2,e2);
//							outputOutterSharedValues.push(intersectResult[1].x,intersectResult[1].y,intersectResult[1].z);
//						}
//						else
//						{
//							if(intersectResult==null)
//							{
//								//与外墙线相交,添加起点
//								outputInnerSharedValues.push(linkedWalls[i].outterRoundPoints[0].x,linkedWalls[i].outterRoundPoints[0].y,linkedWalls[i].outterRoundPoints[0].z);
//								outputOutterSharedValues.push(linkedWalls[i].innerRoundPoints[0].x,linkedWalls[i].innerRoundPoints[0].y,linkedWalls[i].innerRoundPoints[0].z);
//							}
//							else
//							{
//								pos.copyFrom(intersectResult[1]);
//								outputOutterSharedValues.push(pos.x,pos.y,pos.z);
//								s2=linkedWalls[i].outterRoundPoints[0];
//								e2=linkedWalls[i].outterRoundPoints[1];
//								intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(s1,e1,s2,e2);
//								outputInnerSharedValues.push(intersectResult[1].x,intersectResult[1].y,intersectResult[1].z);
//							}
//						}
					}
					else if(i==len-1)
					{
						s1.setTo(end.x+linkedWalls[i].normal3D.x*int.MIN_VALUE,end.y+linkedWalls[i].normal3D.y*int.MIN_VALUE,end.z+linkedWalls[i].normal3D.z*int.MIN_VALUE);
						e1.setTo(end.x+linkedWalls[i].normal3D.x*int.MAX_VALUE,end.y+linkedWalls[i].normal3D.y*int.MAX_VALUE,end.z+linkedWalls[i].normal3D.z*int.MAX_VALUE);
						ver1.copyFrom(linkedWalls[prev].normal3D);
						ver1.scaleBy(linkedWalls[prev].Thickness*.5);
						ver2.copyFrom(linkedWalls[i].normal3D);
						ver2.scaleBy(linkedWalls[i].Thickness*.5);
						ver1.negate();
						ver2.negate();
						pos=CMathUtilForAS.Instance.getCornerPos(linkedWalls[prev].start3D,linkedWalls[prev].end3D,ver1,linkedWalls[i].start3D,linkedWalls[i].end3D,ver2);
						outputInnerSharedValues.push(pos.x,pos.y,pos.z);
						ver1.negate();
						ver2.negate();
						pos=CMathUtilForAS.Instance.getCornerPos(linkedWalls[prev].start3D,linkedWalls[prev].end3D,ver1,linkedWalls[i].start3D,linkedWalls[i].end3D,ver2);
						outputOutterSharedValues.push(pos.x,pos.y,pos.z);
						//添加终点
						s2=linkedWalls[i].innerRoundPoints[0];
						e2=linkedWalls[i].innerRoundPoints[1];
						intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(s1,e1,s2,e2);
						if(intersectResult==null)
						{
							pos.copyFrom(linkedWalls[i].outterRoundPoints[1]);
							outputInnerSharedValues.push(pos.x,pos.y,pos.z);
							pos.copyFrom(linkedWalls[i].innerRoundPoints[1]);
							outputOutterSharedValues.push(pos.x,pos.y,pos.z);
						}
						else
						{
							outputOutterSharedValues.push(intersectResult[1].x,intersectResult[1].y,intersectResult[1].z);
							s2=linkedWalls[i].outterRoundPoints[0];
							e2=linkedWalls[i].outterRoundPoints[1];
							intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(s1,e1,s2,e2);
							outputInnerSharedValues.push(intersectResult[1].x,intersectResult[1].y,intersectResult[1].z);
						}
//						if(isInner)
//						{
//							//如果新画围点属于链接墙体的内测
//							ver1.copyFrom(linkedWalls[prev].normal3D);
//							ver1.scaleBy(linkedWalls[prev].Thickness*.5);
//							ver2.copyFrom(linkedWalls[i].normal3D);
//							ver2.scaleBy(linkedWalls[i].Thickness*.5);
//							pos=CMathUtilForAS.Instance.getCornerPos(linkedWalls[prev].start3D,linkedWalls[prev].end3D,ver1,linkedWalls[i].start3D,linkedWalls[i].end3D,ver2);
//							outputInnerSharedValues.push(pos.x,pos.y,pos.z);
//							ver1.negate();
//							ver2.negate();
//							pos=CMathUtilForAS.Instance.getCornerPos(linkedWalls[prev].start3D,linkedWalls[prev].end3D,ver1,linkedWalls[i].start3D,linkedWalls[i].end3D,ver2);
//							outputOutterSharedValues.push(pos.x,pos.y,pos.z);
//							//添加终点
//							s2=linkedWalls[i].innerRoundPoints[0];
//							e2=linkedWalls[i].innerRoundPoints[1];
//							intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(s1,e1,s2,e2);
//							outputInnerSharedValues.push(intersectResult[1].x,intersectResult[1].y,intersectResult[1].z);
//							s2=linkedWalls[i].outterRoundPoints[0];
//							e2=linkedWalls[i].outterRoundPoints[1];
//							intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(s1,e1,s2,e2);
//							outputOutterSharedValues.push(pos.x,pos.y,pos.z);
//						}
//						else
//						{
//							ver1.copyFrom(linkedWalls[prev].normal3D);
//							ver1.scaleBy(linkedWalls[prev].Thickness*.5);
//							ver2.copyFrom(linkedWalls[i].normal3D);
//							ver2.scaleBy(linkedWalls[i].Thickness*.5);
//							ver1.negate();
//							ver2.negate();
//							pos=CMathUtilForAS.Instance.getCornerPos(linkedWalls[prev].start3D,linkedWalls[prev].end3D,ver1,linkedWalls[i].start3D,linkedWalls[i].end3D,ver2);
//							outputInnerSharedValues.push(pos.x,pos.y,pos.z);
//							ver1.negate();
//							ver2.negate();
//							pos=CMathUtilForAS.Instance.getCornerPos(linkedWalls[prev].start3D,linkedWalls[prev].end3D,ver1,linkedWalls[i].start3D,linkedWalls[i].end3D,ver2);
//							outputOutterSharedValues.push(pos.x,pos.y,pos.z);
//							//添加终点
//							s2=linkedWalls[i].innerRoundPoints[0];
//							e2=linkedWalls[i].innerRoundPoints[1];
//							intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(s1,e1,s2,e2);
//							if(intersectResult==null)
//							{
//								pos.copyFrom(linkedWalls[i].outterRoundPoints[1]);
//								outputInnerSharedValues.push(pos.x,pos.y,pos.z);
//								pos.copyFrom(linkedWalls[i].innerRoundPoints[1]);
//								outputOutterSharedValues.push(pos.x,pos.y,pos.z);
//							}
//							else
//							{
//								outputOutterSharedValues.push(intersectResult[1].x,intersectResult[1].y,intersectResult[1].z);
//								s2=linkedWalls[i].outterRoundPoints[0];
//								e2=linkedWalls[i].outterRoundPoints[1];
//								intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(s1,e1,s2,e2);
//								outputInnerSharedValues.push(intersectResult[1].x,intersectResult[1].y,intersectResult[1].z);
//							}
//						}
					}
				}
			}
			else 
			{
				s2=linkedWalls[0].innerRoundPoints[0];
				e2=linkedWalls[0].innerRoundPoints[1];
				s1.setTo(start.x+linkedWalls[0].normal3D.x*int.MIN_VALUE,start.y+linkedWalls[0].normal3D.y*int.MIN_VALUE,start.z+linkedWalls[0].normal3D.z*int.MIN_VALUE);
				e1.setTo(start.x+linkedWalls[0].normal3D.x*int.MAX_VALUE,start.y+linkedWalls[0].normal3D.y*int.MAX_VALUE,start.z+linkedWalls[0].normal3D.z*int.MAX_VALUE);
				intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(s1,e1,s2,e2);
				if(intersectResult!=null)
				{
					isInner=CMathUtilForAS.Instance.judgePointInPolygonByNumber(drawPoints,intersectResult[1].x,intersectResult[1].y,intersectResult[1].z,matrix);
					if(isInner)
					{
						outputInnerSharedValues.push(intersectResult[1].x,intersectResult[1].y,intersectResult[1].z);
						s1.setTo(end.x+linkedWalls[0].normal3D.x*int.MIN_VALUE,end.y+linkedWalls[0].normal3D.y*int.MIN_VALUE,end.z+linkedWalls[0].normal3D.z*int.MIN_VALUE);
						e1.setTo(end.x+linkedWalls[0].normal3D.x*int.MAX_VALUE,end.y+linkedWalls[0].normal3D.y*int.MAX_VALUE,end.z+linkedWalls[0].normal3D.z*int.MAX_VALUE);
						//添加终点
						intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(s1,e1,s2,e2);
						if(intersectResult==null)
						{
							outputInnerSharedValues.push(linkedWalls[0].innerRoundPoints[1].x,linkedWalls[0].innerRoundPoints[1].y,linkedWalls[0].innerRoundPoints[1].z);
						}
						else
						{
							outputInnerSharedValues.push(intersectResult[1].x,intersectResult[1].y,intersectResult[1].z);
						}
						
						s2=linkedWalls[0].outterRoundPoints[0];
						e2=linkedWalls[0].outterRoundPoints[1];
						s1.setTo(start.x+linkedWalls[0].normal3D.x*int.MIN_VALUE,start.y+linkedWalls[0].normal3D.y*int.MIN_VALUE,start.z+linkedWalls[0].normal3D.z*int.MIN_VALUE);
						e1.setTo(start.x+linkedWalls[0].normal3D.x*int.MAX_VALUE,start.y+linkedWalls[0].normal3D.y*int.MAX_VALUE,start.z+linkedWalls[0].normal3D.z*int.MAX_VALUE);
						intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(s1,e1,s2,e2);
						outputOutterSharedValues.push(intersectResult[1].x,intersectResult[1].y,intersectResult[1].z);
						s1.setTo(end.x+linkedWalls[0].normal3D.x*int.MIN_VALUE,end.y+linkedWalls[0].normal3D.y*int.MIN_VALUE,end.z+linkedWalls[0].normal3D.z*int.MIN_VALUE);
						e1.setTo(end.x+linkedWalls[0].normal3D.x*int.MAX_VALUE,end.y+linkedWalls[0].normal3D.y*int.MAX_VALUE,end.z+linkedWalls[0].normal3D.z*int.MAX_VALUE);
						intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(s1,e1,s2,e2);
						outputOutterSharedValues.push(intersectResult[1].x,intersectResult[1].y,intersectResult[1].z);
					}
					else
					{
						outputOutterSharedValues.push(intersectResult[1].x,intersectResult[1].y,intersectResult[1].z);
						s1.setTo(end.x+linkedWalls[0].normal3D.x*int.MIN_VALUE,end.y+linkedWalls[0].normal3D.y*int.MIN_VALUE,end.z+linkedWalls[0].normal3D.z*int.MIN_VALUE);
						e1.setTo(end.x+linkedWalls[0].normal3D.x*int.MAX_VALUE,end.y+linkedWalls[0].normal3D.y*int.MAX_VALUE,end.z+linkedWalls[0].normal3D.z*int.MAX_VALUE);
						intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(s1,e1,s2,e2);
						if(intersectResult==null)
						{
							outputOutterSharedValues.push(linkedWalls[0].innerRoundPoints[1].x,linkedWalls[0].innerRoundPoints[1].y,linkedWalls[0].innerRoundPoints[1].z);
						}
						else
						{
							outputOutterSharedValues.push(intersectResult[1].x,intersectResult[1].y,intersectResult[1].z);
						}
						
						s2=linkedWalls[0].outterRoundPoints[0];
						e2=linkedWalls[0].outterRoundPoints[1];
						s1.setTo(start.x+linkedWalls[0].normal3D.x*int.MIN_VALUE,start.y+linkedWalls[0].normal3D.y*int.MIN_VALUE,start.z+linkedWalls[0].normal3D.z*int.MIN_VALUE);
						e1.setTo(start.x+linkedWalls[0].normal3D.x*int.MAX_VALUE,start.y+linkedWalls[0].normal3D.y*int.MAX_VALUE,start.z+linkedWalls[0].normal3D.z*int.MAX_VALUE);
						intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(s1,e1,s2,e2);
						outputInnerSharedValues.push(intersectResult[1].x,intersectResult[1].y,intersectResult[1].z);
						s1.setTo(end.x+linkedWalls[0].normal3D.x*int.MIN_VALUE,end.y+linkedWalls[0].normal3D.y*int.MIN_VALUE,end.z+linkedWalls[0].normal3D.z*int.MIN_VALUE);
						e1.setTo(end.x+linkedWalls[0].normal3D.x*int.MAX_VALUE,end.y+linkedWalls[0].normal3D.y*int.MAX_VALUE,end.z+linkedWalls[0].normal3D.z*int.MAX_VALUE);
						intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(s1,e1,s2,e2);
						outputInnerSharedValues.push(intersectResult[1].x,intersectResult[1].y,intersectResult[1].z);
					}
				}
				else
				{
					outputInnerSharedValues.push(linkedWalls[0].outterRoundPoints[0].x,linkedWalls[0].outterRoundPoints[0].y,linkedWalls[0].outterRoundPoints[0].z);
					outputOutterSharedValues.push(linkedWalls[0].innerRoundPoints[0].x,linkedWalls[0].innerRoundPoints[0].y,linkedWalls[0].innerRoundPoints[0].z);
					//终点
					s1.setTo(end.x+linkedWalls[0].normal3D.x*int.MIN_VALUE,end.y+linkedWalls[0].normal3D.y*int.MIN_VALUE,end.z+linkedWalls[0].normal3D.z*int.MIN_VALUE);
					e1.setTo(end.x+linkedWalls[0].normal3D.x*int.MAX_VALUE,end.y+linkedWalls[0].normal3D.y*int.MAX_VALUE,end.z+linkedWalls[0].normal3D.z*int.MAX_VALUE);
					s2=linkedWalls[0].outterRoundPoints[0];
					e2=linkedWalls[0].outterRoundPoints[1];
					intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(s1,e1,s2,e2);
					outputInnerSharedValues.push(intersectResult[1].x,intersectResult[1].y,intersectResult[1].z);
					s2=linkedWalls[0].innerRoundPoints[0];
					e2=linkedWalls[0].innerRoundPoints[1];
					intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(s1,e1,s2,e2);
					if(intersectResult==null)
					{
						outputOutterSharedValues.push(linkedWalls[0].innerRoundPoints[1].x,linkedWalls[0].innerRoundPoints[1].y,linkedWalls[0].innerRoundPoints[1].z);
					}
					else
					{
						outputOutterSharedValues.push(intersectResult[1].x,intersectResult[1].y,intersectResult[1].z);
					}
				}
			}
		}
		/**
		 * 计算建模模型围点坐标集合
		 * @param sourceRoundPoints	围点坐标集合
		 * @param polys	用于判断的平面范围集合
		 * @param matrix		围点坐标系矩阵
		 * @param wallMap	墙体对象图集
		 * @param outputInnerValues	输出的墙体内侧围点坐标集合
		 * @param outputOutterValues	输出的墙体外侧围点坐标集合
		 * 
		 */	
		private function doCalculateBuidingMeshRoundPoints(sourceRoundPoints:Vector.<Vector3D>,unitPolys:Vector.<Poly>,matrix:Matrix3D,wallMap:CHashMap,outputInnerValues:Vector.<Number>,outputOutterValues:Vector.<Number>):void
		{
			if(!unitPolys || !unitPolys.length)
			{
				return;
			}
			var i:int,len:int;
			var unitPoints:Array;
			var start:Vector3D;
			var end:Vector3D;
			var invertMatrix:Matrix3D;
			var targetPointValues:Vector.<Number>,buildPoint3DValues:Vector.<Number>,combinePointValues:Vector.<Number>;
			
			len=sourceRoundPoints.length;
			start=sourceRoundPoints[0];
			end=sourceRoundPoints[len-1];
			invertMatrix=matrix.clone();
			invertMatrix.invert();
			for(i=unitPolys.length-1; i>=0; i--)
			{
				unitPoints=unitPolys[i].getPoints();
				targetPointValues=CMathUtilForAS.Instance.change2NumberVector(unitPoints,unitPoints.length,3);
				if(CMathUtilForAS.Instance.judgePointInPolygonByNumber(targetPointValues,start.x,start.y,0,invertMatrix) && 
					CMathUtilForAS.Instance.judgePointInPolygonByNumber(targetPointValues,end.x,end.y,0,invertMatrix))
				{
					//起始点和终点都落在区域上,计算家具的围点与区域共享的围点集合
					buildPoint3DValues=CMathUtilForAS.Instance.change2NumberVector(sourceRoundPoints,len,3);
					CMathUtilForAS.Instance.amendRoundPoint3Ds(buildPoint3DValues,CMathUtilForAS.ZAXIS_POS);
					CMathUtilForAS.Instance.amendRoundPoint3Ds(targetPointValues,CMathUtilForAS.ZAXIS_POS);
					combinePointValues=doGetCombineSharedPositionValues(buildPoint3DValues,targetPointValues);
					doCalculateRoundPointsByWalls(combinePointValues,wallMap,outputInnerValues,outputOutterValues);
					break;
				}
			}
		}
		/**
		 * 根据临近墙体的围点，获取相连墙体的另一侧围点坐标 
		 * @param points			墙体围点集合
		 * @param matrix			围点集合坐标系
		 * @param wallMap		墙体集合
		 * @return Vector.<Number> 另一侧的围点坐标
		 * 
		 */		
		public function pickedWallByWallPosition(start:Vector3D,end:Vector3D,wallMap:CHashMap):ICL3DWallExtension
		{
			var tmpWall:ICL3DWallExtension;
			var i:int,j:int;
			var wallGroup:Array;
			var dir:Vector3D;
			var projectResult:Array;
			
			dir=end.subtract(start);
			dir.normalize();
			for(i=wallMap.keys.length-1; i>=0; i--)
			{
				wallGroup=wallMap.get(wallMap.keys[i]) as Array;
				if(!wallGroup || !wallGroup.length)
				{
					continue;
				}
				for(j=wallGroup.length-1; j>=0; j--)
				{
					tmpWall=wallGroup[j];
					if(!CMathUtilForAS.Instance.isEqualVector3D(tmpWall.direction3D,dir))
					{
						continue;
					}
					//找到方向相同墙体,做投影判断
					projectResult=CMathUtilForAS.Instance.getProjectPoint3DAtSegment(tmpWall.Thickness*.5,tmpWall.start3D,tmpWall.end3D,start);
					if(projectResult && projectResult[0]>=0)
					{
						//找到目标墙体
						return tmpWall;
					}
				}
			}
			return null;
		}
		/**
		 * 根据当前坐标点，查找关联墙体，并输出相关的结果数据 
		 * @param originPos
		 * @param dir
		 * @param vertical
		 * @param wallMap
		 * @param outputIdx
		 * @param outputContainer
		 * @param isInner	结果数据是否是中墙线的内侧
		 * 
		 */		
		private function doSearchTargetWall(originPos:Vector3D,dir:Vector3D,vertical:Vector3D,wallMap:CHashMap,outputIdx:int,outputContainer:Vector.<Number>,isInner:Boolean):void
		{
			var j:int,k:int,next:int,len:int;
			var keys:Array;
			var hasSearched:Boolean;
			var group:Array,projectResult:Array;
			var wall:ICL3DWallExtension;
			var pos:Vector3D;
			
			pos=new Vector3D();
			keys=wallMap.keys;
			hasSearched=false;
			for(j=keys.length-1; j>=0; j--)
			{
				group=wallMap.get(keys[j]) as Array;
				for(k=group.length-1; k>=0; k--)
				{
					wall=group[k];
					if(!CMathUtilForAS.Instance.isEqualVector3D(wall.direction3D,dir))
					{
						continue;
					}
					//找到方向相同墙体,做投影判断
					projectResult=CMathUtilForAS.Instance.getProjectPoint3DAtSegment(wall.Thickness*.5,wall.start3D,wall.end3D,originPos);
					if(projectResult && projectResult[0]>=0)
					{
						//找到目标墙体
						pos.setTo(projectResult[1],projectResult[2],projectResult[3]);
						vertical.scaleBy(wall.Thickness*.5);
						pos.incrementBy(vertical);
						vertical.normalize();
						outputContainer[outputIdx*3]=pos.x;
						outputContainer[outputIdx*3+1]=pos.y;
						outputContainer[outputIdx*3+2]=pos.z;
						hasSearched=true;
						break;
					}
					
				}
				if(hasSearched)
				{
					break;
				}
			}
		}
		/**
		 * 创建模型面片 
		 * @param roundPoints	模型面片的围点坐标集合
		 * @param matrix		模型面片的坐标系矩阵
		 * @param name		模型名称
		 * @param material		模型面需要的材质对象
		 * @param ulength	横向纹理长度
		 * @param vlength	纵向纹理长度
		 * @param is3DMode	是否是3D模式
		 * @return Mesh
		 * 
		 */		
		public function buildMeshPlane(roundPoints:Vector.<Number>,matrix:Matrix3D,name:String,material:Material,ulength:Number,vlength:Number,is3DMode:Boolean=true):Mesh
		{
			var result:Mesh;
			var trangleVertices:Vector.<Number>;
			var i:int,len:int;
			var iterator:ICIterator,rootIterator:ICIterator;
			var v:Vector3D,start:Vector3D;
			var startResult:Array;

			iterator=rootIterator=new CIterator(0);
			len=roundPoints.length/3;
			for(i=1; i<len; i++)
			{
				iterator.linkToNext(new CIterator(i));
				iterator=iterator.next;
			}
			iterator.linkToNext(rootIterator);
			startResult=CMathUtilForAS.Instance.getStartPosIndexByXYZArray(roundPoints);
			start=new Vector3D(roundPoints[startResult[0]*3],roundPoints[startResult[0]*3+1],roundPoints[startResult[0]*3+2]);
			trangleVertices=getTrianglesByRoundPointValues(roundPoints,matrix,rootIterator);
			if(trangleVertices.length>0)
			{
				result=createPlanMeshBytriangles(trangleVertices,matrix,start,material,ulength,vlength,is3DMode);
				result.name=name;
				result.calculateBoundBox();
			}
			return result;
		}
		/**
		 * 上传场景3D资源对象到GPU 
		 * @param object
		 * @param stage3D
		 * @param forceMode
		 * 
		 */		
		public function uploadSceneResource3D(object:Object3D, stage3D:Stage3D,forceMode:Boolean=false):void
		{
			for each (var res:alternativa.engine3d.core.Resource in object.getResources(true))
			{
				if (res != null && (forceMode || res is Geometry || !res.isUploaded))
				{
					//lx9.15 防报错
					try
					{
						//cloud 2017.9.12 移除trycatch，提高运行效率
						res.upload(stage3D.context3D);
					}
					catch (error:Error)
					{
						break;
					}
					
				}
			}
		}
		/**
		 * 计算并修正2D场景界面上的当前点坐标 
		 * @param scene2d
		 * @param drawStart
		 * @param localPoint
		 * @param orthoMode
		 * @param wallLineAngle
		 * @param inputNum
		 * @return 
		 * 
		 */		
		public function calculateScene2DPoint(scene2d:ICL2DSceneExtension,drawStart:Point,localPoint:Point,orthoMode:Boolean,wallLineAngle:Number,inputNum:Number):Point
		{
			var point:Point = localPoint.clone();
			var type:int = scene2d.pickTypeOnScene2D(point);
			var dir:Point;
			var dotValue:Number;
			
			if(type >= 0)
			{
				var deltaPoint:Point = new Point(point.x - drawStart.x, point.y - drawStart.y);
				if(wallLineAngle>0)
				{
					dir=new Point(Math.cos(CMathUtil.Instance.toRadians(-wallLineAngle)),Math.sin(CMathUtil.Instance.toRadians(-wallLineAngle)));
					dotValue=dir.x*deltaPoint.x+dir.y*deltaPoint.y;
					if(dotValue>0)
					{
						point.x=dir.x*dotValue+drawStart.x;
						point.y=dir.y*dotValue+drawStart.y;
					}
					else
					{
						point.y=drawStart.y;
						point.x=drawStart.x;
					}
				}
				else if(orthoMode)
				{
					if(Math.abs(deltaPoint.y) > Math.abs(deltaPoint.x))
					{
						point.x = drawStart.x;
					}
					else
					{
						point.y = drawStart.y;
					}
				}
				scene2d.renderCoordination2D(point.x, point.y, type);
			}
			else
			{
				scene2d.ClearCoordination2D();
				deltaPoint = new Point(localPoint.x - drawStart.x, localPoint.y - drawStart.y);
				if(wallLineAngle>0)
				{
					dir=new Point(Math.cos(CMathUtil.Instance.toRadians(-wallLineAngle)),Math.sin(CMathUtil.Instance.toRadians(-wallLineAngle)));
					dotValue=dir.x*deltaPoint.x+dir.y*deltaPoint.y;
					if(dotValue>0)
					{
						point.x=dir.x*dotValue+drawStart.x;
						point.y=dir.y*dotValue+drawStart.y;
					}
					else
					{
						point.y=drawStart.y;
						point.x=drawStart.x;
					}
				}
				else if(orthoMode)
				{
					if(Math.abs(deltaPoint.y) > Math.abs(deltaPoint.x))
					{
						point.x = drawStart.x;
					}
					else
					{
						point.y = drawStart.y;
					}
				}
			}
			if(inputNum > 0)
			{
				var dn:Vector3D = new Vector3D(point.x - drawStart.x, point.y - drawStart.y, 0);
				dn.normalize();
				point.x = drawStart.x + dn.x * inputNum * CL3DGlobalCacheUtil.Instance.sceneScaleRatio;
				point.y = drawStart.y + dn.y * inputNum * CL3DGlobalCacheUtil.Instance.sceneScaleRatio;
			}
			CMathUtilForAS.Instance.amendPoint(point);
			return point;
		}
		/**
		 * 获取当前屏幕坐标对应的辅助线类型
		 * @param point	当前屏幕坐标
		 * @param startScene2D	屏幕起始点对象
		 * @param endScene2D	屏幕终止点对象
		 * @return int 0:十字  1:横向 2:竖向
		 * 
		 */		
		public function getSegmentType(point:Point,startScreen2D:Vector3D,endScreen2D:Vector3D,typeDefault:int,pickTolerance:Number):int
		{
			var pickX:Boolean,pickY:Boolean;
			var result:int;
			var position:Vector3D;
			
			result=typeDefault;
			position=CMathUtil.Instance.getDistanceByXY(point.x,point.y,startScreen2D.x,startScreen2D.y)<CMathUtil.Instance.getDistanceByXY(point.x,point.y,endScreen2D.x,endScreen2D.y)?startScreen2D:endScreen2D;
			pickX = (Math.abs(point.x-position.x)<=pickTolerance) && (Math.abs(point.x-position.x)<=pickTolerance);
			pickY = (Math.abs(point.y-position.y)<=pickTolerance) && (Math.abs(point.y-position.y)<=pickTolerance);
			if(pickX && pickY)
			{
				if(typeDefault==1)
				{
					point.x=position.x;
				}
				else if(typeDefault==2)
				{
					point.y=position.y;
				}
				else
				{
					point.x = position.x;
					point.y = position.y;
				}
				result=0;
			}
			else if(pickX)
			{
				point.x = position.x;
				if(result!=1)
				{
					result=2;
				}
				else
				{
					result=0;
				}
			}
			else if(pickY)
			{
				point.y=position.y;
				if(result!=2)
				{
					result=1;
				}
				else
				{
					result=0;
				}
			}
			return result;
		}
		/**
		 * 在2D主界面画墙线 
		 * @param scene2d
		 * @param drawStart
		 * @param localPoint
		 * @param orthoMode
		 * @param wallLineAngle
		 * @param inputNum
		 * @param wallPointColor
		 * @param wallPointSelectColor
		 * 
		 */		
		public function drawWallLineOnL2DSceneRender(scene2d:ICL2DSceneExtension,drawStart:Point,localPoint:Point,orthoMode:Boolean,wallLineAngle:Number,inputNum:Number,wallPointColor:uint,wallPointSelectColor:Number):void
		{
			var point:Point=calculateScene2DPoint(scene2d,drawStart,localPoint,orthoMode,wallLineAngle,inputNum);
			scene2d.RefreshWalls2D();
			scene2d.WallLayer.graphics.lineStyle(CL3DConstDict.DEFAULT_WALL_WIDTH*CL3DGlobalCacheUtil.Instance.sceneScaleRatio, 0x000000, 0.50, true, LineScaleMode.NORMAL, CapsStyle.NONE);
			scene2d.WallLayer.graphics.moveTo(drawStart.x, drawStart.y);
			scene2d.WallLayer.graphics.lineTo(point.x, point.y);
			scene2d.WallLayer.graphics.lineStyle(1, 0x000000, 1);
			scene2d.WallLayer.graphics.beginFill(wallPointColor, 1);
			scene2d.WallLayer.graphics.drawCircle(drawStart.x, drawStart.y, 12.5);
			scene2d.WallLayer.graphics.endFill();
			scene2d.WallLayer.graphics.beginFill(wallPointSelectColor, 1);
			scene2d.WallLayer.graphics.drawCircle(point.x, point.y, 12.5);
			scene2d.WallLayer.graphics.endFill();
			scene2d.drawDimension(drawStart, point);
		}
		/**
		 * 创建实体的唯一ID
		 * @param entitySymbol	实体对象符号
		 * @param uniqueID		唯一ID
		 * @return String	实体对象的唯一ID
		 * 
		 */		
		public function createEntityUID(entitySymbol:String,uniqueID:String=null):String
		{
			return entitySymbol.concat(CL3DConstDict.STRING_LINKSYMBOL,uniqueID?uniqueID:CUtil.Instance.createUID());
		}
		/**
		 * 创建基础业务数据对象 
		 * @param clsName
		 * @param ownerID
		 * @param uniqueID
		 * @param name
		 * @param type
		 * @return CBaseL3DData
		 * 
		 */		
		public function createL3DData(clsName:String,ownerID:String,uniqueID:String,name:String=null,type:uint=0):CBaseL3DData
		{
			var cls:Class=CL3DClassFactory.Instance.getClassRefByName(clsName);
			var l3dData:CBaseL3DData=new cls(clsName,uniqueID);
			l3dData.ownerID=ownerID;
			l3dData.name=name;
			l3dData.type=type;
			return l3dData;
		}
		/**
		 * 创建3D实体数据对象 
		 * @param roundPoint3DValues	3D截面围点坐标值集合
		 * @param matrix		3D变换矩阵
		 * @param clsName
		 * @param ownerID
		 * @param uniqueID
		 * @param name
		 * @param type
		 * @return ICEntity3DData
		 * 
		 */		
		public function createEntity3DData(roundPoint3DValues:Vector.<Number>,transform:CTransform3D,clsName:String,ownerID:String,uniqueID:String,name:String=null,type:int=0):ICEntity3DData
		{
			var entity3DData:ICEntity3DData=createL3DData(clsName,ownerID,uniqueID,name,type) as ICEntity3DData;
			entity3DData.roundPoint3DValues=roundPoint3DValues;
			entity3DData.transform=transform;
			return entity3DData;
		}
		/**
		 * 根据数据ID查找双向链表节点 
		 * @param dNode
		 * @param areaID
		 * @return ICDoubleNode
		 * 
		 */		
		public function searchDoubleNodeByDataID(dNode:ICDoubleNode,areaID:String):ICDoubleNode
		{
			if(dNode==null)
			{
				return null;
			}
			if(dNode.nodeData.uniqueID==areaID)
			{
				return dNode;
			}
			return searchDoubleNodeByDataID(dNode.next,areaID);
		}
		/**
		 * 根据2个闭合区间是否共用1条线段（区分方向）来判断两个区域是否类似。（可以用来判断同一区域是否发生变化，比如房间的墙体拖动，发生改变）
		 * @param area1
		 * @param area2
		 * @return Boolean
		 * 
		 */		
		public function isCloseLine3DAreaSame(area1:CClosedLine3DArea,area2:CClosedLine3DArea):Boolean
		{
			var result:Boolean;
			var line1:CWallLineData,line2:CWallLineData;
			var i:int,j:int,len1:int,len2:int,next1:int,next2:int;
			var s1:Vector3D,s2:Vector3D,e1:Vector3D,e2:Vector3D;
			
			s1=new Vector3D();
			s2=new Vector3D();
			e1=new Vector3D();
			e2=new Vector3D();
			len1=area1.roundPoints.length/3;
			len2=area2.roundPoints.length/3;
			for(i=len1-1; i>=0; i--)
			{
				next1=i==len1-1?0:i+1;
				s1.setTo(area1.roundPoints[i*3],area1.roundPoints[i*3+1],area1.roundPoints[i*3+2]);
				e1.setTo(area1.roundPoints[next1*3],area1.roundPoints[next1*3+1],area1.roundPoints[next1*3+2]);
				for(j=len2-1; j>=0; j--)
				{
					next2=j==len2-1?0:j+1;
					s2.setTo(area2.roundPoints[j*3],area2.roundPoints[j*3+1],area2.roundPoints[j*3+2]);
					e2.setTo(area2.roundPoints[next2*3],area2.roundPoints[next2*3+1],area2.roundPoints[next2*3+2]);
					if(CMathUtilForAS.Instance.isEqualVector3D(s1,s2) && CMathUtilForAS.Instance.isEqualVector3D(e1,e2))
					{
						//两个区域共墙，判断面积是否相同
						return CMathUtilForAS.Instance.isEqualVector3D(area1.center,area2.center) || CMathUtil.Instance.isEqual(area1.area,area2.area);
					}
				}
			}
			return false;
		}
		/**
		 *  两个墙体对象是否相似
		 * @param s1	墙1的起点坐标
		 * @param e1	墙1的终点坐标
		 * @param s2	墙2的起点坐标
		 * @param e2	墙2的终点坐标
		 * @return Boolean	两面墙体相同
		 * 
		 */		
		public function isWall3DSamed(s1:Vector3D,e1:Vector3D,s2:Vector3D,e2:Vector3D):Boolean
		{
			return (CMathUtilForAS.Instance.isEqualVector3D(s1,s2) && CMathUtilForAS.Instance.isEqualVector3D(e1,e2)) 
			|| (CMathUtilForAS.Instance.isEqualVector3D(s1,e2) && CMathUtilForAS.Instance.isEqualVector3D(s2,e1));
		}
		/**
		 *	获取图形的三角化顶点数组
		 * @param areaPoints	区域围点坐标集合
		 * @param convexIndice
		 * @param concaveIndice
		 * @param lobeIndice
		 * @param trangles	三角化顶点数组
		 * @param axisMatrix		用于计算的坐标轴
		 * 
		 */		
		private function doGetGraphyTrangles(areaPoints:Vector.<Number>,areaIterator:ICIterator,convexIndice:Array,concaveIndice:Array,lobeIndice:Array,trangles:Vector.<Number>,axisMatrix:Matrix3D):void
		{
			var len:int,lobeIndex:int,prev:int,next:int;
			var sindex:int;
			var curIterator:ICIterator,prevIterator:ICIterator,nextIterator:ICIterator;
			
			if(lobeIndice.length==0)
			{
				return;
			}
			lobeIndex=lobeIndice.shift();
			if(areaIterator.iteratorData==lobeIndex)
			{
				curIterator=areaIterator;
			}
			else
			{
				curIterator=areaIterator.getIteratorByData(lobeIndex);
			}
			prevIterator=curIterator.prev;
			nextIterator=curIterator.next;
			prev=prevIterator.iteratorData;
			next=nextIterator.iteratorData;
			//填充当前耳朵角所在三角形
			trangles.push(areaPoints[prev*3],areaPoints[prev*3+1],areaPoints[prev*3+2],areaPoints[lobeIndex*3],areaPoints[lobeIndex*3+1],areaPoints[lobeIndex*3+2],areaPoints[next*3],areaPoints[next*3+1],areaPoints[next*3+2]);
			if(curIterator.linkLength==3)
			{
				//三角形生成完毕，返回
				return;
			}
			curIterator.unlink();
			//删除耳尖角索引
			sindex=convexIndice.indexOf(lobeIndex);
			if(sindex>=0)
			{
				convexIndice.removeAt(sindex);
			}
			//检查生成三角形后，前一点与后一点的凹凸性是否发生改变
			//prev
			doUpdateGraphyPoint(prevIterator,areaPoints,convexIndice,concaveIndice,lobeIndice,axisMatrix);
			//next
			doUpdateGraphyPoint(nextIterator,areaPoints,convexIndice,concaveIndice,lobeIndice,axisMatrix);
			//回调获取三角形方法，一直到结束
			doGetGraphyTrangles(areaPoints,nextIterator,convexIndice,concaveIndice,lobeIndice,trangles,axisMatrix);
		}
		
		private function doUpdateGraphyPoint(curIterator:ICIterator,areaPoints:Vector.<Number>,convexIndice:Array,concaveIndice:Array,lobeIndice:Array,axisMatrix:Matrix3D):void
		{
			var len:int,index:int,prev:int,next:int;
			var polyVec:Vector.<Number>;
			var isLobe:Boolean;
			var arrIndex:int,tmpIndex:int;
			var invertMatrix:Matrix3D;
			
			invertMatrix=axisMatrix.clone();
			invertMatrix.invert();
			len=areaPoints.length/3;
			index=curIterator.iteratorData;
			prev=curIterator.prev.iteratorData;
			next=curIterator.next.iteratorData;
			polyVec=new Vector.<Number>();
			if(convexIndice.indexOf(index)>=0)
			{
				//之前是凸角,检测是否是耳朵
				polyVec.push(areaPoints[index*3],areaPoints[index*3+1],areaPoints[index*3+2],areaPoints[next*3],areaPoints[next*3+1],areaPoints[next*3+2],areaPoints[prev*3],areaPoints[prev*3+1],areaPoints[prev*3+2]);
				if(CGPCUtil.Instance.isLobe(areaPoints,polyVec,next==len-1?0:next+1,prev,invertMatrix))
				{
					if(lobeIndice.indexOf(index)<0)
					{
						lobeIndice.unshift(index);
					}
				}
				else
				{
					tmpIndex=lobeIndice.indexOf(index);
					if(tmpIndex>=0)
					{
						lobeIndice.removeAt(tmpIndex);
					}
				}
			}
			else
			{
				arrIndex=concaveIndice.indexOf(index);
				if(arrIndex>=0)
				{
					//之前是凹角，检测是否是凸角
					if(!CGPCUtil.Instance.is2DConcave(areaPoints[index*3],areaPoints[index*3+1],areaPoints[prev*3],areaPoints[prev*3+1],areaPoints[next*3],areaPoints[next*3+1]))
					{
						//是凸角
						concaveIndice.removeAt(arrIndex);
						convexIndice.push(index);
						polyVec.push(areaPoints[index*3],areaPoints[index*3+1],areaPoints[index*3+2],areaPoints[next*3],areaPoints[next*3+1],areaPoints[next*3+2],areaPoints[prev*3],areaPoints[prev*3+1],areaPoints[prev*3+2]);
						if(CGPCUtil.Instance.isLobe(areaPoints,polyVec,next==len-1?0:next+1,prev,invertMatrix))
						{
							if(lobeIndice.indexOf(index)<0)
							{
								lobeIndice.unshift(index);
							}
						}
						else
						{
							tmpIndex=lobeIndice.indexOf(index);
							if(tmpIndex>=0)
							{
								lobeIndice.removeAt(tmpIndex);
							}
						}
					}
				}
			}
		}
		/**
		 * 通过闭合图形的逆时针围点坐标值集合，获取三角化坐标值集合 
		 * @param roundPointValues	围点坐标值集合
		 * @param axisMatrix	坐标系矩阵
		 * @param iterator	迭代器对象
		 * @param isClockwise		顺时针是否遵循正向旋转规则
		 * @return Array
		 * 
		 */		
		public function getTrianglesByRoundPointValues(roundPointValues:Vector.<Number>,axisMatrix:Matrix3D,iterator:ICIterator,isClockwise:Boolean=false):Vector.<Number>
		{
			if(roundPointValues==null)
			{
				return null;
			}
			var convexIndice:Array,concaveIndice:Array,lobeIndice:Array;
			var result:Vector.<Number>;
			var invertMatrix:Matrix3D;
			
			convexIndice=[];
			concaveIndice=[];
			lobeIndice=[];
			result=new Vector.<Number>();
			CGPCUtil.Instance.calculateGraphy3DPoints(roundPointValues,axisMatrix,convexIndice,concaveIndice,lobeIndice,isClockwise);
			//执行三角化流程遍历
			doGetGraphyTrangles(roundPointValues,iterator,convexIndice,concaveIndice,lobeIndice,result,axisMatrix);
			return result;
		}
		/**
		 * 通过三角面顶点坐标集合创建模型 
		 * @param tmpTriangles	三角面顶点坐标集合
		 * @param is3DAxis 模型的顶点坐标是否是3D坐标系坐标
		 * @return Mesh
		 * 
		 */		
		public function createPlanMeshBytriangles(triangles:Vector.<Number>,matrix3D:Matrix3D,start:Vector3D,meshMaterial:Material,ulength:Number,vlength:Number,is3DAxis:Boolean):Mesh
		{
			var i:int,len:int,count:int,prev:int,next:int;
			var result:Mesh;
			var normal:Vector3D,direction:Vector3D,vertical:Vector3D;
			var u:Number,v:Number;
			var indice:Vector.<uint>;
			var uvs0:Vector.<Number>;
			var uvs1:Vector.<Number>;
			var normals:Vector.<Number>;
			var geometry:Geometry;
			var attributes:Array;
			var tmpTriangles:Vector.<Number>;
			var tmpVec:Vector3D;
			var length:Number;
			
			direction=new Vector3D();
			normal=new Vector3D();
			vertical=new Vector3D();
			matrix3D.copyColumnTo(0,direction);
			matrix3D.copyColumnTo(1,vertical);
			matrix3D.copyColumnTo(2,normal);
			tmpTriangles=triangles.concat();
			len=tmpTriangles.length/3;
			if(!is3DAxis)
			{
				for(i=0; i<len; i++)
				{
					tmpTriangles[i*3+1]*=-1;
				}
			}
			//遍历每一个三角顶点，统计uv,索引等数据
			uvs0=new Vector.<Number>();
			uvs1=new Vector.<Number>();
			normals=new Vector.<Number>();
			indice=new Vector.<uint>();
			tmpVec=new Vector3D();
			for(i=0; i<len/3; i++)
			{
				//处理三角形
//				normal=CMathUtilForAS.Instance.crossByPosition3D(
//					tmpTriangles[i*9],tmpTriangles[i*9+1],tmpTriangles[i*9+2],
//					tmpTriangles[i*9+6],tmpTriangles[i*9+7],tmpTriangles[i*9+8],
//					tmpTriangles[i*9+3],tmpTriangles[i*9+4],tmpTriangles[i*9+5]
//				);
//				normal.normalize();
//				vertical=normal.crossProduct(direction);
				//第一个顶点
				tmpVec.setTo(start.x-tmpTriangles[i*9],start.y-tmpTriangles[i*9+1],start.z-tmpTriangles[i*9+2]);
				uvs0.push(tmpVec.dotProduct(direction)/ulength,tmpVec.dotProduct(vertical)/vlength);
				uvs1.push(tmpVec.dotProduct(direction)/ulength,tmpVec.dotProduct(vertical)/vlength);
				//第二个顶点
				tmpVec.setTo(start.x-tmpTriangles[i*9+3],start.y-tmpTriangles[i*9+4],start.z-tmpTriangles[i*9+5]);
				uvs0.push(tmpVec.dotProduct(direction)/ulength,tmpVec.dotProduct(vertical)/vlength);
				uvs1.push(tmpVec.dotProduct(direction)/ulength,tmpVec.dotProduct(vertical)/vlength);
				//第三个顶点
				tmpVec.setTo(start.x-tmpTriangles[i*9+6],start.y-tmpTriangles[i*9+7],start.z-tmpTriangles[i*9+8]);
				uvs0.push(tmpVec.dotProduct(direction)/ulength,tmpVec.dotProduct(vertical)/vlength);
				uvs1.push(tmpVec.dotProduct(direction)/ulength,tmpVec.dotProduct(vertical)/vlength);
				//法线
				normals.push(normal.x,normal.y,normal.z,normal.x,normal.y,normal.z,normal.x,normal.y,normal.z);
				//索引
				indice.push(count,count+1,count+2);
				count+=3;
			}
			geometry = new Geometry();
			attributes = [
				VertexAttributes.POSITION,VertexAttributes.POSITION,VertexAttributes.POSITION,
				VertexAttributes.TEXCOORDS[0],VertexAttributes.TEXCOORDS[0],VertexAttributes.TEXCOORDS[1],VertexAttributes.TEXCOORDS[1],
				VertexAttributes.NORMAL,VertexAttributes.NORMAL,VertexAttributes.NORMAL
			];
			geometry.addVertexStream(attributes); 		// 添加顶点属性到几何
			geometry.numVertices = len;  	  					// 顶点数量
			geometry.setAttributeValues(VertexAttributes.POSITION,tmpTriangles);
			geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0],uvs0);
			geometry.setAttributeValues(VertexAttributes.TEXCOORDS[1],uvs1);
			geometry.setAttributeValues(VertexAttributes.NORMAL,normals);
			geometry.indices = indice;
			result = new Mesh();
			result.geometry = geometry;
			result.addSurface(meshMaterial,  0, len/3);	// 创建Surface
			return result;
		}
		/**
		 * 画2D墙体（新版本墙体画法）
		 * @param wall
		 * @param layer
		 * @param drawColor
		 * @param drawAlpha
		 * 
		 */		
		public function drawWall2DNew(wall:ICL3DWallExtension,layer:Sprite,drawColor:uint,drawAlpha:Number,pixelHinting:Boolean=false,scaleMode:String="normal",caps:String=null):void
		{
			if(!wall.topRoundPoints.length)
			{
				return;
			}
			var point2D:Vector3D;
			var i:int,len:int;
			
			len=wall.topRoundPoints.length;
			point2D=new Vector3D();
			layer.graphics.lineStyle(1 ,drawColor, drawAlpha);
			layer.graphics.beginFill(drawColor, drawAlpha);
			point2D.copyFrom(wall.topRoundPoints[0]);
			amendPosition3DByVector3D(point2D,CL3DConstDict.POSITIONMODE_SCENE3D,CL3DConstDict.POSITIONMODE_SCREEN,false);
			layer.graphics.moveTo(point2D.x,point2D.y);
			for(i=len-1;i>=0;i--)
			{
				point2D.copyFrom(wall.topRoundPoints[i]);
				amendPosition3DByVector3D(point2D,CL3DConstDict.POSITIONMODE_SCENE3D,CL3DConstDict.POSITIONMODE_SCREEN,false);
				layer.graphics.lineTo(point2D.x,point2D.y);
			}
			layer.graphics.endFill();
		}
		/**
		 * 填充 
		 * @param wall
		 * 
		 */		
		public function drawWall2DOld(wall:ICL3DWallExtension,layer:Sprite,drawColor:uint,drawAlpha:Number,pixelHinting:Boolean=false,scaleMode:String="normal",caps:String=null):void
		{
			if(!wall.Points2D.length)
			{
				return;
			}
			layer.graphics.lineStyle(1 ,drawColor, drawAlpha, pixelHinting, scaleMode, caps);
			layer.graphics.beginFill(drawColor, drawAlpha);
			layer.graphics.moveTo(wall.Points2D[0].x * CL3DGlobalCacheUtil.Instance.sceneScaleRatio + CL3DGlobalCacheUtil.Instance.screenWidth, wall.Points2D[0].y * CL3DGlobalCacheUtil.Instance.sceneScaleRatio + CL3DGlobalCacheUtil.Instance.screenHeight);
			layer.graphics.lineTo(wall.Points2D[2].x * CL3DGlobalCacheUtil.Instance.sceneScaleRatio + CL3DGlobalCacheUtil.Instance.screenWidth, wall.Points2D[2].y * CL3DGlobalCacheUtil.Instance.sceneScaleRatio + CL3DGlobalCacheUtil.Instance.screenHeight);
			layer.graphics.lineTo(wall.Points2D[3].x * CL3DGlobalCacheUtil.Instance.sceneScaleRatio + CL3DGlobalCacheUtil.Instance.screenWidth, wall.Points2D[3].y * CL3DGlobalCacheUtil.Instance.sceneScaleRatio + CL3DGlobalCacheUtil.Instance.screenHeight);
			layer.graphics.lineTo(wall.Points2D[1].x * CL3DGlobalCacheUtil.Instance.sceneScaleRatio + CL3DGlobalCacheUtil.Instance.screenWidth, wall.Points2D[1].y * CL3DGlobalCacheUtil.Instance.sceneScaleRatio + CL3DGlobalCacheUtil.Instance.screenHeight);
			layer.graphics.lineTo(wall.Points2D[0].x * CL3DGlobalCacheUtil.Instance.sceneScaleRatio + CL3DGlobalCacheUtil.Instance.screenWidth, wall.Points2D[0].y * CL3DGlobalCacheUtil.Instance.sceneScaleRatio + CL3DGlobalCacheUtil.Instance.screenHeight);
			layer.graphics.endFill();
		}
		/**
		 * 检查线段是否在地面范围内 
		 * @param start2D
		 * @param end2D
		 * @param floor
		 * @return Boolean
		 * 
		 */		
		public function pickedFloorBySegment(start2D:Vector3D,end2D:Vector3D,floor:ICL3DFloorExtension):Boolean
		{
			return floor.onPickedByPosition2D(start2D) || floor.onPickedByPosition2D(end2D);
		}
		/**
		 * 通过3D坐标点拣选房间 
		 * @param originPos	3D坐标点
		 * @param floor	房间地面接口实例
		 * @return Boolean
		 * 
		 */		
		public function pickedRoomByPosition(originPos:Vector3D,floor:ICL3DFloorExtension):Boolean
		{
			var matrix:Matrix3D=getGlobalAxisMatrix3D();
			return isNewSystem?CMathUtilForAS.Instance.judgePointInPolygonByVector3D(originPos,floor.outter3DRoundPoints,matrix,true):CMathUtilForAS.Instance.judgePointInPolygonByVector3D(originPos,floor.center3DRoundPoints,matrix,true);
		}
		/**
		 * 修正围点坐标集合（将同方向的点去除） 
		 * @param roundPoints
		 * @param isNew
		 * @return Vector.<Number>
		 * 
		 */		
		public function amend3DRoundPoints(roundPoints:Vector.<Number>):Vector.<Number>
		{
			var result:Vector.<Number>;
			var curDir:Vector3D,lastDir:Vector3D;
			var i:int,prev:int,next:int,len:int;
			
			curDir=new Vector3D();
			lastDir=new Vector3D();
			len=roundPoints.length/3;
			result=new Vector.<Number>();
			for(i=0;i<len;i++)
			{
				prev=i==0?len-1:i-1;
				next=i==len-1?0:i+1;
				lastDir.setTo(roundPoints[i*3]-roundPoints[prev*3],roundPoints[i*3+1]-roundPoints[prev*3+1],roundPoints[i*3+2]-roundPoints[prev*3+2]);
				lastDir.normalize();
				curDir.setTo(roundPoints[next*3]-roundPoints[i*3],roundPoints[next*3+1]-roundPoints[i*3+1],roundPoints[next*3+2]-roundPoints[i*3+2]);
				curDir.normalize();
				if(!CMathUtilForAS.Instance.isEqualVector3D(curDir,lastDir,0.01))
				{
					result.push(CMathUtil.Instance.amendInt(roundPoints[i*3]),CMathUtil.Instance.amendInt(roundPoints[i*3+1]),CMathUtil.Instance.amendInt(roundPoints[i*3+2]));
				}
			}
			return result;
		}
		/**
		 * 修正围点坐标集合 
		 * @param roundPoints
		 * @return Vector.<Vector3D>
		 * 
		 */		
		public function amend3DRoundPointsByVector3D(roundPoints:Vector.<Vector3D>):Vector.<Vector3D>
		{
			var result:Vector.<Vector3D>;
			var curDir:Vector3D,lastDir:Vector3D;
			var i:int,next:int,len:int;
			
			curDir=new Vector3D();
			lastDir=new Vector3D();
			len=roundPoints.length;
			result=new Vector.<Vector3D>();
			for(i=0;i<len;i++)
			{
				next=i==len-1?0:i+1;
				curDir.setTo(roundPoints[next].x-roundPoints[i].x,roundPoints[next].y-roundPoints[i].y,roundPoints[next].z-roundPoints[i].z);
				curDir.normalize();
				if(!CMathUtilForAS.Instance.isEqualVector3D(curDir,lastDir,0.01))
				{
					CMathUtilForAS.Instance.amendVector3D(roundPoints[i]);
					result.push(roundPoints[i]);
					lastDir.setTo(curDir.x,curDir.y,curDir.z);
				}
			}
			return result;
		}
		/**
		 * 根据相连墙体数组，确定当前墙体相连的墙体数据对象
		 * @param wall		当前墙体数据对象
		 * @param walls	墙体数组
		 * @param isPositiveSort 是否属于正向排序 
		 * @return ICL3DWallExtension
		 * 
		 */		
		private function doGetConnectedWall(wall:ICL3DWallExtension,walls:Array,isPositiveSort:Boolean):ICL3DWallExtension
		{
			var i:int;
			var dotValue:Number,tmpValue:Number;
			var result:ICL3DWallExtension;
			var cross:Vector3D;
			
			cross=new Vector3D();
			dotValue=int.MAX_VALUE;
			for(i=walls.length-1;i>=0;i--)
			{
				CMathUtilForAS.Instance.crossByVector3D(wall.direction3D,walls[i].direction3D,cross);
				cross.normalize();
				if(isPositiveSort?CMathUtil.Instance.isEqual(cross.z,1):CMathUtil.Instance.isEqual(cross.z,-1))
				{
					tmpValue=wall.direction3D.dotProduct(walls[i].direction3D);
					if(dotValue>tmpValue)
					{
						dotValue=tmpValue;
						result=walls[i];
					}
				}
			}
			return result;
		}
		public function sortInnerWallCallback(a:ICL3DWallExtension,b:ICL3DWallExtension):int
		{
			if(!a || !b)
			{
				return 0;
			}
			var cross:Vector3D=a.direction3D.crossProduct(b.direction3D);
			if(cross.z==0)
			{
				return 0;
			}
			return cross.z>0?1:-1;
		}
		public function sortOutterWallCallback(a:ICL3DWallExtension,b:ICL3DWallExtension):int
		{
			if(!a || !b)
			{
				return 0;
			}
			var cross:Vector3D=a.direction3D.crossProduct(b.direction3D);
			if(cross.z==0)
			{
				return 0;
			}
			return cross.z<0?1:-1;
		}
		/**
		 * 修正断墙的链接关系
		 * @param wallMap
		 * 
		 */		
		public function calculateBrokenWallConnected(wallMap:CHashMap):void
		{
			var keys:Array;
			var i:int,j:int,k:int;
			var wallGroup:Array,searchedGroup:Array;
			var wall:ICL3DWallExtension,searchedWall:ICL3DWallExtension;
			var key:String;
			var linkedWalls:Array;
			
			linkedWalls=[];
			//修正所有断墙的相连关系
			keys=wallMap.keys;
			for(i=keys.length-1; i>=0; i--)
			{
				wallGroup=wallMap.get(keys[i]) as Array;
				for(j=wallGroup.length-1; j>=0; j--)
				{
					wall=wallGroup[j];
					if(wall.isRoomOutline)
					{
						continue;
					}
					//是断墙
					key=wall.end3D.toString();
					searchedGroup=wallMap.get(key) as Array;
					if(searchedGroup==null)
					{
						continue;
					}
					linkedWalls.length=0;
					for(k=searchedGroup.length-1;k>=0;k--)
					{
						searchedWall=searchedGroup[k];
						if(searchedWall.isRoomOutline || CMathUtilForAS.Instance.isEqualVector3D(searchedWall.end3D,wall.start3D))
						{
							continue;
						}
						//找到一个相连的断墙
						linkedWalls.push(searchedWall);
					}
					if(wall.isRoomOutterWall)
					{
						linkedWalls.sort(sortOutterWallCallback)
					}
					else
					{
						linkedWalls.sort(sortInnerWallCallback);
					}
					if(linkedWalls.length)
					{
						//找到链接墙体
						wall.nextWall=linkedWalls[0];
						linkedWalls[0].prevWall=wall;
					}
				}
			}
		}
		/**
		 * 获取墙体某一侧的起点和终点坐标
		 * @param wall		墙体对象
		 * @param isInner	是否是内侧
		 * @param outputStart	输出起点
		 * @param outputEnd	输出终点
		 * 
		 */		
		public function getWallSideStartAndEnd(wall:ICL3DWallExtension,isInner:Boolean,outputStart:Vector3D,outputEnd:Vector3D):void
		{
			var newStart:Vector3D,newEnd:Vector3D;
			var ver1:Vector3D,ver2:Vector3D;
			//计算起点
			if(wall.prevWall)
			{
				ver1=wall.prevWall.normal3D.clone();
				ver1.scaleBy(wall.prevWall.Thickness*.5);
				ver2=wall.normal3D.clone();
				ver2.scaleBy(wall.Thickness*.5);
				if(!isInner)
				{
					ver1.negate();
					ver2.negate();
				}
				//生成新的起点坐标
				newStart=CMathUtilForAS.Instance.getCornerPos(wall.prevWall.start3D,wall.prevWall.end3D,ver1,wall.start3D,wall.end3D,ver2);
				outputStart.copyFrom(newStart);
			}
			else
			{
				if(!isInner)
				{
					outputStart.setTo(wall.start3D.x-wall.normal3D.x*wall.Thickness*.5,wall.start3D.y-wall.normal3D.y*wall.Thickness*.5,wall.start3D.z-wall.normal3D.z*wall.Thickness*.5);
				}
				else
				{
					outputStart.setTo(wall.start3D.x+wall.normal3D.x*wall.Thickness*.5,wall.start3D.y+wall.normal3D.y*wall.Thickness*.5,wall.start3D.z+wall.normal3D.z*wall.Thickness*.5);
				}
			}
			//计算终点
			if(wall.nextWall)
			{
				ver1=wall.normal3D.clone();
				ver1.scaleBy(wall.Thickness*.5);
				ver2=wall.nextWall.normal3D.clone();
				ver2.scaleBy(wall.nextWall.Thickness*.5);
				if(!isInner)
				{
					ver1.negate();
					ver2.negate();
				}
				//生成新的起点坐标
				newEnd=CMathUtilForAS.Instance.getCornerPos(wall.start3D,wall.end3D,ver1,wall.nextWall.start3D,wall.nextWall.end3D,ver2);
				outputEnd.copyFrom(newEnd);
			}
			else
			{
				if(!isInner)
				{
					outputEnd.setTo(wall.end3D.x-wall.normal3D.x*wall.Thickness*.5,wall.end3D.y-wall.normal3D.y*wall.Thickness*.5,wall.end3D.z-wall.normal3D.z*wall.Thickness*.5);
				}
				else
				{
					outputEnd.setTo(wall.end3D.x+wall.normal3D.x*wall.Thickness*.5,wall.end3D.y+wall.normal3D.y*wall.Thickness*.5,wall.end3D.z+wall.normal3D.z*wall.Thickness*.5);
				}
			}
		}

		/**
		 * 从墙体数据哈希图中移除一个墙体数据
		 * @param wall
		 * @param hashMap
		 * 
		 */	
		public function removeWallFromHashMap(wall:ICL3DWallExtension, hashMap:CHashMap):void
		{
			var group:Array,targetGroup:Array;
			var i:int,j:int,index:int;
			var key:String;
			var searchedWall:ICL3DWallExtension;
			var updatedWall:ICL3DWallExtension;
			
			key=wall.start3D.toString();
			group=hashMap.get(key) as Array;
			if(group)
			{
				for(i=group.length-1; i>=0; i--)
				{
					searchedWall=group[i];
					if(searchedWall.wallID==wall.wallID)
					{
						if(searchedWall.isShared)
						{
							//反向共享墙体设置为非共享
							targetGroup=hashMap.get(searchedWall.end3D.toString()) as Array;
							if(!targetGroup||!targetGroup.length)
							{
								continue;
							}
							for(j=targetGroup.length-1;j>=0;j--)
							{
								if(CMathUtilForAS.Instance.isEqualVector3D(searchedWall.start3D,targetGroup[j].end3D))
								{
									targetGroup[j].isShared=false;
									break;
								}
							}
						}
						if(searchedWall.prevWall)
						{
							searchedWall.prevWall.nextWall=null;
							searchedWall.prevWall=null;
						}
						if(searchedWall.nextWall)
						{
							searchedWall.nextWall.prevWall=null;
							searchedWall.nextWall=null;
						}
						group.removeAt(i);
						if(group.length==0)
						{
							hashMap.remove(key);
						}
						break;
					}
				}
			}
		}
		/**
		 * 根据3D闭合围点数据，获取3D范围
		 * @param points
		 * @return BoundBox
		 * 
		 */		
		public function getBoundBox3DByPoints(points:Vector.<Number>,matrix:Matrix3D=null):BoundBox
		{
			var i:int,len:int;
			var boundBox:BoundBox;
			var pos:Vector3D;
			var x:Number,y:Number,z:Number;
			
			if(matrix)
			{
				pos=new Vector3D();
			}
			boundBox=new BoundBox();
			len=points.length/3;
			for(i=0; i<len; i++)
			{
				if(pos)
				{
					pos.setTo(points[i*3],points[i*3+1],points[i*3+2]);
					pos=matrix.transformVector(pos);
					x=pos.x;
					y=pos.y;
					z=pos.z;
				}
				else
				{
					x=points[i*3];
					y=points[i*3+1];
					z=points[i*3+2];
				}
				if(boundBox.maxX<x)
				{
					boundBox.maxX=x;
				}
				if(boundBox.maxY<y)
				{
					boundBox.maxY=y;
				}
				if(boundBox.maxZ<z)
				{
					boundBox.maxZ=z;
				}
				if(boundBox.minX>x)
				{
					boundBox.minX=x;
				}
				if(boundBox.minY>y)
				{
					boundBox.minY=y;
				}
				if(boundBox.minZ>z)
				{
					boundBox.minZ=z;
				}
			}
			return boundBox;
		}
		
		private function doAddedOutterWallPoints(walls:Vector.<ICL3DWallExtension>,curIndex:int,targetIndex:int,len:int,isInner:Boolean,outputVec:Vector.<Number>):void
		{
			var tmpPos:Vector3D,start:Vector3D,end:Vector3D,nextStart:Vector3D,nextEnd:Vector3D;
			var dir:Vector3D,normal:Vector3D,ver1:Vector3D,ver2:Vector3D;
			var olen:int,prev:int,next:int;
			var wallPoints:Vector.<Vector3D>;
			
			normal=new Vector3D();
			ver1=new Vector3D();
			ver2=new Vector3D();
			dir=new Vector3D();
			tmpPos=new Vector3D();
			prev=curIndex==0?len-1:curIndex-1;
			next=curIndex==len-1?0:curIndex+1;
			wallPoints=isInner?walls[next].outterRoundPoints:walls[next].innerRoundPoints;
			wallPoints.length=0;
			if(CMathUtilForAS.Instance.isEqualVector3D(walls[curIndex].end3D,walls[targetIndex].start3D))
			{
				//终止断墙处理
				ver1.copyFrom(walls[next].normal3D);
				ver1.scaleBy(walls[next].Thickness*.5);
				ver2.copyFrom(walls[targetIndex].normal3D);
				ver2.scaleBy(walls[targetIndex].Thickness*.5);
				if(isInner)
				{
					ver1.negate();
				}
				else
				{
					ver2.negate();
				}
				tmpPos=CMathUtilForAS.Instance.getCornerPos(walls[next].start3D,walls[next].end3D,ver1,walls[targetIndex].start3D,walls[targetIndex].end3D,ver2);
				olen=outputVec.length;
				if(olen>2)
				{
					wallPoints.push(tmpPos.clone(),new Vector3D(outputVec[olen-3],outputVec[olen-2],outputVec[olen-1]));
				}
				outputVec.push(tmpPos.x,tmpPos.y,tmpPos.z);
				return;
			}
			ver1.copyFrom(walls[curIndex].normal3D);
			ver1.scaleBy(walls[curIndex].Thickness*.5);
			ver2.copyFrom(walls[next].normal3D);
			ver2.scaleBy(walls[next].Thickness*.5);
			if(isInner)
			{
				ver1.negate();
				ver2.negate();
			}
			tmpPos=CMathUtilForAS.Instance.getCornerPos(walls[curIndex].start3D,walls[curIndex].end3D,ver1,walls[next].start3D,walls[next].end3D,ver2);
			olen=outputVec.length;
			if(olen>2)
			{
				wallPoints.push(tmpPos.clone(),new Vector3D(outputVec[olen-3],outputVec[olen-2],outputVec[olen-1]));
			}
			outputVec.push(tmpPos.x,tmpPos.y,tmpPos.z);
			
			doAddedOutterWallPoints(walls,prev,targetIndex,len,isInner,outputVec);
		}
		/**
		 * 查找墙体数据集合的索引 
		 * @param walls	墙体数据集合
		 * @param index	当前墙体数据集合的索引
		 * @param len		墙体数据集合的长度
		 * @param isPrev	是否向前查找
		 * @return int		结果索引
		 * 
		 */		
		private function doSearchWallsIndex(walls:Vector.<ICL3DWallExtension>,index:int,len:int,isPrev:Boolean):int
		{
			var result:int;
			
			result=index==0?len-1:index-1;
			if(CMathUtilForAS.Instance.isEqualVector3D(walls[result].direction3D,walls[index].direction3D))
			{
				result=doSearchWallsIndex(walls,result,len,isPrev);
			}
			return result;
		}
//		/**
//		 * 获取新创建的墙体围点 
//		 * @param walls	墙体数据集合
//		 * @param index	当前墙体数据索引
//		 * @param next	下一个墙体数据索引
//		 * @param len		墙体数据集合长度
//		 * @param isInner	是否是内围点
//		 * @return Vector3D		返回新创建的墙体围点
//		 * 
//		 */		
//		private function doGetNewWallRoundPosition(walls:Vector.<ICL3DWallExtension>,index:int,next:int,len:int,isInner:Boolean):Vector3D
//		{
//			var normal:Vector3D;
//			var ver1:Vector3D,ver2:Vector3D;
//			var result:Vector3D;
//			
//			normal=new Vector3D();
//			ver1=new Vector3D();
//			ver2=new Vector3D();
//			if(CMathUtilForAS.Instance.isEqualVector3D(walls[index].direction3D,walls[next].direction3D))
//			{
//				doCalculateWallsNormalByIndex(walls,index,len,true,normal);
//				doGetVertical(normal,walls[index].direction3D,isInner,ver1);
//				ver1.scaleBy(walls[index].Thickness*.5);
//				result=walls[next].start3D.clone();
//				result.incrementBy(ver1);
//				return result;
//			}
//			//统计出当前墙体的起点和终点
//			doCalculateWallsNormalByIndex(walls,index,len,true,normal);
//			doGetVertical(normal,walls[index].direction3D,isInner,ver1);
//			ver1.scaleBy(walls[index].Thickness*.5);
//			//统计出下一墙体的起点和终点
//			doCalculateWallsNormalByIndex(walls,next,len,true,normal);
//			doGetVertical(normal,walls[next].direction3D,isInner,ver2);
//			ver2.scaleBy(walls[next].Thickness*.5);
//			result=doGetCornerPos(walls[index].start3D,walls[index].end3D,ver1,walls[next].start3D,walls[next].end3D,ver2);
//			return result;
//		}
//		/**
//		 * 获取相交线条缩放后的交点坐标 
//		 * @param start1	线条1起点
//		 * @param end1	线条1终点
//		 * @param vertical1	线条1的缩放方向向量
//		 * @param start2	线条2的起点
//		 * @param end2	线条2的终点
//		 * @param vertical2	线条2的缩放方向向量
//		 * @return Vector3D
//		 * 
//		 */		
//		private function doGetCornerPos(start1:Vector3D,end1:Vector3D,vertical1:Vector3D,start2:Vector3D,end2:Vector3D,vertical2:Vector3D):Vector3D
//		{
//			var dir1:Vector3D,dir2:Vector3D;
//			var newStart1:Vector3D,newEnd1:Vector3D,newStart2:Vector3D,newEnd2:Vector3D;
//			var intersectResult:Array;
//			
//			dir1=end1.subtract(start1);
//			dir1.normalize();
//			dir2=end2.subtract(start2);
//			dir2.normalize();
//			if(CMathUtil.Instance.isEqual(dir1.dotProduct(dir2),1) || CMathUtil.Instance.isEqual(dir1.dotProduct(dir2),-1))
//			{
//				//两条线共线平行，返回交点坐标
//				return end1.add(vertical1);
//			}
//			newStart1=start1.add(vertical1);
//			newEnd1=end1.add(vertical1);
//			dir1.setTo(newEnd1.x-newStart1.x,newEnd1.y-newStart1.y,newEnd1.z-newStart1.z);
//			dir1.normalize();
//			newStart1.setTo(newStart1.x+dir1.x*int.MIN_VALUE,newStart1.y+dir1.y*int.MIN_VALUE,newStart1.z+dir1.z*int.MIN_VALUE);
//			newEnd1.setTo(newEnd1.x+dir1.x*int.MAX_VALUE,newEnd1.y+dir1.y*int.MAX_VALUE,newEnd1.z+dir1.z*int.MAX_VALUE);
//
//			newStart2=start2.add(vertical2);
//			newEnd2=end2.add(vertical2);
//			dir2.setTo(newEnd2.x-newStart2.x,newEnd2.y-newStart2.y,newEnd2.z-newStart2.z);
//			dir2.normalize();
//			newStart2.setTo(newStart2.x+dir2.x*int.MIN_VALUE,newStart2.y+dir2.y*int.MIN_VALUE,newStart2.z+dir2.z*int.MIN_VALUE);
//			newEnd2.setTo(newEnd2.x+dir2.x*int.MAX_VALUE,newEnd2.y+dir2.y*int.MAX_VALUE,newEnd2.z+dir2.z*int.MAX_VALUE);
//			intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(newStart1,newEnd1,newStart2,newEnd2);
//			return intersectResult[1];
//		}
		public function calculateRoundPointsByRoundWalls(walls:Vector.<ICL3DWallExtension>,isInner:Boolean):Vector.<Number>
		{
			var i:int,wlen:int,prev:int,next:int,rlen:int;
			var dir:Vector3D,nor:Vector3D,ver1:Vector3D,ver2:Vector3D;
			var wallPoints:Vector.<Vector3D>;
			var tmpPos:Vector3D;
			var result:Vector.<Number>;
			
			dir=new Vector3D();
			nor=new Vector3D();
			ver1=new Vector3D();
			ver2=new Vector3D();
			tmpPos=new Vector3D();
			result=new Vector.<Number>();
			
			wlen=walls.length;
			for(i=0;i<wlen;i++)
			{
				prev=i==0?wlen-1:i-1;
				next=i==wlen-1?0:i+1;
				wallPoints=isInner?walls[i].innerRoundPoints:walls[i].outterRoundPoints;
				wallPoints.length=0;
				if(!CMathUtilForAS.Instance.isEqualVector3D(walls[i].end3D,walls[next].start3D))
				{
					//墙体不相连，需要补点
					//添加中继点
					ver1.copyFrom(walls[i].normal3D);
					ver1.scaleBy(walls[i].Thickness*.5);
					ver2.copyFrom(walls[i].direction3D);
					ver2.scaleBy(walls[i].Thickness*.5);
					if(!isInner)
					{
						ver1.negate();
					}
					tmpPos.copyFrom(walls[i].end3D);
					tmpPos.incrementBy(ver1);
					tmpPos.incrementBy(ver2);
					rlen=result.length;
					if(rlen>2)
					{
						wallPoints.push(new Vector3D(result[rlen-3],result[rlen-2],result[rlen-1]),tmpPos.clone());
					}
					result.push(tmpPos.x,tmpPos.y,tmpPos.z);
					tmpPos.copyFrom(walls[i].end3D);
					tmpPos.decrementBy(ver1);
					tmpPos.incrementBy(ver2);
					result.push(tmpPos.x,tmpPos.y,tmpPos.z);
					if(CMathUtilForAS.Instance.isEqualVector3D(walls[prev].end3D,walls[i].start3D))
					{
						//当前墙体属于断墙，需要逆推补点
						doAddedOutterWallPoints(walls,prev,next,wlen,isInner,result);
					}
					else if(CMathUtilForAS.Instance.isEqualVector3D(walls[prev].end3D,walls[next].start3D))
					{
						//前一墙体与下以墙体相连，说明与当前墙体的起点属于多个墙体交叉点
						ver1.copyFrom(walls[i].normal3D);
						ver1.scaleBy(walls[i].Thickness*.5);
						ver2.copyFrom(walls[next].normal3D);
						ver2.scaleBy(walls[next].Thickness*.5);
						if(isInner)
						{
							ver1.negate();
						}
						else
						{
							ver2.negate();
						}
						tmpPos=CMathUtilForAS.Instance.getCornerPos(walls[i].start3D,walls[i].end3D,ver1,walls[next].start3D,walls[next].end3D,ver2);
						rlen=result.length;
						if(rlen>2)
						{
							wallPoints.push(new Vector3D(result[rlen-3],result[rlen-2],result[rlen-1]),tmpPos.clone());
						}
						result.push(tmpPos.x,tmpPos.y,tmpPos.z);
					}
				}
				else
				{
					//墙体相连
					ver1.copyFrom(walls[i].normal3D);
					ver1.scaleBy(walls[i].Thickness*.5);
					ver2.copyFrom(walls[next].normal3D);
					ver2.scaleBy(walls[next].Thickness*.5);
					if(!isInner)
					{
						ver1.negate();
						ver2.negate();
					}
					tmpPos=CMathUtilForAS.Instance.getCornerPos(walls[i].start3D,walls[i].end3D,ver1,walls[next].start3D,walls[next].end3D,ver2);
					rlen=result.length;
					if(rlen>2)
					{
						wallPoints.push(new Vector3D(result[rlen-3],result[rlen-2],result[rlen-1]),tmpPos.clone());
					}
					result.push(tmpPos.x,tmpPos.y,tmpPos.z);
				}
			}
			wallPoints=isInner?walls[0].innerRoundPoints:walls[0].outterRoundPoints;
			wlen=result.length;
			wallPoints.push(new Vector3D(result[wlen-3],result[wlen-2],result[wlen-1]),new Vector3D(result[0],result[1],result[2]));
			return result;
		}
		/**
		 * 创建墙体模型面 
		 * @param start3D	墙体起始点
		 * @param end3D		墙体终止点
		 * @param matrix		墙体坐标系矩阵对象
		 * @param meshName		墙体模型名
		 * @param material		墙体材质对象
		 * @param ulength		u
		 * @param vlength		v
		 * @param wall			墙体Wall3D对象
		 * @param scene		墙体所在场景的Scene3D对象
		 * @return Mesh	墙体模型对象
		 * 
		 */		
		public function createWallMeshPoly(start3D:Vector3D,end3D:Vector3D,matrix3D:Matrix3D,meshName:String,material:Material,ulength:Number,vlength:Number,wall:ICL3DWallExtension):Mesh
		{
			var mesh:Mesh;
			var baseWallPoints:Vector.<PPoint>,holeWallPoints:Array;
			var holePoints:Vector.<Number>,roundPoints:Vector.<Number>;
			var matrix:Matrix3D,invertMatrix:Matrix3D;
			var locS:Vector3D,locE:Vector3D,locPos:Vector3D,pos:Vector3D,start:Vector3D;
			var wallPoly:VisiblePolygon;
			var i:int,j:int,len:int;
			var yValue:Number;
			var dir:Vector3D,right:Vector3D;
			var minX:Number,maxX:Number,minY:Number,maxY:Number;
			var isInner:Boolean;
			var holes:Array;
			var normal:Vector3D;
			
			roundPoints=new Vector.<Number>();
			normal=new Vector3D();
			if(wall.hasHole)
			{
				matrix3D.copyColumnTo(2,normal);
				matrix=CMathUtilForAS.Instance.getMatrix3DBySegment(start3D,end3D,normal);
				invertMatrix=matrix.clone();
				invertMatrix.invert();
				locS=invertMatrix.transformVector(start3D);
				locE=invertMatrix.transformVector(end3D);
				minX=locS.x-.1;
				maxX=locE.x+.1;
				minY=locS.z-.1;
				maxY=locE.z+wall.wallHeight*CL3DGlobalCacheUtil.Instance.sceneScaleRatio+.1;
				baseWallPoints=new Vector.<PPoint>();
				baseWallPoints.push(new PPoint(minX,minY));
				baseWallPoints.push(new PPoint(maxX,minY));
				baseWallPoints.push(new PPoint(maxX,maxY));
				baseWallPoints.push(new PPoint(minX,maxY));
				
				wallPoly = new VisiblePolygon();
				wallPoly.addPolyline(baseWallPoints);
				isInner=meshName==CL3DConstDict.TYPE_WALL_IN;
				holes=wall.getHoles(isInner);
				holeWallPoints=[];
				for(i=holes.length-1; i>=0; i--)
				{
					holePoints=holes[i];
					len=holePoints.length/3;
					holeWallPoints.length=0;
					for(j=0; j<len; j++)
					{
						pos=new Vector3D(holePoints[j*3]*CL3DGlobalCacheUtil.Instance.sceneScaleRatio,holePoints[j*3+1]*CL3DGlobalCacheUtil.Instance.sceneScaleRatio,holePoints[j*3+2]*CL3DGlobalCacheUtil.Instance.sceneScaleRatio);
						locPos=invertMatrix.transformVector(pos);
						holeWallPoints.push(new PPoint(locPos.x,locPos.y));
					}
					holeWallPoints=CMathUtilForAS.Instance.amendRoundPoint2Ds(holeWallPoints);
					wallPoly.addHole(Vector.<PPoint>(holeWallPoints));
				}
				//三角化墙面
				var trianglePoints:Vector.<PPoint>;
				var tri1:Vector3D,tri2:Vector3D,tri3:Vector3D;
				var triangles:Vector.<Number>;
				var triNormal:Vector3D;
				var isNegtive:Boolean;

				triangles=new Vector.<Number>();
				try
				{
					len=wallPoly.triangles.length;
				}
				catch(e:Error)
				{
					print("墙洞生成有问题，检查洞是否超出墙体模型范围");
				}
				for(i=0; i<len; i++)
				{
					trianglePoints=wallPoly.triangles[i].points;
					if(trianglePoints[2].x<minX || trianglePoints[2].y<minY || trianglePoints[2].x>maxX || trianglePoints[2].y>maxY ||
						trianglePoints[1].x<minX || trianglePoints[1].y<minY || trianglePoints[1].x>maxX || trianglePoints[1].y>maxY ||
						trianglePoints[0].x<minX || trianglePoints[0].y<minY || trianglePoints[0].x>maxX || trianglePoints[0].y>maxY)
					{
						continue;
					}
					doAmendPoint2D(trianglePoints[2],locS.x,locE.x,locS.y,locE.z+wall.wallHeight*CL3DGlobalCacheUtil.Instance.sceneScaleRatio,.11,.11);
					doAmendPoint2D(trianglePoints[1],locS.x,locE.x,locS.y,locE.z+wall.wallHeight*CL3DGlobalCacheUtil.Instance.sceneScaleRatio,.11,.11);
					doAmendPoint2D(trianglePoints[0],locS.x,locE.x,locS.y,locE.z+wall.wallHeight*CL3DGlobalCacheUtil.Instance.sceneScaleRatio,.11,.11);
					locPos.setTo(trianglePoints[2].x,trianglePoints[2].y,0);
					tri1=matrix.transformVector(locPos);
					locPos.setTo(trianglePoints[1].x,trianglePoints[1].y,0);
					tri2=matrix.transformVector(locPos);
					locPos.setTo(trianglePoints[0].x,trianglePoints[0].y,0);
					tri3=matrix.transformVector(locPos);
					triangles.push(tri1.x,tri1.y,tri1.z,tri2.x,tri2.y,tri2.z,tri3.x,tri3.y,tri3.z);
					if(!start)
					{
						start=tri1;
					}
					if(tri1.x<start.x || tri1.y<start.y || tri1.z<start.z)
					{
						start=tri1;
					}
					if(tri2.x<start.x || tri2.y<start.y || tri2.z<start.z)
					{
						start=tri2;
					}
					if(tri3.x<start.x || tri3.y<start.y || tri3.z<start.z)
					{
						start=tri3;
					}
				}
				mesh=createPlanMeshBytriangles(triangles,matrix3D,start,material,ulength,vlength,true);
				mesh.name=meshName;
				mesh.calculateBoundBox();
			}
			else
			{
				roundPoints.push(end3D.x,end3D.y,end3D.z);
				roundPoints.push(start3D.x,start3D.y,start3D.z);
				roundPoints.push(start3D.x,start3D.y,start3D.z+wall.wallHeight*CL3DGlobalCacheUtil.Instance.sceneScaleRatio);
				roundPoints.push(end3D.x,end3D.y,end3D.z+wall.wallHeight*CL3DGlobalCacheUtil.Instance.sceneScaleRatio);
				mesh=buildMeshPlane(roundPoints,matrix3D,meshName,material,ulength,vlength);
			}
			return mesh;
		}
		private function doAmendPoint2D(point2D:*,minX:Number,maxX:Number,minY:Number,maxY:Number,offsetX:Number,offsetY:Number):void
		{
			if(CMathUtil.Instance.isEqual(point2D.x,minX,offsetX))
			{
				point2D.x=minX;
			}
			else if(CMathUtil.Instance.isEqual(point2D.x,maxX,offsetX))
			{
				point2D.x=maxX;
			}
			if(CMathUtil.Instance.isEqual(point2D.y,minY,offsetY))
			{
				point2D.y=minY;
			}
			else if(CMathUtil.Instance.isEqual(point2D.y,maxY,offsetY))
			{
				point2D.y=maxY;
			}
		}
		/**
		 * 计算3D闭合围点集合的包围盒 
		 * @param roundPoints
		 * @return BoundBox
		 * 
		 */		
		public function calculateBoundBox3D(roundPoints:Vector.<Number>):BoundBox
		{
			var result:BoundBox;
			var i:int,len:int;
			
			result=new BoundBox();
			len=roundPoints.length/3;
			for(i=0; i<len; i++)
			{
				if(result.maxX<roundPoints[i*3])
				{
					result.maxX=roundPoints[i*3];
				}
				if(result.minX>roundPoints[i*3])
				{
					result.minX=roundPoints[i*3];
				}
				if(result.maxY<roundPoints[i*3+1])
				{
					result.maxY=roundPoints[i*3+1];
				}
				if(result.minY>roundPoints[i*3+1])
				{
					result.minY=roundPoints[i*3+1];
				}
				if(result.maxZ<roundPoints[i*3+2])
				{
					result.maxZ=roundPoints[i*3+2];
				}
				if(result.minZ>roundPoints[i*3+2])
				{
					result.minZ=roundPoints[i*3+2];
				}
			}
			return result;
		}
		/**
		 * 获取两个区域组合后,共享部分的点集合 
		 * @param sourcePoints	源围点集合
		 * @param targetPoints	目标围点集合
		 * @return Vector.<Number>	两区域共享部分的点集合
		 * 
		 */		
		private function doGetCombineSharedPositionValues(sourcePoints:Vector.<Number>,targetPoints:Vector.<Number>):Vector.<Number>
		{
			var i:int,j:int,prev:int,next:int,slen:int,tlen:int;
			var start:Vector3D,end:Vector3D,tStart:Vector3D,tEnd:Vector3D;
			var intersectResult:Array;
			var dotValue:Number,zValue:Number;
			var noCombine:Boolean,hasSearched:Boolean;
			var result:Vector.<Number>;
			var intersectPoints:Array;
			var indices:Array;
			var startIndex:int;

			slen=sourcePoints.length/3;
			if(slen<2)
			{
				return null;
			}
			start=new Vector3D(sourcePoints[0],sourcePoints[1],0);
			end=new Vector3D(sourcePoints[(slen-1)*3],sourcePoints[(slen-1)*3+1],0);
			if(CMathUtilForAS.Instance.isEqualVector3D(start,end))
			{
				//起点与终点相同，无效数据不做计算，返回空
				return null;
			}
			result=new Vector.<Number>();
			intersectPoints=[];
			indices=[];
			zValue=sourcePoints[2];
			tlen=targetPoints.length/3;
			tStart=new Vector3D();
			tEnd=new Vector3D();
			noCombine=false;
			for(i=0; i<tlen; i++)
			{
				next=i==tlen-1?0:i+1;
				tStart.setTo(targetPoints[i*3],targetPoints[i*3+1],targetPoints[i*3+2]);
				tEnd.setTo(targetPoints[next*3],targetPoints[next*3+1],targetPoints[next*3+2]);
				intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(start,end,tStart,tEnd);
				if(!intersectResult)
				{
					continue;
				}
				if(intersectResult.length>2)
				{
					//起始点终点与目标共线,没有需要联合的点
					noCombine=true;
					break;
				}
				hasSearched=false;
				for(j=intersectPoints.length-1;j>=0;j--)
				{
					if(CMathUtilForAS.Instance.isEqualVector3D(intersectPoints[j],intersectResult[1]))
					{
						hasSearched=true;
						break;
					}
				}
				if(!hasSearched)
				{
					intersectPoints.push(intersectResult[1]);
					//交点如果与端点重合，必须选择墙体的起始点是交点的墙体围点索引
					if(CMathUtilForAS.Instance.isEqualVector3D(intersectResult[1],tEnd))
					{
						indices.push(next);
					}
					else
					{
						indices.push(i);
					}
				}
			}
			if(noCombine)
			{
				//返回起点坐标和终点坐标
				result.push(start.x,start.y,zValue,end.x,end.y,zValue);
				return result;
			}
			for(i=intersectPoints.length-1;i>=0;i--)
			{
				if(CMathUtilForAS.Instance.isEqualVector3D(intersectPoints[i],start))
				{
					//找到起点
					startIndex=indices[i];
					break;
				}
			}
			result.push(start.x,start.y,zValue);
			i=startIndex;
			while(true)
			{
				next=i==tlen-1?0:i+1;
				tStart.setTo(targetPoints[i*3],targetPoints[i*3+1],targetPoints[i*3+2]);
				tEnd.setTo(targetPoints[next*3],targetPoints[next*3+1],targetPoints[next*3+2]);
				dotValue=CMathUtilForAS.Instance.dotByPosition3D(end,tStart,tEnd,true);
				if(CMathUtil.Instance.isEqual(dotValue,-1) || CMathUtil.Instance.isEqual(dotValue,0))
				{
					result.push(end.x,end.y,zValue);
					break;
				}
				result.push(tEnd.x,tEnd.y,zValue);
				i=next;
			}
			return result;
		}
		private function doAddWallSideRoundPoint(wall:ICL3DWallExtension,verStart:Vector3D,verEnd:Vector3D,zValue:Number,outputInnerValues:Vector.<Number>,outputOutterValues:Vector.<Number>,isStart:Boolean):void
		{
			var intersectResult:Array;
			var index:int;
			
			index=isStart?0:1;
			intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(wall.innerRoundPoints[0],wall.innerRoundPoints[1],verStart,verEnd);
			if(intersectResult)
			{
				outputInnerValues.push(intersectResult[1].x,intersectResult[1].y,zValue);
			}
			else
			{
				outputInnerValues.push(wall.innerRoundPoints[index].x,wall.innerRoundPoints[index].y,zValue);
			}
			intersectResult=CMathUtilForAS.Instance.calculateSegment3DIntersect(wall.outterRoundPoints[0],wall.outterRoundPoints[1],verStart,verEnd);
			if(intersectResult)
			{
				outputOutterValues.unshift(intersectResult[1].x,intersectResult[1].y,zValue);
			}
			else
			{
				outputOutterValues.unshift(wall.outterRoundPoints[index].x,wall.outterRoundPoints[index].y,zValue);
			}
		}
		/**
		 * 通过墙体对象集合，计算并输出墙体边缘围点坐标集合 
		 * @param sourcePoints	墙线坐标数据
		 * @param wallMap	墙体对象图集
		 * @param outputInnerValues	输出的墙体内侧围点坐标集合
		 * @param outputOutterValues	输出的墙体外侧围点坐标集合
		 * 
		 */		
		private function doCalculateRoundPointsByWalls(sourcePoints:Vector.<Number>,wallMap:CHashMap,outputInnerValues:Vector.<Number>,outputOutterValues:Vector.<Number>):void
		{
			var i:int,len:int,next:int;
			var zValue:Number;
			var start:Vector3D,end:Vector3D,verStart:Vector3D,verEnd:Vector3D;
			var wall:ICL3DWallExtension;
			
			start=new Vector3D();
			end=new Vector3D();
			verStart=new Vector3D();
			verEnd=new Vector3D();
			len=sourcePoints.length/3;
			zValue=CMathUtil.Instance.amendInt(sourcePoints[2]);
			for(i=0; i<len-1; i++)
			{
				next=i==len-1?0:i+1;
				start.setTo(sourcePoints[i*3],sourcePoints[i*3+1],0);
				end.setTo(sourcePoints[next*3],sourcePoints[next*3+1],0);
				wall=pickedWallByWallPosition(start,end,wallMap);
				if(i==0)
				{
					verStart.setTo(start.x+wall.normal3D.x*int.MIN_VALUE,start.y+wall.normal3D.y*int.MIN_VALUE,start.z+wall.normal3D.z*int.MIN_VALUE);
					verEnd.setTo(start.x+wall.normal3D.x*int.MAX_VALUE,start.y+wall.normal3D.y*int.MAX_VALUE,start.z+wall.normal3D.z*int.MAX_VALUE);
					doAddWallSideRoundPoint(wall,verStart,verEnd,zValue,outputInnerValues,outputOutterValues,true);
				}
				verStart.setTo(end.x+wall.normal3D.x*int.MIN_VALUE,end.y+wall.normal3D.y*int.MIN_VALUE,end.z+wall.normal3D.z*int.MIN_VALUE);
				verEnd.setTo(end.x+wall.normal3D.x*int.MAX_VALUE,end.y+wall.normal3D.y*int.MAX_VALUE,end.z+wall.normal3D.z*int.MAX_VALUE);
				doAddWallSideRoundPoint(wall,verStart,verEnd,zValue,outputInnerValues,outputOutterValues,false);
			}
		}
		/**
		 * 根据模块类型，获取对应模块的主场景坐标系的转换矩阵 
		 * @param moduleType	模块类型
		 * @return Matrix3D
		 * 
		 */		
		public function getGlobalAxisMatrix3D(moduleType:int=0):Matrix3D
		{
			var result:Matrix3D;
			switch(moduleType)
			{
				case CL3DConstDict.MODULETYPE_DOORWINDOW:
				case CL3DConstDict.MODULETYPE_BUILDMESH:
					result=new Matrix3D(Vector.<Number>([1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1]));
					break;
				default:
					result=new Matrix3D(Vector.<Number>([1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1]));
					break;
			}
			return result;
		}
		/**
		 * 通过墙洞数据，创建墙洞边缘模型数组 
		 * @param innerHole
		 * @param outterHole
		 * @param material
		 * @param wMatrix
		 * @param wallThickness
		 * @param hideStart
		 * @param hideDir
		 * @return Array
		 * 
		 */		
		public function createWallRoundSideMeshesByWallHoles(innerHole:Vector.<Number>,outterHole:Vector.<Number>,material:Material,wallThickness:Number,hidePoints:Array,hideDir:Vector3D,mm2cm:Number):Array
		{
			var result:Array;
			var i:int,j:int,prev:int,next:int,len:int,index:int;
			var start:Vector3D,end:Vector3D,tmpPos:Vector3D,hidePos:Vector3D;
			var realPoints:Vector.<Number>,polyPoints:Vector.<Number>;
			var normal:Vector3D,vertical:Vector3D,direction:Vector3D;
			var mesh:Mesh;
			var axisMatrix:Matrix3D;
			var isSearched:Boolean;
			
			axisMatrix=new Matrix3D();
			direction=new Vector3D();
			normal=new Vector3D();
			vertical=new Vector3D();
			realPoints=new Vector.<Number>();
			polyPoints=new Vector.<Number>();
			tmpPos=new Vector3D();
			result=[];

			len=innerHole.length/3;
			start=new Vector3D();
			end=new Vector3D();
			for(i=0; i<len; i++)
			{
				next=i==len-1?0:i+1;
				start.setTo(innerHole[i*3],innerHole[i*3+1],innerHole[i*3+2]);
				end.setTo(innerHole[next*3],innerHole[next*3+1],innerHole[next*3+2]);
				direction.setTo(end.x-start.x,end.y-start.y,end.z-start.z);
				direction.normalize();
				isSearched=false;
				for(j=hidePoints.length-1;j>=0;j--)
				{
					//查找需要隐藏的面
					if(CMathUtil.Instance.isEqual(Math.abs(hideDir.dotProduct(direction)),1))
					{
						//放向相似
						if((CMathUtil.Instance.isEqual(start.x,hidePoints[j].x,wallThickness*.5) && CMathUtil.Instance.isEqual(start.y,hidePoints[j].y,wallThickness*.5)) || 
							(CMathUtil.Instance.isEqual(end.x,hidePoints[j].x,wallThickness*.5) && CMathUtil.Instance.isEqual(end.y,hidePoints[j].y,wallThickness*.5)))
						{
							isSearched=true;
						}
					}
				}
				if(isSearched)
				{
					//起点或者终点相同
					continue;
				}
				polyPoints.length=0;
				polyPoints.push(innerHole[i*3]*mm2cm,innerHole[i*3+1]*mm2cm,innerHole[i*3+2]*mm2cm);
				polyPoints.push(innerHole[next*3]*mm2cm,innerHole[next*3+1]*mm2cm,innerHole[next*3+2]*mm2cm);
				polyPoints.push(outterHole[next*3]*mm2cm,outterHole[next*3+1]*mm2cm,outterHole[next*3+2]*mm2cm);
				polyPoints.push(outterHole[i*3]*mm2cm,outterHole[i*3+1]*mm2cm,outterHole[i*3+2]*mm2cm);
				vertical.setTo(outterHole[next*3]-innerHole[next*3],outterHole[next*3+1]-innerHole[next*3+1],outterHole[next*3+2]-innerHole[next*3+2]);
				vertical.normalize();
				normal=direction.crossProduct(vertical);
				normal.w=0;
				normal.normalize();
				CMathUtilForAS.Instance.amendRoundPoint3Ds(polyPoints,normal);
				axisMatrix.copyColumnFrom(0,direction);
				axisMatrix.copyColumnFrom(1,vertical);
				axisMatrix.copyColumnFrom(2,normal);
				mesh=buildMeshPlane(polyPoints,axisMatrix,CL3DConstDict.TYPE_WINDOWWALLGAP_IN,material,100,100);
				result.push(mesh);
			}
			return result;
		}
		/**
		 * 创建墙体边缘模型数组(旧方法)
		 * @return Array
		 * 
		 */		
		public function createWallEdgeMeshes(regionPoints:Array,deep:Vector3D,material:Material,wMatrix:Matrix3D,offset:Number,hideStart:Vector3D=null,hideDir:Vector3D=null):Array
		{
			var result:Array;
			var i:int,prev:int,next:int,len:int;
			var start:Vector3D,end:Vector3D,tmpPos:Vector3D,hidePos:Vector3D;
			var realPoints:Vector.<Number>,polyPoints:Vector.<Number>;
			var normal:Vector3D,vertical:Vector3D,direction:Vector3D;
			var mesh:Mesh;
			var axisMatrix:Matrix3D;
			var minX:Number=int.MIN_VALUE;
			var deepLength:Number;
			
			axisMatrix=new Matrix3D();
			direction=new Vector3D();
			normal=new Vector3D();
			realPoints=new Vector.<Number>();
			polyPoints=new Vector.<Number>();
			tmpPos=new Vector3D();
			result=[];
			deepLength=deep.length;
			normal=deep.clone();
			normal.normalize();
			len=regionPoints.length;
			//转换区域围点数据为世界坐标系
			if(!isNewSystem && hideStart==null)
			{
				minX=int.MAX_VALUE;
				for(i=0; i<len; i++)
				{
					if(minX>regionPoints[i].x)
					{
						minX=regionPoints[i].x;
					}
				}
				for(i=0;i<len;i++)
				{
					if(CMathUtil.Instance.isEqual(regionPoints[i].x,minX))
					{
						regionPoints[i].x-=offset;
					}
					else
					{
						regionPoints[i].x+=offset;
					}
					tmpPos.setTo(regionPoints[i].x,0,0);
					start=wMatrix.transformVector(tmpPos);
					start.z=regionPoints[i].y;
					realPoints.push(start.x,start.y,start.z);
				}
			}
			else
			{
				for(i=0;i<len;i++)
				{
					tmpPos.setTo(regionPoints[i].x,0,0);
					start=wMatrix.transformVector(tmpPos);
					start.z=regionPoints[i].y;
					realPoints.push(start.x,start.y,start.z);
				}
			}
			CMathUtilForAS.Instance.amendRoundPoint3Ds(realPoints,normal);
			var index:int=-1;
			len=realPoints.length/3;
			start=new Vector3D();
			end=new Vector3D();
			for(i=0; i<len; i++)
			{
				next=i==len-1?0:i+1;
				start.setTo(realPoints[i*3],realPoints[i*3+1],realPoints[i*3+2]);
				end.setTo(realPoints[next*3],realPoints[next*3+1],realPoints[next*3+2]);
				direction.setTo(end.x-start.x,end.y-start.y,end.z-start.z);
				direction.normalize();
				if(hideStart!=null)
				{
					//查找需要隐藏的面
					if(CMathUtil.Instance.isEqual(Math.abs(hideDir.dotProduct(direction)),1))
					{
						//放向相似
						if((CMathUtil.Instance.isEqual(start.x,hideStart.x,deepLength*.5) && CMathUtil.Instance.isEqual(start.y,hideStart.y,deepLength*.5)) || 
							(CMathUtil.Instance.isEqual(end.x,hideStart.x,deepLength*.5) && CMathUtil.Instance.isEqual(end.y,hideStart.y,deepLength*.5)))
						{
							//起点或者终点相同
							continue;
						}
					}
				}
				vertical=direction.crossProduct(deep);
				vertical.w=0;
				vertical.negate();
				vertical.normalize();
				polyPoints.length=0;
				polyPoints.push(start.x,start.y,start.z);
				polyPoints.push(end.x,end.y,end.z);
				polyPoints.push(end.x+deep.x,end.y+deep.y,end.z+deep.z);
				polyPoints.push(start.x+deep.x,start.y+deep.y,start.z+deep.z);
				CMathUtilForAS.Instance.amendRoundPoint3Ds(polyPoints,vertical);
				normal=vertical.crossProduct(direction);
				normal.w=0;
				normal.normalize();
				axisMatrix.copyColumnFrom(0,direction);
				axisMatrix.copyColumnFrom(1,normal);
				axisMatrix.copyColumnFrom(2,vertical);
				mesh=buildMeshPlane(polyPoints,axisMatrix,CL3DConstDict.TYPE_WINDOWWALLGAP_IN,material,100,100);
				result.push(mesh);
			}
			return result;
		}
//		/**
//		 * 通过墙体位置坐标值集合，获取对应墙体一侧的相关位置集合 
//		 * @param sourceWall3DPositions	墙体位置源数据集合
//		 * @param wallMap		墙体数据图集
//		 * @param matrix		坐标系矩阵
//		 * @param isWallInner	是否获取内墙一侧的位置
//		 * @return Vector.<Number>
//		 * 
//		 */		
//		private function doGetWallSidePointsByWallPositions(sourceWall3DPositions:Vector.<Number>,wallMap:CHashMap,matrix:Matrix3D,isWallInner:Boolean):Vector.<Number>
//		{
////			var start:Vector3D,end:Vector3D,dir:Vector3D,nor:Vector3D,vertical:Vector3D;
////			var i:int,next:int,len:int;
//			var result:Vector.<Number>;
////			var tmpPos:Vector3D;
////			var targetWall:ICL3DWallExtension;
////			var sideRoundPoints:Vector.<Vector3D>;
////			var projectResult:
////			
////			result=new Vector.<Number>();
////			start=new Vector3D();
////			end=new Vector3D();
////			dir=new Vector3D();
////			nor=new Vector3D();
////			matrix.copyColumnTo(2,nor);
////			len=sourceWall3DPositions.length/3-1;
////			for(i=0; i<len; i++)
////			{
////				next=i==len?0:i+1;
////				start.setTo(result[i*3],result[i*3+1],result[i*3+2]);
////				end.setTo(result[next*3],result[next*3+1],result[next*3+2]);
////				targetWall=pickedWallByWallPosition(start,end,wallMap);
////				sideRoundPoints=isWallInner?targetWall.innerRoundPoints:targetWall.outterRoundPoints;
////				
//////				dir.setTo(result[next*3]-result[i*3],result[next*3+1]-result[i*3+1],result[next*3+2]-result[i*3+2]);
//////				dir.normalize();
//////				vertical=nor.crossProduct(dir);
//////				originPos.setTo(result[i*3],result[i*3+1],result[i*3+2]);
//////				doSearchTargetWall(originPos,dir,vertical,wallMap,i,result);
//////				originPos.setTo(result[next*3],result[next*3+1],result[next*3+2]);
//////				doSearchTargetWall(originPos,dir,vertical,wallMap,next,result);
////			}
//			return result;
//		}
		/**
		 * 计算参数化模型家具的共享围点数据 
		 * @param railPoints
		 * @param unitFloorPolys
		 * @param wallMap
		 * @param normal
		 * @param hasRoom
		 * @return Object	共享围点数据，属性有：innerPoints共享内围点集合，outterPoints共享外围点集合，unionPoints补充点集合，sharedPoints共享围点集合，finalPoints最终参数化家具地面投影围点集合;
		 * 
		 */		
		public function calculateParamBuildingSharedRoundPointsData(railPoints:Vector.<Vector3D>,unitFloorPolys:Vector.<Poly>,wallMap:CHashMap,normal:Vector3D):Object
		{
			var innerSharedValues:Vector.<Number>,outterSharedValues:Vector.<Number>,drawPoints:Vector.<Number>,wallPoints:Vector.<Number>,combinePoints:Vector.<Number>;
			var unionPoints:Vector.<Vector3D>;
			var obj:Object;
			var i:int,j:int,len:int;
			var linkedWalls:Vector.<ICL3DWallExtension>;
			var linkedWall:ICL3DWallExtension;
			var hasSearched:Boolean;
			var start:Vector3D,end:Vector3D,railPoint:Vector3D;
			var height:Number;
			var hasRoom:Boolean;
			
			innerSharedValues=new Vector.<Number>();
			outterSharedValues=new Vector.<Number>();
			obj={};
			if(CL3DModuleUtil.Instance.isNewSystem)
			{
				start=railPoints[0].clone();
				end=railPoints[railPoints.length-1].clone();
				drawPoints=CMathUtilForAS.Instance.change2NumberVector(railPoints,railPoints.length,3);
				linkedWalls=getLinkedWalls(start,end,drawPoints,wallMap);
				if(linkedWalls && linkedWalls.length)
				{
					doCalculateAddedRoundPointsByLinkedWalls(linkedWalls,drawPoints,start,end,innerSharedValues,outterSharedValues);
					CMathUtilForAS.Instance.revertNumberVerctor(innerSharedValues,3,false);
					unionPoints=CMathUtilForAS.Instance.change2Vector3Ds(innerSharedValues,3);
					obj.innerPoints=unionPoints.concat();
					obj.outterPoints=CMathUtilForAS.Instance.change2Vector3Ds(outterSharedValues,3);
				}
			}
			if(obj.innerPoints)
			{
				obj.sharedPoints=innerSharedValues;
				unionPoints.shift();
				unionPoints.pop();
				obj.finalPoints=railPoints.concat(unionPoints);
			}
			else
			{
				obj.finalPoints=railPoints;
			}
			return obj;
		}
		
		/**
		 * 遍历场景中线条数据节点  
		 * @param lineNodeMap	线条节点集合
		 * @param func	回调方法
		 * @param params	回调参数
		 * @return Boolean	是否发生中断
		 * 
		 */		
		public function mapSceneLineNode(lineNodeMap:CHashMap,callbackFunc:Function,...callbackParams):Boolean
		{
			var i:int,j:int;
			var keys:Array;
			var groupLines:Vector.<CTreeNode>;
			var callbackParams:Array;
			var isBroken:Boolean;
			
			callbackParams=callbackParams==null?[]:callbackParams.concat();
			callbackParams.unshift(null);
			keys=lineNodeMap.keys;
			for(i=keys.length-1;i>=0;i--)
			{
				groupLines=lineNodeMap.get(keys[i]) as Vector.<CTreeNode>;
				if(groupLines==null)
				{
					continue;
				}
				for(j=groupLines.length-1;j>=0;j--)
				{
					callbackParams[0]=groupLines[j];
					isBroken=callbackFunc.apply(null,callbackParams)
					if(isBroken)
					{
						return true;
					}
				}
			}
			return false;
		}
		/**
		 * 获取墙角数据对象 
		 * @param first		第一面墙体
		 * @param second	第二面墙体
		 * @return Object		墙角数据对象
		 * 
		 */		
		public function getWallCornerObj(firstWall:ICL3DWallExtension,secondWall:ICL3DWallExtension,firstLength:Number,secondLength:Number):Object
		{
			var obj:Object;
			var tmpDir:Vector3D;
			var angle:Number;
			var cross:Vector3D;
			var sizeObjArr:Array;

			cross=new Vector3D();
			obj={};
			obj.linkedWall1=firstWall;
			obj.linkedWall2=secondWall;
			obj.length1=firstLength;
			obj.length2=secondLength;
			CMathUtilForAS.Instance.crossByVector3D(firstWall.direction3D,secondWall.direction3D,cross);
			if(firstWall.nextWall!=secondWall)
			{
				//拣选方向与墙体方向不一致
				obj.corner=firstWall.start3D.clone();
				obj.isCancave=cross.z>0?true:false;
				tmpDir=firstWall.direction3D.clone();
				tmpDir.negate();
				obj.dir1=tmpDir;
				tmpDir=secondWall.direction3D.clone();
				tmpDir.negate();
				obj.dir2=tmpDir;
				obj.angle=-CMathUtil.Instance.toDegrees(Math.acos(obj.dir1.dotProduct(obj.dir2)));
			}
			else
			{
				//拣选方向与墙体方向一致
				obj.isCancave=cross.z<0?true:false;
				obj.corner=firstWall.end3D.clone();
				tmpDir=firstWall.direction3D.clone();
				obj.dir1=tmpDir;
				tmpDir=secondWall.direction3D.clone();
				obj.dir2=tmpDir;
				obj.angle=CMathUtil.Instance.toDegrees(Math.acos(obj.dir1.dotProduct(obj.dir2)));
			}
			if(obj.isCancave)
			{
				obj.angle=-obj.angle;
			}
			return obj;
		}
	}
}