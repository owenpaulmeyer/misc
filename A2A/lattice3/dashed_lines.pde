int i = 1;

for (int y = 2; y < 100; y += 15){
  

  for (int x = 2; x < i*7; x += 7){
    line (x,y, x+5,y+5);
  }
  i +=2;
}
