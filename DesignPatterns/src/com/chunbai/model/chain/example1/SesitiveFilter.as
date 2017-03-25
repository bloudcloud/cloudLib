package com.chunbai.model.chain.example1
{
	
	/**
	 * Sesitive过滤器(过滤掉敏感词汇)
	 * */
	public class SesitiveFilter implements IFilter
	{
		public function SesitiveFilter()
		{
			
		}
		
		/**
		 * @Override
		 * */  
		public function doFilter($request:Request, $response:Response, $chain:FilterChain):void
		{
			$request.requestStr = $request.requestStr.replace("敏感", "  ").replace("猫猫", "haha--SesitiveFilter");
			$chain.doFilter($request, $response, $chain);
			$response.responseStr += "--SesitiveFilter";
		}
		
	}
}