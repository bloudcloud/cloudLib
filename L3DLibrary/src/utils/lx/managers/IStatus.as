package utils.lx.managers
{
	public interface IStatus
	{
		function get name():String;
		function get isRunning():Boolean;
		function setup():void;
		function reset():void;
	}
}