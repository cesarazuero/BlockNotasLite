package movieclips
{
	import com.greensock.TweenMax;
	import eventos.EventosColor;
	import flash.display.BitmapData;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Cesar Azuero
	 */
	public class ColorPicker extends Sprite 
	{
		public var mcColores:Sprite;
		public var mcColor:Sprite;
		public var btnCancelar:SimpleButton;
		public var btnOk:SimpleButton;
		
		private var colorSeleccionado:Number = 0;
		
		public function ColorPicker():void
		{
			mcColores.addEventListener(MouseEvent.MOUSE_DOWN, escoje);
			btnCancelar.addEventListener(MouseEvent.CLICK, clickHandler);
			btnOk.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			switch (e.currentTarget.name){
				case "btnCancelar":
					var evt:EventosColor = new EventosColor(EventosColor.COLOR_SELECCIONADO, null);
					dispatchEvent(evt);
					close();
					break;
				case "btnOk":
					var evt:EventosColor = new EventosColor(EventosColor.COLOR_SELECCIONADO, colorSeleccionado);
					dispatchEvent(evt);
					colorSeleccionado = null;
					mcColores.removeEventListener(MouseEvent.MOUSE_DOWN, escoje);
					btnCancelar.removeEventListener(MouseEvent.CLICK, clickHandler);
					btnOk.removeEventListener(MouseEvent.CLICK, clickHandler);
					close();
					break;
			}
		}
		
		private function escoje(e:MouseEvent):void 
		{
			var bmpd:BitmapData = new BitmapData(mcColores.width, mcColores.height, true, 0xFFFFFF);
				bmpd.draw(mcColores);
			colorSeleccionado = bmpd.getPixel(mcColores.mouseX, mcColores.mouseY);
			
			if (colorSeleccionado != 0)
			{
				var ct:ColorTransform = mcColor.transform.colorTransform;
					ct.color = colorSeleccionado;
					mcColor.transform.colorTransform = ct;
				
			}			
		}
		
		private function close():void
		{
			TweenMax.to(this, 0.5, { scaleX:0, scaleY:0, alpha:0, onComplete:cerrar});
		}
		
		private function cerrar():void
		{
			parent.removeChild(this);
		}
	}
	
}