import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

 
Minim minim;  //背景音機器
AudioPlayer player;  //背景音変数

Minim ef;//
AudioSample []doremi = new AudioSample[7];//効果音
 
int mouse_click_count = 0;

void setup_my_sound()
{

  minim = new Minim(this);  //初期化
  player = minim.loadFile("s0.mp3"); 
  
  
  ef = new Minim(this); 
  doremi[0] = ef.loadSample("mildsound.wav", 2048);
  doremi[1] = ef.loadSample("pianoA.mp3", 2048);
  doremi[2] = ef.loadSample("pianoB.mp3", 2048);
  doremi[3] = ef.loadSample("pianoD.mp3", 2048);
  doremi[4] = ef.loadSample("pianoC2.mp3", 2048);
  doremi[5] = ef.loadSample("pianoE.mp3", 2048);
  doremi[6] = ef.loadSample("pianoF.mp3", 2048);
  
}


void play_background_sound(int i)
{
  player.play();
}


void play_effect_sound(int i)
{
  doremi[i].trigger();
}





void stop()
{
  player.close();  //サウンドデータを終了
  minim.stop();
  
  for(int i = 0; i < 7; i++)
  doremi[i].close();
  
  ef.stop();
  
  super.stop();
}
 
