package eventos 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Cesar Azuero
	 */
	public class TextEvent extends Event 
	{		
		public static const CAMBIAR_HOJA:String = "onCambiaHoja";
		
		public function TextEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
		}
		
	}

}