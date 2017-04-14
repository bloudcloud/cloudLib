package com.chunbai.model.chain.example1
{
	
	/**
	 * 处理用户信息的逻辑抽象成为一个个的过滤器，进一步抽象出过滤器接口Filter
	 * */
	public interface IFilter
	{
		function doFilter($request:Request, $response:Response, $chain:FilterChain):void;
	}
	
}