package utils.l2dMathExpression
{
	import cores.HashMap;

	public class BasicFunctionMap
	{
		public static var instance:BasicFunctionMap =  null;
		
		public function BasicFunctionMap()
		{
			if (instance) {  
				throw new Error("只能用getInstance()来获取实例");  
			} 
		}
		
		public static function getInstance():BasicFunctionMap
		{
			if(instance == null){
				instance = new BasicFunctionMap();
				instance.makeFunctionMap();
			}
			return instance;
		}
		
		private  var _basicFuncMap:HashMap = null;
		
		private function neg(x:Number):Number
		{
			return -x;
		}
		
		private function postive(x:Number):Number{
			return x;
		}
		private function add(x:Number, y:Number):Number{
			return x+y;
		}
		
		private function sub(x:Number, y:Number):Number{
			return x-y;
		}
		
		private function mul(x:Number, y:Number):Number
		{
			return x*y;
		}
		
		private function div(x:Number, y:Number):Number{
			return x/y;
		}
		
	
		
		private function makeFunctionMap():void
		{
			_basicFuncMap = new HashMap();
			_basicFuncMap.add("neg", neg);
			_basicFuncMap.add("postive", postive);
			_basicFuncMap.add("+", add);
			_basicFuncMap.add("-", sub);
			_basicFuncMap.add("*", mul);
			_basicFuncMap.add("/", div);
			_basicFuncMap.add("^", Math.pow);
			_basicFuncMap.add("sqrt", Math.sqrt);
			_basicFuncMap.add("sin", Math.sin);
			_basicFuncMap.add("cos", Math.cos);
			_basicFuncMap.add("atan2", Math.atan2);
			_basicFuncMap.add("abs", Math.abs);
		}
		
		public function findFunction(funcName:String):Function{
			return _basicFuncMap.getValue(funcName) as Function;
		}
	}
}