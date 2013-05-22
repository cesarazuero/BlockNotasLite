package movieclips 
{
	import eventos.TextAreaEvent;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import idiomas.Idiomas;
	
	/**
	 * ...
	 * @author Cesar Azuero
	 */
	public class TextArea extends Sprite 
	{
		public var btnAceptar:MovieClip;
		public var btnCancelar:MovieClip;
		
		public function TextArea() 
		{
			btnAceptar.txtLabel.text = Idiomas.ACEPTAR;
			btnAceptar.addEventListener(MouseEvent.CLICK, crearTexto);
			btnCancelar.txtLabel.text = Idiomas.CANCELAR;
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