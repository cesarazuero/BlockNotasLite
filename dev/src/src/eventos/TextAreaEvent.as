package eventos 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Cesar Azuero
	 */
	public class TextAreaEvent extends Event 
	{
		public static const TEXTO_INGRESADO:String = "onTextoIngresado";
		public static const TEXTO_CANCELADO:String = "onTextoCancelado";
		
		public var data:*;
		
		public function TextAreaEvent(type:String, _data:*, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.data = _data;
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new TextAreaEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("TextAreaEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}