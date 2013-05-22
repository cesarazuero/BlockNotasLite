package utils
{	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Cesar Azuero
	 */
	public class resizeFoto extends Bitmap 
	{
		
		public function resizeFoto() 
		{
			//Esta clase redimensiona una imagen y la centra de acuerdo al ancho y alto maximo, la redimensiona proporcionalmente.
		}
		
		public function redimensionarFoto(imagen:Bitmap, anchoMax, altoMax:Number):void 
		{			
			//Esta funcion redimensiona una foto y la centra dentro del contenedor de acuerdo al anchoMax y al altoMax.
			var relacion:Number = 0;			
			if (imagen.width < anchoMax|| imagen.height < altoMax) {
				//La foto es más pequeña en ancho o en alto, ajustar incrementando tamaño				
				if (imagen.width > imagen.height) {
					while (imagen.height < altoMax) {
						incSizeFoto(imagen);
					}
				}else {
					while (imagen.width < anchoMax) {
						incSizeFoto(imagen);
					}
				}
			}else {
				//La foto es mas grande que el marco
				if (imagen.width > imagen.height) {
					relacion = imagen.width / imagen.height;
					while (imagen.height > altoMax) {
						imagen.height--;
						imagen.width -= relacion;
						if (imagen.width<=anchoMax) {
							break;
						}
					}
				}else {					
					relacion = imagen.height / imagen.width;
					while (imagen.width > anchoMax) {
						imagen.width--;
						imagen.height -= relacion;
						if (imagen.height<=altoMax) {
							break;
						}
					}
				}
			}
			imagen.x = (anchoMax - imagen.width) / 2;
			imagen.y = (altoMax - imagen.height) / 2;
			//imagen.width = anchoMax;
			//imagen.height = altoMax;
		}
		
		public function redimensionarFotoPosFija(imagen:Bitmap, anchoMax, altoMax:Number, contenedor:MovieClip):void 
		{			
			//Esta funcion redimensiona una foto y la centra dentro del contenedor de acuerdo al anchoMax y al altoMax.
			var relacion:Number = 0;			
			if (imagen.width < anchoMax|| imagen.height < altoMax) {
				//La foto es más pequeña en ancho o en alto, ajustar incrementando tamaño				
				if (imagen.width > imagen.height) {
					while (imagen.height < altoMax) {
						incSizeFoto(imagen);
					}
				}else {
					while (imagen.width < anchoMax) {
						incSizeFoto(imagen);
					}
				}
			}else {
				//La foto es mas grande que el marco
				if (imagen.width > imagen.height) {
					relacion = imagen.width / imagen.height;
					while (imagen.height > altoMax) {
						imagen.height--;
						imagen.width -= relacion;
						if (imagen.width<=anchoMax) {
							break;
						}
					}
				}else {					
					relacion = imagen.height / imagen.width;
					while (imagen.width > anchoMax) {
						imagen.width--;
						imagen.height -= relacion;
						if (imagen.height<=altoMax) {
							break;
						}
					}
				}
			}
			imagen.x = (contenedor.width-imagen.width)/2;
			imagen.y = (contenedor.height-imagen.height)/2;			
		}
		
		private function incSizeFoto(imagen:Bitmap)
		{
			imagen.height++;
			imagen.width++;
		}
	}

}