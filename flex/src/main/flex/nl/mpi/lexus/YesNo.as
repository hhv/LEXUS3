package nl.mpi.lexus
{
	import mx.controls.Alert;

    public class YesNo 
    {
    	
		[Bindable]
        [Embed(source="../resources/assets/images/iconza_24x24_0097d9/save_24x24.png")]
    	private static var saveIcon:Class;
    	
		[Bindable]
        [Embed(source="../resources/assets/images/iconza_24x24_0097d9/warning_24x24.png")]
    	private static var warningIcon:Class;
    	
		[Bindable]
        [Embed(source="../resources/assets/images/iconza_24x24_0097d9/info_24x24.png")]
    	private static var infoIcon:Class;

		[Bindable]
        [Embed(source="../resources/assets/images/iconza_24x24_0097d9/stop_24x24.png")]
    	private static var stopIcon:Class;
		
		private static var isAlerting:Boolean = false;
		
        // Define the constructor.      
        public function YesNo() {
            super();
			isAlerting = true;
        }
        
        public static function yesno(message:String, title:String, closeHandler:Function, icon:Class, defaultChoice:uint = Alert.YES):void {
        	if (null == icon) 
        		icon = warningIcon;
			
			if (!isAlerting) {
				var alert:Alert = Alert.show(message, title, Alert.YES | Alert.NO, null, closeHandler, icon, defaultChoice);
				YesNo.styleBox(alert);
			}
        }
        
        public static function ok(message:String, title:String, icon:Class):void {
        	if (null == icon) 
        		icon = warningIcon;
			if (!isAlerting){
				var alert:Alert = Alert.show(message, title, Alert.OK, null, null, icon);
				YesNo.styleBox(alert);
			}
        }
        
        private static function styleBox(box:Alert):void {
		    box.setStyle("backgroundColor", 0xffffff);
		    box.setStyle("backgroundAlpha", 0.50);
		    box.setStyle("borderColor", 0xffffff);
		    box.setStyle("borderAlpha", 0.75);
		    box.setStyle("color", "0×000000");
        }
        /**
        * Standard save box
        **/
        public static function confirmSave(message:String, closeHandler:Function):void {
        	YesNo.yesno(message, "Confirm", closeHandler, saveIcon);
        }
        
        
        /**
        * Standard delete box
        **/
        public static function confirmDelete(message:String, closeHandler:Function):void {
        	YesNo.yesno(message, "Confirm", closeHandler, warningIcon);
        }
        
       /**
        * Standard alert box
        **/
        public static function alert(message:String):void {
        	YesNo.ok(message, "Alert", warningIcon);
        }


       /**
        * Standard info box
        **/
        public static function info(message:String):void {
        	YesNo.ok(message, "Information", infoIcon);
        }


       /**
        * Standard 'stop' box
        **/
        public static function stop(message:String):void {
        	YesNo.ok(message, "Stop", stopIcon);
        }
    }
}