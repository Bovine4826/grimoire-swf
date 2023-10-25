package grimoire.game
{
   import flash.events.MouseEvent;
   import grimoire.Root;
   
   public class DropStack
   {
      
      private static var game:* = Root.Game;
      
      private static var pref:* = Root.Game.userPreference;
       
      
      public function DropStack()
      {
         super();
      }
      
      public static function hasDrop(param1:String) : String
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = Root.falseString;
         if(game.litePreference.data.bCustomDrops)
         {
            _loc2_ = !!game.cDropsUI.mcDraggable ? game.cDropsUI.mcDraggable.menu : game.cDropsUI;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.numChildren)
            {
               if((_loc4_ = _loc2_.getChildAt(_loc3_)).itemObj)
               {
                  if((_loc7_ = String(_loc4_.itemObj.sName.toLowerCase())) == param1.toLowerCase())
                  {
                     _loc8_ = Root.trueString;
                     break;
                  }
               }
               _loc3_++;
            }
         }
         else
         {
            _loc5_ = int(game.ui.dropStack.numChildren);
            while(_loc3_ < _loc5_)
            {
               if((_loc4_ = game.ui.dropStack.getChildAt(_loc3_)).cnt.strName.text.toLowerCase() == param1.toLowerCase())
               {
                  _loc8_ = Root.trueString;
                  break;
               }
               _loc3_++;
            }
         }
         return _loc8_;
      }
      
      public static function acceptDrop(param1:int) : void
      {
         game.sfc.sendXtMessage("zm","getDrop",[param1],"str",game.world.curRoom);
      }
      
      public static function rejectDrop(param1:String) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Array = param1.split(",");
         if(game.litePreference.data.bCustomDrops)
         {
            _loc2_ = !!game.cDropsUI.mcDraggable ? game.cDropsUI.mcDraggable.menu : game.cDropsUI;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.numChildren)
            {
               if((_loc4_ = _loc2_.getChildAt(_loc3_)).itemObj)
               {
                  _loc7_ = String(_loc4_.itemObj.sName.toLowerCase());
                  if(_loc8_.indexOf(_loc7_) == -1)
                  {
                     _loc4_.btNo.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
               }
               _loc3_++;
            }
         }
         else
         {
            _loc5_ = int(game.ui.dropStack.numChildren);
            for each(_loc6_ in _loc8_)
            {
               while(_loc3_ < _loc5_)
               {
                  if((_loc4_ = game.ui.dropStack.getChildAt(_loc3_)).cnt.strName.text.toLowerCase().indexOf(_loc6_.toLowerCase()) == -1)
                  {
                     _loc4_.cnt.nbtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
                  _loc3_++;
               }
            }
         }
      }
   }
}
