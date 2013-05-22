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
	public class MenuAlerta extends Sprite 
	{
		private const tiempo:Number = 0.3;
		private const tiempoFin:Number = 0.1;
		private var evento:EventosMenu;
		private var mc:Sprite;
		
		public function MenuAlerta() 
		{			
		}
		
		public function construirMenu(_x:Number, _y:Number, anchoStage:Number):void
		{
			//Primero ajusto el crop en Y.
			//85 es el resultado de sumar la altura del menu (74)
			//mas un margen (11).
			mc = new mcAlertaConfirm();
			
			if (_y < 85)
			{
				mc.mcFondo.scaleY = -1;
			}
			
			//Luego ajusto el crop en X
			//90 es el resultado del ancho / 2
			if (_x < 124)
			{
				mc.x = 130;
			}
			else if (_x > anchoStage - 124)
			{
				mc.x = anchoStage - 130;
			}
			else
			{
				mc.x = _x;
			}
			
			mc.y = _y;
			
			mc.btnSi.addEventListener(MouseEvent.CLICK, clickHandler);
			mc.btnNo.addEventListener(MouseEvent.CLICK, clickHandler);
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
				case "btnSi":
					evento = new EventosMenu(EventosMenu.SI);
					dispatchEvent(evento);
					break;
				case "btnNo":
					evento = new EventosMenu(EventosMenu.NO);
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
			mc.btnSi.removeEventListener(MouseEvent.CLICK, clickHandler);
			mc.btnNo.removeEventListener(MouseEvent.CLICK, clickHandler);
			
			removeChild(mc);
			parent.removeChild(this);
			mc = null;
		}
		
		public function setTexto(cadena:String, si:String, no:String):void
		{
			mc.txtTexto.text = cadena;
			mc.btnSi.txtLabel.text = si;
			mc.btnNo.txtLabel.text = no;
		}
	}
}