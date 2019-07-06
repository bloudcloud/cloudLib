package utils.lx.managers
{
	import L3DLibrary.L3DMaterialInformations;
	
	import cores.HashMap;
	
	import extension.cloud.a3d.resources.CTextureResource;
	

	public class LibraryResouceMGR
	{
		/**
		 * 商品信息 
		 */		
		private var _informationMap:HashMap;
		/**
		 * 预览图 
		 */		
		private var _previewMap:HashMap;
		/**
		 * 节点 
		 */		
		private var _urlsMap:HashMap;

		public function LibraryResouceMGR()
		{
			_informationMap=new HashMap();
			_previewMap=new HashMap();
			_urlsMap=new HashMap();
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
			return _urlsMap.removeKey(nodeID);
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

		public function addInformation(key:String, information:L3DMaterialInformations, coverage:Boolean=false):void
		{
			if(_informationMap.hasKey(key) && coverage)
			{
				var info:L3DMaterialInformations=_informationMap.removeKey(key);
				info.Dispose(true);
			}
			_informationMap.add(key, information);
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
			return _informationMap.removeKey(value);
		}
		
//		public function addPreview(key:String,preview:BitmapData):void
//		{
//			if(!_previewMap.hasKey(key))
//			{
//				_previewMap.add(key, preview);
//			}
//		}
//		
//		public function getPreview(key:String):BitmapData
//		{
//			return _previewMap
//		}
		/**
		 * 释放GPU内存 
		 * 
		 */		
		public function disposeGPURAM():void
		{
			var keys:Array=_informationMap.getAllKey();
			var i:int=keys.length-1;
			var tex:CTextureResource;
			for(;i>0;i--)
			{
				tex=_informationMap.getValue(keys[i]) as CTextureResource;
				if(tex && tex.refCount<=0)
				{
					tex.dispose();
				}
			}
		}
	}
}
