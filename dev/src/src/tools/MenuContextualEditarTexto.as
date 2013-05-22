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
	public class MenuContextualEditarTexto extends Sprite 
	{
		private const tiempo:Number = 0.2;
		private const tiempoFin:Number = 0.1;
		private var evento:EventosMenu;
		private var textoEscalado:Boolean = false;
		private var hojaEscalada:Boolean = false;
		private var fotoEscalada:Boolean = false;
		private var dibujoEscalado:Boolean = true;
		private var mc:Sprite;
		
		public function MenuContextualEditarTexto() 
		{			
		}
		
		public function construirMenu(_x:Number, _y:Number, anchoStage:Number):void
		{
			//Primero ajusto el crop en Y.
			//85 es el resultado de sumear la altura del menu (74)
			//mas un margen (11).
			if (_y < 85)
			{
				mc = new menuEditarTextoInverso() as Sprite;
			}
			else
			{
				mc = new menuEditarTexto() as Sprite;
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
			
			mc.mcEditarTexto.addEventListener(MouseEvent.CLICK, clickHandler);
			mc.mcEditarTexto.scaleX = mc.mcEditarTexto.scaleY = 0;
			TweenMax.to(mc.mcEditarTexto, tiempo, { scaleX:1, scaleY:1, ease:Elastic.easeOut , onUpdate:progresoTexto } );
			
			mc.mcEditarColor.addEventListener(MouseEvent.CLICK, clickHandler);
			mc.mcEditarColor.scaleX = mc.mcEditarColor.scaleY = 0;				
			
			mc.mcEliminar.addEventListener(MouseEvent.CLICK, clickHandler);
			mc.mcEliminar.scaleX = mc.mcEliminar.scaleY = 0;	
				
				
			addChild(mc);
		}
		
		private function progresoTexto():void
		{
			if (mc.mcEditarTexto.scaleX > 0.5 && !textoEscalado) {
				textoEscalado = true;
				TweenMax.to(mc.mcEditarColor, tiempo, { scaleX:1, scaleY:1, ease:Elastic.easeOut, onUpdate:progresoHoja } );
			}
		}
		
		private function progresoHoja():void
		{
			if (mc.mcEditarColor.scaleX > 0.5 && !hojaEscalada) {
				hojaEscalada = true;
				TweenMax.to(mc.mcEliminar, tiempo, { scaleX:1, scaleY:1, ease:Elastic.easeOut} );
			}
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			switch (e.currentTarget.name){
				case "mcEditarTexto":
					evento = new EventosMenu(EventosMenu.EDITAR_TEXTO);
					dispatchEvent(evento);
					break;
				case "mcEditarColor":
					evento = new EventosMenu(EventosMenu.EDITAR_COLOR);
					dispatchEvent(evento);
					break;
				case "mcEliminar":
					evento = new EventosMenu(EventosMenu.ELIMINAR_TEXTO);
					dispatchEvent(evento);
					break;
			}
			
			retirarMenu();
		}
		
		public function retirarMenu():void
		{
			TweenMax.killTweensOf(mc.mcEditarTexto);
			TweenMax.killTweensOf(mc.mcEditarColor);
			TweenMax.killTweensOf(mc.mcEliminar);
			
			textoEscalado = true;
			hojaEscalada = true;			
			
			TweenMax.to(mc.mcEliminar, tiempo, { scaleX:0, scaleY:0, onUpdate:saleDibujo } );
		}
		
		private function saleDibujo():void
		{
			if (mc.mcEliminar.scaleX < 0.5 && textoEscalado) 
			{
				textoEscalado = false;
				TweenMax.to(mc.mcEditarColor, tiempoFin, { scaleX:0, scaleY:0, onUpdate:saleFoto } );
			}
		}
		
		private function saleFoto():void
		{
			if (mc.mcEditarColor.scaleX < 0.5 && hojaEscalada) 
			{
				hojaEscalada = false;
				TweenMax.to(mc.mcEditarTexto, tiempoFin, { scaleX:0, scaleY:0, onComplete:fin } );
			}
		}
		
		private function fin():void
		{
			mc.mcEditarTexto.removeEventListener(MouseEvent.CLICK, clickHandler);
			mc.mcEditarColor.removeEventListener(MouseEvent.CLICK, clickHandler);
			mc.mcEliminar.removeEventListener(MouseEvent.CLICK, clickHandler);
			
			removeChild(mc);
			parent.removeChild(this);
			mc = null;
			dibujoEscalado = null;
			fotoEscalada = null;
		}		
	}
}