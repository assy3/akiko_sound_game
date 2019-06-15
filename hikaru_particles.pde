final int MAX_PARTICLE = 30;  //  パーティクルの個数
hikaru_Particle[] hikaru_p = new hikaru_Particle[MAX_PARTICLE];
 
final int LIGHT_FORCE_RATIO = 5;  //  輝き具体の抑制値
final int LIGHT_DISTANCE= 75 * 75;  //  光が届く距離
final int BORDER = 75;  //  光の計算する矩形範囲（高速化のため）
 
float baseRed, baseGreen, baseBlue;  //  光の色
float baseRedAdd, baseGreenAdd, baseBlueAdd;  //  光の色の加算量
final float RED_ADD = 1.2;    //  赤色の加算値
final float GREEN_ADD = 1.7;  //  緑色の加算値
final float BLUE_ADD = 2.3;   //  青色の加算値
 
float old_mouseX, old_mouseY;
int hikaru_able = 0;
float hikaru_timer = 0.0;
// int mouse_click_count = 1;

 
 
void setup_hikaru_particles()
{
 //  パーティクルの初期化
  for (int i = 0; i < MAX_PARTICLE; i++) {
    hikaru_p[i] = new hikaru_Particle();
  }
 
  //  光の色の初期化
  baseRed = 0;
  baseRedAdd = RED_ADD;
 
  baseGreen = 0;
  baseGreenAdd = GREEN_ADD;
 
  baseBlue = 0;
  baseBlueAdd = BLUE_ADD;  
  
  old_mouseX = width/2.0;
  old_mouseY = height/2.0;
  hikaru_able = 0;
}
 
 
 
 
void draw_hikaru_particles() 
{

  //  光の色を変更
  baseRed += baseRedAdd;
  baseGreen += baseGreenAdd;
  baseBlue += baseBlueAdd;
 
  //  色が範囲外になった場合は、色の加算値を逆転させる
  colorOutCheck();
 
  //  パーティクルの移動
  for (int pid = 0; pid < MAX_PARTICLE; pid++) {
   // hikaru_p[pid].move(mouseX, mouseY);
   hikaru_p[pid].move(old_mouseX, old_mouseY);
  }
 
  //  各ピクセルの色の計算
  int tRed = (int)baseRed;
  int tGreen = (int)baseGreen;
  int tBlue = (int)baseBlue;
 
  //  綺麗に光を出すために二乗する
  tRed *= tRed;
  tGreen *= tGreen;
  tBlue *= tBlue;
 
  //  各パーティクルの周囲のピクセルの色について、加算を行う
  loadPixels();
  for (int pid = 0; pid < MAX_PARTICLE; pid++) {
 
    //  パーティクルの計算影響範囲
    int left = max(0, hikaru_p[pid].x - BORDER);
    int right = min(width, hikaru_p[pid].x + BORDER);
    int top = max(0, hikaru_p[pid].y - BORDER);
    int bottom = min(height, hikaru_p[pid].y + BORDER);
 
    //  パーティクルの影響範囲のピクセルについて、色の加算を行う
    for (int y = top; y < bottom; y++) {
      for (int x = left; x < right; x++) {
        int pixelIndex = x + y * width;
 
        //  ピクセルから、赤・緑・青の要素を取りだす
        int r = pixels[pixelIndex] >> 16 & 0xFF;
        int g = pixels[pixelIndex] >> 8 & 0xFF;
        int b = pixels[pixelIndex] & 0xFF;
 
        //  パーティクルとピクセルとの距離を計算する
        int dx = x - hikaru_p[pid].x;
        int dy = y - hikaru_p[pid].y;
        int distance = (dx * dx) + (dy * dy);  //  三平方の定理だが、高速化のため、sqrt()はしない。
 
        //  ピクセルとパーティクルの距離が一定以内であれば、色の加算を行う
        if (distance < LIGHT_DISTANCE) {
          int fixFistance = distance * LIGHT_FORCE_RATIO;
          //  0除算の回避
          if (fixFistance == 0) {
            fixFistance = 1;
          }   
          r = r + tRed / fixFistance;
          g = g + tGreen / fixFistance;
          b = b + tBlue / fixFistance;
        }
 
        //  ピクセルの色を変更する
        pixels[x + y * width] = color(r, g, b);
      }
    }
  }
  updatePixels();
}
 
 
//  マウスクリック時に、各パーティクルをランダムな方向に飛ばす
void mousePressed()
{
  hikaru_able = 1;
  hikaru_timer = my_timer;
  
  old_mouseX = mouseX;
  old_mouseY = mouseY;
  
  for (int pid = 0; pid < MAX_PARTICLE; pid++) {
    hikaru_p[pid].explode();
  }
    int k = mouse_click_count % 7; 
    play_effect_sound(k); 
    mouse_click_count++;
}

 
//  色の値が範囲外に変化した場合は符号を変える
void colorOutCheck() {
  if (baseRed < 10) {
    baseRed = 10;
    baseRedAdd *= -1;
  }
  else if (baseRed > 255) {
    baseRed = 255;
    baseRedAdd *= -1;
  }
 
  if (baseGreen < 10) {
    baseGreen = 10;
    baseGreenAdd *= -1;
  }
  else if (baseGreen > 255) {
    baseGreen = 255;
    baseGreenAdd *= -1;
  }
 
  if (baseBlue < 10) {
    baseBlue = 10;
    baseBlueAdd *= -1;
  }
  else if (baseBlue > 255) {
    baseBlue = 255;
    baseBlueAdd *= -1;
  }
}
 
 
 
//  パーティクルクラス
class hikaru_Particle {
  int x, y;        //  位置
  float vx, vy;    //  速度
  float slowLevel; //  座標追従遅延レベル
  final float DECEL_RATIO = 0.95;  //  減速率
 
  hikaru_Particle() {
    x = (int)random(width);
    y = (int)random(height);
    slowLevel = random(100) + 5;
  }
 
  //  移動
  void move(float targetX, float targetY) {
    /*
 
    //  ターゲットに向かって動こうとする
    vx = vx * DECEL_RATIO + (targetX - x) / slowLevel;
    vy = vy * DECEL_RATIO + (targetY - y) / slowLevel;
 
    //  座標を移動
    x = (int)(x + vx);
    y = (int)(y + vy);
    
    */
    
    x = (int)(targetX + 5.0*vx*(my_timer - hikaru_timer));
    y = (int)(targetY + 5.0*vy*(my_timer - hikaru_timer));
    
  }
 
  //  適当な方向に飛び散る
  void explode() {
    vx = random(100) - 50;
    vy = random(100) - 50;
    slowLevel = random(100) + 5;
  }
}
