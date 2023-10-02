import 'dart:async';
import 'package:conduit_core/conduit_core.dart';


class Migration2 extends Migration { 
  @override
  Future upgrade() async {
   		database.alterColumn("_Role", "title", (c) {c.isUnique = true;});
  }
  
  @override
  Future downgrade() async {}
  
  @override
  Future seed() async {}
}
    