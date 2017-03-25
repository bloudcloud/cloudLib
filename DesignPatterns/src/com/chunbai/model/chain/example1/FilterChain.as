package com.chunbai.model.chain.example1
{
	
	/**
	 * 在FilterChain中继承了Filter接口，从而实现了doFilter方法，在FilterChain中又有一个index变量，
	 * 该变量是用来标记当前访问的是哪一个过滤器，这些过滤器是存放在ArrayList中的，
	 * 这样用户在使用的时候就可以实现自己的过滤器，编写自己的处理逻辑，从而将自己的过滤器添加到ArrayList中，
	 * 再调用FilterChain的doFilter方法遍历整个责任链。
	 * */
	public class FilterChain implements IFilter
	{
		private var _filters:Array = [];
		private var _index:int = 0;
		
		public function FilterChain()
		{
		
		}
		
		/**
		 * 用来添加实现IFilter接口的filter和filterChain类的对象
		 * */
		public function addFilter($filter:IFilter):IFilter
		{
		    _filters.push($filter);
			return this;
		}
		
	    public function doFilter($request:Request, $response:Response, $chain:FilterChain):void
		{  
		    if(_index < _filters.length)
			{
				var f:IFilter = _filters[_index] as IFilter;
				_index++;
				f.doFilter($request, $response, $chain);
			}
		}
		
	}
}