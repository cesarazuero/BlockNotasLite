package movieclips 
{	
	import clases.eventos.TextAreaEvent;
	import clases.tools.MenuContextual;		
	import utils.JPEGEncoder;
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.greensock.TweenMax;	
	import eventos.DibujoEvent;
	import eventos.EventosColor;
	import eventos.EventosEnvio;
	import eventos.EventosMenu;
	import eventos.TextAreaEvent;
	import eventos.TextEvent;
	import files.UploadPostHelper;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;		
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.GesturePhase;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.media.MediaPromise;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.system.System;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import idiomas.Idiomas;
	import tools.AddText;
	import tools.MenuAlerta;
	import tools.MenuContextual;
	import flash.media.CameraRoll;
	import flash.media.CameraRollBrowseOptions;
	import flash.events.MediaEvent;
	import tools.MenuContextualEditarDibujo;
	import tools.MenuContextualEditarTexto;
	import tools.MenuContextualEliminarFoto;
	
	/**
	 * ...
	 * @author Cesar Azuero
	 * 
	 * En este moviclip quedan creados los mc's mcTexto, para recrear los dibujos,
	 * el trazado quedan en vectorObj y las fotos quedan en mcFoto
	 * 
	 */
	public class Hoja extends MovieClip 
	{
		const color:Number = 0x999999;		
		
		public var mcPapel:MovieClip;
		public var vectorObj:Vector.<Object>;
		public var mcTarget:Sprite;		
		public var btnSend:MovieClip;
		public var mcEnvio:MovieClip;
		
		private var menuActivo:Sprite = null;
		private var loader:Loader;
		private var timerMenu:Timer = new Timer(5000);
		private var timerClick:Timer = new Timer(100);
		private var timerSend:Timer = new Timer(10000);
		private var urlRequest:URLRequest;
		private var urlLoader:URLLoader;
		
		public function Hoja() 
		{
			addEventListener(Event.ADDED_TO_STAGE, ini);
		}
		
		private function ini(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, ini);
			activarHoja();
			
			timerMenu.addEventListener(TimerEvent.TIMER, tickMenu);
			timerSend.addEventListener(TimerEvent.TIMER, tickSend);
			
			btnSend.addEventListener(MouseEvent.CLICK, enviar);
			
			btnSend.txtLabel.text = Idiomas.ENVIAR;
		}
		
		public function activarHoja():void
		{
			mcPapel.addEventListener(MouseEvent.CLICK, clickHandlerHoja);
		}
		
		public function desactivarHoja():void
		{
			mcPapel.removeEventListener(MouseEvent.CLICK, clickHandlerHoja);
		}
		
		public function clickHandlerHoja(e:MouseEvent):void
		{	
			e.stopPropagation();
			
			if (menuActivo)
			{					
				menuActivo.retirarMenu();	
				menuActivo = null;
			}
			
			var menu:MenuContextual = new MenuContextual();
				menu.name = "inicio";
				menu.construirMenu(mouseX, mouseY, stage.stageWidth);
				//Las coordenadas X y Y vienen de la clase Menu contextual.
				menu.addEventListener(EventosMenu.CREAR_TEXTO, llamarTextArea);
				menu.addEventListener(EventosMenu.CREAR_DIBUJO, crearDibujo);
				menu.addEventListener(EventosMenu.CREAR_FOTO, crearFoto);				
				menuActivo = menu;
				addChild(menu);
				
			mcTarget = null;
			
			timerMenu.reset();
			timerMenu.start();
		}
		
		public function decodificarClick(e:DisplayObject):void 
		{
			if (menuActivo)
			{	
				menuActivo.retirarMenu();
				menuActivo = null;
			}
			
			switch (e.name)
			{
				case "txtTexto":
					var menu2:MenuContextualEditarTexto = new MenuContextualEditarTexto();
						menu2.name = "modificacion";
						menu2.construirMenu(mouseX, mouseY, stage.stageWidth);
						//Las coordenadas X y Y vienen de la clase Menu contextual.
						menu2.addEventListener(EventosMenu.EDITAR_TEXTO, llamarTextArea);
						menu2.addEventListener(EventosMenu.EDITAR_COLOR, editarColor);
						menu2.addEventListener(EventosMenu.ELIMINAR_TEXTO, eliminar);
						menuActivo = menu2;
						addChild(menu2);
						mcTarget = e.parent;
					break;
				case "mcDibujo":
					var menu3:MenuContextualEditarDibujo = new MenuContextualEditarDibujo();
						menu3.name = "modificacionDibujo";
						menu3.construirMenu(mouseX, mouseY, stage.stageWidth);
						menu3.addEventListener(EventosMenu.EDITAR_DIBUJO, crearDibujo);
						menu3.addEventListener(EventosMenu.EDITAR_COLOR, editarColor);
						menu3.addEventListener(EventosMenu.ELIMINAR_TEXTO, eliminar);
						menuActivo = menu3;
						addChild(menu3);
						mcTarget = e;
					break;
				case "mcFoto":
					var menu4:MenuContextualEliminarFoto = new MenuContextualEliminarFoto();
						menu4.name = "eliminarFoto";
						menu4.construirMenu(mouseX, mouseY, stage.stageWidth);
						menu4.addEventListener(EventosMenu.ELIMINAR_FOTO, eliminar);
						menuActivo = menu4;
						addChild(menu4);
						mcTarget = e;
					break;
			}
			
			timerMenu.reset();
			timerMenu.start();
		}
		
		private function editarColor(e:EventosMenu):void 
		{
			desactivarHoja();
			timerMenu.stop();
			
			var mc:Sprite = new mcColorPicker();
				mc.x = stage.stageWidth * 0.5;
				mc.y = stage.stageHeight * 0.5;
				mc.addEventListener(EventosColor.COLOR_SELECCIONADO, onColor);
			addChild(mc);
			
			menuActivo = null;
			
			function onColor(e:EventosColor):void 
			{
				if (e.data != null)
				{
					var ct:ColorTransform = mcTarget.transform.colorTransform;
						ct.color = e.data;
					mcTarget.transform.colorTransform = ct;
					
					//Cambio el color del vector
					if (mcTarget.vector)
					{
						for (var i:uint = 0; i < mcTarget.vector.length; i++ )
						{							
							if (mcTarget.vector[i].colorPincel != undefined)
							{
								mcTarget.vector[i].colorPincel = e.data;
							}
						}
					}
				}
				activarHoja();
			}
		}
		
		private function eliminar(e:EventosMenu):void 
		{		
			desactivarHoja();
			timerMenu.stop();
			
			var menu:MenuAlerta = new MenuAlerta();				
				menu.construirMenu(mouseX, mouseY, stage.stageWidth);
				//Las coordenadas X y Y vienen de la clase Menu contextual.
				menu.addEventListener(EventosMenu.SI, eliminarConfirmado);
				menu.addEventListener(EventosMenu.NO, eliminarCancelado);
				addChild(menu);
			
			menuActivo = null;
			
			switch (e.currentTarget.name)
			{
				case "modificacion":
					menu.setTexto(Idiomas.DELETE_TEXT);
					break;
				case "modificacionDibujo":
					menu.setTexto(Idiomas.DELETE_DRAWING);
					break;
				case "eliminarFoto":
					menu.setTexto(Idiomas.DELETE_PHOTO);
					break;
			}
				
			function eliminarConfirmado(e:EventosMenu)
			{
				menu.removeEventListener(EventosMenu.SI, eliminarConfirmado);
				menu.removeEventListener(EventosMenu.NO, eliminarCancelado);
				
				mcTarget.removeEventListener(TransformGestureEvent.GESTURE_ROTATE, rotar);
				mcTarget.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, escalar);
				mcTarget.removeEventListener(TransformGestureEvent.GESTURE_PAN, pan);
				mcTarget.removeEventListener(MouseEvent.MOUSE_DOWN, startTimerClick);
				removeChild(mcTarget);
				mcTarget = null;
				System.gc();
				activarHoja();
			}
			
			function eliminarCancelado(e:EventosMenu)
			{
				menu.removeEventListener(EventosMenu.SI, eliminarConfirmado);
				menu.removeEventListener(EventosMenu.NO, eliminarCancelado);
				
				activarHoja();
			}
		}
		
		private function llamarTextArea(e:EventosMenu):void 
		{
			desactivarHoja();
			timerMenu.stop();
			
			var tipo:String = "";
			var mc:Sprite;
				mc = new mcTextArea();
				mc.x = stage.stageWidth * 0.5;
				mc.y = stage.stageHeight * 0.5;
				mc.scaleX = mc.scaleY = 0;
				mc.scaleX = mc.scaleY = 1;
				mc.name = "textArea";
				mc.addEventListener(TextAreaEvent.TEXTO_INGRESADO, textoIngresado);
				mc.addEventListener(TextAreaEvent.TEXTO_CANCELADO, textoCancelado);
				mc.addEventListener(Event.REMOVED_FROM_STAGE, destroy);
				
			TweenMax.to(mc, 0.5, {scaleX:1, scaleY:1, ease:Back.easeOut, onComplete:llamarNativeText});
				
			addChild(mc);
			menuActivo = null;
			
			function llamarNativeText()
			{
				if (e.currentTarget.name == "inicio")
				{
					//root.crearNativeText();
					root.crearNativeText(7, null, 357, stage.stageWidth * 0.5 - (357 * 0.5), stage.stageHeight * 0.5 - (250 * 0.5), 200);
					tipo = "inicio";
				}
				else
				{
					//root.crearNativeText(mcTarget.txtTexto.text);
					root.crearNativeText(7, mcTarget.txtTexto.text, 357, stage.stageWidth * 0.5 - (357 * 0.5), stage.stageHeight * 0.5 - (250 * 0.5), 200);
					tipo = "otro";
				}
			}
			
			function textoIngresado(e:TextAreaEvent)
			{
				mc.removeEventListener(TextAreaEvent.TEXTO_INGRESADO, textoIngresado);
				mc.removeEventListener(TextAreaEvent.TEXTO_CANCELADO, textoCancelado);
				
				//Creo el texto, y le paso como referencia el mc de ingreso
				//de texto con el proposito de cambiar alturas
				if (tipo == "inicio")
				{
					crearTexto(e.data, mc);
				}
				else
				{
					crearTexto(e.data, mc, true);
				}
				
				retirarTextArea();
				
				activarHoja();
			}
			
			function textoCancelado(e:TextAreaEvent)
			{	
				retirarTextArea();
				
				activarHoja();
			}
			
			function retirarTextArea()
			{
				root.removeChild(root.nt);
				root.nt = null;
				TweenMax.to(mc, 0.5, { scaleX:0, scaleY:0, ease:Back.easeIn, onComplete:function() {
					removeChild(getChildByName("textArea"));
					activarHoja();
					mc = null;
				}});
			}
			
			function destroy(e:Event)
			{
				mc.removeEventListener(TextAreaEvent.TEXTO_INGRESADO, textoIngresado);
				mc.removeEventListener(TextAreaEvent.TEXTO_CANCELADO, textoCancelado);
			}
		}
		
		private function crearTexto(cadena:String, destino:Sprite, reemplazar:Boolean = false):void
		{
			parent.guardado = false;
			
			if (!reemplazar)
			{
				var mc:Sprite = new mcTexto();
					mc.name = "mcTexto";
					mc.txtTexto.text = cadena;
					mc.txtTexto.width = mc.txtTexto.textWidth + 5;				
					
					if (mc.txtTexto.width < 120)
					{
						mc.mcFondo.width = 120;
					}
					else
					{
						mc.mcFondo.width = mc.txtTexto.width;
					}				
					
					mc.txtTexto.height = mc.txtTexto.textHeight + 5;
					mc.mcFondo.height = mc.txtTexto.height;
					
					mc.txtTexto.x = -mc.txtTexto.width * 0.5;
					mc.txtTexto.y = -mc.txtTexto.height * 0.5;
					
					mc.mcFondo.x = mc.txtTexto.x -((mc.mcFondo.width - mc.txtTexto.width) * 0.5);
					mc.mcFondo.y = mc.txtTexto.y;
					
					mc.x = stage.stageWidth * 0.5;
					mc.y = stage.stageHeight * 0.5;
				
				addChild(mc);
				addChild(destino);
				
				mc.addEventListener(TransformGestureEvent.GESTURE_ROTATE, rotar);
				mc.addEventListener(TransformGestureEvent.GESTURE_ZOOM, escalar);
				mc.addEventListener(TransformGestureEvent.GESTURE_PAN, pan);				
				mc.addEventListener(MouseEvent.MOUSE_DOWN, startTimerClick);
			}
			else
			{
				mcTarget.txtTexto.text = cadena;
				mcTarget.txtTexto.width = mcTarget.txtTexto.textWidth + 5;				
				
				if (mcTarget.txtTexto.width < 120)
				{
					mcTarget.mcFondo.width = 120;
				}
				else
				{
					mcTarget.mcFondo.width = mcTarget.txtTexto.width;
				}				
				
				mcTarget.txtTexto.height = mcTarget.txtTexto.textHeight + 5;
				mcTarget.mcFondo.height = mcTarget.txtTexto.height;
			}
		}
		
		public function startTimerClick(e:MouseEvent):void
		{			
			var tgt:DisplayObject = e.target;
			
			timerClick.reset();
			timerClick.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, stopTimerClick);
			
			function stopTimerClick(e:MouseEvent)
			{
				timerClick.stop();
				stage.removeEventListener(MouseEvent.MOUSE_UP, stopTimerClick);
				
				if (timerClick.currentCount < 3)
				{
					decodificarClick(tgt);
				}
			}
		}
		
		private function crearDibujo(e:EventosMenu):void 
		{			
			desactivarHoja();
			timerMenu.stop();
			
			var mc:Sprite = new mcDibujo();
			
			if (e.currentTarget.name != "inicio")
			{
				mc.vectorObj = mcTarget.vector;
			}
			
			mc.x = stage.stageWidth * 0.5;
			mc.y = stage.stageHeight * 0.5;
			mc.name = "dibujo";
			mc.addEventListener(DibujoEvent.DIBUJO_HECHO, dibujoOk);
			mc.addEventListener(DibujoEvent.DIBUJO_CANCELADO, dibujoCancelado);
				
			addChild(mc);
			menuActivo = null;
		}
		
		private function dibujoOk(e:DibujoEvent):void 
		{
			parent.guardado = false;
			activarHoja();
		}
		
		private function dibujoCancelado(e:DibujoEvent):void 
		{
			activarHoja();
		}
		
		private function crearFoto(e:EventosMenu):void
		{
			timerMenu.stop();
			menuActivo = null;
			//root.debug("Se pide crear foto");
			if ((CameraRoll.supportsBrowseForImage == false) || (CameraRoll.supportsAddBitmapData == false))
			{				
				return;
			}
			
			desactivarHoja();
			
			var cro:CameraRollBrowseOptions = new CameraRollBrowseOptions();
				cro.height = this.stage.stageHeight / 3;
				cro.width = this.stage.stageWidth / 3;
				cro.origin = new Rectangle(0, 0, 200, 200);
				
			var cr:CameraRoll = new CameraRoll();
				cr.addEventListener(MediaEvent.SELECT, imagenSeleccionada);
				cr.addEventListener(Event.CANCEL, imagenCancelada);
				cr.addEventListener(ErrorEvent.ERROR, imagenError);								
				cr.browseForImage(cro);
				
			function imagenSeleccionada(e:MediaEvent):void
			{	
				var promise:MediaPromise = e.data as MediaPromise;
				
				cr.removeEventListener(MediaEvent.SELECT, imagenSeleccionada);
				cr.removeEventListener(Event.CANCEL, imagenCancelada);
				cr.removeEventListener(ErrorEvent.ERROR, imagenError);
				
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
				loader.contentLoaderInfo.addEventListener(ErrorEvent.ERROR, onError);
				loader.loadFilePromise(promise);
			}
			
			function onImageLoaded(event:Event):void 
			{
				var isPortrait:Boolean;
				var bitmapData:BitmapData = Bitmap(event.currentTarget.content).bitmapData;					
				var bitmap:Bitmap = new Bitmap(bitmapData);				
				var contenedor:Sprite = new Sprite();
					contenedor.name = "mcFoto";					
				
				if (bitmapData.height > bitmapData.width)
				{
					isPortrait=true;
				}
				else 
				{
					isPortrait=false;
				}
				
				var ratio:Number;
				
				if (isPortrait)
				{
					ratio = Math.min(stage.stageHeight / bitmapData.width, stage.stageWidth / bitmapData.height);					
					ratio = Math.min(ratio, 1);
					bitmap.width = bitmapData.width * ratio;
					bitmap.height = bitmapData.height * ratio;					
					bitmap.rotation = -90;
				} 
				else 
				{
					ratio = Math.min(stage.stageHeight / bitmapData.height, stage.stageWidth / bitmapData.width);					
					ratio = Math.min(ratio, 1);
					bitmap.width = bitmapData.width * ratio;
					bitmap.height = bitmapData.height * ratio;					
				}
				
				
				bitmap.x = -bitmap.width * 0.5;
				bitmap.y = -bitmap.height * 0.5;
				contenedor.rotation = 90;
				contenedor.mouseChildren = false;
				contenedor.addChild(bitmap);
				contenedor.x = stage.stageWidth * 0.5;
				contenedor.y = stage.stageHeight * 0.5;				
				contenedor.addEventListener(TransformGestureEvent.GESTURE_ROTATE, rotar);
				contenedor.addEventListener(TransformGestureEvent.GESTURE_ZOOM, escalar);
				contenedor.addEventListener(TransformGestureEvent.GESTURE_PAN, pan);
				contenedor.addEventListener(MouseEvent.MOUSE_DOWN, startTimerClick);
				
				addChild(contenedor);
				
				activarHoja();
				
				parent.guardado = false;
			}
			
			function imagenCancelada(e:Event):void
			{
				cr.removeEventListener(MediaEvent.SELECT, imagenSeleccionada);
				cr.removeEventListener(Event.CANCEL, imagenCancelada);
				cr.removeEventListener(ErrorEvent.ERROR, imagenError);
				
				activarHoja();
			}
			
			function imagenError(e:ErrorEvent):void
			{
				cr.removeEventListener(MediaEvent.SELECT, imagenSeleccionada);
				cr.removeEventListener(Event.CANCEL, imagenCancelada);
				cr.removeEventListener(ErrorEvent.ERROR, imagenError);
				
				activarHoja();
			}
			
			function onError(e:Event):void
			{
				cr.removeEventListener(MediaEvent.SELECT, imagenSeleccionada);
				cr.removeEventListener(Event.CANCEL, imagenCancelada);
				cr.removeEventListener(ErrorEvent.ERROR, imagenError);
				
				activarHoja();
			}
		}
		
		public function pan(e:TransformGestureEvent)
		{			
			tickMenu(null);
			e.currentTarget.x += e.offsetX;
			e.currentTarget.y += e.offsetY;

			if (e.phase == GesturePhase.BEGIN)
			{
				e.currentTarget.removeEventListener(MouseEvent.MOUSE_DOWN, startTimerClick);
			}
			else if(e.phase == GesturePhase.END)
			{
				e.currentTarget.addEventListener(MouseEvent.MOUSE_DOWN, startTimerClick);
			}
		}
		
		public function rotar(e:TransformGestureEvent)
		{
			tickMenu(null);
			e.currentTarget.rotation += e.rotation;
			
			if (e.phase == GesturePhase.BEGIN)
			{
				e.currentTarget.removeEventListener(MouseEvent.MOUSE_DOWN, startTimerClick);
			}
			else if(e.phase == GesturePhase.END)
			{
				e.currentTarget.addEventListener(MouseEvent.MOUSE_DOWN, startTimerClick);
			}
		}
		
		public function escalar(e:TransformGestureEvent)
		{
			tickMenu(null);
			e.currentTarget.scaleX *= e.scaleX;				
			e.currentTarget.scaleY *= e.scaleY;
			
			if (e.phase == GesturePhase.BEGIN)
			{
				e.currentTarget.removeEventListener(MouseEvent.MOUSE_DOWN, startTimerClick);
			}
			else if(e.phase == GesturePhase.END)
			{
				e.currentTarget.addEventListener(MouseEvent.MOUSE_DOWN, startTimerClick);
			}
		}
		
		private function tickMenu(e:TimerEvent):void
		{
			timerMenu.stop();
			
			if (menuActivo)
			{					
				menuActivo.retirarMenu();
				menuActivo = null;
			}
		}
		
		public function eliminarListeners():void
		{
			for (var i:uint = 0; i < this.numChildren; i++ )
			{
				var mc:DisplayObject;
					mc = this.getChildAt(i);
					
				if (mc.name == "mcFoto" || mc.name == "mcTexto" || mc.name == "mcDibujo")
				{					
					mc.removeEventListener(TransformGestureEvent.GESTURE_ROTATE, rotar);
					mc.removeEventListener(TransformGestureEvent.GESTURE_ZOOM, escalar);
					mc.removeEventListener(TransformGestureEvent.GESTURE_PAN, pan);
					mc.removeEventListener(MouseEvent.MOUSE_DOWN, startTimerClick);
				}
			}
			
			desactivarHoja();
			
			btnSave.removeEventListener(MouseEvent.CLICK, guardar);
			
			//Elimino el dialogo de guardar cada vez que se cambie de pagina
			if (getChildByName("textArea"))
			{
				root.removeChild(root.nt);
				root.nt = null;
				TweenMax.to(getChildByName("textArea"), 0.5, { scaleX:0, scaleY:0, ease:Back.easeIn, onComplete:function() {
					removeChild(getChildByName("textArea"));
					activarHoja();
				}});
				
				activarHoja();
			}
		}
		
		public function agregarListeners():void
		{
			for (var i:uint = 0; i < this.numChildren; i++ )
			{
				var mc:DisplayObject;
					mc = this.getChildAt(i);
					
				if (mc.name == "mcFoto" || mc.name == "mcTexto" || mc.name == "mcDibujo")
				{					
					mc.addEventListener(TransformGestureEvent.GESTURE_ROTATE, rotar);
					mc.addEventListener(TransformGestureEvent.GESTURE_ZOOM, escalar);
					mc.addEventListener(TransformGestureEvent.GESTURE_PAN, pan);
					mc.addEventListener(MouseEvent.MOUSE_DOWN, startTimerClick);
				}
			}
			
			activarHoja();
			
			btnSave.addEventListener(MouseEvent.CLICK, guardar);
		}
		
		private function enviar(e:MouseEvent):void
		{
			desactivarHoja();
			
			TweenMax.to(btnSend, 0.5, { y:1032, onComplete:function() {
				TweenMax.to(mcEnvio, 0.5, { y:824.4, onComplete:function() {
					mcEnvio.habilitar();
					mcEnvio.addEventListener(EventosEnvio.ACEPTAR, hacerEnvio);
					mcEnvio.addEventListener(EventosEnvio.CANCELAR, cerrarEnvio);
				}});
			}});
		}
		
		private function hacerEnvio(e:EventosEnvio):void
		{
			mcEnvio.visible = false;
			var bmpd:BitmapData = new BitmapData(this.width, this.height - 70, false, 0x000000);		//70 es la altura del boton enviar
				bmpd.draw(this);
			var jpgStream:ByteArray = new JPEGEncoder(80).encode(bmpd);
			mcEnvio.visible = true;
			
			urlRequest = new URLRequest();
			urlLoader = new URLLoader();
			urlRequest.url = "http://ec2-50-17-112-140.compute-1.amazonaws.com/image2mail.php?remitente=" + e.data.remitente + "&destinatario=" + e.data.destinatario;
			urlRequest.requestHeaders.push(new URLRequestHeader('Cache-Control', 'no-cache'));
			urlRequest.requestHeaders.push(new URLRequestHeader('Content-Type', 'multipart/form-data; boundary=' + UploadPostHelper.getBoundary()));	
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = UploadPostHelper.getPostData( 'imagen.jpg', jpgStream );
			urlRequest.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );   			
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.load(urlRequest);   
			urlLoader.addEventListener(Event.COMPLETE, onCompleteUpload);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			
			timerSend.start();
		}
		
		private function onCompleteUpload(e:Event):void
		{
			//trace(urlLoader.data);
			timerSend.stop();
			mcEnvio.txtAlerta.text = Idiomas.SUCCESS_SENDING;
			var timer:Timer = new Timer(2000);
				timer.addEventListener(TimerEvent.TIMER, tick);
				timer.start();
				
			function tick(e:TimerEvent):void
			{
				timer.removeEventListener(TimerEvent.TIMER, tick);
				timer.stop();
				cerrarEnvio(null);
			}
		}
		
		private function onError(e:IOErrorEvent):void
		{
			tickSend(null);
		}
		
		private function cerrarEnvio(e:EventosEnvio):void
		{
			activarHoja();
			mcEnvio.deshabilitar();
			
			TweenMax.to(mcEnvio, 0.5, { y:1032, onComplete:function() {
				TweenMax.to(btnSend, 0.5, { y:953, onComplete:function() {					
					mcEnvio.removeEventListener(EventosEnvio.ACEPTAR, hacerEnvio);
					mcEnvio.removeEventListener(EventosEnvio.CANCELAR, cerrarEnvio);
				}});
			}});
		}
		
		private function tickSend(e:TimerEvent):void
		{
			timerSend.stop();			
			mcEnvio.txtAlerta.text = Idiomas.ERROR_SENDING;
			mcEnvio.agregarListeners();
		}
	}

}