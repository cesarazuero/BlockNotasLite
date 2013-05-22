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
	public class MenuContextualEliminarFoto extends Sprite 
	{
		private const tiempo:Number = 0.2;
		private const tiempoFin:Number = 0.1;
		private var evento:EventosMenu;
		private var dibujoEscalado:Boolean = false;
		private var mc:Sprite;
		
		public function MenuContextualEliminarFoto() 
		{			
		}
		
		public function construirMenu(_x:Number, _y:Number, anchoStage:Number):void
		{
			//Primero ajusto el crop en Y.
			//85 es el resultado de sumear la altura del menu (74)
			//mas un margen (11).
			if (_y < 85)
			{
				mc = new menuEditarFotoInverso() as Sprite;
			}
			else
			{
				mc = new menuEditarFoto() as Sprite;
			}
			
			//Luego ajusto el crop en X
			//90 es el resultado del ancho / 2
			if (_x < 90)
			{
				mc.x = 95;
			}
			else if (_x > anchoStage - 90)
			{
				mc.x = anchoStage - 95;
			}
			else
			{
				mc.x = _x;
			}
			
			mc.y = _y;
			
			mc.mcEliminar.addEventListener(MouseEvent.CLICK, clickHandler);
			mc.mcEliminar.scaleX = mc.mcEliminar.scaleY = 0;
			TweenMax.to(mc.mcEliminar, tiempo, { scaleX:1, scaleY:1, ease:Elastic.easeOut} );
				
			addChild(mc);
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			switch (e.currentTarget.name) {	
				case "mcEliminar":
					evento = new EventosMenu(EventosMenu.ELIMINAR_FOTO);
					dispatchEvent(evento);
					break;
			}
			
			retirarMenu();
		}
		
		public function retirarMenu():void
		{
			TweenMax.killTweensOf(mc.mcEliminar);			
			
			TweenMax.to(mc.mcEliminar, tiempo, { scaleX:0, scaleY:0, onComplete:fin } );
		}
		
		private function fin():void
		{			
			mc.mcEliminar.removeEventListener(MouseEvent.CLICK, clickHandler);
			
			removeChild(mc);
			parent.removeChild(this);
			mc = null;
			colorEscalado = null;
		}		
	}
}