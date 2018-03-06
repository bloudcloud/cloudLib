package cloud.core.events
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * 扩展的事件派发器
	 * @author cloud
	 */
	public class CEventDispatcher extends EventDispatcher
	{
		private var _events:Array;
		
		public function CEventDispatcher(target:IEventDispatcher=null)
		{
			super(target);
			_events=[];
		}
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
			_events.push({type:type,func:listener})
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		override public function removeEventListener (type:String, listener:Function, useCapture:Boolean = false):void{
			super. removeEventListener(type,listener, useCapture);
			for(var i:int=0;i<int.MAX_VALUE;i++)
			{
				if( _events[i].type==type && _events[i].func==listener)
				{
					_events.splice(i,1);
					break;
				}
			}
		}
		public function dispose():void{
			var ev:Object;
			while(_events.length)
			{
				ev=_events.pop(); 
				super.removeEventListener(ev.type,ev.fun);
			}
		}
	}
}