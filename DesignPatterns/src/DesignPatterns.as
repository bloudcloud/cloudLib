package
{
	import com.chunbai.model.abstractFactory.AbstractFactoryTest;
	import com.chunbai.model.adapter.AdapterTest;
	import com.chunbai.model.bridge.BridgeTest;
	import com.chunbai.model.builder.BuilderTest;
	import com.chunbai.model.chain.ChainTest;
	import com.chunbai.model.command.CommandTest;
	import com.chunbai.model.composite.CompositeTest;
	import com.chunbai.model.decorator.DecoratorTest;
	import com.chunbai.model.facade.FacadeTest;
	import com.chunbai.model.factoryMethod.FactoryMethodTest;
	import com.chunbai.model.flyweight.FlyweightTest;
	import com.chunbai.model.interpreter.InterpreterTest;
	import com.chunbai.model.iterator.IteratorTest;
	import com.chunbai.model.mediator.MediatorTest;
	import com.chunbai.model.memento.MementoTest;
	import com.chunbai.model.observer.ObserverTest;
	import com.chunbai.model.prototype.PrototypeTest;
	import com.chunbai.model.proxy.ProxyTest;
	import com.chunbai.model.singleton.SingletonTest;
	import com.chunbai.model.state.StateTest;
	import com.chunbai.model.strategy.StrategyTest;
	import com.chunbai.model.templateMethod.TemplateMethodTest;
	import com.chunbai.model.visitor.VisitorTest;
	
	import flash.display.Sprite;
	
	/**
	 * 23种设计模式实例及说明大全(as3语言描述)
	 * @author xuechong
	 * @version v20121028.2
	 * @homepage http://bbs.9ria.com/space-uid-52584.html
	 * @QQ群交流 238680860
	 * */
	public class DesignPatterns extends Sprite
	{
		public function DesignPatterns()
		{
//			singletonFunc();    //单例模式
//			
//			observerFunc();    //观察者模式
//			
//			commandFunc();    //命令模式
//			
//			templateMethodFunc();    //模板方法模式
//			
//			factoryMethodFunc();    //工厂方法模式
			
			//abstractFactoryFunc();    //抽象工厂模式
			
			iteratorFunc();    //迭代器模式
			
			//proxyFunc();    //代理模式
			
			//adapterFunc();    //适配器模式
			
			//facadeFunc();    //外观模式
			
			//biulderFunc();    //建造者模式
			
			//prototypeFunc();    //原型模式
			
			//chainFunc();    //责任链模式
			
			//bridgeFunc();    //桥接模式
			
			//flyweightFunc();    //享元模式
			
			//mediatorFunc();    //中介者模式
			
			//strategyFunc();    //策略模式
			
			//interpreterFunc();    //解释器模式
			
			//compositeFunc();    //组合模式
			
			//decoratorFunc();    //装饰者模式
			
			//mementoFunc();    //备忘录模式
			
			//stateFunc();    //状态模式
			
			//visitorFunc();    //访问者模式
		}
		
		/**
		 * 单例模式
		 * */
		private function singletonFunc():void
		{
			var singleton:SingletonTest = new SingletonTest();
		}
		
		/**
		 * 观察者模式
		 * */
		private function observerFunc():void
		{
			var observer:ObserverTest = new ObserverTest();
			this.addChild(observer);
		}
		
		/**
		 * 命令模式
		 * */
		private function commandFunc():void
		{
			var commmand:CommandTest = new CommandTest();
		}
		
		/**
		 * 模板方法模式
		 * */
		private function templateMethodFunc():void
		{
			var templateMethod:TemplateMethodTest = new TemplateMethodTest();
		}
		
		/**
		 * 工厂方法模式
		 * */
		private function factoryMethodFunc():void
		{
			var factoryMethod:FactoryMethodTest = new FactoryMethodTest();
		}
		
		/**
		 * 抽象工厂模式
		 * */
		private function abstractFactoryFunc():void
		{
			var abstractFactory:AbstractFactoryTest = new AbstractFactoryTest();
		}
		
		/**
		 * 迭代器模式
		 * */
		private function iteratorFunc():void
		{
			var iterator:IteratorTest = new IteratorTest();
		}
		
		/**
		 * 代理模式
		 * */
		private function proxyFunc():void
		{
			var proxy:ProxyTest = new ProxyTest();
		}
		
		/**
		 * 适配器模式
		 * */
		private function adapterFunc():void
		{
			var adapter:AdapterTest = new AdapterTest();
		}
		
		/**
		 * 外观模式
		 * */
		private function facadeFunc():void
		{
			var facade:FacadeTest = new FacadeTest();
		}
		
		/**
		 * 建造者模式
		 * */
		private function biulderFunc():void
		{
			var builder:BuilderTest = new BuilderTest();
		}
		
		/**
		 * 原型模式
		 * */
		private function prototypeFunc():void
		{
			var prototype:PrototypeTest = new PrototypeTest();
		}
		
		/**
		 * 责任链模式
		 * */
		private function chainFunc():void
		{
			var chain:ChainTest = new ChainTest();
		}
		
		/**
		 * 桥接模式
		 * */
		private function bridgeFunc():void
		{
			var bridge:BridgeTest = new BridgeTest();
		}
		
		/**
		 * 享元模式
		 * */
		private function flyweightFunc():void
		{
			var flyweight:FlyweightTest = new FlyweightTest();
		}
		
		/**
		 * 中介者模式
		 * */
		private function mediatorFunc():void
		{
			var mediator:MediatorTest = new MediatorTest();
		}
		
		/**
		 * 策略模式
		 * */
		private function strategyFunc():void
		{
			var strategy:StrategyTest = new StrategyTest();
		}
		
		/**
		 * 解释器模式
		 * */
		private function interpreterFunc():void
		{
			var interpreter:InterpreterTest = new InterpreterTest();
		}
		
		/**
		 * 组合模式
		 * */
		private function compositeFunc():void
		{
			var composite:CompositeTest = new CompositeTest();
			this.addChild(composite);
		}
		
		/**
		 * 装饰者模式
		 * */
		private function decoratorFunc():void
		{
			var decorator:DecoratorTest = new DecoratorTest();
		}
		
		/**
		 * 备忘录模式
		 * */
		private function mementoFunc():void
		{
			var main1:MementoTest = new MementoTest();
		}
		
		/**
		 * 状态模式
		 * */
		private function stateFunc():void
		{
			var state:StateTest = new StateTest();
		}
		
		/**
		 * 访问者模式
		 * */
		private function visitorFunc():void
		{
			var visitor:VisitorTest = new VisitorTest();
		}
		
	}
}