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
	public class MenuGuardar extends Sprite 
	{
		private const tiempo:Number = 0.3;
		private const tiempoFin:Number = 0.1;
		private var evento:EventosMenu;
		private var mc:Sprite;
		
		public function MenuGuardar() 
		{			
		}
		
		public function construirMenu(_x:Number, _y:Number, anchoStage:Number, finStart:Function):void
		{
			mc = new mcAlertaGuardar();
			mc.x = _x;
			mc.y = _y;
			
			mc.btnAceptar.addEventListener(MouseEvent.CLICK, clickHandler);
			mc.btnCancelar.addEventListener(MouseEvent.CLICK, clickHandler);
			mc.scaleX = 0;
			mc.scaleY = 0;
			mc.alpha = 1;
				
			addChild(mc);
			
			TweenMax.to(mc, 0.3, {scaleX:1, scaleY:1, alpha:1, onComplete:finStart});
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			e.stopPropagation();
			
			switch (e.currentTarget.name){
				case "btnAceptar":
					evento = new EventosMenu(EventosMenu.ACEPTAR);
					dispatchEvent(evento);
					break;
				case "btnCancelar":
					evento = new EventosMenu(EventosMenu.CANCELAR);
					dispatchEvent(evento);
					break;
			}
			
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