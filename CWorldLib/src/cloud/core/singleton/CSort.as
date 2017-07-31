package cloud.core.singleton
{
	/**
	 * Classname : public class CSort
	 * 
	 * Date : 2013-10-18
	 * 
	 * author :cloud
	 * 
	 * company :青岛羽翎珊动漫科技有限公司
	 */
	/**
	 * 实现功能: 数值排序
	 * 
	 */
	public class CSort
	{
		public static const QUICK_SORT:int = 1;	
		
		private static var _Instance:CSort;
		
		public function CSort(enforcer:SingletonEnforce)
		{
			
		}

		public static function get Instance():CSort
		{
			if(!_Instance)
				_Instance = new CSort(new SingletonEnforce());
			return _Instance;
		}
		/**
		 * 排序 
		 * @param arr		数据源
		 * @param type	排序算法
		 * 
		 */		
		public function sort(arr:Array, type:int):void
		{
			switch(type)
			{
				case QUICK_SORT:
					quickSort(arr,0,arr.length - 1);
					break;
			}
		}
		private function quickSort(arr:Array,low:int,high:int):String
		{
			if( low < high)
			{
				var part:int=partition(arr,low,high);
				quickSort(arr,low,part-1);
				quickSort(arr,part+1,high);
			}
			return "quickSort";
		}
		
		private function partition(arr:Array,low:int,high:int):int
		{
			var mid:int=low+(high-low)/2;
			var pivot:int=arr[mid];
			//set pivot to the end
			var temp1:int=arr[mid];
			arr[mid]=arr[high];
			arr[high]=temp1;
			
			var index:int=low;
			for(var i:int=low;i<high;i++)
			{
				if( arr[i]<=pivot)
				{
					//swap
					var temp:int=arr[index];
					arr[index]=arr[i];
					arr[i]=temp;
					index++;
				}
			}
			//set pivot to the final place
			var swap:int=arr[high];
			arr[high]=arr[index];
			arr[index]=swap;
			return index;
		}
	}
}