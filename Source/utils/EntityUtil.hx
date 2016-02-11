package utils;

import ash.core.Entity;
import components.Description;

class EntityUtil {
  public static inline function ret_name(entity: Entity): String {
    var desc: Name = entity.get(Description);
    if (desc != null) return desc.name;
    else              return "unknown entity";
  }
}
