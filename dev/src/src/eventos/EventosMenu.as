package eventos 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Cesar Azuero
	 */
	public class EventosMenu extends Event 
	{
		public static const CREAR_TEXTO = "onCrearTexto";
		public static const CREAR_HOJA = "onCrearHoja";
		public static const CREAR_FOTO = "onCrearFoto";
		public static const CREAR_DIBUJO = "onCrearDibujo";
		public static const MENU_RETIRADO = "onMenuRetirado";
		public static const EDITAR_TEXTO = "onEditarTexto";
		public static const EDITAR_COLOR = "onEditarColor";
		public static const ELIMINAR_TEXTO = "onEliminarTexto";
		public static const EDITAR_DIBUJO = "onEditarDibujo";
		public static const ELIMINAR_FOTO = "onEliminarFoto";
		public static const SI = "onSi";
		public static const NO = "onNo";
		public static const ACEPTAR = "onAceptar";
		public static const CANCELAR = "onCancelar";
		
		public function EventosMenu(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
		}
		
	}

}