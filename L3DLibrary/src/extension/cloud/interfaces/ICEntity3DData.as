package extension.cloud.interfaces
{
	import flash.geom.Vector3D;
	
	import cloud.core.datas.base.CBoundBox;
	import cloud.core.datas.base.CTransform3D;
	
	/**
	 * 3D实体对象数据接口
	 * @author	cloud
	 * @date	2018-7-21
	 */
	public interface ICEntity3DData
	{
		/**
		 * 设置3D截面围点坐标值集合（以轮廓底部中心点为坐标原点)
		 * @param value
		 * 
		 */		
		function set roundPoint3DValues(value:Vector.<Number>):void;
		/**
		 * 设置外轮廓3D包围盒 
		 * @param value
		 * 
		 */		
		function set outline3DBox(value:CBoundBox):void;
		/**
		 * 设置3D线性变换对象（不带缩放值）
		 * @param box	包围盒对象
		 * 
		 */		
		function set transform(value:CTransform3D):void;
	}
}