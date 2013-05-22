package eventos
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Cesar Azuero
	 */
	public class EventosColor extends Event 
	{
		public static const COLOR_SELECCIONADO = "onColor";
		public var data:*;
		
		public function EventosColor(type:String, _data:*, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			this.data = _data;
			super(type, bubbles, cancelable);
		}
		
	}

}