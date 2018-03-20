package utils
{
	import core.datas.L3DMaterialInformations;
	
	import resources.manager.GlobalManager;

	/**
	 * 
	 * @author cloud
	 * @2018-3-16
	 */
	public class OKResourceUtil
	{
		private static var _Instance:OKResourceUtil;
		
		public static function get Instance():OKResourceUtil
		{
			return _Instance ||= new OKResourceUtil();
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
			else if(code && code.length>0 && isNaN(Number(code)))
			{
				result=GlobalManager.Instance.resourceMGR.getInformation(code);
				if(!result)
				{
					GlobalManager.Instance.loaderMGR.addInformationByCode(code,successCallback,faultCallback,rpcType);
				}
			}
			
			return result;
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
	}
}