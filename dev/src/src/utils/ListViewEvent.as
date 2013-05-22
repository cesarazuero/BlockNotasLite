package utils
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Cesar Azuero
	 */
	public class ListViewEvent extends Event 
	{
		public static const ITEM_SELECTED = "onSeleted";
		public static const CANCELED = "onCanceled";
		public var data:*;
		
		public function ListViewEvent(type:String, _data:*, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.data = _data;
			super(type, bubbles, cancelable);			
		} 
		
		public override function clone():Event 
		{ 
			return new ListViewEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ListViewEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}