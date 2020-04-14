import ch.bildspur.artnet.*;

PGraphics pg;

ArtNetClient artnet;
byte[] dmxData = new byte[512];

void setup() {
  //frameRate(10);
  size(160,40);
  pg = createGraphics(16,4);

  
  // create artnet client without buffer (no receving needed)
  artnet = new ArtNetClient(null);
  artnet.start();
}

void draw() {
  
  pg.beginDraw();
  pg.colorMode(HSB, 255);
  pg.noStroke();
  for (int ix=0; ix<pg.width; ix++) {
    pg.fill((255/pg.width)*ix,255,frameCount%255);
    pg.rect(ix,0,1,1);
    pg.fill((255/pg.width)*ix,235,frameCount%255);
    pg.rect(ix,1,1,1);
    pg.fill((255/pg.width)*ix,215,frameCount%255);
    pg.rect(ix,2,1,1);
    pg.fill((255/pg.width)*ix,195,frameCount%255);
    pg.rect(ix,3,1,1);
  }
  //pg.background(255,0,255);
  //pg.fill(255,255,255);
  //pg.rect(frameCount%16,0,1,4);
  pg.endDraw();
  
  int dmxCounter = 0;
  for(int iy=0; iy<pg.height; iy++) {
    for(int ix=0; ix<pg.width; ix++) {
      dmxData[dmxCounter] = (byte) red(pg.get(ix,iy));
      dmxData[dmxCounter+1] = (byte) green(pg.get(ix,iy));
      dmxData[dmxCounter+2] = (byte) blue(pg.get(ix,iy));
      dmxCounter += 3;
    }
  }

  print(dmxData[11]);
  
  // send dmx to localhost
  artnet.unicastDmx("127.0.0.1", 0, 0, dmxData);
  
  PImage img = pg.get();
  img.resize(160,40);
  image(img, 0, 0);
  
}
