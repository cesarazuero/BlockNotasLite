package eventos 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Cesar Azuero
	 */
	public class DibujoEvent extends Event 
	{
		public static const DIBUJO_HECHO:String = "onPictureDone";
		public static const DIBUJO_CANCELADO:String = "onPictureCanceled";
		
		public function DibujoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);			
		} 
		
		public override function clone():Event 
		{ 
			return new DibujoEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("DibujoEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}