package grimoire.game
{
   import grimoire.Root;
   
   public class Skill
   {
      
      private static var game:* = Root.Game;
      
      private static var pref:* = Root.Game.userPreference;
      
      public static var skillRange:String = "";
       
      
      public function Skill()
      {
         super();
      }
      
      public static function allSkillsAvailable() : int
      {
         return Math.max(skillReady(game.world.actions.active[1]),skillReady(game.world.actions.active[2]),skillReady(game.world.actions.active[3]),skillReady(game.world.actions.active[4]));
      }
      
      public static function isSkillReady(param1:String) : int
      {
         return skillReady(game.world.actions.active[parseInt(param1)]);
      }
      
      public static function isSkillAvailable(param1:String) : String
      {
         return skillAvailability(game.world.actions.active[parseInt(param1)]) ? Root.trueString : Root.falseString;
      }
      
      private static function skillAvailability(param1:*) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:Number = new Date().getTime();
         var _loc4_:Number = 1 - Math.min(Math.max(game.world.myAvatar.dataLeaf.sta.$tha,-1),0.5);
         if(param1.auto)
         {
            if(game.world.autoActionTimer.running)
            {
               return false;
            }
            return true;
         }
         if(_loc3_ - game.world.GCDTS < game.world.GCD)
         {
            return false;
         }
         if(param1.OldCD != null)
         {
            _loc2_ = Math.round(param1.OldCD * _loc4_);
         }
         else
         {
            _loc2_ = Math.round(param1.cd * _loc4_);
         }
         if(_loc3_ - param1.ts >= _loc2_)
         {
            delete param1.OldCD;
            return true;
         }
         return false;
      }
      
      private static function skillReady(param1:*) : int
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = new Date().getTime();
         var _loc4_:Number = 1 - Math.min(Math.max(game.world.myAvatar.dataLeaf.sta.$tha,-1),0.5);
         if(param1.OldCD != null)
         {
            _loc2_ = Math.round(param1.OldCD * _loc4_);
            delete param1.OldCD;
         }
         else
         {
            _loc2_ = Math.round(param1.cd * _loc4_);
         }
         var _loc5_:Number;
         if((_loc5_ = game.world.GCD - (_loc3_ - game.world.GCDTS)) < 0)
         {
            _loc5_ = 0;
         }
         var _loc6_:Number;
         if((_loc6_ = _loc2_ - (_loc3_ - param1.ts)) < 0)
         {
            _loc6_ = 0;
         }
         return Math.max(_loc5_,_loc6_);
      }
      
      public static function skillAction(param1:String) : void
      {
         var _loc2_:Object = game.world.actions.active[parseInt(param1)];
         var _loc3_:* = game.ui.mcInterface.actBar.getChildByName("i" + (parseInt(param1) + 1)).actObj.skillLock;
         var _loc4_:* = null;
         if(game.world.myAvatar.target == game.world.myAvatar)
         {
            game.world.myAvatar.target = null;
            return;
         }
         if(_loc2_.tgt == "s" || _loc2_.tgt == "f")
         {
            _loc4_ = game.world.myAvatar.target;
            game.world.myAvatar.target = game.world.myAvatar;
         }
         if(game.world.myAvatar.target != null && game.world.myAvatar.target.dataLeaf.intHP > 0)
         {
            game.world.approachTarget();
            if(skillAvailability(_loc2_) && game.world.myAvatar.dataLeaf.intMP >= _loc2_.mp && _loc2_.isOK && (_loc3_ == null || !_loc3_))
            {
               game.world.testAction(_loc2_);
            }
         }
         if(_loc2_.tgt == "s" || _loc2_.tgt == "f")
         {
            game.world.myAvatar.target = _loc4_;
         }
      }
      
      public static function getRange() : void
      {
         var _loc1_:int = 0;
         skillRange = "";
         while(_loc1_ < 6)
         {
            skillRange = skillRange + game.world.actions.active[_loc1_].range + ";";
            _loc1_++;
         }
      }
   }
}
