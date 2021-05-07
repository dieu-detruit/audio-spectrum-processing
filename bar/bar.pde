import com.hamoid.*;

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer player;
VideoExport videoExport;
FFT fft;
int fftSize;

PImage bg;

void setup()
{
  size(1920, 1080);
  bg = loadImage("thumb_logo.png");
  //colorMode(HSB, 360, 100, 100, 100);
  minim = new Minim(this);
  fftSize = 512;
  videoExport = new VideoExport(this, "output.mp4");
  player = minim.loadFile("audio.mp3", fftSize);
  videoExport.startMovie();
  player.play();
  player.setGain(-10);
  fft = new FFT(player.bufferSize(), player.sampleRate());
  frameRate(30);
}

void draw()
{
  background(bg);

  strokeWeight(2.0);
  fft.forward( player.mix );

  stroke(0, 0, 0, 0);
  fill(255, 255, 255, 100);
  for (int i = 0; i < (0.8 * width) / 100; i++)
  {
    //↓ = fft.specSize()/(width/box.x) * i;
    float fftPos = fft.specSize() * i * 100 / (0.8 * width);
    
    float x = map(fftPos, 0, fft.specSize(), 0.1 * width, 0.9 * width);
    float y = map(fft.getBand((int)fftPos), 0, 30.0, 0, 0.4 * height);
    
    rect(x, height - 30, 80, -y);
  }
  
  videoExport.saveFrame();
  if (!player.isPlaying()) {
    videoExport.endMovie();
  }
}
