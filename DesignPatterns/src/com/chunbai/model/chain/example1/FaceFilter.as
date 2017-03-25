package com.chunbai.model.chain.example1
{
	
	/**
	 * Face过滤器
	 * */
	public class FaceFilter implements IFilter
	{
		public function FaceFilter()
		{
			
		}
		
		/**
		 * @Override
		 * */
		public function doFilter($request:Request, $response:Response, $chain:FilterChain):void
		{
			$request.requestStr = $request.requestStr.replace(":)", "^V^--FaceFilter");
			$chain.doFilter($request, $response, $chain);
			$response.responseStr += "--FaceFilter";
		}
		
	}
}