package eventos 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Cesar Azuero
	 */
	public class EventosEnvio extends Event 
	{
		public static const ACEPTAR = "onAceptar";
		public static const CANCELAR = "onCancelar";
		
		public var data:*;
		
		public function EventosEnvio(type:String, _data:*, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			this.data = _data;
			super(type, bubbles, cancelable);
		}
		
	}

}