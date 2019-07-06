package extension.cloud.singles
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import extension.cloud.interfaces.ICL3DFloorExtension;
	import extension.cloud.interfaces.ICL3DWallExtension;
	import extension.cloud.mvcs.base.CBaseL3DConfig;
	import extension.cloud.mvcs.base.CMVCSGlobalConfig;
	import extension.cloud.mvcs.base.command.CL3DCommandEvent;
	import extension.cloud.mvcs.base.model.CBaseL3DData;
	
	import ns.cloud_lejia;
	
	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;

	use namespace cloud_lejia;
	/**
	 * 业务MVCS框架管理类
	 * @author	cloud
	 * @date	2018-6-26
	 */
	public class CMVCSManager
	{
		private static var _Instance:CMVCSManager
		/**
		 * 获取业务MVCS框架管理类唯一实例
		 * @return CMVCSManager
		 */
		cloud_lejia static function get Instance():CMVCSManager
		{
			return _Instance||=new CMVCSManager(new SingletonEnforce());
		}
		
		private var _context:IContext;
		private var _configs:Array;
		private var _changedFloors:Array;

		/**
		 * 
		 * @param enforcer
		 */
		public function CMVCSManager(enforcer:SingletonEnforce)
		{
			_configs=[CMVCSGlobalConfig];
			_context = new Context();
			CL3DClassFactory.Instance.registClassRef("CBaseL3DData",CBaseL3DData);
			
		}
		
		private function onDestoryMVCS(evt:Event):void
		{
			evt.target.removeEventListener(evt.type,onDestoryMVCS);
			for(var i:int=_configs.length-1; i>=0; i--)
			{
				(_context.injector.getInstance(_configs[i]) as CBaseL3DConfig).destroyServices();
			}
		}

		public function dispatchMVCSEvent(evt:CL3DCommandEvent):void
		{
			_context.dispatchEvent(evt);
		}
		/**
		 * 安装配置对象 
		 * @param config
		 * 
		 */		
		public function addConfig(configClass:Class):void
		{
			var index:int=_configs.indexOf(configClass);
			if(index<0)
			{
				_configs.push(configClass);
			}
		}
		/**
		 * 卸载配置对象 
		 * 
		 */		
		public function removeConfig(configClass:Class):void
		{
			var config:CBaseL3DConfig;
			var index:int=_configs.indexOf(configClass);
			
			if(index>=0)
			{
				config=_context.injector.getInstance(_configs[index]) as CBaseL3DConfig;
				config.destroyServices();
				_context.injector.unmap(_configs[index]);
				_configs.removeAt(0);
			}
		}
		/**
		 * 通过主界面启动MVCS框架
		 * @param contextView
		 * 
		 */		
		public function start(contextView:DisplayObjectContainer):void
		{
			_context=_context.install(MVCSBundle);
			_context=_context.configure.apply(contextView,_configs);
			_context=_context.configure(new ContextView(contextView));
			
			contextView.addEventListener(Event.REMOVED_FROM_STAGE,onDestoryMVCS);
		}
		
		/**
		 * 创建墙线数据
		 * @param start2DPoint
		 * @param end2DPoint
		 * 
		 */		
		public function createWallLineData(start2DPoint:Vector3D,end2DPoint:Vector3D,sceneKey:String):void
		{
			_context.dispatchEvent(new CL3DCommandEvent(CL3DCommandEvent.EVENT_DRAW_WALLLINE,{start2D:start2DPoint,end2D:end2DPoint,sceneKey:sceneKey}));
		}
		/**
		 * 创建场景地面
		 * @param roundPoints	地面围点集合
		 * @param sceneKey	地面所在场景标记
		 * @param floorUrl	地面地面的纹理url
		 * @param roomType	地面所属房间的类型
		 * @param floorID		地面的ID
		 * @param roomID	所属房间的ID
		 * 
		 */		
		public function createSceneRoom(roundPoints:Vector.<Number>,sceneKey:String,floorUrl:String,roomType:int,floorID:String,roomID:String):void
		{
			_context.dispatchEvent(new CL3DCommandEvent(CL3DCommandEvent.EVENT_DRAW_ROOM,{roundPoints:roundPoints,sceneKey:sceneKey,floorUrl:floorUrl,roomType:roomType,floorID:floorID,roomID:roomID}));
		}
		/**
		 * 移除地面对象 
		 * @param floor
		 * 
		 */		
		public function removeFloor(floor:ICL3DFloorExtension,sceneKey:String,isClearWall:Boolean=false):void
		{
			_context.dispatchEvent(new CL3DCommandEvent(CL3DCommandEvent.EVENT_REMOVE_FLOORDATA,{floorID:floor.floorID,roomID:floor.roomID,sceneKey:sceneKey,isClearWall:isClearWall}));
		}
		/**
		 * 移除墙体对象
		 * @param wall
		 * 
		 */		
		public function removeWall(wall:ICL3DWallExtension):void
		{
			var start3D:Vector3D=wall.start3D;
			var end3D:Vector3D=wall.end3D;
			var sceneKey:String=wall.start3D.z.toString();
			_context.dispatchEvent(new CL3DCommandEvent(CL3DCommandEvent.EVENT_REMOVE_WALLDATA,{start3D:start3D,end3D:end3D,sceneKey:sceneKey}));
		}
		/**
		 * 更新墙线 
		 * @param sceneKey	场景键值
		 * @param lineDatas		墙线数据集合
		 * 
		 */	
		public function updateWallLineDatas(line3DDatas:Array,sceneKey:String):void
		{
			_context.dispatchEvent(new CL3DCommandEvent(CL3DCommandEvent.EVENT_UPDATE_WALLINE,{sceneKey:sceneKey,line3DDatas:line3DDatas}));
		}
		
		public function sendLineMark(start3D:Vector3D,end3D:Vector3D):void
		{
			_context.dispatchEvent(new CL3DCommandEvent(CL3DCommandEvent.EVENT_SEND_LINEMARK,{start3D:start3D,end3D:end3D}));
		}
//		public function createScenePolyData(polyPoints:Array):void
//		{
//			_context.dispatchEvent(new CL3DCommandEvent(CL3DCommandEvent.EVENT_DRAW_SCENEPOLY,polyPoints));
//		}
		public function clearScene():void
		{
			_context.dispatchEvent(new CL3DCommandEvent(CL3DCommandEvent.EVENT_CLEAR_SCENE));
		}
		/**
		 * 添加通知监听 
		 * @param type
		 * @param listener
		 * 
		 */	
		public function addNotifyListener(type:String,listener:Function):void
		{
			_context.addEventListener(type,listener);
		}
		/**
		 * 移除通知监听 
		 * @param type
		 * @param listener
		 * 
		 */		
		public function removeNotifyListener(type:String,listener:Function):void
		{
			_context.removeEventListener(type,listener);
		}
	}
}
