package idiomas 
{
	/**
	 * ...
	 * @author Cesar Azuero
	 */
	public class Idiomas 
	{		
		private var _DIGITA_TEXTO:String = "";
		private var _DESTINATARIO:String = "";
		private var _REMITENTE:String = "";
		private var _NOMBRE_DESTINATARIO:String = "";
		private var _NOMBRE_REMITENTE:String = "";
		private var _DELETE_TEXT:String = "";
		private var _DELETE_DRAWING:String = "";
		private var _DELETE_PHOTO:String = "";
		private var _SENDER_EMAIL_NOT_VALID:String = "";
		private var _ADDRESSEE_EMAIL_NOT_VALID:String = "";
		private var _SENDER_NAME_EMPTY:String = "";
		private var _ADDRESSEE_NAME_EMPTY:String = "";
		private var _SENDING:String = "";
		private var _ENVIAR:String = "";
		private var _CANCELAR:String = "";
		private var _ERROR_SENDING:String = "";
		private var _SUCCESS_SENDING:String = "";
		private var _ACEPTAR:String = "";
		
		private static var _instance:Idiomas;
		
		public function Idiomas(singletonEnforcer:SingletonEnforcer):void
		{			
		}
		
		public static function getInstance():Idiomas
		{
			if( _instance == null ) _instance = new Idiomas( new SingletonEnforcer() );
			return _instance;
		}
		
		public static function setIdioma(tipo:String):void
		{
			switch (tipo) 
			{
				case "en":					
					getInstance()._DIGITA_TEXTO = "Text";
					getInstance()._DESTINATARIO = "e-mail Addressee";
					getInstance()._REMITENTE = "e-mail Sender";
					getInstance()._NOMBRE_DESTINATARIO = "Addressee Name";
					getInstance()._NOMBRE_REMITENTE = "Sender Name";
					getInstance()._DELETE_TEXT = "Delete text?";
					getInstance()._DELETE_DRAWING = "Delete drawing?";
					getInstance()._DELETE_PHOTO = "Delete photo?";
					getInstance()._ADDRESSEE_EMAIL_NOT_VALID = "Addressee e-mail not valid";
					getInstance()._SENDER_EMAIL_NOT_VALID = "Sender e-mail not valid";
					getInstance()._ADDRESSEE_NAME_EMPTY = "Addressee name missing";
					getInstance()._SENDER_NAME_EMPTY = "Sender name missing";
					getInstance()._SENDING = "Sending... wait a moment please.";
					getInstance()._ENVIAR = "Send";
					getInstance()._CANCELAR = "Cancel";
					getInstance()._ERROR_SENDING = "Server no reponse, try again please!";
					getInstance()._SUCCESS_SENDING = "Image sent successfully.";
					getInstance()._ACEPTAR = "Accept";
					break;
				default:
					getInstance()._DIGITA_TEXTO = "Digita el texto";
					getInstance()._DESTINATARIO = "e-mail Destinatario";
					getInstance()._REMITENTE = "e-mail Remitente";
					getInstance()._NOMBRE_DESTINATARIO = "Nombre Destinatario";
					getInstance()._NOMBRE_REMITENTE = "Nombre Remitente";
					getInstance()._DELETE_TEXT = "¿Estás seguro de eliminar este texto?";
					getInstance()._DELETE_DRAWING = "¿Estás seguro de eliminar este dibujo?";
					getInstance()._DELETE_PHOTO = "¿Estás seguro de eliminar esta imagen?";
					getInstance()._ADDRESSEE_EMAIL_NOT_VALID = "El e-mail del destinatario no es válido";
					getInstance()._SENDER_EMAIL_NOT_VALID = "El e-mail del remitente no es válido";
					getInstance()._ADDRESSEE_NAME_EMPTY = "Te falta colocar el nombre del destinatario";
					getInstance()._SENDER_NAME_EMPTY = "Te falta colocar el nombre del remitente";
					getInstance()._SENDING = "Enviando... un momento por favor.";
					getInstance()._ENVIAR = "Enviar";
					getInstance()._CANCELAR = "Cancelar";
					getInstance()._ERROR_SENDING = "El servidor no responde, intente de nuevo por favor.";
					getInstance()._SUCCESS_SENDING = "Tu imagen se ha enviado exitosamente.";
					getInstance()._ACEPTAR = "Aceptar";
					break;
			}
		}
		
		public static function get DIGITA_TEXTO():String 
		{
			return getInstance()._DIGITA_TEXTO;
		}
		
		public static function set DIGITA_TEXTO(value:String):void 
		{
			getInstance()._DIGITA_TEXTO = value;
		}
		
		public static function get DESTINATARIO():String 
		{
			return getInstance()._DESTINATARIO;
		}
		
		public static function set DESTINATARIO(value:String):void 
		{
			getInstance()._DESTINATARIO = value;
		}
		
		public static function get REMITENTE():String 
		{
			return getInstance()._REMITENTE;
		}
		
		public static function set REMITENTE(value:String):void 
		{
			getInstance()._REMITENTE = value;
		}
		
		public static function get NOMBRE_REMITENTE():String 
		{
			return getInstance()._NOMBRE_REMITENTE;
		}
		
		public static function set NOMBRE_REMITENTE(value:String):void 
		{
			getInstance()._NOMBRE_REMITENTE = value;
		}
		
		public static function get NOMBRE_DESTINATARIO():String 
		{
			return getInstance()._NOMBRE_DESTINATARIO;
		}
		
		public static function set NOMBRE_DESTINATARIO(value:String):void 
		{
			getInstance()._NOMBRE_DESTINATARIO = value;
		}
		
		public static function get DELETE_TEXT():String 
		{
			return getInstance()._DELETE_TEXT;
		}
		
		public static function set DELETE_TEXT(value:String):void 
		{
			getInstance()._DELETE_TEXT = value;
		}
		
		public static function get DELETE_DRAWING():String 
		{
			return getInstance()._DELETE_DRAWING;
		}
		
		public static function set DELETE_DRAWING(value:String):void 
		{
			getInstance()._DELETE_DRAWING = value;
		}
		
		public static function get DELETE_PHOTO():String 
		{
			return getInstance()._DELETE_PHOTO;
		}
		
		public static function set DELETE_PHOTO(value:String):void 
		{
			getInstance()._DELETE_PHOTO = value;
		}
		
		public static function get ADDRESSEE_EMAIL_NOT_VALID():String 
		{
			return getInstance()._ADDRESSEE_EMAIL_NOT_VALID;
		}
		
		public static function set ADDRESSEE_EMAIL_NOT_VALID(value:String):void 
		{
			getInstance()._ADDRESSEE_EMAIL_NOT_VALID = value;
		}
		
		public static function get SENDER_EMAIL_NOT_VALID():String 
		{
			return getInstance()._SENDER_EMAIL_NOT_VALID;
		}
		
		public static function set SENDER_EMAIL_NOT_VALID(value:String):void 
		{
			getInstance()._SENDER_EMAIL_NOT_VALID = value;
		}
		
		public static function get SENDER_NAME_EMPTY():String 
		{
			return getInstance()._SENDER_NAME_EMPTY;
		}
		
		public static function set SENDER_NAME_EMPTY(value:String):void 
		{
			getInstance()._SENDER_NAME_EMPTY = value;
		}
		
		public static function get ADDRESSEE_NAME_EMPTY():String 
		{
			return getInstance()._ADDRESSEE_NAME_EMPTY;
		}
		
		public static function set ADDRESSEE_NAME_EMPTY(value:String):void 
		{
			getInstance()._ADDRESSEE_NAME_EMPTY = value;
		}
		
		public static function get SENDING():String 
		{
			return getInstance()._SENDING;
		}
		
		public static function set SENDING(value:String):void 
		{
			getInstance()._SENDING = value;
		}
		
		public static function get ENVIAR():String 
		{
			return getInstance()._ENVIAR;
		}
		
		public static function set ENVIAR(value:String):void 
		{
			getInstance()._ENVIAR = value;
		}
		
		public static function get CANCELAR():String 
		{
			return getInstance()._CANCELAR;
		}
		
		public static function set CANCELAR(value:String):void 
		{
			getInstance()._CANCELAR = value;
		}
		
		public static function get ERROR_SENDING():String 
		{
			return getInstance()._ERROR_SENDING;
		}
		
		public static function set ERROR_SENDING(value:String):void 
		{
			getInstance()._ERROR_SENDING = value;
		}
		
		public static function get SUCCESS_SENDING():String 
		{
			return getInstance()._SUCCESS_SENDING;
		}
		
		public static function set SUCCESS_SENDING(value:String):void 
		{
			getInstance()._SUCCESS_SENDING = value;
		}
		
		public static function get ACEPTAR():String 
		{
			return getInstance()._ACEPTAR;
		}
		
		public static function set ACEPTAR(value:String):void 
		{
			getInstance()._ACEPTAR = value;
		}
		
	}

}

internal class SingletonEnforcer{}