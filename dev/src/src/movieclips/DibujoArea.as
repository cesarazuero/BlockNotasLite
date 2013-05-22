package movieclips
{
	import com.greensock.easing.Back;
	import com.greensock.TweenMax;
	import eventos.DibujoEvent;
	import eventos.EventosColor;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.ObjectEncoding;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Cesar Azuero
	 */
	public class DibujoArea extends Sprite
	{
		public var btnOk:SimpleButton;
		public var btnCancelar:SimpleButton;
		public var btnColor:SimpleButton;
		public var btnPincel1:SimpleButton;
		public var btnPincel2:SimpleButton;
		public var btnPincel3:SimpleButton;
		public var mcFondoDibujo:MovieClip;
		public var mcIndicadorPincel1:MovieClip;
		public var mcIndicadorPincel2:MovieClip;
		public var mcIndicadorPincel3:MovieClip;
		public var mcLienzo:MovieClip;
		public var mcLienzoBonito:MovieClip;
		public var vectorObj:Vector.<Object> = new Vector.<Object>;
		
		private var pincelSize:uint = 14;
		private var colorPincel:Number = 0x000000;
		private var pincelActivo:MovieClip;
		private var coordAnt:Point = new Point();
		private var lineArray: Array = [];
		private var currentPointArray: Array;
		private var currentIndex: int = 0;		
		
		
		public function DibujoArea():void 
		{
			addEventListener(Event.ADDED_TO_STAGE, ini);			
		}
		
		private function ini(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, ini);
			
			open();
			agregarListeners();
			pincelActivo = mcIndicadorPincel1;
			pincelActivo.nextFrame();
			
			mcLienzoBonito = new mcLienzoBonitoBase();
			mcLienzoBonito.name = "mcLienzoBonito";
			mcLienzoBonito.x = -232;
			mcLienzoBonito.y = -257;
			addChild(mcLienzoBonito);
			
			mcLienzo.mouseChildren = false;
			mcLienzo.mouseEnabled = false;
			
			mcLienzoBonito.mouseChildren = false;
			mcLienzoBonito.mouseEnabled = false;
		}
		
		private function agregarListeners():void
		{			
			btnOk.addEventListener(MouseEvent.CLICK, clickHandler);
			btnCancelar.addEventListener(MouseEvent.CLICK, clickHandler);
			btnColor.addEventListener(MouseEvent.CLICK, clickHandler);
			btnPincel1.addEventListener(MouseEvent.CLICK, clickHandler);
			btnPincel2.addEventListener(MouseEvent.CLICK, clickHandler);
			btnPincel3.addEventListener(MouseEvent.CLICK, clickHandler);
			
			mcFondoDibujo.addEventListener(MouseEvent.MOUSE_DOWN, startDraw);
		}
		
		private function removerListeners():void
		{			
			btnOk.removeEventListener(MouseEvent.CLICK, clickHandler);
			btnCancelar.removeEventListener(MouseEvent.CLICK, clickHandler);
			btnColor.removeEventListener(MouseEvent.CLICK, clickHandler);
			btnPincel1.removeEventListener(MouseEvent.CLICK, clickHandler);
			btnPincel2.removeEventListener(MouseEvent.CLICK, clickHandler);
			btnPincel3.removeEventListener(MouseEvent.CLICK, clickHandler);
			
			mcFondoDibujo.removeEventListener(MouseEvent.MOUSE_DOWN, startDraw);
		}
		
		private function open():void
		{
			this.scaleX = 0;
			this.scaleY = 0;
			TweenMax.to(this, 0.5, { scaleX:1, scaleY:1, ease:Back.easeOut, onComplete:function() 
				{
					if (vectorObj.length > 1)
					{
						//Si este vector no está vacío es porque se va a modificar un dibujo
						dibujar(vectorObj);
					}
				}
			});
		}
		
		private function startDraw(e:MouseEvent):void 
		{
			mcFondoDibujo.removeEventListener(MouseEvent.MOUSE_DOWN, startDraw);
			mcFondoDibujo.addEventListener(MouseEvent.MOUSE_MOVE, onDraw);
			stage.addEventListener(MouseEvent.MOUSE_UP, endDraw);
			
			mcLienzo.graphics.lineStyle(pincelSize, colorPincel, 1, true, "normal", CapsStyle.ROUND, "round", 8);			
			mcLienzo.graphics.moveTo(mcFondoDibujo.mouseX, mcFondoDibujo.mouseY);
			coordAnt = new Point(mcFondoDibujo.mouseX, mcFondoDibujo.mouseY);
			currentIndex = 0;
			currentPointArray = new Array();
			lineArray = new Array();
			lineArray.push(currentPointArray);
			
			var obj:Object = new Object();
				obj.x = mcFondoDibujo.mouseX;
				obj.y = mcFondoDibujo.mouseY;
				obj.pincelSize = pincelSize;
				obj.colorPincel = colorPincel;
				obj.nuevo = true;
			
			vectorObj.push(obj);
		}
		
		private function onDraw(e:MouseEvent):void 
		{
			mcLienzo.graphics.lineTo(mcFondoDibujo.mouseX, mcFondoDibujo.mouseY);
			coordAnt = new Point(mcFondoDibujo.mouseX, mcFondoDibujo.mouseY);
			
			currentPointArray[currentIndex] = coordAnt;
			currentIndex ++;
			
			var obj:Object = new Object();
				obj.x = mcFondoDibujo.mouseX;
				obj.y = mcFondoDibujo.mouseY;
				obj.nuevo = false;
				
			vectorObj.push(obj);
		}
		
		private function endDraw(e:MouseEvent):void 
		{
			mcFondoDibujo.addEventListener(MouseEvent.MOUSE_DOWN, startDraw);
			mcFondoDibujo.removeEventListener(MouseEvent.MOUSE_MOVE, onDraw);
			stage.removeEventListener(MouseEvent.MOUSE_UP, endDraw);
			smoothLines();
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			switch (e.currentTarget.name)
			{
				case "btnOk":					
					/*var rect:Rectangle = mcLienzoBonito.getBounds(mcLienzoBonito);					
					
					var bmpd:BitmapData = new BitmapData(mcFondoDibujo.width, mcFondoDibujo.height, true, 0xFF0000);
						bmpd.draw(mcLienzoBonito);					
					var bmpd2:BitmapData = new BitmapData(rect.width, rect.height, true, 0xFFFFFF);
						bmpd2.copyPixels(bmpd, rect, new Point(0, 0));
					var bmp:Bitmap = new Bitmap(bmpd2);
						bmp.x = - bmp.width * 0.5;
						bmp.y = - bmp.height * 0.5;
					var ret:MovieClip = new MovieClip();
						ret.name = "mcDibujo";
						ret.addChild(bmp);
						ret.x = stage.stageWidth * 0.5;
						ret.y = stage.stageHeight * 0.5;*/
						
					close(mcLienzoBonito);
					break;
				case "btnCancelar":
					close();
					break;
				case "btnColor":
					removerListeners();
					
					var mc:Sprite = new mcColorPicker();
						mc.x = stage.stageWidth * 0.5;
						mc.y = stage.stageHeight * 0.5;
						mc.addEventListener(EventosColor.COLOR_SELECCIONADO, onColor);
						parent.addChild(mc);
					break;
				case "btnPincel1":
					if (pincelActivo != mcIndicadorPincel1)
					{
						pincelActivo.prevFrame();
						pincelSize = 14;
						pincelActivo = mcIndicadorPincel1;
						pincelActivo.nextFrame();
					}
					break;
				case "btnPincel2":
					if (pincelActivo != mcIndicadorPincel2)
					{
						pincelActivo.prevFrame();
						pincelSize =22;
						pincelActivo = mcIndicadorPincel2;
						pincelActivo.nextFrame();
					}
					break;
				case "btnPincel3":
					if (pincelActivo != mcIndicadorPincel3)
					{
						pincelActivo.prevFrame();
						pincelSize =28;
						pincelActivo = mcIndicadorPincel3;
						pincelActivo.nextFrame();
					}
					break;
			}
			
			e.stopPropagation();
		}
		
		private function onColor(e:EventosColor):void 
		{
			if (e.data != null)
			{
				colorPincel = e.data;
			}
			
			agregarListeners();
		}
		
		public function close(mc:MovieClip = null ):void
		{
			if (!mc)
			{
				TweenMax.to(this, 0.5, { scaleX: 0, scaleY:0, ease:Back.easeIn, onComplete:cerrar} );
			}
			else
			{
				TweenMax.to(this, 0.5, { scaleX: 0, scaleY:0, ease:Back.easeIn, onComplete:cerrar, onCompleteParams:[mc] } );
			}
		}
		
		private function cerrar(mc:MovieClip = null):void
		{
			var gr:Graphics = mcLienzo.graphics;
				gr.clear();			
				
			if (mc)
			{	
				var rect:Rectangle = mc.getBounds(mc);
				var mcDibujo:MovieClip = new MovieClip();
					mcDibujo.addChild(mc);
					mc.x = -rect.x -(rect.width * 0.5);
					mc.x = -rect.y -(rect.height * 0.5);
					mcDibujo.name = "mcDibujo";
				
				mcDibujo.addEventListener(TransformGestureEvent.GESTURE_ROTATE, parent.rotar);
				mcDibujo.addEventListener(TransformGestureEvent.GESTURE_ZOOM, parent.escalar);
				mcDibujo.addEventListener(TransformGestureEvent.GESTURE_PAN, parent.pan);
				mcDibujo.addEventListener(MouseEvent.MOUSE_DOWN, parent.startTimerClick);
				mcDibujo.mouseEnabled = true;
				mcDibujo.mouseChildren = false;
				mcDibujo.x = stage.stageWidth * 0.5;
				mcDibujo.y = stage.stageHeight * 0.5;
				mcDibujo.vector = vectorObj;
				
				//Testeo para ver si es una modificacion o es una creacion				
				
				if (parent.mcTarget)
				{					
					mcDibujo.scaleX = parent.mcTarget.scaleX;
					mcDibujo.scaleY = parent.mcTarget.scaleY;
					mcDibujo.x = parent.mcTarget.x;
					mcDibujo.y = parent.mcTarget.y;
					mcDibujo.rotation = parent.mcTarget.rotation;
					parent.mcTarget.removeEventListener(TransformGestureEvent.GESTURE_ROTATE, parent.rotar);
					parent.mcTarget.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, parent.escalar);
					parent.mcTarget.removeEventListener(TransformGestureEvent.GESTURE_PAN, parent.pan);
					parent.mcTarget.removeEventListener(MouseEvent.MOUSE_DOWN, parent.startTimerClick);
					parent.removeChild(parent.mcTarget);
					parent.mcTarget = null;					
				}
				
				var rect:Rectangle = mcDibujo.getBounds(mcDibujo);
				var relleno:Sprite = new Sprite();
					relleno.graphics.beginFill(0xFF0000, 0);				//Aca se pone el color rojo de fondo
					relleno.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
					relleno.graphics.endFill();
				mcDibujo.addChild(relleno);				
				
				parent.addChild(mcDibujo);				
				
				var evt:DibujoEvent = new DibujoEvent(DibujoEvent.DIBUJO_HECHO);
					dispatchEvent(evt);
			}
			else
			{
				var evt2:DibujoEvent = new DibujoEvent(DibujoEvent.DIBUJO_CANCELADO);
					dispatchEvent(evt2);
			}
			
			this.visible = false;
			parent.removeChild(this);
		}
		
		private function smoothLines():void 
		{
			var h:Graphics = mcLienzo.graphics;
				h.clear();
			var g: Graphics = mcLienzoBonito.graphics;
				//g.clear();
			var line: Array;
			var p1: Point;
			var p2: Point;
			var prevMidPoint: Point;
			var midPoint: Point;
			var skipPoints: int = 2; //default 2			
			
			for (var j: int = 0; j < lineArray.length; j++) 
			{
				line = lineArray[j];
				g.lineStyle(pincelSize, colorPincel, 1);
				prevMidPoint = null;
				midPoint = null;
				
				for (var i: int = skipPoints; i < line.length; i++)
				{
					if (i % skipPoints == 0) 
					{
						p1 = line[i - skipPoints];
						p2 = line[i];
						
						midPoint = new Point(p1.x + (p2.x - p1.x) / 2, p1.y + (p2.y - p1.y) / 2);
						
						// draw the curves:
						if (prevMidPoint) 
						{
							g.moveTo(prevMidPoint.x,prevMidPoint.y);
							g.curveTo(p1.x, p1.y, midPoint.x, midPoint.y);
						}
						else 
						{
							// draw start segment:
							g.moveTo(p1.x, p1.y);
							g.lineTo(midPoint.x,midPoint.y);
						}
						prevMidPoint = midPoint;
					} 
					//draw last stroke
					if (i == line.length - 1)
					{
						g.lineTo(line[i].x,line[i].y);
					}
				}
			}
		}
		
		public function dibujar(vect:Vector.<Object>):void
		{			
			for (var i:uint = 0; i < vect.length; i++ )				
			{					
				if (vect[i].nuevo)					
				{	
					currentIndex = 0;
					currentPointArray = new Array();
					lineArray = new Array();
					lineArray.push(currentPointArray);
					
					mcLienzo.graphics.lineStyle(uint(vect[i].pincelSize), vect[i].colorPincel, 1, true, "normal", CapsStyle.ROUND, "round", 8);						
					mcLienzo.graphics.moveTo(vect[i].x, vect[i].y);
					coordAnt = new Point(vect[i].x, vect[i].y);
					colorPincel = vect[i].colorPincel;
					pincelSize = vect[i].pincelSize;
					
					//trace("En nuevo: "+mcLienzo.width+"   "+mcLienzo.height);
				}
				else
				{						
					currentPointArray[currentIndex] = coordAnt;
					currentIndex ++;
					mcLienzo.graphics.lineTo(vect[i].x, vect[i].y);
					coordAnt = new Point(vect[i].x, vect[i].y);
					
					if (i + 1 < vect.length && vect[i+1].nuevo)
					{
						smoothLines();
					}
					else if (i + 1 == vect.length)						
					{
						smoothLines();
					}
				}
			}		
		}
	}
	
}