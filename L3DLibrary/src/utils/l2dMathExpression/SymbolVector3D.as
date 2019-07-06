package utils.l2dMathExpression
{
	import flash.geom.Vector3D;
	
	import cores.HashMap;

	/*符号3D向量或者点*/
	public class SymbolVector3D
	{
		public function SymbolVector3D()
		{
		}
		
		/*u/x坐标*/
		public var u:String = "0";
		/*v/y坐标*/
		public var v:String = "0";
		/*w/z坐标*/
		public var w:String = "0";
		
		public function clone():SymbolVector3D
		{
			var c:SymbolVector3D = new SymbolVector3D();
			c.u = u; c.v=v; c.w=w;
			return c;
		}
		
		public function toRealVector3D(hashMap:HashMap):Vector3D
		{
			var realV:Vector3D = new Vector3D();
			var val:Number = 0;
			var mathExp:MathExp = null;
			
			if(u != null && u!="" && u.length>0)
			{
				mathExp = new MathExp(u);
				mathExp.toPostfix();
				val = mathExp.toRealNumber(hashMap);
				realV.x = val;
			}
			
			if(v != null && v!="" && v.length>0)
			{
				mathExp = new MathExp(v);
				mathExp.toPostfix();
				val = mathExp.toRealNumber(hashMap);
				realV.y = val;
			}
			
			if(w != null && w!="" && w.length>0)
			{
				mathExp = new MathExp(w);
				mathExp.toPostfix();
				val = mathExp.toRealNumber(hashMap);
				realV.z = val;
			}
			
			return realV;
		}
		
		/*序列化*/
		public function serialize():XML
		{
			var dataXML:XML = new XML();
			
			dataXML = <SymbolVector3D
					   u={u}
			v={v}
			w={w}
			>
			</SymbolVector3D>
			return dataXML;
		}
		
		/*反序列化*/
		public function deserialize(xml:XML):Boolean
		{
			u = String(xml.@u);
			v = String(xml.@v);
			w = String(xml.@w);
			
			return true;
		}
	}
}