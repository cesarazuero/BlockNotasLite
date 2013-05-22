package tools 
{
	import constantes.Constantes;
	import eventos.TextEvent;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import ID.Componentes.ScrollBarID
	/**
	 * ...
	 * @author Cesar Azuero
	 */
	public class AddText extends TextField
	{	
		private var fuente:Font = new angelinaFont();		
		private var formato:TextFormat;	
		
		public  var txtTexto:TextField;
		
		public function AddText():void
		{
			/*NOTAS:
				 * En la ingresada del texto, cuando llega a la última linea sigue ingresando texto y se desplaza hacia
				 * arriba, investigar la manera en que se pueda bloquear la inserción de nuevas líneas de texto al
				 * campo de texto.
			*/
		}
		
		public function colocarTexto(ambito:DisplayObject, linea:uint):TextField
		{
			formato = new TextFormat();
			formato.font = fuente.fontName;
			formato.size = 20;
			formato.color = 0x666666;
			formato.leading = 6;
			
			txtTexto = new TextField();			
			txtTexto.embedFonts = true;
			txtTexto.antiAliasType = AntiAliasType.ADVANCED;
			txtTexto.gridFitType = GridFitType.PIXEL;			
			txtTexto.multiline = true;
			txtTexto.wordWrap = true;
			txtTexto.type = TextFieldType.INPUT;
			txtTexto.x = Constantes.MARGEN_IZQUIERDO + 10;			
			txtTexto.y = (Constantes.MARGEN_SUPERIOR + 5) * linea;
			txtTexto.width = ambito.mcPapel.width - Constantes.MARGEN_IZQUIERDO - 10;
			//Esta linea me ajusta el alto del texto a toda la hoja
			//txtTexto.height = (Constantes.CANTIDAD_LINEAS * Constantes.INTERLINEADO) - ((Constantes.MARGEN_SUPERIOR + 5) * linea);
			txtTexto.height = 15;
			txtTexto.defaultTextFormat = formato;
			
			txtTexto.addEventListener(FocusEvent.FOCUS_IN, focusIn);
			txtTexto.addEventListener(FocusEvent.FOCUS_OUT, focusOut);
			
			function focusIn(e:FocusEvent):void 
			{
				txtTexto.addEventListener(Event.CHANGE, cambia);
			}
			
			function focusOut(e:FocusEvent):void 
			{
				txtTexto.removeEventListener(Event.CHANGE, cambia);
			}
			
			function cambia(e:Event):void 
			{				
				var altoMax:Number = ((Constantes.MARGEN_SUPERIOR + 5) * linea) + (Constantes.CANTIDAD_LINEAS * Constantes.INTERLINEADO);
				
				if (txtTexto.y + txtTexto.height >= altoMax)
				{
					//SE SUPERA LOS LIMITES INFERIORES DEL MARGEN DE LA HOJA
				}		
				else
				{
					txtTexto.height = txtTexto.textHeight + 15;
				}
			}
			
			return txtTexto;
		}
	}
}