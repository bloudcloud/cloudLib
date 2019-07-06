package extension.cloud.dict
{
	/**
	 * 业务模块事件类
	 * @author	cloud
	 * @date	2018-6-4
	 */
	public class CL3DEventTypeDict
	{
		/**
		 * 下载商品信息队列的事件结束类型 
		 */		
		public static const LOAD_L3DMATERIALINFO_QUEUE_COMPLETE:String = "loadL3DMaterialInfoQueueComplete";
		/**
		 * 护墙板显示模式发生改变 
		 */		 
		public static const CHANGE_WEATHERBOARD_VTYPE:String = "weatherboardVTypeChanged";
		/**
		 * 房间层高发生改变 
		 */		
		public static const CHANGE_ROOMHEIGHT:String="roomHeightChanged";
		
		/**
		 * 房间离地高发生改变 
		 */		
		public static const CHANGE_ROOMOFFGROUND:String="roomOffGroundChanged";
		
		/**
		 * 设置一个墙洞 
		 */		
		public static const SET_WALLHOLE:String="setWallHole";
		
		/**
		 * 家具内的所有模型下载完成
		 */		
		public static const LOADCOMPLETE_ALLMESHES_INFURNITURE:String="loadAllMeshesInFurnitureComplete";
		
		/**
		 *  斜墙编辑界面的角度发生改变
		 */		
		public static const UPDATE_OBLIQUEWALLEDIT:String = "obliqueWallEditUpdated";
		/**
		 * 斜墙编辑界面的确定按钮被点击 
		 */		
		public static const CONFIRM_OBLIQUEWALL:String = "obliqueWallConfirmed";
		/**
		 * 关闭事件 
		 */		
		public static const CLOSE_POPBAR:String = "popbarClosed";
	}
}