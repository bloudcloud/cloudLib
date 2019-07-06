/**
 * This license does NOT supersede the original license of GPC.  Please see:
 * http://www.cs.man.ac.uk/~toby/alan/software/#Licensing
 *
 * This license does NOT supersede the original license of SEISW GPC Java port.  Please see:
 * http://www.seisw.com/GPCJ/GpcjLicenseAgreement.txt
 *
 * Copyright (c) 2009, Jakub Kaniewski, jakub.kaniewsky@gmail.com
 * BMnet software http://www.bmnet.pl/
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *   - Neither the name of the BMnet software nor the
 *     names of its contributors may be used to endorse or promote products
 *     derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY JAKUB KANIEWSKI, BMNET ''AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL JAKUB KANIEWSKI, BMNET BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package 
{
	import flash.utils.describeType;
	
	public class TestCase
	{
		public var logFunction : Function = function(msg:String):void{trace(msg);};
		public var resultFunction : Function = function(result:Boolean):void{};
		public var assertEqualsFunction : Function = null;
		
		public function TestCase()
		{
		}
		
		 public function assertEquals(o1:Object, o2:Object):void{
		 	if (assertEqualsFunction!=null) assertEqualsFunction(o1,o2);
		 	try{
		 		if ((o1==o2)||(o1["equals"](o2))){
		 			logFunction("Passed - expected "+o2.toString()+" has "+o1.toString());
		 			resultFunction(true);
		 			return;
		 		}
		 	} catch (e:Error){};
		 	logFunction("Not passed - expected "+o2.toString()+" has "+o1.toString());
		 	resultFunction(false);
		 }
		 
		 public function assertTrue(val:Boolean):void{
		 	if (val){
		 		logFunction("Passed - is true");
		 		resultFunction(true);
		 		return;
		 	}
		 	logFunction("Not passed - is false");
		 	resultFunction(false);
		 }
		 
		 
		 public function assertFalse(val:Boolean):void{
		 	if (!val){
		 		logFunction("Passed - is false");
		 		resultFunction(true);
		 		return;
		 	}
		 	logFunction("Not passed - is true");
		 	resultFunction(false);
		 }
		 
		 public function get methods():Array{
		 	var description:XML = describeType(this);
			var methods:Array = [];
			for each (var method : XML in description.method){
				var name : String = method.@name.toString();
				if (name.indexOf("test")==0){
					methods.push(name);
				}		
			}
   			methods=methods.sort();
   			return methods;
		 }
		 
		 
		 public function runTest():void{
   			
   			for each (var methodName : String in methods){
   				logFunction("Executing method "+methodName);
   				this[methodName]();
   			}
		 }

	}
}
