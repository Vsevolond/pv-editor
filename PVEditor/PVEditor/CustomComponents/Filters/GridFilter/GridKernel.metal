#include <CoreImage/CoreImage.h>

extern "C" {
  namespace coreimage {
    
    float2 gridFilter(destination dest) {
      float y = dest.coord().y + tan(dest.coord().y / 10) * 20;
      float x = dest.coord().x + tan(dest.coord().x/ 10) * 20;
      return float2(x,y);
    }
  }
}
