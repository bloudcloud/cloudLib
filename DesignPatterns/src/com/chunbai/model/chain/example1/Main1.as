package com.chunbai.model.chain.example1
{
	public class Main1
	{
		public function Main1()
		{
			var request:Request = new Request();
			request.requestStr = "敏感词汇，重庆，<script> 躲猫猫 :)";
			
			var response:Response = new Response();
			response.responseStr = "response";
			
			var fc:FilterChain = new FilterChain();
			fc.addFilter(new HTMLFilter());
			fc.addFilter(new SesitiveFilter());
			
			var fc2:FilterChain = new FilterChain();
			fc2.addFilter(new FaceFilter());
			
			fc.addFilter(fc2);
			fc.doFilter(request, response, fc);
			
			trace("request = " + request.requestStr);    //request =   词汇，重庆，[script] --HTMLFilter 躲haha--SesitiveFilter ^V^--FaceFilter
			trace("response = " + response.responseStr);    //response = response--FaceFilter--SesitiveFilter--HTMLFilter
		}
		
	}
}