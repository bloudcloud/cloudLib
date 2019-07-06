package extension.cloud.interfaces
{
	import flash.geom.Vector3D;
	
	import L3DLibrary.L3DMaterialInformations;

	/**
	 * 业务家具扩展接口
	 * @author	cloud
	 * @date	2018-7-5
	 */
	public interface ICL3DFurnitureExtension
	{
		/**
		 * 家具唯一ID 
		 * @return String
		 * 
		 */		
		function get FurnitureID():String;
		/**
		 * 家具类别 
		 * @return int 
		 * 
		 */		
		function get Catalog():int;
		/**
		 *	获取是否属于裁切源的家具 
		 * @return Boolean
		 * 
		 */		
		function get IsPolyMode():Boolean;
		/**
		 * 设置是否属于裁切源的家具 
		 * @param v
		 * 
		 */		
		function set IsPolyMode(v:Boolean):void;
		/**
		 * 获取家具模型 
		 * @return L3DMesh
		 * 
		 */		
		function get mesh():L3DMesh;
		/**
		 * 设置家具模型 
		 * @param value
		 * 
		 */		
		function set mesh(value:L3DMesh):void;
		/**
		 * 获取材质信息 
		 * @return L3DMaterialInformations
		 * 
		 */		
		function get MaterialInfo():L3DMaterialInformations;
		/**
		 * 设置材质信息 
		 * @param value
		 * 
		 */		
		function set MaterialInfo(value:L3DMaterialInformations):void;
		/**
		 * 获取家具的中心点X坐标值 
		 * @return Number
		 * 
		 */		
		function get centerX():Number;
		/**
		 * 设置家具的中心点X坐标值 
		 * @param value
		 * 
		 */		
		function set centerX(value:Number):void;
		/**
		 * 获取家具的中心点Y坐标值 
		 * @return Number
		 * 
		 */	
		function get centerY():Number;
		/**
		 * 设置家具的中心点Y坐标值 
		 * @param value
		 * 
		 */		
		function set centerY(value:Number):void;
		/**
		 * 获取家具的中心点Z坐标值 
		 * @return Number
		 * 
		 */	
		function get centerZ():Number;
		/**
		 * 设置家具的中心点Z坐标值 
		 * @param value
		 * 
		 */		
		function set centerZ(value:Number):void;
		/**
		 * 获取中心点坐标 
		 * @return Vector3D
		 * 
		 */		
		function get Center():Vector3D;
		/**
		 * 获取家具的X坐标值 
		 * @return Number
		 * 
		 */		
		function get PositionX():Number;
		/**
		 * 设置家具的X坐标值 
		 * @param value
		 * 
		 */		
		function set PositionX(value:Number):void;
		/**
		 * 获取家具Y坐标值 
		 * @return Number
		 * 
		 */	
		function get PositionY():Number;
		/**
		 * 设置家具的Y坐标值 
		 * @param value
		 * 
		 */		
		function set PositionY(value:Number):void;
		/**
		 * 获取家具Z坐标值 
		 * @return Number
		 * 
		 */	
		function get PositionZ():Number;
		/**
		 * 设置家具的Z坐标值 
		 * @param value
		 * 
		 */		
		function set PositionZ(value:Number):void;
		/**
		 * 获取家具的旋转角度值 
		 * @return Number
		 * 
		 */		
		function get Rotation():Number;
		/**
		 * 设置家具的旋转角度值 
		 * @param value
		 * 
		 */		
		function set Rotation(value:Number):void;
		/**
		 * 获取家具的长度值 
		 * @return Number
		 * 
		 */		
		function get Length():Number;
		/**
		 * 设置家具的长度值 
		 * @param value
		 * 
		 */		
		function set Length(value:Number):void;
		/**
		 * 获取家具的厚度值 
		 * @return Number
		 * 
		 */		
		function get Width():Number;
		/**
		 * 设置家具的厚度值 
		 * @param value
		 * 
		 */		
		function set Width(value:Number):void;
		/**
		 * 获取家具的高度值 
		 * @return Number
		 * 
		 */		
		function get Height():Number;
		/**
		 * 设置家具的高度值 
		 * @param value
		 * 
		 */		
		function set Height(value:Number):void;
		/**
		 * 获取家具的离地高 
		 * @return Number
		 * 
		 */		
		function get OffGround():Number;
		/**
		 * 设置家具的离地高 
		 * @param value
		 * 
		 */		
		function set OffGround(value:Number):void;
		/**
		 * 设置家具的原始尺寸 
		 * @param length	长度
		 * @param width	厚度
		 * @param height	高度
		 * 
		 */		
		function setOriginSize(length:Number,width:Number,height:Number):void;
		/**
		 * 设置家具的2D尺寸 
		 * @param length
		 * @param width
		 * 
		 */		
		function setSize2D(length:Number,width:Number):void;
		/**
		 * 渲染2D显示 
		 * 
		 */		
		function ToRender2D():void;
		/**
		 * 渲染3D显示 
		 * 
		 */		
		function ToRender3D():void;
		/**
		 * 更新所在墙体的墙洞数据 
		 * 
		 */		
		function removeLinkedWallHole():void;
		/**
		 * 获取3D坐标 
		 * @return Vector3D
		 * 
		 */		
		function get position3D():Vector3D;
		/**
		 * 设置3D坐标 
		 * @param value
		 * 
		 */		
		function set position3D(value:Vector3D):void;
		/**
		 * 家具是否属于门类型
		 * @return Boolean
		 * 
		 */		
		function get IsDoor():Boolean;
		/**
		 * 家具是否属于拐角窗类型
		 * @return Boolean
		 * 
		 */		
		function get isCornerWindow():Boolean;
		/**
		 * 家具是否属于窗类型 
		 * @return Boolean
		 * 
		 */		
		function get IsWindow():Boolean;
		/**
		 * 家具是否属于梁 
		 * @return Boolean
		 * 
		 */		
		function get IsBeam():Boolean;
		/**
		 * 家具是否属于门窗大类型 
		 * @return Boolean
		 * 
		 */		
		function get IsDoorWindow():Boolean;
		/**
		 * 获取家具所吸附的墙体数据接口的实例 
		 * @return ICL3DWallExtension
		 * 
		 */		
		function get LinkedWall():ICL3DWallExtension;
		/**
		 * 拐角窗对象
		 * @return Array
		 * 
		 */		
		function get cornerWindowObjArr():Array;
		/**
		 * 获取家具内墙洞线顶点坐标集合 
		 * @return Vector.<Number>;
		 * 
		 */		
		function get furnitureInnerWallHoleLines():Vector.<Number>;
		/**
		 * 设置家具内墙洞线顶点坐标集合 
		 * @param val
		 * 
		 */		
		function set furnitureInnerWallHoleLines(val:Vector.<Number>):void;
	}
}