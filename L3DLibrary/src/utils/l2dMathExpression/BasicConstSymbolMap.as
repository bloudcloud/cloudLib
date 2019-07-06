package utils.l2dMathExpression
{
	import cores.HashMap;

	public class BasicConstSymbolMap
	{
		
		public static var instance:BasicConstSymbolMap =  null;
		
		public function BasicConstSymbolMap()
		{
			if (instance) {  
				throw new Error("只能用getInstance()来获取实例");  
			} 
		}
		
		public static function getInstance():BasicConstSymbolMap
		{
			if(instance == null){
				instance = new BasicConstSymbolMap();
				instance.makeConstSymbolMap();
			}
			return instance;
		}
		
		private  var _basicConstSymbolMap:HashMap = null;
		private function makeConstSymbolMap():void{
			_basicConstSymbolMap = new HashMap();
			_basicConstSymbolMap.add("PI", Math.PI);
		}
		
		public function findSymbol(sym:String):Number
		{
			if(!_basicConstSymbolMap.hasKey(sym)){
				return Number.NaN;
			}
			return _basicConstSymbolMap.getValue(sym) as Number;
		}
	}
}