loadPixels();
for (int i=0; i<pixels.length; i++) {
   if (i%3 == 0) {
      pixels[i] = color(255);
   } else {
      pixels[i] = color(0);
   }
updatePixels();
}
  image
