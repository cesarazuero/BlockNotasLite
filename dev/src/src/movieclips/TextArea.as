package movieclips 
{
	import eventos.TextAreaEvent;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Cesar Azuero
	 */
	public class TextArea extends Sprite 
	{
		public var btnAceptar:SimpleButton;
		public var btnCancelar:SimpleButton;
		
		public function TextArea() 
		{
			btnAceptar.addEventListener(MouseEvent.CLICK, crearTexto);
			btnCancelar.addEventListener(MouseEvent.CLICK, cerrarTextArea);
			
			addEventListener(Event.ADDED_TO_STAGE, ini);
		}
		
		private function ini(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, ini);
		}
		
		private function crearTexto(e:MouseEvent):void 
		{
			if (root.nt.text != "")
			{
				btnAceptar.removeEventListener(MouseEvent.CLICK, crearTexto);
				btnCancelar.removeEventListener(MouseEvent.CLICK, cerrarTextArea);
				
				var evt:TextAreaEvent = new TextAreaEvent(TextAreaEvent.TEXTO_INGRESADO, root.nt.text);
					dispatchEvent(evt);
			}
		}
		
		private function cerrarTextArea(e:MouseEvent):void 
		{
			btnAceptar.removeEventListener(MouseEvent.CLICK, crearTexto);
			btnCancelar.removeEventListener(MouseEvent.CLICK, cerrarTextArea);
			
			var evt:TextAreaEvent = new TextAreaEvent(TextAreaEvent.TEXTO_CANCELADO, "");
				dispatchEvent(evt);
		}
		
	}

}