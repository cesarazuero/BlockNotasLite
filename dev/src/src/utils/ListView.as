package utils
{
	import com.greensock.easing.Back;
	import com.greensock.TweenLite;
	import fl.events.ListEvent;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Cesar Azuero
	 */
	
	public class ListView extends Sprite 
	{	
		private var posX:Number = 0;
		private var posY:Number = 0;
		private var ancho:Number = 0;
		private var alto:Number = 0;
		private var altoItem:Number = 0;
		private var colorIdle:Number = 0;
		private var colorActivo:Number = 0;
		private var mcContenedor:Sprite = null;
		private var espaciado:Number = 0;
		private var cantItems:uint = 0;	
		private var mcActivo:Sprite = null;
		private var timer:Timer = new Timer(50);
		private var posIniY:Number = 0;
		private var enableDrag:Boolean = false;
		
		public function ListView(_x:Number, _y:Number, _ancho:Number, _alto:Number, _altoItem:Number, _colorIdle:Number, _colorActivo:Number, _espaciado:Number, _padre:DisplayObject, _btnCancelar:Class) 
		{
			//Almaceno las variables "globales"
			ancho = _ancho;
			alto = _alto;
			altoItem = _altoItem;
			colorIdle = _colorIdle;
			colorActivo = _colorActivo;
			espaciado = _espaciado;
			posX = _x;
			posY = _y;
			
			//Creo el fondo
			this.graphics.beginFill(0x000000, 0.4);
			this.graphics.drawRect(0, 0, _padre.width, _padre.height);
			this.graphics.endFill();
			
			//Creo el contenedor del menú
			mcContenedor = new Sprite();
			mcContenedor.x = _x;
			mcContenedor.y = _y;
			
			//Creo el boton de cancelar
			var btn:SimpleButton = new _btnCancelar();
				btn.x = _x + _ancho - btn.width;
				btn.y = _y -btn.height -10;
				btn.name = "cerrar";
			
			addChild(mcContenedor);
			addChild(btn);
			
			addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		public function addItem(texto:String, data:*):void
		{
			var mc:MovieClip = renderItem(texto) as MovieClip;
				mc.name = "item" + cantItems;
				mc.data = data;
				mc.y = (mc.height + espaciado) * cantItems;				
				
			mcContenedor.addChild(mc);
			
			cantItems++;
			
			updateMask();
		}
		
		private function renderItem(_texto:String):MovieClip
		{
			var mc:MovieClip = new MovieClip();
				mc.mouseChildren = false;
			var fondo:Sprite = new Sprite();
				fondo.name = "fondo";
				fondo.graphics.beginFill(colorIdle, 0.6);
				fondo.graphics.drawRect(0, 0, ancho, altoItem);
				fondo.graphics.endFill();			
			var formato:TextFormat = new TextFormat();
				formato.font = "tahoma";
				formato.color = 0x000000;
				formato.align = "left";
				formato.size = 16;
			var texto:TextField = new TextField();
				texto.defaultTextFormat = formato;
				texto.text = _texto;
				texto.width = texto.textWidth +5;
				texto.height = texto.textHeight +5;
			
			mc.addChild(fondo);
			mc.addChild(texto);
			
			return mc;
		}
		
		private function downHandler(e:MouseEvent):void
		{			
			if (e.target && e.target.name != "cerrar" && e.target.name != "list")
			{
				var tc:ColorTransform = Sprite(e.target.getChildByName("fondo")).transform.colorTransform;
					tc.color = colorActivo;				
				Sprite(e.target.getChildByName("fondo")).transform.colorTransform = tc;
				
				if (enableDrag)
				{
					var h:Number = mcContenedor.height - alto;
					
					mcContenedor.startDrag(false, new Rectangle(posX, posY - h, 0, h));				
					stage.addEventListener(MouseEvent.MOUSE_MOVE, moverHandler);				
					
					posIniY = mouseY;
				}
				
				mcActivo = e.target;
				stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
				timer.start();
			}
			else
			{
				cerrar();
			}
		}
		
		private function moverHandler(e:MouseEvent):void 
		{
			var tc:ColorTransform = Sprite(mcActivo.getChildByName("fondo")).transform.colorTransform;
				tc.color = colorIdle;			
			Sprite(mcActivo.getChildByName("fondo")).transform.colorTransform = tc;
		}
		
		private function upHandler(e:MouseEvent):void
		{			
			var tc:ColorTransform = Sprite(mcActivo.getChildByName("fondo")).transform.colorTransform;
				tc.color = colorIdle;			
			Sprite(mcActivo.getChildByName("fondo")).transform.colorTransform = tc;
			
			mcContenedor.stopDrag();
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, moverHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			
			if (timer.currentCount < 3)
			{				
				//Si el tiempo entre DOWN y UP es muy corto, despacho el click
				var evt:ListViewEvent = new ListViewEvent(ListViewEvent.ITEM_SELECTED, e.target.data);
				dispatchEvent(evt);
				timer.stop();
			}
			
			var desplazamiento:Number = posIniY - mouseY;
			var posicion:Number = mcContenedor.y - desplazamiento;
			
			if (posicion > posY)
			{
				posicion = posY;
			}
			else if (posicion < posY - (mcContenedor.height - alto))
			{
				posicion = posY - (mcContenedor.height - alto);
			}
			
			TweenLite.to(mcContenedor, 0.5, { y:posicion, ease:Back.easeOut } );
			
			timer.reset();
		}
		
		private function updateMask():void
		{	
			if (mcContenedor.height > alto && !getChildByName("mask"))
			{
				var mask:Sprite = new Sprite();
					mask.name = "mask";
					mask.x = posX;
					mask.y = posY;
					mask.graphics.beginFill(0xFFFFFF, 0);
					mask.graphics.drawRect(0, 0, ancho, alto);
					mask.graphics.endFill();
					
				addChild(mask);				
				mcContenedor.mask = mask;
				enableDrag = true;
			}
			else
			{
				enableDrag = false;
			}
		}
		
		private function destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		}
		
		private function cerrar():void
		{
			var evt:ListViewEvent = new ListViewEvent(ListViewEvent.CANCELED, null);
				dispatchEvent(evt);
		}
	}
}