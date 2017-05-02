package cloud.core.interfaces
{
	import flash.display.Stage3D;

	/**
	 *  渲染对象接口
	 * @author cloud
	 */
	public interface IRenderAble
	{
		function render(stage3d:Stage3D):void;
	}
}