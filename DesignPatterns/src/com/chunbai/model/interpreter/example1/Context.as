package com.chunbai.model.interpreter.example1
{
	
	public class Context
	{
	    private var input:String;
	    private var output:String;
	    
	    public function Context()
		{
		    
	    }
	    
	    public function get Input():String
		{
		    return input;
	    }
	    
	    public function set Input(s:String):void
		{
		    input = s;
	    }
	    
	    public function get Output():String
		{
		    return output;
	    }
	    
	    public function set Output(s:String):void
		{
		    output = s;
	    }
		
	}
}