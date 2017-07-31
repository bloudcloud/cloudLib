package cloud.core.interfaces
{
	import cloud.core.data.CTransform3D;
	import cloud.core.data.CVector;
	import cloud.core.data.container.CVector3DContainer;

	/**
	 *  3D对象数据
	 * @author cloud
	 */
	public interface ICObject3D
	{
		/**
		 * 获取长度 
		 * @return 
		 * 
		 */		
		function get length():Number;
		/**
		 * 设置长度 
		 * @param value
		 * 
		 */		
		function set length(value:Number):void;
		/**
		 * 获取厚度 
		 * @return Number
		 * 
		 */		
		function get width():Number;
		/**
		 * 设置厚度 
		 * @param value
		 * 
		 */		
		function set width(value:Number):void;
		/**
		 *  获取高度
		 * @return Number
		 * 
		 */
		function get height():Number;
		/**
		 * 设置高度 
		 * @param value
		 * 
		 */		
		function set height(value:Number):void;
		/**
		 * 获取在长度方向的缩放值 
		 * @return Number
		 * 
		 */		
		function get scaleLength():Number;
		/**
		 *	设置在长度方向的缩放值  
		 * @param value
		 * 
		 */		
		function set scaleLength(value:Number):void;
		/**
		 * 获取在厚度方向的缩放值  
		 * @return Number
		 * 
		 */		
		function get scaleWidth():Number;
		/**
		 * 设置在厚度方向的缩放值   
		 * @param value
		 * 
		 */		
		function set scaleWidth(value:Number):void;
		/**
		 * 获取在高度方向的缩放值  
		 * @return Number
		 * 
		 */		
		function get scaleHeight():Number;
		/**
		 * 设置在高度方向的缩放值 
		 * @param value
		 * 
		 */		
		function set scaleHeight(value:Number):void;
		/**
		 * 获取以长度方向为轴进行旋转的角度值 
		 * @return Number
		 * 
		 */		
		function get rotationLength():Number;
		/**
		 * 获设置以长度方向为轴进行旋转的角度值 
		 * @param value
		 * 
		 */		
		function set rotationLength(value:Number):void;
		/**
		 * 获取以宽度方向为轴进行旋转的角度值 
		 * @return Number
		 * 
		 */		
		function get rotationWidth():Number;
		/**
		 * 获设置以宽度方向为轴进行旋转的角度值 
		 * @param value
		 * 
		 */		
		function set rotationWidth(value:Number):void;
		/**
		 * 获取以高度方向为轴进行旋转的角度值 
		 * @return Number
		 * 
		 */		
		function get rotationHeight():Number;
		/**
		 * 获设置以高度方向为轴进行旋转的角度值 
		 * @param value
		 * 
		 */		
		function set rotationHeight(value:Number):void;
		/**
		 * 获取方向 
		 * @return Vector3D
		 * 
		 */		
		function get direction():CVector;

		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		function get z():Number;
		function set z(value:Number):void;
		/**
		 * 获取位置 
		 * @return Vector3D
		 * 
		 */
		function get position():CVector;
		/**
		 * 获取转换 
		 * @return Transform3D
		 * 
		 */		
		function get transform():CTransform3D;
		/**
		 * 获取逆转换 
		 * @return Transform3D
		 * 
		 */		
		function get inverseTransform():CTransform3D;
		/**
		 * 获取子容器是否需要更新
		 * @return Boolean
		 * 
		 */		
		function get invalidParent():Boolean;
		/**
		 * 获取位置坐标是否需要更新
		 * @return Boolean
		 * 
		 */		
		function get invalidPosition():Boolean;
		/**
		 * 设置位置坐标需要更新 
		 * @param value
		 * 
		 */		
		function set invalidPosition(value:Boolean):void;
		/**
		 * 获取尺寸是否更新
		 * @return Boolean
		 * 
		 */		
		function get invalidSize():Boolean;
		/**
		 *  获取3D物体围点数据容器对象 
		 * @return CVector3DContainer
		 * 
		 */		
		function get roundPoints():CVector3DContainer;
		/**
		 * 设置3D物体围点数据容器对象 
		 * @param value
		 * 
		 */		
		function set roundPoints(value:CVector3DContainer):void;
		/**
		 * 获取父对象 
		 * @return ICObject3D
		 * 
		 */		
		function get parent():ICObject3D;
		/**
		 * 获取子对象
		 * @return ICObject3D
		 * 
		 */		
		function get children():ICObject3D
		/**
		 * 获取下一个节点对象
		 * @return ICObject3D
		 * 
		 */		
		function get next():ICObject3D;
		/**
		 * 设置下一个节点对象 
		 * @param value
		 * 
		 */		
		function set next(value:ICObject3D):void;
		/**
		 * 获取子对象的总数 
		 * @return int
		 * 
		 */		
		function get numChildren():int;
		/**
		 * 根据 
		 * @param index
		 * @return ICObject3D
		 * 
		 */		
		function getChildAt(index:int):ICObject3D;
		/**
		 * 添加一个子对象
		 * @param child
		 * 
		 */		
		function addChild(child:ICObject3D):void;
		/**
		 * 移除一个子对象 
		 * @param child
		 * 
		 */		
		function removeChild(child:ICObject3D):void;
		/**
		 * 将本地的3D向量转换成全局的3D向量 
		 * @param vec
		 * @param outPut
		 * 
		 */		
		function localToGlobal(vec:CVector,outPut:CVector):void;
		/**
		 * 将全局的3D向量转换成本地的3D向量 
		 * @param vec
		 * @param outPut
		 * 
		 */		
		function globalToLocal(vec:CVector,outPut:CVector):void;
		
		function clear():void;
	}
}