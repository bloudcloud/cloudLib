package cloud.core.singleton
{
	import flash.geom.Vector3D;
	
	import cloud.core.data.CVector;
	import cloud.core.data.container.CVector3DContainer;
	import cloud.core.utils.CMathUtil;
	import cloud.core.utils.Ray3D;

	/**
	 *  3D向量工具
	 * @author cloud
	 */
	public class CVector3DUtil
	{
		public static const RAY_3D:Ray3D = new Ray3D();
		
		private static var _Instance:CVector3DUtil;

		public static function get Instance():CVector3DUtil
		{
			return _Instance ||= new CVector3DUtil(new SingletonEnforce());
		}
		
		public function CVector3DUtil(enforcer:SingletonEnforce)
		{
		}
		/**
		 * 将自定义3D向量对象，转换成Vector3D对象 
		 * @param vec	自定义3D对象
		 * @return Vector3D
		 * 
		 */		
		public function transformToVector3D(vec:CVector):Vector3D
		{
			return new Vector3D(vec.x,vec.y,vec.z,vec.w);
		}
		/**
		 * 用向量方法获取点到线段的距离 
		 * @param a	线上a点
		 * @param b	线上b点
		 * @param p	空间一点
		 * @return Number 最短距离
		 * 
		 */		
		public function getPointToSegmentDistanceByVector(a:CVector,b:CVector,p:CVector):Number
		{
			var returnLength:Number;
			var dotValue:Number;
			var scale:Number;
			var ap:CVector = CVector.Substract(p,a);
			var ab:CVector = CVector.Substract(b,a);
			var ac:CVector = ab;
			dotValue=CVector.DotValue(ap,ab);
			scale=dotValue / ab.lengthSquared;
			if(scale<=0)
			{
				returnLength = ap.length;
			}
			else if(scale>=1)
			{
				returnLength = CVector.Substract(p,b).length;
			}
			else
			{
				CVector.Scale(ac,scale);
				returnLength=CVector.Substract(ac,ap).length;
			}
			ap.back();
			ab.back();
			return returnLength;
		}
		/**
		 * 在XY平面内计算轴方向与当前方向的夹角
		 * @param dir	当前方向
		 * @param axis	轴方向
		 * @param isDegreeORRadian	ture返回角度值，false返回弧度值
		 * @return Number	夹角
		 * 
		 */		
		public function calculateRotationByAxis(dir:CVector,axis:CVector,isDegreeORRadian:Boolean=true):Number
		{
			var angle:Number;
			var cosValue:Number = CVector.DotValue(dir,axis) / dir.length;
			var nor:CVector=CVector.CrossValue(dir,axis);
			if(CVector.DotValue(nor,CVector.NEG_Z_AXIS)<0)
				angle=isDegreeORRadian ? CMathUtil.instance.toDegrees(Math.acos(cosValue))*-1 : Math.acos(cosValue)*-1;
			else
				angle=isDegreeORRadian ? CMathUtil.instance.toDegrees(Math.acos(cosValue)) : Math.acos(cosValue);
			nor.back();
			return angle;
		}
		/**
		 * 通过旋转角度,计算平行于地面的方向 
		 * @param rotation
		 * @param isDegreeOrRadian
		 * @return CVector
		 * 
		 */		
		public function calculateDirectionByRotation(rotation:Number,outPut:CVector,isDegreeOrRadian:Boolean=true):void
		{
			var radian:Number=isDegreeOrRadian?CMathUtil.instance.toRadians(rotation):rotation;
			CVector.SetTo(outPut,Math.cos(radian),Math.sin(radian),0);
		}
		/**
		 * 将2D点坐标转换成3D点坐标
		 * @param roundPoints
		 * @return Vector.<CVector>
		 * 
		 */		
		public function transformPointsToVector3Ds(roundPoints:Array):CVector3DContainer
		{
			var container:CVector3DContainer=CVector3DContainer.CreateOneInstance();
			container.add(roundPoints);
			return container;
		}

	}
}