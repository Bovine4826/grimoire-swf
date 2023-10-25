package grimoire.game
{
   import flash.events.Event;
   import grimoire.Root;
   
   public class Bank
   {
      
      private static var game:* = Root.Game;
      
      private static var pref:* = Root.Game.userPreference;
      
      public static var loaded:Boolean = false;
       
      
      public function Bank()
      {
         super();
      }
      
      public static function bankItems() : String
      {
         return JSON.stringify(game.world.bankinfo.items);
      }
      
      public static function bankSlots() : int
      {
         return game.world.myAvatar.objData.iBankSlots;
      }
      
      public static function usedBankSlots() : int
      {
         return game.world.myAvatar.iBankCount;
      }
      
      public static function transfer(param1:String, param2:String) : void
      {
         var _loc3_:Object = param1 == "Bank" ? Inventory.getItem(param2) : getItem(param2);
         if(_loc3_ != null)
         {
            if(param1 == "Bank")
            {
               game.world.sendBankFromInvRequest(_loc3_);
            }
            else
            {
               game.world.sendBankToInvRequest(_loc3_);
            }
         }
      }
      
      public static function bankSwap(param1:String, param2:String) : void
      {
         var _loc3_:Object = Inventory.getItem(param1);
         var _loc4_:Object = getItem(param2);
         if(_loc3_ != null && _loc4_ != null)
         {
            game.world.sendBankSwapInvRequest(_loc4_,_loc3_);
         }
      }
      
      public static function getItem(param1:String) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:* = game.world.bankinfo.items;
         if(_loc3_ != null && _loc3_.length > 0)
         {
            for each(_loc2_ in _loc3_)
            {
               if(_loc2_.sName.toLowerCase() == param1.toLowerCase())
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
      
      public static function toggleBank() : void
      {
         game.world.toggleBank();
      }
      
      public static function loadBank() : void
      {
         game.requestAPI("bank",{"layout":{"cat":"all"}},onBankComplete,game.onBankError,true);
      }
      
      public static function onBankComplete(param1:Event) : void
      {
         game.world.addItemsToBank(JSON.parse(param1.target.data));
         loaded = true;
      }
      
      public static function loadBankItems() : void
      {
         game.sfc.sendXtMessage("zm","loadBank",["Sword","Axe","Dagger","Gun","Bow","Mace","Polearm","Staff","Wand","Class","Armor","Helm","Cape","Pet","Amulet","Necklace","Note","Resource","Item","Quest Item","ServerUse","House","Wall Item","Floor Item","Enhancement"],"str",game.world.curRoom);
      }
      
      public static function isBankOpen() : String
      {
         return game.ui.mcPopup.currentLabel != "Bank" ? Root.falseString : Root.trueString;
      }
      
      public static function isBankLoaded() : String
      {
         return loaded ? Root.trueString : Root.falseString;
      }
   }
}
