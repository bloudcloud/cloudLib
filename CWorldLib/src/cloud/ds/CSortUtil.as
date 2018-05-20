package cloud.ds
{
	/**
	 * 排序工具类
	 * @author cloud
	 */
	public class CSortUtil
	{
		private static var _Instance:CSortUtil;
		
		public static function get Instance():CSortUtil
		{
			return _Instance ||= new CSortUtil();
		}
		/**
		 * 升序
		 */
		public const ASC_COMPARE_FUNC:Function = function(a:*, b:*):Number {
			if (a < b)
				return -1;
			else if (a > b)
				return 1;
			else
				return 0;
		}
		/**
		 * 降序
		 */
		public const DESC_COMPARE_FUNC:Function = function(a:*, b:*):Number {
			if (a > b)
				return -1;
			else if (a < b)
				return 1;
			else
				return 0;
		}
		/**
		 * a是否小于b 
		 * @param a
		 * @param b
		 * @param compareFunc
		 * @return Boolean
		 * 
		 */		
		public function less(a:* ,b:*,compareFunc:Function):Boolean
		{
			return compareFunc(a, b) < 0;
		}
		/**
		 * 交换数据 
		 * @param arr
		 * @param i
		 * @param j
		 * 
		 */		
		public function swap(arr:Array, i:int, j:int):void
		{
			var t:* = arr[i];
			arr[i] = arr[j];
			arr[j] = t;
		}
		public function isSorted(arr:Array , compareFunc:Function):Boolean
		{
			for ( var i:int = 0; i < arr.length-1 ; i++)
			{
				if (less(arr[i + 1], arr[i],compareFunc)) return false;
			}
			return true;
		}
		
		public function traceAll(arr:Array):void 
		{
			trace("--------------------------------------")
			for ( var i:int = 0 ; i < arr.length ; i++)
			{
				trace(arr[i])
			}
			trace("--------------------------------------")
		}

		private function heapSwap(arr:Array , i:int , j:int):void
		{
			var t:* = arr[i-1];
			arr[i-1] = arr[j-1];
			arr[j-1] = t;
		}
		private function heapSink(arr:Array , k:int , l:int ,compareFunc:Function):void
		{
			var j:uint;
			var key:* = arr[k - 1];
			while ( k << 1 <= l) //2 * k < length 有子节点
			{
				j = k << 1;
				if (j < l && compareFunc(arr[j-1], arr[j] ) < 0) j++; //2k还是2k+1
				if ( compareFunc(key, arr[j - 1]) >= 0) break;
				arr[k - 1] = arr[j - 1]; //子节点上移，并记录顶节点应该放的位置
				k = j;
			}
			arr[k - 1] = key;
		}
		/**
		 * 数组的堆排序 
		 * @param arr	数组	
		 * @param compareFunc	比较方法
		 * 
		 */		
		public function heapSort(arr:Array , compareFunc:Function = null):void
		{
			if (compareFunc == null)
				compareFunc =  ASC_COMPARE_FUNC;
			var size:uint =  arr.length;
			for ( var k:int = size >> 1 ; k >= 1; k --)
				heapSink(arr, k, size , compareFunc); //下沉构造堆
			while (size > 1)
			{
				heapSwap(arr, 1, size-- )
				heapSink(arr, 1, size , compareFunc);
			}
		}
		/**
		 * 数组的插入排序 
		 * @param arr	数组
		 * @param compareFunc	比较方法
		 * 
		 */		
		public function insertionSort(arr:Array , compareFunc:Function = null):void
		{
			
			if (compareFunc == null)
				compareFunc = ASC_COMPARE_FUNC;
			
			var l:int = arr.length;
			var key:*;
			for (var i:int = 1 ; i < l ; i++)
			{
				key = arr[i];//待插入的
				for (var j:int = i ; j > 0 && less(key,arr[j-1],compareFunc) ; j--)
				{
					arr[j] = arr[j - 1]; //比待插入大的向右移动
				}
				arr[j] = key;
			}
		}
		/**
		 * 归并排序 
		 * @param arr
		 * @param compareFunc
		 * 
		 */		
		public function mergeSort(arr:Array, compareFunc:Function = null):void
		{
			if (compareFunc == null)
				compareFunc = ASC_COMPARE_FUNC;
			
			var cp:Array = arr.slice(0);
			doMergeSort(arr, cp, 0, arr.length - 1, compareFunc)
		}
		private function doMergeSort(arr:Array , cp:Array , startIndex:int , endIndex:int ,compareFunc:Function):void
		{
			if (startIndex >= endIndex) return;
			var mid:int =  ( (endIndex - startIndex) >> 1 ) + startIndex ;
			doMergeSort(arr, cp, startIndex, mid, compareFunc);
			doMergeSort(arr, cp, mid + 1, endIndex, compareFunc);
			doMerge(arr, cp, startIndex, mid, endIndex,compareFunc);
		}
		private function doMerge(arr:Array,cp:Array, l0:int, mid:int, hi:int,compareFunc:Function):void
		{
			//trace(" merge" , l0,mid,hi)
			//将[l0...mid]和[mid+1 ... hi]归并
			var i:int = l0 , j:int = mid + 1 , k:int = l0;
			
			for ( k = l0 ; k <= hi; k++)
				cp[k] = arr[k];
			
			for (k = l0; k <= hi; k++)
			{
				if (i > mid)
					arr[k] = cp[j++]; //左边用尽，取右边
				else if (j > hi)
					arr[k] = cp[i++]; //右边用尽，取左边 
				else if (less(cp[j], cp[i], compareFunc)) 
					arr[k] = cp[j++]; //右边小，取右边
				else						
					arr[k] = cp[i++];
			}
		}
		/**
		 *  
		 * @param arr
		 * @param compareFunc
		 * 
		 */		
		public function quickSort(arr:Array, compareFunc:Function):void
		{
			if (compareFunc == null)
				compareFunc = ASC_COMPARE_FUNC;
			
			doQuickSort(arr,  0, arr.length - 1, compareFunc)
		}
		private function doQuickSort(arr:Array, startIndex:int, endIndex:int, compareFunc:Function):void 
		{
			if ( startIndex >= endIndex) return;
			var j:int = partition(arr, startIndex, endIndex, compareFunc);
			doQuickSort(arr, startIndex , j - 1 ,compareFunc);
			doQuickSort(arr, j + 1, endIndex,compareFunc);
		}
		private function partition (arr:Array , startIndex:int , endIndex:int ,compareFunc:Function):uint
		{
			var i:int = startIndex , j:int = endIndex + 1 ; //左右扫描指针
			var v:* = arr[startIndex]; //分割元素
			while (true) 
			{
				while (less(arr[++i], v, compareFunc)) if (i == endIndex) break;
				while (less(v, arr[--j], compareFunc)) if (j == startIndex) break;
				if (i >= j) break; //相遇
				swap(arr, i, j);
			}
			swap(arr, startIndex, j);//将v = a[j]放入正确的位置
			return j;
		}
		/**
		 * 选择排序 
		 * @param arr
		 * @param compareFunc
		 * 
		 */		
		public function selectionSort(arr:Array , compareFunc:Function = null):void
		{
			if (compareFunc == null)
				compareFunc = ASC_COMPARE_FUNC;
			var l:int = arr.length;
			var min:int;
			for (var i:int = 0 ; i < l - 1 ; i++)
			{
				min = i; //遍历取最小索引
				for (var j:int = i + 1; j < l; j++)
				{
					if (less(arr[j], arr[min] , compareFunc))
						min = j;
				}
				if (i != min) //最小的放在左边
					swap(arr, i, min);
			}
		}
		/**
		 * 希尔排序（改进的插入排序） 
		 * @param arr
		 * @param compareFunc
		 * 
		 */		
		public function shellSort(arr:Array , compareFunc:Function):void
		{
			if (compareFunc == null)
				compareFunc = ASC_COMPARE_FUNC;
			var l:int = arr.length;
			var h:int = 1;
			var key:*;
			while ( h < l/3 ) h = 3 * h + 1; // 1,4,13,40,121,364,1093,....
			while ( h >= 1)
			{
				for (var i:int = h; i < l ; i++)
				{
					key = arr[i]; //待插入
					for ( var j:int = i ; j >= h && less(key, arr[j - h], compareFunc); j -= h)
					{
						arr[j] = arr[j - h]; //右移
					}
					arr[j] = key;
				}
				h = int(h / 3);
			}
		}
	}
}