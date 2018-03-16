package core
{
	import flash.events.Event;

	public class ListenerExtend
	{
		public function ListenerExtend()
		{
		}
		
		public function concat(func:Function, ...args):Function
		{
			if(args!=null){
				return function(e:Event):void
				{
					func.apply(null, [e].concat(args));
				};
			}else{
				return func;
			}
		}
	}
}