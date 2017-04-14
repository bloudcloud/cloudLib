package com.chunbai.model.chain.example1
{
	
	/**
	 * HTML过滤器
	 * */
	public class HTMLFilter implements IFilter
	{
		public function HTMLFilter()
		{
			
		}
		
		/**
		 * @Override
		 * */  
		public function doFilter($request:Request, $response:Response, $chain:FilterChain):void
		{
			$request.requestStr = $request.requestStr.replace("<", "[").replace(">", "] --HTMLFilter");
			$chain.doFilter($request, $response, $chain);
			$response.responseStr += "--HTMLFilter";   
		 }
	
	}
}