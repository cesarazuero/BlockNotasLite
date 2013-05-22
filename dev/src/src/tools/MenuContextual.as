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
	public class MenuContextual extends Sprite 
	{
		private const tiempo:Number = 0.3;
		private const tiempoFin:Number = 0.1;
		private var evento:EventosMenu;
		private var textoEscalado:Boolean = false;
		private var hojaEscalada:Boolean = false;
		private var fotoEscalada:Boolean = false;
		private var dibujoEscalado:Boolean = true;
		private var mc:Sprite;
		
		public function MenuContextual() 
		{			
		}
		
		public function construirMenu(_x:Number, _y:Number, anchoStage:Number):void
		{
			//Primero ajusto el crop en Y.
			//85 es el resultado de sumear la altura del menu (74)
			//mas un margen (11).
			if (_y < 85)
			{
				mc = new menuGeneralInverso() as Sprite;
			}
			else
			{
				mc = new menuGeneral() as Sprite;
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
			
			mc.mcAddTexto.addEventListener(MouseEvent.CLICK, clickHandler);
			mc.mcAddTexto.scaleX = mc.mcAddTexto.scaleY = 0;
			TweenMax.to(mc.mcAddTexto, tiempo, { scaleX:1, scaleY:1, ease:Elastic.easeOut , onUpdate:progresoTexto } );
			
			mc.mcAddFoto.addEventListener(MouseEvent.CLICK, clickHandler);
			mc.mcAddFoto.scaleX = mc.mcAddFoto.scaleY = 0;				
			
			mc.mcAddDibujo.addEventListener(MouseEvent.CLICK, clickHandler);
			mc.mcAddDibujo.scaleX = mc.mcAddDibujo.scaleY = 0;				
				
			addChild(mc);
		}
		
		private function progresoTexto():void
		{
			if (mc.mcAddTexto.scaleX > 0.5 && !textoEscalado) {
				textoEscalado = true;
				TweenMax.to(mc.mcAddFoto, tiempo, { scaleX:1, scaleY:1, ease:Elastic.easeOut, onUpdate:progresoHoja } );
			}
		}
		
		private function progresoHoja():void
		{
			if (mc.mcAddFoto.scaleX > 0.5 && !hojaEscalada) {
				hojaEscalada = true;
				TweenMax.to(mc.mcAddDibujo, tiempo, { scaleX:1, scaleY:1, ease:Elastic.easeOut} );
			}
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			switch (e.currentTarget.name)
			{
				case "mcAddTexto":
					evento = new EventosMenu(EventosMenu.CREAR_TEXTO);
					dispatchEvent(evento);
					break;
				case "mcAddFoto":
					evento = new EventosMenu(EventosMenu.CREAR_FOTO);
					dispatchEvent(evento);
					break;
				case "mcAddDibujo":
					evento = new EventosMenu(EventosMenu.CREAR_DIBUJO);
					dispatchEvent(evento);
					break;
			}
			
			retirarMenu();
		}
		
		public function retirarMenu():void
		{			
			TweenMax.killTweensOf(mc.mcAddTexto);			
			TweenMax.killTweensOf(mc.mcAddFoto);
			TweenMax.killTweensOf(mc.mcAddDibujo);
			
			textoEscalado = true;
			hojaEscalada = true;
			fotoEscalada = true;
			
			TweenMax.to(mc.mcAddDibujo, tiempoFin, { scaleX:0, scaleY:0, onUpdate:saleDibujo } );
		}
		
		private function saleDibujo():void
		{
			if (mc.mcAddDibujo.scaleX < 0.5 && dibujoEscalado) 
			{
				dibujoEscalado = false;
				TweenMax.to(mc.mcAddFoto, tiempoFin, { scaleX:0, scaleY:0, onUpdate:saleFoto } );
			}
		}
		
		private function saleFoto():void
		{
			if (mc.mcAddFoto.scaleX < 0.5 && fotoEscalada) 
			{
				fotoEscalada = false;
				TweenMax.to(mc.mcAddTexto, tiempoFin, { scaleX:0, scaleY:0} );
			}
		}
		
		private function fin():void
		{
			mc.mcAddTexto.removeEventListener(MouseEvent.CLICK, clickHandler);			
			mc.mcAddFoto.removeEventListener(MouseEvent.CLICK, clickHandler);
			mc.mcAddDibujo.removeEventListener(MouseEvent.CLICK, clickHandler);
			
			removeChild(mc);
			parent.removeChild(this);
			mc = null;
			dibujoEscalado = null;
			fotoEscalada = null;
			hojaEscalada = null;			
		}		
	}
}