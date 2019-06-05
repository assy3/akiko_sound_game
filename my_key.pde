float falling_time = 1.85;
void keyPressed()
{
 if(key == 'p' && state == -1)
 {
 state = 1;
 my_timer = 0.0;
 index = 0;
 song.rewind();
 song.play();
 }

 if(key == 'e' && state == 2){
   state = -1;
 }
 if(key == 'd' && state == 1){
   state = 2;
 }
}
