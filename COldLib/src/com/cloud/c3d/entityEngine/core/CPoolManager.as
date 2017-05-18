package com.cloud.c3d.entityEngine.core
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	/**
	 * ClassName: package com.cloud.entityEngine.core::Pool
	 *
	 * Intro:
	 *
	 * @date: 2014-8-5
	 * @autor: cloud
	 * @languageVersion: 3.0
	 * @playerVersion: FlashPlayer14
	 * @sdkVersion: AIR14.0
	 */
	public class CPoolManager
	{
		private static var _instance:CPoolManager;

		public static function get instance():CPoolManager
		{
			return _instance ||= new CPoolManager(new SingletonEnforce());
		}

		private const constructedFuncs:Array = [
			function(k:Class,p:Array):*{ return new k(p[0]);}
			,function(k:Class,p:Array):*{ return new k(p[0],p[1]);}
			,function(k:Class,p:Array):*{ return new k(p[0],p[1],p[2]);}
			,function(k:Class,p:Array):*{ return new k(p[0],p[1],p[2],p[3]);}
			,function(k:Class,p:Array):*{ return new k(p[0],p[1],p[2],p[3],p[4]);}
			,function(k:Class,p:Array):*{ return new k(p[0],p[1],p[2],p[3],p[4],p[5]);}
			,function(k:Class,p:Array):*{ return new k(p[0],p[1],p[2],p[3],p[4],p[5],p[6]);}
			,function(k:Class,p:Array):*{ return new k(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7]);}
			,function(k:Class,p:Array):*{ return new k(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8]);}
			,function(k:Class,p:Array):*{ return new k(p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7],p[8],p[9]);}
		];
		private var objDic:Dictionary;
		
		public function CPoolManager(enforcer:SingletonEnforce)
		{
			objDic = new Dictionary();
		}
		/**
		 * 入池 
		 * @param cls	类名
		 * @param obj	类对象
		 * 
		 */		
		public function push(cls:*,obj:*):void
		{
			if(objDic[cls] == null)
				objDic[cls] = new Array();
			objDic[cls].push(obj);
		}
		/**
		 * 出池 
		 * @param cls	类名
		 * @param params	类对象
		 * @return *
		 * 
		 */		
		public function pop(cls:*,...params):*
		{
			var clsRef:Class,obj:*;
			if(cls is String)
				clsRef = getDefinitionByName(cls) as Class;
			else if(cls is Class)
				clsRef = cls as Class;
			else 
			 	return null;
			if(objDic[clsRef] == null)
				objDic[clsRef] = new Array();
			if(objDic[clsRef].length == 0)
			{
				if(!params || params.length == 0)
					obj = new clsRef();
				else
					obj = constructedFuncs[params.length-1].apply(null,[clsRef,params]);
			}
			else
			{
				obj = objDic[clsRef].pop();
			}
			return obj;	
		}
		
		public function clearAll():void
		{
			var arr:Array;
			for (var key:* in objDic)
			{
				objDic[key]
			}
		}
	}
}
class SingletonEnforce{}