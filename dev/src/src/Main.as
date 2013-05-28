package 
{
	import com.adobe.images.JPGEncoder;
	import com.greensock.TweenMax;
	import eventos.DibujoEvent;
	import eventos.EventosMenu;
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.filesystem.File;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.html.ResourceLoader;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.ReturnKeyLabel;
	import flash.text.TextField;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.ByteArray;
	import idiomas.Idiomas;
	import tools.AlertaGeneral;
	import tools.MenuGuardar;
	import tools.NativeText;
	import flash.text.SoftKeyboardType;
	
	/**
	 * ...
	 * @author Cesar Azuero
	 */
	public class Main extends Sprite 
	{		
		public var nt:NativeText;		
		public var guardado:Boolean = true;
		
		private var vectorHojas:Vector.<MovieClip> = new Vector.<MovieClip>;
		private var mcHoja:MovieClip;
		private var cantHojas:uint = 0;
		private var hojaActual:uint = 1;		
		private var dbFile:File;
		private var id_archivo:uint = 0;
		private var id_hoja:uint = 0;
		private var nombreArchivo:String = "";
		
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);	
			
			addEventListener(Event.ADDED_TO_STAGE, ini);
			
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			/*
			 * Aca se debe captar el idioma con Capabilities, este es de prueba
			 */
			Idiomas.setIdioma("en");
			//Idiomas.setIdioma(Capabilities.language);
			var hoja:MovieClip = new mcHojaBase();
				addChild(hoja);
		}
		
		private function deactivate(e:Event):void 
		{
			// auto-close
			//NativeApplication.nativeApplication.exit();
		}
		
		private function ini(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, ini);
		}
		
		public function crearNativeText(cantLineas:uint, cadena:String = null, ancho:Number = 0, posX:Number = 0, posY:Number = 0, maxChars:uint = 5, cambiar:Boolean = false, nombre:String = ""):void
		{
			//Esta funcion se encarga de crear una instancia de NativeText y colocarla
			//en el stage ya que sólo funciona colocandola en el root
			
			nt = new NativeText(cantLineas);
			nt.returnKeyLabel = ReturnKeyLabel.DONE;
			nt.autoCorrect = true;			
			nt.borderThickness = 0;
			nt.fontFamily = "_sans";
			nt.fontSize = 20;
			nt.borderColor = 0x000000;
			
			if (cadena) 
			{
				nt.text = cadena;
			}
			else
			{
				nt.text = Idiomas.DIGITA_TEXTO;
			}
			
			nt.color = 0x000000;
			nt.width = ancho;
			nt.maxChars = maxChars;			
			nt.x = posX;
			nt.y = posY;
			nt.addEventListener(FocusEvent.FOCUS_IN, foco);
			
			if (cambiar)
			{
				if (nombre == "to")
				{					
					nt.addEventListener(FocusEvent.FOCUS_OUT, focusOutTo);					
				}
				else if (nombre == "from")
				{
					nt.addEventListener(FocusEvent.FOCUS_OUT, focusOutFrom);
				}
				else if (nombre == "nombreRemitente")
				{
					nt.addEventListener(FocusEvent.FOCUS_OUT, focusOutNombreRemitente);
				}
				else if (nombre == "nombreDestinatario")
				{
					nt.addEventListener(FocusEvent.FOCUS_OUT, focusOutNombreDestinatario);
				}
				
				nt.softKeyboardType = SoftKeyboardType.EMAIL;
				nt.name = nombre;
			}
			
			addChild(nt);
		}
		
		private function foco(e:FocusEvent):void 
		{
			e.currentTarget.text = "";
		}
		
		private function focusOutTo(e:FocusEvent):void 
		{
			if (e.currentTarget.text == "")
			{
				e.currentTarget.text = Idiomas.DESTINATARIO;
			}	
		}
		
		private function focusOutFrom(e:FocusEvent):void 
		{
			if (e.currentTarget.text == "")
			{
				e.currentTarget.text = Idiomas.REMITENTE;
			}	
		}
		
		private function focusOutNombreRemitente(e:FocusEvent):void 
		{
			if (e.currentTarget.text == "")
			{
				e.currentTarget.text = Idiomas.NOMBRE_REMITENTE;
			}	
		}
		
		private function focusOutNombreDestinatario(e:FocusEvent):void 
		{
			if (e.currentTarget.text == "")
			{
				e.currentTarget.text = Idiomas.NOMBRE_DESTINATARIO;
			}	
		}
	}	
}