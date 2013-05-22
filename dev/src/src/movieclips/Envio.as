package movieclips 
{
	import eventos.EventosEnvio;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	import idiomas.Idiomas;
	import tufik.helps.StringHelp;
	
	/**
	 * ...
	 * @author 
	 */
	public class Envio extends MovieClip 
	{
		public var mcMailTo:Sprite;
		public var mcNombreTo:Sprite;
		public var mcMailFrom:Sprite;
		public var mcNombreFrom:Sprite;
		public var btnEnviar:MovieClip;
		public var btnCancelar:MovieClip;
		public var txtAlerta:TextField;
		
		private var stringHelp = new StringHelp();	
		
		public function Envio() 
		{
			addEventListener(Event.ADDED_TO_STAGE, ini);
		}
		
		private function ini(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, ini);
			
			btnEnviar.txtLabel.text = Idiomas.ENVIAR;
			btnCancelar.txtLabel.text = Idiomas.CANCELAR;
			btnEnviar.addEventListener(MouseEvent.CLICK, clickHandler);
			btnCancelar.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			var evento:EventosEnvio;
			
			switch (e.currentTarget.name) 
			{
				case "btnEnviar":
					var validado:Object = new Object();
						validado.estado = true;
						validado.fuente = "to";
					
					if (root.getChildByName("nombreDestinatario").text == "" || root.getChildByName("nombreDestinatario").text == Idiomas.NOMBRE_DESTINATARIO)
					{
						validado.estado = false;
						validado.fuente = "nombreDestinatario";
					}
					else if (root.getChildByName("nombreRemitente").text == "" || root.getChildByName("nombreRemitente").text == Idiomas.NOMBRE_REMITENTE)
					{
						validado.estado = false;
						validado.fuente = "nombreRemitente";
					}					
					else if (root.getChildByName("to").text == "")
					{
						validado.estado = false;
						validado.fuente = "to";
					}
					else if (!stringHelp.validarEmail(root.getChildByName("to").text))
					{
						validado.estado = false;
						validado.fuente = "to";
					}
					else if (root.getChildByName("from").text == "")
					{
						validado.estado = false;
						validado.fuente = "from";
					}
					else if (!stringHelp.validarEmail(root.getChildByName("from").text))
					{
						validado.estado = false;
						validado.fuente = "from";
					}
					
					if (!validado.estado)
					{
						if (validado.fuente == "to")
						{
							txtAlerta.text = Idiomas.ADDRESSEE_EMAIL_NOT_VALID;
						}
						else if(validado.fuente == "from")
						{
							txtAlerta.text = Idiomas.SENDER_EMAIL_NOT_VALID;
						}
						else if(validado.fuente == "nombreRemitente")
						{
							txtAlerta.text = Idiomas.SENDER_NAME_EMPTY;
						}
						else if(validado.fuente == "nombreDestinatario")
						{
							txtAlerta.text = Idiomas.ADDRESSEE_NAME_EMPTY;
						}
					}
					else
					{
						txtAlerta.text = Idiomas.SENDING;
						validado.remitente = root.getChildByName("from").text;
						validado.destinatario = root.getChildByName("to").text;
						validado.nombreDestinatario = root.getChildByName("nombreDestinatario").text;
						validado.nombreRemitente = root.getChildByName("nombreRemitente").text;
						retirarListeners();
						
						var timer:Timer = new Timer(1000);
							timer.addEventListener(TimerEvent.TIMER, tick);
							timer.start();
					}
					break;
				case "btnCancelar":
					evento = new EventosEnvio(EventosEnvio.CANCELAR, null);
					dispatchEvent(evento);
					break;
			}
			
			function tick(e:TimerEvent):void
			{
				e.currentTarget.stop();
				evento = new EventosEnvio(EventosEnvio.ACEPTAR, validado);
					dispatchEvent(evento);
			}
		}
		
		public function habilitar():void
		{
			txtAlerta.text = "";
			root.crearNativeText(1, Idiomas.REMITENTE, mcMailFrom.width, this.x + mcMailFrom.x, this.y + mcMailFrom.y, 50, true, "from");
			root.crearNativeText(1, Idiomas.DESTINATARIO, mcMailTo.width, this.x + mcMailTo.x, this.y + mcMailTo.y, 50, true, "to");
			root.crearNativeText(1, Idiomas.NOMBRE_REMITENTE, mcNombreFrom.width, this.x + mcNombreFrom.x, this.y + mcNombreFrom.y, 50, true, "nombreRemitente");
			root.crearNativeText(1, Idiomas.NOMBRE_DESTINATARIO, mcNombreTo.width, this.x + mcNombreTo.x, this.y + mcNombreTo.y, 50, true, "nombreDestinatario");
		}
		
		public function deshabilitar():void
		{
			root.removeChild(root.getChildByName("to"));
			root.removeChild(root.getChildByName("from"));
			root.removeChild(root.getChildByName("nombreRemitente"));
			root.removeChild(root.getChildByName("nombreDestinatario"));
		}
		
		public function retirarListeners():void
		{
			btnEnviar.removeEventListener(MouseEvent.CLICK, clickHandler);
			btnCancelar.removeEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		public function agregarListeners():void
		{
			btnEnviar.addEventListener(MouseEvent.CLICK, clickHandler);
			btnCancelar.addEventListener(MouseEvent.CLICK, clickHandler);
		}
	}

}