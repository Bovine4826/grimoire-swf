package grimoire.game
{
   import grimoire.Root;
   
   public class House
   {
      
      private static var game:* = Root.Game;
      
      private static var pref:* = Root.Game.userPreference;
       
      
      public function House()
      {
         super();
      }
      
      public static function houseItems() : String
      {
         return JSON.stringify(game.world.myAvatar.houseitems);
      }
      
      public static function houseSlots() : int
      {
         return game.world.myAvatar.objData.iHouseSlots;
      }
      
      public static function getItem(param1:String) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:* = game.world.myAvatar.houseitems;
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
   }
}
