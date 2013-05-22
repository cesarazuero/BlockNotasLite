package movieclips 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Cesar Azuero
	 */
	public class mcMenu extends MovieClip 
	{
		public var mcLapiz:MovieClip;
		public var mcResaltador:MovieClip;
		public var mcBorrador:MovieClip;
		public var mcAddImage:MovieClip;
		public var mcGuardar:MovieClip;
		
		private var mcActivo:MovieClip;
		
		public function mcMenu() 
		{
			addEventListener(Event.ADDED_TO_STAGE, ini);
		}
		
		private function ini(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, ini);
			
			mcLapiz.addEventListener(MouseEvent.CLICK, clickHandler);
			mcResaltador.addEventListener(MouseEvent.CLICK, clickHandler);
			mcBorrador.addEventListener(MouseEvent.CLICK, clickHandler);			
			mcAddImage.addEventListener(MouseEvent.CLICK, clickHandler);
			mcGuardar.addEventListener(MouseEvent.CLICK, clickHandler);
			
			mcActivo = mcLapiz;
			mcActivo.nextFrame();
		}
		
		private function clickHandler(e:MouseEvent):void 
		{			
			if (mcActivo != e.currentTarget)
			{
				switch (e.currentTarget.name) 
				{
					case "mcLapiz":						
						break;
					case "mcResaltador":
						break;
					case "mcBorrador":
						break;
					case "mcAddImage":
						break;
					case "mcGuardar":
						break;
				}

				mcActivo.prevFrame();				
				mcActivo = e.currentTarget;
				mcActivo.nextFrame();
			}
		}
		
		
		
	}

}