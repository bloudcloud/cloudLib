package cloud.core.datas.base
{
	/**
	 *  2维向量(待废弃)
	 * @author cloud
	 */
	public class Vector2D
	{
		private var _x:Number;   
		private var _y:Number;   
		
		/**
		 * 返回两向量夹角的弦度值 
		 * @param v1
		 * @param v2
		 * @return Number
		 * 
		 */		   
		public static function angleBetween(v1:Vector2D,v2:Vector2D):Number{   
			if(!v1.isNormalized()) v1=v1.clone().normalize();   
			if(!v2.isNormalized()) v2=v2.clone().normalize();   
			return Math.acos(v1.dotProd(v2));   
		}  
		
		public function Vector2D(x:Number=0,y:Number=0)  
		{  
			_x = x;  
			_y = y;  
		}  
		/**
		 * 拷贝向量    
		 * @return Vector2D
		 * 
		 */		
		final public function clone():Vector2D{   
			return new Vector2D(_x,_y);   
		}   
		/**
		 * 将当前向量变成0向量    
		 * @return 
		 * 
		 */		
		final public function zero():Vector2D{   
			_x=0;   
			_y=0;   
			return this;   
		}   
		/**
		 * 判断是否是0向量    
		 * @return Boolean
		 * 
		 */		
		final public function isZero():Boolean{   
			return _x==0 && _y==0;   
		}  
		/**
		 * 设置角度 
		 * @param value
		 * 
		 */		
		final public function set angle(value:Number):void{   
			var len:Number=length;   
			_x=Math.cos(value)*len;   
			_y=Math.sin(value)*len;   
		}  
		/**
		 * 获取角度    
		 * @return Number
		 * 
		 */		
		final public function get angle():Number{   
			return Math.atan2(_y,_x);   
		}   
		/**
		 * 设置向量的大小    
		 * @param value
		 * 
		 */		
		final public function set length(value:Number):void{   
			var a:Number=angle;   
			_x=Math.cos(a)*value;   
			_y=Math.sin(a)*value;   
		}  
		/**
		 * 获取当前向量大小   
		 * @return Number
		 * 
		 */		
		final public function get length():Number{   
			return Math.sqrt(lengthSQ);   
		}   
		/**
		 * 获取当前向量大小的平方    
		 * @return Number
		 * 
		 */		
		final public function get lengthSQ():Number{   
			return _x*_x+_y*_y;   
		}   
		/**
		 * 将当前向量转化成单位向量    
		 * @return Vector2D
		 * 
		 */		
		final public function normalize():Vector2D{   
			if(length==0){   
				_x=1;   
				return this;   
			}   
			var len:Number=length;   
			_x/=len;   
			_y/=len;   
			return this;   
		}   
		/**
		 * 截取当前向量    
		 * @param max
		 * @return Vector2D
		 * 
		 */		
		final public function truncate(max:Number):Vector2D{   
			length=Math.min(max,length);   
			return this;   
		}   
		/**
		 * 反转向量    
		 * @return Vector2D
		 * 
		 */		
		final public function reverse():Vector2D{   
			_x=-_x;   
			_y=-_y;   
			return this;   
		}   
		/**
		 * 判断当前向量是否是单位向量   
		 * @return Boolean
		 * 
		 */		 
		final public function isNormalized():Boolean{   
			return length==1.0;   
		}  
		/**
		 * 向量点积 
		 * @param v2
		 * @return Number
		 * 
		 */		
		final public function dotProd(v2:Vector2D):Number{   
			return _x*v2.x+_y*v2.y;   
		}   
		/**
		 * 判断两向量是否垂直 
		 * @param v2
		 * @return Boolean
		 * 
		 */		   
		final public function crossProd(v2:Vector2D):Boolean{   
			return _x*v2.y-_y*v2.x == 0;   
		}  
		/**
		 * 返回向量的符号值
		 * @param v2
		 * @return int		大于0在向量左侧，小于0在向量右侧
		 * 
		 */		   
		final public function sign(v2:Vector2D):int{   
			return perp.dotProd(v2)<0?-1:1;   
		}   
		/**
		 * 返回坐标向量（与当前向量垂直）
		 * @return Vector2D
		 * 
		 */		
		final public function get perp():Vector2D{   
			return new Vector2D(-y,x);   
		}   
		/**
		 * 返回当前向量与V2的距离 
		 * @param v2
		 * @return Number
		 * 
		 */		  
		final public function dist(v2:Vector2D):Number{   
			return Math.sqrt(distSQ(v2));   
		}   
		/**
		 * 返回当前向量与V2的距离的平方    
		 * @param v2
		 * @return Number
		 * 
		 */		
		final public function distSQ(v2:Vector2D):Number{   
			return (v2.x-x)*(v2.x-x)+(v2.y-y)*(v2.y-y);   
		}   
		/**
		 * 两向量相加  
		 * @param v2
		 * @return Vector2D
		 * 
		 */		
		final public function add(v2:Vector2D):Vector2D{   
			return new Vector2D(_x+v2.x,_y+v2.y);   
		}   
		/**
		 * 两向量相减 
		 * @param v2
		 * @return Vector2D
		 * 
		 */		  
		final public function subtract(v2:Vector2D):Vector2D{   
			return new Vector2D(_x-v2.x,y-v2.y);   
		}   
		/**
		 * 数与向量的乘积 
		 * @param value
		 * @return Vector2D
		 * 
		 */		   
		final public function multiply(value:Number):Vector2D{   
			return new Vector2D(_x*value,_y*value);   
		}   
		/**
		 * 数与向量的商 
		 * @param value
		 * @return Vector2D
		 * 
		 */		   
		final public function divide(value:Number):Vector2D{   
			return new Vector2D(_x/value,_y/value);   
		}   
		/**
		 * 判断两向量是否相等 
		 * @param v2
		 * @return Boolean
		 * 
		 */		 
		final public function equals(v2:Vector2D):Boolean{   
			return _x==v2.x && _y==v2.y;   
		}   
		
		final public function get x():Number  
		{  
			return _x;  
		}  
		
		final public function set x(value:Number):void  
		{  
			_x = value;  
		}  
		
		final public function get y():Number  
		{  
			return _y;  
		}  
		
		final public function set y(value:Number):void  
		{  
			_y = value;  
		}  
	}
}