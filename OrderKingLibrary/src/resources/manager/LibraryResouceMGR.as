package resources.manager
{
	import core.HashMap;
	import core.a3d.CTextureResource;
	import core.a3d.ICNameResource;
	import core.datas.L3DMaterialInformations;
	

	public class LibraryResouceMGR
	{
		/**小图系列*/
		private var _informationMap:HashMap;
		private var _urlsMap:HashMap;
		private var _a3dResourceMap:HashMap;
		private var _classMap:HashMap;

		public function LibraryResouceMGR()
		{
			_informationMap=new HashMap();
			_urlsMap=new HashMap();
			_a3dResourceMap=new HashMap();
		}

		/**
		 * 节点ID和URLS
		 * @param nodeID
		 * @param urls
		 */
		public function addURLs(nodeID:String, urls:Array):void
		{
			_urlsMap.add(nodeID, urls);
		}

		public function getURLs(nodeID:String):Array
		{
			return _urlsMap.getValue(nodeID) as Array;
		}

		public function hasURLs(nodeID:String):Boolean
		{
			return _urlsMap.hasKey(nodeID);
		}

		public function removeURLs(nodeID:String):Boolean
		{
			return _urlsMap.remove(nodeID);
		}

		/**
		 * 根据URL得到L3DMaterialInformations，主要用于右边框批量加载节点ID的分页
		 * @param url
		 * @param information
		 */
		public function addInformationURL(url:String, information:L3DMaterialInformations, coverage:Boolean=false):void
		{
			addInformation(url, information, coverage);
		}

		/**
		 * 根据Code得到L3DMaterialInformations，主要用于单独加载（大图片，XML）
		 * @param code
		 * @param information
		 */
		public function addInformationCode(code:String, information:L3DMaterialInformations, coverage:Boolean=false):void
		{
			addInformation(code, information, coverage);
		}

		public function addInformation(value:String, information:L3DMaterialInformations, coverage:Boolean=false):void
		{
			if (coverage || !_informationMap.hasKey(value))
			{
				_informationMap.add(value, information);
			}
		}
		/**
		 * 查询有无URL或Code
		 * @param value
		 * @return 
		 */		
		public function hasInformation(value:String):Boolean
		{
			return _informationMap.hasKey(value);
		}
		/**
		 * 根据URL或者Code取得L3DMaterialInformations
		 * @param value
		 * @return
		 */
		public function getInformation(value:String):L3DMaterialInformations
		{
			return _informationMap.getValue(value) as L3DMaterialInformations;
		}
		/**
		 * 根据URL或者Code移除L3DmaterialInformations
		 * @param value
		 * @return 
		 */		
		public function removeInformation(value:String):Boolean
		{
			return _informationMap.remove(value);
		}
		/**
		 * 添加A3D资源对象 
		 * @param key
		 * @param resource
		 * 
		 */		
		public function addA3DResource(key:String,resource:ICNameResource):void
		{
			var result:ICNameResource=_a3dResourceMap.add(key,resource) as ICNameResource;
			if(result && result != resource)
			{
				resource.refCount=result.refCount;
				result.refCount=0;
				result.clear();
			}
			resource.refCount++;
		}
		/**
		 * 根据键值获取A3D资源对象 
		 * @param key
		 * @return ICResource
		 * 
		 */		
		public function getResource(key:String):ICNameResource
		{
			var resource:ICNameResource=_a3dResourceMap.getValue(key) as ICNameResource;
			if(resource)
				resource.refCount++;
			return resource;
		}
		/**
		 * 移除A3D资源
		 * @param resource
		 * 
		 */
		public function removeResource(resource:ICNameResource):void
		{
			_a3dResourceMap.remove(resource.mark);
		}
		/**
		 * 注册类缓存
		 * @param key
		 * @param cls
		 * 
		 */		
		public function registClass(key:String,cls:Class):void
		{
			if(!_classMap.hasKey(key))
			{
				_classMap.add(key,cls);
			}
		}
		/**
		 * 移除类缓存
		 * @param key
		 * 
		 */		
		public function unregistClass(key:String):void
		{
			if(_classMap.hasKey(key))
			{
				_classMap.remove(key);
			}
		}
		/**
		 * 根据关键字获取类 
		 * @param key
		 * @return Class
		 * 
		 */		
		public function getClassByKey(key:String):Class
		{
			return _classMap.getValue(key) as Class;
		}
		/**
		 * 释放不使用的GPU显存
		 * 
		 */		
		public function disposeGPURAM():void
		{
			var keys:Array=_a3dResourceMap.getAllKey();
			var i:int=keys.length-1;
			var resource:CTextureResource;
			for(;i>0;i--)
			{
				resource=_a3dResourceMap.getValue(keys[i]) as CTextureResource;
				if(resource && resource.refCount<=0)
				{
					resource.refCount=0;
					resource.dispose();
				}
			}
		}
	}
}
