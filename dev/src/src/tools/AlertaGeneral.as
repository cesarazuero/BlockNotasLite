package tools 
{
	import com.greensock.easing.Elastic;
	import com.greensock.TweenMax;
	import eventos.EventosMenu;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Cesar Azuero
	 */
	public class AlertaGeneral extends Sprite 
	{
		private const tiempo:Number = 0.3;
		private const tiempoFin:Number = 0.1;
		private var evento:EventosMenu;
		private var mc:Sprite;
		
		public function AlertaGeneral() 
		{			
		}
		
		public function construirMenu(_x:Number, _y:Number, anchoStage:Number, texto:String, tipo:String, verAceptar:Boolean = true, verCancelar:Boolean = true):void
		{
			mc = new mcAlertaGeneral();
			mc.x = _x;
			mc.y = _y;
			mc.txtTexto.text = texto;
			
			//Para mostrar botones si/no o aceptar/cancelar paso la variable tipo
			switch (tipo) 
			{
				case "si/no":
					mc.btnAceptar.visible = false;
					mc.btnCancelar.visible = false;
					mc.btnSi.visible = true;
					mc.btnNo.visible = true;
					break;
				case "aceptar/cancelar":
					mc.btnAceptar.visible = true;
					mc.btnCancelar.visible = true;
					mc.btnSi.visible = false;
					mc.btnNo.visible = false;
					break;
			}
			
			if (verAceptar && tipo == "aceptar/cancelar")
			{
				mc.btnAceptar.addEventListener(MouseEvent.CLICK, clickHandler);
			}
			else if (verAceptar && tipo == "si/no")
			{
				mc.btnSi.addEventListener(MouseEvent.CLICK, clickHandler);
			}
			else if (!verAceptar && tipo == "aceptar/cancelar")
			{
				mc.btnAceptar.visible = false;
				mc.btnAceptar.removeEventListener(MouseEvent.CLICK, clickHandler);
			}
			else if (!verAceptar && tipo == "si/no")
			{
				mc.btnSi.visible = false;
				mc.btnSi.removeEventListener(MouseEvent.CLICK, clickHandler);
			}
			
			if (verCancelar && tipo == "aceptar/cancelar")
			{
				mc.btnCancelar.addEventListener(MouseEvent.CLICK, clickHandler);
			}
			else if (verCancelar && tipo == "si/no")
			{
				mc.btnNo.addEventListener(MouseEvent.CLICK, clickHandler);
			}
			else if (!verCancelar && tipo == "aceptar/cancelar")
			{
				mc.btnCancelar.visible = false;
				mc.btnCancelar.removeEventListener(MouseEvent.CLICK, clickHandler);
			}
			else if (!verCancelar && tipo == "si/no")
			{
				mc.btnNo.visible = false;
				mc.btnNo.removeEventListener(MouseEvent.CLICK, clickHandler);
			}
			
			mc.scaleX = 0;
			mc.scaleY = 0;
			mc.alpha = 1;
				
			addChild(mc);
			
			TweenMax.to(mc, 0.3, {scaleX:1, scaleY:1, alpha:1});
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			e.stopPropagation();
			
			switch (e.currentTarget.name){
				case "btnAceptar":
					evento = new EventosMenu(EventosMenu.ACEPTAR);					
					break;
				case "btnCancelar":
					evento = new EventosMenu(EventosMenu.CANCELAR);
					break;
				case "btnSi":
					evento = new EventosMenu(EventosMenu.SI);
					break;
				case "btnNo":
					evento = new EventosMenu(EventosMenu.NO);
					break;
			}
			
			dispatchEvent(evento);
			
			retirarMenu();
		}
		
		public function retirarMenu():void 
		{
			TweenMax.to(mc, 0.3, { scaleX:0, scaleY:0, alpha:0, onComplete:fin } );
		}
		
		private function fin():void
		{
			mc.btnAceptar.removeEventListener(MouseEvent.CLICK, clickHandler);
			mc.btnCancelar.removeEventListener(MouseEvent.CLICK, clickHandler);
			
			removeChild(mc);
			parent.removeChild(this);
			mc = null;
		}
		
		public function setTexto(cadena:String):void
		{
			mc.txtTexto.text = cadena;
		}
	}
}