package grimoire.game
{
   import grimoire.Root;
   
   public class TempInventory
   {
      
      private static var game:* = Root.Game;
      
      private static var pref:* = Root.Game.userPreference;
       
      
      public function TempInventory()
      {
         super();
      }
      
      public static function tempItems() : String
      {
         return JSON.stringify(game.world.myAvatar.tempitems);
      }
      
      public static function getTempItem(param1:String) : Object
      {
         var _loc2_:Object = null;
         for each(_loc2_ in game.world.myAvatar.tempitems)
         {
            if(_loc2_.sName.toLowerCase() == param1.toLowerCase())
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function isItemInTemp(param1:String, param2:String) : String
      {
         var _loc3_:Object = getTempItem(param1);
         if(_loc3_ == null)
         {
            return Root.falseString;
         }
         return param2 == "*" ? Root.trueString : (_loc3_.iQty >= parseInt(param2) ? Root.trueString : Root.falseString);
      }
   }
}
